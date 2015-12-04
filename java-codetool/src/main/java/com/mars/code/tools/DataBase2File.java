package com.mars.code.tools;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
  
/** 
 * 通过数据库表结构生成表对应的实体类以及根据entity,view,action、service和dao模板生成基本的相关文件 
 */  
public class DataBase2File {
	
	private static Config config=null;
	static{
		config = Config.loadConfig();
	}
      
    /** 
     * 主方法，反转生成相关文件 
     * @throws IOException  
     * @throws ClassNotFoundException 
     * @throws SQLException 
     */  
    public void generateFiles() throws IOException, ClassNotFoundException, SQLException {
        System.out.println("Generating..."); 
        Long start=System.currentTimeMillis();
        Class.forName(config.getDb().getDriver());  
        Connection con = DriverManager.getConnection(config.getDb().getUrl(), config.getDb().getUser(),config.getDb().getPwd());  
        for (Module module : config.getModules()) {
        	System.out.println("module="+module.getName());
        	//如果没有配置数据表，则默认加载模块名为前缀的所有数据表
        	if (module.getTables()==null || module.getTables().isEmpty()) {
        		module.setTables(getAllTables(module.getName()+"%"));
        	}
        	//系统的model文件
        	StringBuffer sbModel = new StringBuffer("");
        	if (module.getTables()!=null) {
	        	for (TableConf tbConf : module.getTables()) {
	        		System.out.println(tbConf.getName());
	        		Table table = getTable(tbConf,module, con);//获取一个表的相关信息
	        		generateEntityFile(table, module);//通过成entity
	                generateServiceFile(table, module);//生成service
	                generateActionFile(table,module);//生成action
	                generateViewFile(table,module);//生成view
	                generateDaoFile(table, module);//生成dao
	              //生成model的数据块
	                sbModel.append(generateDoradoModelString(table, module));
	                //生成子表对象
	                if (!table.getSubTables().isEmpty()) {
	                	for (Table tb : table.getSubTables()) {
	                		generateEntityFile(tb, module);//通过成entity
	    	                generateServiceFile(tb, module);//生成service
	    	                generateActionFile(tb,module);//生成action
	    	                generateViewFile(tb,module);//生成view
	    	                generateDaoFile(tb, module);//生成dao
	    	              //生成model的数据块
	    	                sbModel.append(generateDoradoModelString(tb, module));
	                	}
	                }
                	
	        	}
        	}
        	writeModelFile(module.getName()+".model.xml", sbModel.toString());//生成model文件
        }
        con.close();
        Long end = System.currentTimeMillis();
        System.out.println("Generate Success! total time = "+(end-start));
        System.out.println("Please check: " + config.getBaseDir());
    }  
      
