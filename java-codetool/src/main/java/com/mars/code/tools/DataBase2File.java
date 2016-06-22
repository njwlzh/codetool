package com.mars.code.tools;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.mars.code.tools.dbservice.ITableService;
import com.mars.code.tools.model.Module;
import com.mars.code.tools.model.Table;
import com.mars.code.tools.model.TableConf;
import com.mars.code.tools.utils.CodeUtil;
import com.mars.code.tools.utils.FreemarkerUtil;
  
/** 
 * 通过数据库表结构生成表对应的实体类以及根据entity,view,action、service和dao模板生成基本的相关文件，支持深度主从表关系<br>
 * 后期可考虑抽像出一些接口来实现更多的持久层、展现层框架 
 * @author mars.liu
 */  
public class DataBase2File {
	
	private Config config=null;
	public DataBase2File(){
		config = Config.loadConfig();
	}
	
	private ITableService tableService;
      
    /** 
     * 主方法，反转生成相关文件 
     * @throws IOException  
     * @throws ClassNotFoundException 
     * @throws SQLException 
     */  
    public void generateFiles() throws IOException, ClassNotFoundException, SQLException {
        System.out.println("Generating..."); 
        Long start=System.currentTimeMillis();
        tableService = TableServiceFactory.getInstance(config.getDb().getDbType());
        tableService.setConfig(config);
        Class.forName(config.getDb().getDriver());  
        Connection con = DriverManager.getConnection(config.getDb().getUrl(), config.getDb().getUser(),config.getDb().getPwd());  
        for (Module module : config.getModules()) {
        	System.out.println("module="+module.getName());
        	//如果没有配置数据表，则默认加载模块名为前缀的所有数据表
        	if (module.getTables()==null || module.getTables().isEmpty()) {
        		module.setTables(tableService.getAllTables(module.getName()+"%"));
        	}
        	//系统的model文件
        	StringBuffer sbModel = new StringBuffer();
        	if (module.getTables()!=null) {
	        	for (TableConf tbConf : module.getTables()) {
	        		Table table = tableService.getTable(tbConf,module, con);//获取一个表的相关信息
	        		sbModel.append(genFile(table, module));
	        	}
        	}
        	//System.out.println(sbModel.toString());
        	if ("dorado".equals(module.getFramework())) {
        		writeModelFile(module.getName().split("/")[0]+".model.xml", sbModel.toString());//生成model文件
        	}
        }
        con.close();
        Long end = System.currentTimeMillis();
        System.out.println("Generate Success! total time = "+(end-start));
        System.out.println("Please check: " + config.getBaseDir());
    } 
    
    /**
     * 递归生成所有文件代码，子表可以重叠
     * @param tb
     * @param module
     * @return
     */
    private StringBuffer genFile(Table tb,Module module) {
    	generateEntityFile(tb, module);//生成entity
        generateServiceFile(tb, module);//生成service
        generateActionFile(tb,module);//生成action
        generateDaoFile(tb, module);//生成dao
        if ("dorado".equals(module.getFramework())) {
        	generateViewFile(tb,module);//生成view
        }
        StringBuffer sb = new StringBuffer();
        //若是使用dorado框架，则生成model的数据块
        String modleString = (generateDoradoModelString(tb, module));
        sb.append(modleString);
        if (!tb.getSubTables().isEmpty()) {
        	for (Table subTb : tb.getSubTables()){
        		sb.append(genFile(subTb,module));
        	}
        }
        return sb;
    }
      
  
     /**
     * 将模块信息转换为json结构
     * @param obj
     * @param module
     */
    private void setBaseInfo(JSONObject obj,Module module) {
    	obj.put("basePackage", config.getBasePackage());
    	obj.put("moduleName", module.getName().replace("/", "."));
    	obj.put("entityPackage", module.getEntityPackage());
    	obj.put("servicePackage", module.getServicePackage());
    	obj.put("serviceImplPackage", module.getServiceImplPackage());
    	obj.put("daoPackage", module.getDaoPackage());
    	obj.put("daoImplPackage", module.getDaoImplPackage());
    	obj.put("actionPackage", module.getActionPackage());
    	obj.put("viewPackage", module.getViewPackage());
    	obj.put("mapperPackage", module.getMapperPackage());
    }
    