    /* 
     * 连接数据库获取所有表信息 
     */  
    private List<TableConf> getAllTables(String pattern) {  
        if (isEmpty(pattern)) {
        	pattern="*";
        }
        List<TableConf> tbConfList = new ArrayList<TableConf>();
        Connection con = null;  
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {  
            Class.forName(config.getDb().getDriver());  
            con = DriverManager.getConnection(config.getDb().getUrl(), config.getDb().getUser(),config.getDb().getPwd());  
            // 获取所有表名  
            String showTablesSql = "";  
            if(config.getDb().getDriver().toLowerCase().indexOf("mysql")!=-1) {  
                showTablesSql = "show tables like '"+pattern+"'";  // MySQL查询所有表格名称命令  
            } else if(config.getDb().getDriver().toLowerCase().indexOf("sqlserver")!=-1) {  
                showTablesSql = "SELECT TABLE_NAME FROM edp.INFORMATION_SCHEMA.TABLES Where TABLE_TYPE='BASE TABLE' and table_name like '"+pattern+"'";  // SQLServer查询所有表格名称命令  
            } else if(config.getDb().getDriver().toLowerCase().indexOf("oracle")!=-1) {  
                showTablesSql = "select table_name from user_tables where table_name like '"+pattern+"'"; // ORACLE查询所有表格名称命令  
            }  
            ps = con.prepareStatement(showTablesSql);  
            rs = ps.executeQuery();  
              
            // 循环生成所有表的表信息
            while(rs.next()) {  
                if(rs.getString(1)==null) continue;  
                TableConf cf = new TableConf();
                cf.setName(rs.getString(1));
                tbConfList.add(cf);
            }  
              
            rs.close();  
            ps.close(); 
            con.close();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
          
        return tbConfList;  
    }  
      
    /* 
     * 获取指定表信息并封装成Table对象 
     * @param tableName 
     * @param con 
     */  
    private Table getTable(TableConf tbConf,Module module, Connection con) throws SQLException {
    	String tableName =tbConf.getName();
        Table table = new Table(); 
        table.setTableFullName(tableName);
        table.setTableName(tableName);
        if (module.isDeleteTablePrefix() && !isEmpty(tbConf.getPrefix())){
        	table.setTableName(tableName.toLowerCase().replaceFirst(tbConf.getPrefix(), ""));  
        }
        //table.setTableName(tableName);  
        
        /*PreparedStatement ps = con.prepareStatement(" SELECT * FROM "+tableName);  
        ResultSet rs = ps.executeQuery();  
        ResultSetMetaData rsmd = rs.getMetaData();  
        int columCount = rsmd.getColumnCount();  
        for(int i=1; i<=columCount; i++) {
        	Column col = new Column();
        	String colName = rsmd.getColumnName(i).trim();
        	col.setColumnName(colName);
        	col.setColumnType(rsmd.getColumnTypeName(i).trim());
        	col.setRemark(getColumnRemark(tableName,colName,con));
        	col.setPropertyName(convertToFirstLetterLowerCaseCamelCase(colName));
        	col.setPropertyType(convertType(col.getColumnType()));
        	col.setPropertyCamelName(convertToCamelCase(colName));
        	if (table.getPrimaryKey().equals(colName)) {
        		col.setPrimaryKey(true);
        	}
        	if (col.getPropertyType().indexOf(".")!=-1 && !existsType(table.getImportClassList(),col.getPropertyType())) {
        		table.getImportClassList().add(col.getPropertyType());
        	}
        	table.getColumns().add(col);
        } */ 
        //获取表各字段的信息
        getTableColumns(table,con);
        table.setPrimaryKey(getTablePrimaryKey(tableName, con));
        table.setPrimaryProperty(convertToFirstLetterLowerCaseCamelCase(table.getPrimaryKey())); 
        table.setRemark(getTableRemark(tableName, con));
        table.setPrimaryKeyType(getColumnType(table, table.getPrimaryKey()));
        table.setPrimaryPropertyType(convertType(table.getPrimaryKeyType()));
        table.setPrimaryCamelProperty(convertToCamelCase(table.getPrimaryKey()));
        table.setEntityCamelName(isEmpty(tbConf.getEntityName())?convertToCamelCase(table.getTableName()):tbConf.getEntityName());
        table.setEntityName(convertToFirstLetterLowerCaseCamelCase(table.getTableName()));
        table.setModule(module);
        //设置子表的entity属性
        if (!tbConf.getSubTables().isEmpty()) {
        	List<Table> subTables = new ArrayList<Table>();
        	for (TableConf tc : tbConf.getSubTables()) {
        		Table tb = getTable(tc,module,con);
        		tb.setParentProperty(convertToFirstLetterLowerCaseCamelCase(tc.getParentField()));
        		tb.setRefType(tc.getRefType());
        		subTables.add(tb);
        	}
        	table.setSubTables(subTables);
        }
        //rs.close();  
        //ps.close();  
          
        return table;  
    } 
    
    private void getTableColumns(Table table,Connection conn) throws SQLException {
    	if (config.getDb().getDriver().toLowerCase().indexOf("mysql")!=-1) {
			String sql="select * from information_schema.COLUMNS where TABLE_SCHEMA=? and TABLE_NAME=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1,config.getDb().getDbName());
			ps.setString(2,table.getTableFullName());
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Column col = new Column();
	        	String colName = rs.getString("column_name");
	        	col.setColumnName(colName);
	        	String type = rs.getString("data_type").toUpperCase();
	        	if (type.equals("TEXT")){
	        		type="LONGVARCHAR";
	        	}
	        	col.setColumnType(type);
	        	col.setRemark(rs.getString("column_comment"));
	        	col.setPropertyName(convertToFirstLetterLowerCaseCamelCase(colName));
	        	col.setPropertyType(convertType(col.getColumnType()));
	        	col.setPropertyCamelName(convertToCamelCase(colName));
	        	col.setNullable(rs.getString("is_nullable").equals("YES"));
	        	col.setLength(rs.getLong("character_maximum_length"));
	        	col.setDefaultValue(rs.getString("column_default"));
	        	
	        	String colKey = rs.getString("column_key");
	        	if (!isEmpty(colKey) && colKey.toLowerCase().equals("pri")) {
	        		col.setPrimaryKey(true);
	        	}
	        	if (col.getPropertyType().indexOf(".")!=-1 && !existsType(table.getImportClassList(),col.getPropertyType())) {
	        		table.getImportClassList().add(col.getPropertyType());
	        	}
	        	table.getColumns().add(col);
			}
			rs.close();
			ps.close();
		} else { //其它数据库
			
		}
    }
    