    /**
     * 生成指定表对象对应的类文件 
     * @param table 
     */  
    private void generateEntityFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getEntityPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+".java");
    	
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "Entity", savePath);
    	System.out.println("生成文件："+savePath);
    }
    
    /**
     * 根据模块定义生成文件保存目录
     * @param module
     * @param packageName
     * @return
     */
    private File getSaveFilePath(Module module,String packageName){
    	String moduleName=module.getName().replace(".", "/");
    	File saveDir;
    	if (CodeUtil.isEmpty(module.getSavePath())) {
    		saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+moduleName+File.separator+packageName);
    	} else {
    		saveDir = new File(module.getSavePath(),moduleName+File.separator+packageName);
    	}
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	return saveDir;
    }
    /**
     * 生成指定表映射的RowMapper类文件，用于jdbcTemplate的查询 
     * @param table 
     */  
    private void generateMapperFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getDaoPackage()+File.separator+module.getMapperPackage());
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"RowMapper.java");
    	
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "RowMapper", savePath);
    	System.out.println("生成文件："+savePath);
    }
    
    /**
     * 生成dao文件
     * @param table
     */
    private void generateDaoFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getDaoPackage());
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Dao.java");
    	String savePath =saveFile.getAbsolutePath();
    	String templateName="DaoInterface";
    	if ("jpa".equals(module.getPersistance())) {
    		templateName="DaoInterface_"+module.getPersistance();
    	}
    	FreemarkerUtil.createDoc(obj, templateName, savePath);
    	System.out.println("生成文件："+savePath);
    	//实现文件
    	if (!module.getPersistance().equals("mybatis") && !module.getPersistance().equals("jpa")){
        	File implDir=getSaveFilePath(module,module.getDaoPackage()+File.separator+module.getDaoImplPackage());
	    	templateName = "HibernateDaoImpl";
	    	generateMapperFile(table, module);
	    	if (module.getPersistance().equals("jdbc")) {
	    		templateName="JdbcDaoImpl_"+config.getDb().getDbType();
	    	}
	    	File implFile = new File(implDir,table.getEntityCamelName()+"DaoImpl.java");
	    	String implPath =implFile.getAbsolutePath();
	    	FreemarkerUtil.createDoc(obj, templateName, implPath);
	    	System.out.println("生成文件："+implPath);
    	}
    	/**
    	 * 如果是mybatis，则生成mytabis的xml配置文件
    	 */
    	else if (module.getPersistance().equals("mybatis")) {
    		if (!CodeUtil.isEmpty(module.getSavePath())){ //配置了模块文件保存，则把文件全部生成到此目录下
    			saveDir = new File(module.getSavePath());
    		} else {
    			saveDir = new File(config.getBaseDir());
    			saveDir = saveDir.getParentFile();
    			saveDir = new File(saveDir, "resources/mapper" + File.separator+module.getName());
    		}
    		if (!saveDir.exists()) {
        		saveDir.mkdirs();
        	}
    		File implFile = new File(saveDir,table.getEntityCamelName()+"Mapper.xml");
	    	String implPath =implFile.getAbsolutePath();
	    	FreemarkerUtil.createDoc(obj, "MyBatis_"+config.getDb().getDbType(), implPath);
	    	System.out.println("生成文件："+implPath);
    	}
    }
    
    /**
     * 生成service文件
     * @param table
     */
    private void generateServiceFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getServicePackage());
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Service.java");
    	String savePath =saveFile.getAbsolutePath();
    	System.out.println("生成文件："+savePath);
    	FreemarkerUtil.createDoc(obj, "ServiceInterface", savePath);
    	//实现文件
    	File implDir=getSaveFilePath(module,module.getServicePackage()+File.separator+module.getServiceImplPackage());
    	File implFile = new File(implDir,table.getEntityCamelName()+"ServiceImpl.java");
    	String implPath =implFile.getAbsolutePath();
    	String templateName="ServiceImpl";
    	if (module.getPersistance().equals("jpa")) {
    		templateName="ServiceImpl_jpa";
    	}
    	FreemarkerUtil.createDoc(obj, templateName, implPath);
    	System.out.println("生成文件："+implPath);
    } 
    
    /**
     * 生成Action
     * @param table
     * @param module
     */
    private void generateActionFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getActionPackage());
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Action.java");
    	
    	String templateName="Action";
    	if (module.getFramework().equals("mvc")) {
    		templateName="Action_"+module.getFramework();
    	}
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, templateName, savePath);
    	System.out.println("生成文件："+savePath);
    }
    
    /**
     * 生成指定表对象对应的视图文件 
     * @param table 
     */  
    private void generateViewFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir=getSaveFilePath(module,module.getViewPackage());
    	File saveFile = new File(saveDir,table.getEntityCamelName()+".view.xml");
    	
    	String savePath =saveFile.getAbsolutePath();
    	System.out.println("生成文件："+savePath);
    	FreemarkerUtil.createDoc(obj, "View", savePath);
    }
    
    /**
     * 生成dorado的公用model文件
     * @param table
     * @param module
     * @return
     */
    private String generateDoradoModelString(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	String str = FreemarkerUtil.createString(obj,"DoradoModel");
    	//System.out.println(str);
    	return str;
    }
    
    /**
     * 写入model文件，如果model已存在，则增加内容
     * @param fileName
     * @param content
     * @throws IOException
     */
    private void writeModelFile(String fileName,String content) throws IOException {
    	FileOutputStream fos=null;
    	Writer out = null;
        try {
        	File dir = new File(config.getBaseDir()+ File.separator + "models");
        	if (!dir.exists()) {
        		dir.mkdirs();
        	}
        	File modelFile = new File(dir,fileName);
        	if (modelFile.exists()) {
        		//如果文件存在，则读取出文件，再增加参数中的内容后，再写回文件
        		String cont = readFile(modelFile);
        		content = cont.replace("</Model>", content+"\n</Model>");
        	} else {
        		content="<?xml version=\"1.0\" encoding=\"UTF-8\"?><Model>"+content+"</Model>";
        	}
        	//System.out.println(content);
            fos = new FileOutputStream(modelFile);  
            OutputStreamWriter oWriter = new OutputStreamWriter(fos,"UTF-8");  
            //这个地方对流的编码不可或缺，使用main（）单独调用时，应该可以，但是如果是web请求导出时导出后word文档就会打不开，并且包XML文件错误。主要是编码格式不正确，无法解析。  
            //out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile)));  
             out = new BufferedWriter(oWriter);   
        } catch (FileNotFoundException e1) {  
            e1.printStackTrace();  
        } catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
        out.write(content);
        out.close();
        fos.close();
        System.out.println("生成文件："+config.getBaseDir()+ File.separator + "models"+File.separator +fileName);
    }
    /**
     * 读取文件内容到一个字符串中
     * @param f
     * @return
     */
	private static String readFile(File file) {
		StringBuffer result = new StringBuffer();
		try {
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "utf-8"));// 构造一个BufferedReader类来读取文件
			String s = null;
			while ((s = br.readLine()) != null) {// 使用readLine方法，一次读一行
				result.append(s);
				result.append("\n");
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
    
    public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException {  
        DataBase2File reverser = new DataBase2File(); 
        reverser.generateFiles(); 
          
    }  
      
}  