    private static boolean isEmpty(String str) {
    	if (str==null) {
    		return true;
    	}
    	if (str.length()==0) {
    		return true;
    	}
    	return false;
    }
    
    private boolean existsType(List<String> list , String type) {
    	return list.contains(type);
    }
    
    /**
	 * 表主键
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public String getTablePrimaryKey(String tableName, Connection con) throws SQLException{
		DatabaseMetaData dbMeta = con.getMetaData(); 
		ResultSet rs = dbMeta.getPrimaryKeys(null,null,tableName);
		if (rs.next()){
			return (rs.getString("COLUMN_NAME"));
		}
		return null;
	}
	/**
	 * 主键类型
	 * @param tableName
	 * @param column 指定列名
	 * @return
	 * @throws SQLException
	 */
	public String getColumnType(Table table,String column) throws SQLException{
		String colType="";
		for (Column col : table.getColumns()) {
			if (col.getColumnName().equals(column)) {
				return col.getColumnType();
			}
		}
		return colType;
	}
	/**
	 * 表注释
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public String getTableRemark(String tableName, Connection con) throws SQLException {
		String remark="";
		if (config.getDb().getDriver().toLowerCase().indexOf("mysql")!=-1) {
			String sql="show table status where name=?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, tableName);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				remark=rs.getString("comment");
			}
			rs.close();
			ps.close();
		} else {
			DatabaseMetaData dbMeta = con.getMetaData(); 
			ResultSet rsMeta = dbMeta.getTables(null, null, tableName, new String[]{"TABLE"});//.getPrimaryKeys(null,null,tableName);
			ResultSetMetaData metaData = rsMeta.getMetaData();
			if (rsMeta.next()){
				for (int i=1;i<=metaData.getColumnCount();i++){
					String colName = metaData.getColumnName(i);
					System.out.println(colName+"="+rsMeta.getString(colName));
				}
				remark = (rsMeta.getString("REMARKS"));
			}
		}
		return remark;
	}
	
      
      
    /* 
     * 将数据库的数据类型转换为java的数据类型 
     */  
    private String convertType(String databaseType) {  
        String javaType = "";  
          
        String databaseTypeStr = databaseType.trim().toLowerCase();  
        if(databaseTypeStr.startsWith("int")||databaseTypeStr.equals("smallint")) {  
            javaType = "Integer";  
        } else if(databaseTypeStr.equals("char")) {  
            javaType = "String";  
        } else if(databaseTypeStr.equals("number")) {  
            javaType = "Integer";  
        } else if(databaseTypeStr.indexOf("varchar")!=-1) {  
            javaType = "String";  
        } else if(databaseTypeStr.equals("blob")) {  
            javaType = "Byte[]";  
        } else if(databaseTypeStr.equals("float")) {  
            javaType = "Float";  
        } else if(databaseTypeStr.equals("double")) {  
            javaType = "Double";  
        } else if(databaseTypeStr.equals("decimal")) {  
            javaType = "java.math.BigDecimal";  
        } else if(databaseTypeStr.startsWith("bigint")) {  
            javaType = "Long";  
        } else if(databaseTypeStr.equals("date")) {  
            javaType = "java.util.Date";  
        } else if(databaseTypeStr.equals("time")) {  
            javaType = "java.util.Date";  
        } else if(databaseTypeStr.equals("datetime")) {  
            javaType = "java.util.Date";  
        } else if(databaseTypeStr.equals("timestamp")) {  
            javaType = "java.util.Date";  
        } else if(databaseTypeStr.equals("year")) {  
            javaType = "java.util.Date";  
        } else {  
            javaType = "String";  
        }  
          
        return javaType;  
    }  
    
    private void setBaseInfo(JSONObject obj,Module module) {
    	obj.put("basePackage", config.getBasePackage());
    	obj.put("moduleName", module.getName());
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
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getEntityPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+".java");
    	
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "Entity", savePath);
    	System.out.println("生成文件："+savePath);
    }
    
    /**
     * 生成指定表映射的RowMapper类文件，用于jdbcTemplate的查询 
     * @param table 
     */  
    private void generateMapperFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getEntityPackage()+File.separator+module.getMapperPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
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
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getDaoPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Dao.java");
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "DaoInterface", savePath);
    	System.out.println("生成文件："+savePath);
    	//实现文件
    	if (!module.getPersistance().equals("mybatis")){
    		File implDir = new File(saveDir,module.getDaoImplPackage());
    		if (!implDir.exists()){
    			implDir.mkdirs();
    		}
	    	String templateName = "HibernateDaoImpl";
	    	if (module.getPersistance().equals("jdbc")) {
	    		generateMapperFile(table, module);
	    		templateName="JdbcDaoImpl";
	    	}
	    	File implFile = new File(implDir,table.getEntityCamelName()+"DaoImpl.java");
	    	String implPath =implFile.getAbsolutePath();
	    	FreemarkerUtil.createDoc(obj, templateName, implPath);
	    	System.out.println("生成文件："+implPath);
    	}
    	/**
    	 * 如果是mybatis，则生成mytabis的xml配置文件
    	 */
    	else {
    		if (!isEmpty(module.getSavePath())){ //配置了模块文件保存，则把文件全部生成到此目录下
    			saveDir = new File(module.getSavePath());
    		} else {
    			saveDir = new File(config.getBaseDir()+ File.separator + "resources/mapper" + File.separator+module.getName());
    		}
    		if (!saveDir.exists()) {
        		saveDir.mkdirs();
        	}
    		File implFile = new File(saveDir,table.getEntityCamelName()+"Mapper.xml");
	    	String implPath =implFile.getAbsolutePath();
	    	FreemarkerUtil.createDoc(obj, "MyBatis", implPath);
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
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getServicePackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Service.java");
    	String savePath =saveFile.getAbsolutePath();
    	System.out.println("生成文件："+savePath);
    	FreemarkerUtil.createDoc(obj, "ServiceInterface", savePath);
    	//实现文件
    	File implDir = new File(saveDir,module.getServiceImplPackage());
    	if (!implDir.exists()){
    		implDir.mkdirs();
    	}
    	File implFile = new File(implDir,table.getEntityCamelName()+"ServiceImpl.java");
    	String implPath =implFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "ServiceImpl", implPath);
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
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getActionPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+"Action.java");
    	
    	String savePath =saveFile.getAbsolutePath();
    	FreemarkerUtil.createDoc(obj, "Action", savePath);
    	System.out.println("生成文件："+savePath);
    }
    
    private String generateDoradoModelString(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	return FreemarkerUtil.createString(obj,"DoradoModel");
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
	public static String readFile(File file) {
		StringBuffer result = new StringBuffer();
		try {
			BufferedReader br = new BufferedReader(new FileReader(file));// 构造一个BufferedReader类来读取文件
			String s = null;
			while ((s = br.readLine()) != null) {// 使用readLine方法，一次读一行
				//result = result + "\n" + s;
				result.append(s);
				result.append("\n");
			}
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
    
    /**
     * 生成指定表对象对应的类文件 
     * @param table 
     */  
    private void generateViewFile(Table table,Module module) {
    	JSONObject obj = (JSONObject)JSON.toJSON(table);
    	setBaseInfo(obj,module);
    	File saveDir = new File(config.getBaseDir()+ File.separator + config.getBasePackage().replace(".", File.separator)+File.separator+module.getName()+File.separator+module.getViewPackage());
    	if (!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	File saveFile = new File(saveDir,table.getEntityCamelName()+".view.xml");
    	
    	String savePath =saveFile.getAbsolutePath();
    	System.out.println("生成文件："+savePath);
    	FreemarkerUtil.createDoc(obj, "View", savePath);
    }
      
    /* 
     * 表名转换为驼峰命名 
     */  
    private String convertToCamelCase(String str) {  
        String result = "";  
  
        String[] strArr = str.trim().split("_");  
        for(String s : strArr) {  
            if(s.length()>1) {  
                result += s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();  
            } else {  
                result += s.toUpperCase();  
            }  
        }  
  
        return result;  
    }
      
    /* 
     * 表名转换为首字母小写的驼峰命名 
     */  
    private String convertToFirstLetterLowerCaseCamelCase(String str) {  
        String resultCamelCase = convertToCamelCase(str);  
  
        String result = "";  
        if(resultCamelCase.length()>1) {  
            result = resultCamelCase.substring(0, 1).toLowerCase() + resultCamelCase.substring(1);  
        } else {  
            result = resultCamelCase.toLowerCase();  
        }  
          
        return result;  
    }  
      
    public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException {  
        DataBase2File reverser = new DataBase2File();  
        reverser.generateFiles(); 
          
    }  
      
}  

/** 
 * 表对象, 对应数据库表信息, 原汁原味, 未做处理 
 */  
class Table {
	private Module module;
	private String packageName;
	private String tableFullName;//完整表名
    private String tableName;  // 表名，去掉prefix
    private String entityName; //实体名
    private String entityCamelName; //完整实体类名
    private String remark; //表注释
    private String primaryKey;//主键
    private String primaryProperty;//主键属性名
    private String primaryPropertyType; //主键属性类型
    private String primaryCamelProperty;
    private String primaryKeyType;//主键类型
    
    private String parentProperty; //若为子表，则此属性为上级表的属性
    
    private List<String> importClassList=new ArrayList<String>();
    private List<Column> columns=new ArrayList<Column>();
    private List<Table> subTables = new ArrayList<Table>();
    private String refType; //表间关联类型
      
    public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getTableName() {  
        return tableName;  
    }  
  
    public void setTableName(String tableName) {  
        this.tableName = tableName;  
    }  
  

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(String primaryKey) {
		this.primaryKey = primaryKey;
	}


	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public List<Column> getColumns() {
		return columns;
	}

	public void setColumns(List<Column> columns) {
		this.columns = columns;
	}

	public List<String> getImportClassList() {
		return importClassList;
	}

	public void setImportClassList(List<String> importClassList) {
		this.importClassList = importClassList;
	}

	public String getEntityCamelName() {
		return entityCamelName;
	}

	public void setEntityCamelName(String entityCamelName) {
		this.entityCamelName = entityCamelName;
	}

	public String getPrimaryKeyType() {
		return primaryKeyType;
	}

	public void setPrimaryKeyType(String primaryKeyType) {
		this.primaryKeyType = primaryKeyType;
	}

	public String getPrimaryProperty() {
		return primaryProperty;
	}

	public void setPrimaryProperty(String primaryProperty) {
		this.primaryProperty = primaryProperty;
	}

	public String getPrimaryCamelProperty() {
		return primaryCamelProperty;
	}

	public void setPrimaryCamelProperty(String primaryCamelProperty) {
		this.primaryCamelProperty = primaryCamelProperty;
	}

	public String getPrimaryPropertyType() {
		return primaryPropertyType;
	}

	public void setPrimaryPropertyType(String primaryPropertyType) {
		this.primaryPropertyType = primaryPropertyType;
	}

	public Module getModule() {
		return module;
	}

	public void setModule(Module module) {
		this.module = module;
	}

	public String getTableFullName() {
		return tableFullName;
	}

	public void setTableFullName(String tableFullName) {
		this.tableFullName = tableFullName;
	}

	public List<Table> getSubTables() {
		return subTables;
	}

	public void setSubTables(List<Table> subTables) {
		this.subTables = subTables;
	}

	public String getParentProperty() {
		return parentProperty;
	}

	public void setParentProperty(String parentProperty) {
		this.parentProperty = parentProperty;
	}

	public String getRefType() {
		return refType;
	}

	public void setRefType(String refType) {
		this.refType = refType;
	}

	@Override
	public String toString() {
		return "Table [module=" + module + ", packageName=" + packageName
				+ ", tableFullName=" + tableFullName + ", tableName="
				+ tableName + ", entityName=" + entityName
				+ ", entityCamelName=" + entityCamelName + ", remark=" + remark
				+ ", primaryKey=" + primaryKey + ", primaryProperty="
				+ primaryProperty + ", primaryPropertyType="
				+ primaryPropertyType + ", primaryCamelProperty="
				+ primaryCamelProperty + ", primaryKeyType=" + primaryKeyType
				+ ", parentProperty=" + parentProperty + ", importClassList="
				+ importClassList + ", columns=" + columns + ", subTables="
				+ subTables + ", refType=" + refType + "]";
	}
	
}  

class Column{
    
    private String columnName;
    private String columnType;
    private String remark;
    private String propertyName; //属性名，首字小写
    private String propertyType;
    private String propertyCamelName; //首字大写的属性名
    private boolean isPrimaryKey;
    private boolean isNullable;//是否允许为空
    private Long length; //字段长度
    private Object defaultValue; //字段默认值
    
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public String getColumnType() {
		return columnType;
	}
	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getPropertyName() {
		return propertyName;
	}
	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}
	public boolean isPrimaryKey() {
		return isPrimaryKey;
	}
	public void setPrimaryKey(boolean isPrimaryKey) {
		this.isPrimaryKey = isPrimaryKey;
	}
	public String getPropertyType() {
		return propertyType;
	}
	public void setPropertyType(String propertyType) {
		this.propertyType = propertyType;
	}
	public String getPropertyCamelName() {
		return propertyCamelName;
	}
	public void setPropertyCamelName(String propertyCamelName) {
		this.propertyCamelName = propertyCamelName;
	}
	
	public boolean isNullable() {
		return isNullable;
	}
	public void setNullable(boolean isNullable) {
		this.isNullable = isNullable;
	}
	public Long getLength() {
		return length;
	}
	public void setLength(Long length) {
		this.length = length;
	}
	
	public Object getDefaultValue() {
		return defaultValue;
	}
	public void setDefaultValue(Object defaultValue) {
		this.defaultValue = defaultValue;
	}
	@Override
	public String toString() {
		return "Column [columnName=" + columnName + ", columnType="
				+ columnType + ", remark=" + remark + ", propertyName="
				+ propertyName + ", propertyType=" + propertyType
				+ ", propertyCamelName=" + propertyCamelName
				+ ", isPrimaryKey=" + isPrimaryKey + ", isNullable="
				+ isNullable + ", length=" + length + ", defaultValue="
				+ defaultValue + "]";
	}
    
}
