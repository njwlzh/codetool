package com.mars.code.tools;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.Element;

import com.mars.code.tools.model.Db;
import com.mars.code.tools.model.Module;
import com.mars.code.tools.model.PackageSetting;
import com.mars.code.tools.model.TableConf;
import com.mars.code.tools.utils.XmlUtil;

/**
 * 读取配置文件
 * @author mars.liu
 *
 */
public class Config {
	private String baseDir; //文件存放默认路径
	private String basePackage; //包路径的前缀，如com.mars，后面则跟上模块名等
	private Db db; //连接数据库的配置信息
	private List<Module> modules; //要生成的代码模块列表
	private PackageSetting packageSetting; //全局包名设置
	private String theme; //全局界面模板风格
	private List<String> ignoreColumns;
	public String getBaseDir() {
		return baseDir;
	}
	public void setBaseDir(String baseDir) {
		this.baseDir = baseDir;
	}
	public String getBasePackage() {
		return basePackage;
	}
	public void setBasePackage(String basePackage) {
		this.basePackage = basePackage;
	}
	public Db getDb() {
		return db;
	}
	public void setDb(Db db) {
		this.db = db;
	}
	public List<Module> getModules() {
		return modules;
	}
	public void setModules(List<Module> modules) {
		this.modules = modules;
	}
	
	public PackageSetting getPackageSetting() {
		return packageSetting;
	}
	public void setPackageSetting(PackageSetting packageSetting) {
		this.packageSetting = packageSetting;
	}
	
	public String getTheme() {
		return theme;
	}
	public void setTheme(String theme) {
		this.theme = theme;
	}
	
	public List<String> getIgnoreColumns() {
		return ignoreColumns;
	}
	public void setIgnoreColumns(List<String> ignoreColumns) {
		this.ignoreColumns = ignoreColumns;
	}
	@Override
	public String toString() {
		return "Config [baseDir=" + baseDir + ", basePackage=" + basePackage
				+ ", db=" + db + ", modules=" + modules + "]";
	}
	public static Config loadConfig(){
		Config cfg = new Config();
		
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-babyshop-mysql.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-b2c.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-back.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-babyshop.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-kmair-questionaire.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-kmair-insurance.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-pubinfo.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-ymy.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-camp-admin.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-simplelife.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-kmair-member.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-youmai-hr.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-jinke-ppm.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-washing.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-washing-mis.xml"));
		Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-kitchen-coat.xml"));
		//Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config-youmai-system.xml"));
		Element root = XmlUtil.getRootNode(doc);
		
		cfg.setBaseDir(XmlUtil.getChild(root, "baseDir").getTextTrim());
		Element elemThem = XmlUtil.getChild(root, "theme");
		if (elemThem==null){
			cfg.setTheme("");
		} else {
			cfg.setTheme(elemThem.getTextTrim());
		}
		cfg.setBasePackage(XmlUtil.getChild(root, "basePackage").getTextTrim());
		//加载数据库配置
		Element dbNode = XmlUtil.getChild(root, "db");
		Db db = new Db();
		String dbType;
		Element elemDbType=XmlUtil.getChild(dbNode, "dbType");
		if (elemDbType==null) {
			dbType="mysql";
		} else {
			dbType=elemDbType.getTextTrim();
		}
		db.setDbType(dbType);
		db.setDriver(XmlUtil.getChild(dbNode, "driver").getTextTrim());
		db.setPwd(XmlUtil.getChild(dbNode, "pwd").getTextTrim());
		db.setUrl(XmlUtil.getChild(dbNode, "url").getTextTrim());
		db.setUser(XmlUtil.getChild(dbNode, "user").getTextTrim());
		db.setDbName(XmlUtil.getChild(dbNode, "dbName").getTextTrim());
		cfg.setDb(db);
		
		//设置公共忽略字段
		//加载ignoreColumns
		List<String> ignoreColumnList = new ArrayList<String>();
		Element ignoreColumns = XmlUtil.getChild(root, "ignoreColumns");
		if (ignoreColumns!=null){
			ignoreColumnList = Arrays.asList(ignoreColumns.getTextTrim().split(","));
		}
		cfg.setIgnoreColumns(ignoreColumnList);
		//加载包名设置
		Element pkg = XmlUtil.getChild(root, "packageSetting");
		PackageSetting pkgSetting=new PackageSetting();
		pkgSetting.setActionPackage(XmlUtil.getChild(pkg, "actionPackage").getTextTrim());
		pkgSetting.setViewPackage(XmlUtil.getChild(pkg, "viewPackage").getTextTrim());
		pkgSetting.setEntityPackage(XmlUtil.getChild(pkg, "entityPackage").getTextTrim());
		pkgSetting.setMapperPackage(XmlUtil.getChild(pkg, "mapperPackage").getTextTrim());
		pkgSetting.setDaoPackage(XmlUtil.getChild(pkg, "daoPackage").getTextTrim());
		pkgSetting.setDaoImplPackage(XmlUtil.getChild(pkg, "daoImplPackage").getTextTrim());
		pkgSetting.setServicePackage(XmlUtil.getChild(pkg, "servicePackage").getTextTrim());
		pkgSetting.setServiceImplPackage(XmlUtil.getChild(pkg, "serviceImplPackage").getTextTrim());
		pkgSetting.setIsDeleteTablePrefix(Boolean.valueOf(XmlUtil.getChild(pkg, "isDeleteTablePrefix").getTextTrim()));
		cfg.setPackageSetting(pkgSetting);
		//加载module
		List<Module> moduleList = new ArrayList<Module>();
		List<Element> modules = XmlUtil.getChildElements(root, "module");
		for (Element e : modules) {
			Module m = new Module();
			Element persistance = XmlUtil.getChild(e, "persistance");
			if (persistance==null) {
				m.setPersistance("hibernate");
			} else {
				m.setPersistance(XmlUtil.getChild(e, "persistance").getTextTrim());
			}
			m.setName(XmlUtil.getChild(e, "name").getTextTrim());
			m.setSavePath(XmlUtil.getChild(e, "savePath").getTextTrim());
			m.setFramework(XmlUtil.getChild(e, "framework").getTextTrim());
			
			Element elePkg = XmlUtil.getChild(e, "actionPackage");
			m.setActionPackage(elePkg==null?pkgSetting.getActionPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "isDeleteTablePrefix");
			m.setDeleteTablePrefix(elePkg==null?pkgSetting.getIsDeleteTablePrefix():Boolean.valueOf(elePkg.getTextTrim()));
			elePkg=XmlUtil.getChild(e, "daoImplPackage");
			m.setDaoImplPackage(elePkg==null?pkgSetting.getDaoImplPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "daoPackage");
			m.setDaoPackage(elePkg==null?pkgSetting.getDaoPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "entityPackage");
			m.setEntityPackage(elePkg==null?pkgSetting.getEntityPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "mapperPackage");
			m.setMapperPackage(elePkg==null?pkgSetting.getMapperPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "serviceImplPackage");
			m.setServiceImplPackage(elePkg==null?pkgSetting.getServiceImplPackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "servicePackage");
			m.setServicePackage(elePkg==null?pkgSetting.getServicePackage():elePkg.getTextTrim());
			elePkg = XmlUtil.getChild(e, "viewPackage");
			m.setViewPackage(elePkg==null?pkgSetting.getViewPackage():elePkg.getTextTrim());
			//页面模板
			Element eleTheme = XmlUtil.getChild(e, "theme");
			if (eleTheme!=null) {
				String theme = eleTheme.getTextTrim();
				if (theme!=null && theme.length()>0){
					m.setTheme(theme);
				}
			}
			//加载table
			m.setTables(readTableConfList(e));
			moduleList.add(m);
		}
		cfg.setModules(moduleList);
		return cfg;
	}
	
	/**
	 * 以递归方式读取主从表关系
	 * @param module
	 * @return
	 */
	private static List<TableConf> readTableConfList(Element module){
		List<TableConf> tableList = new ArrayList<TableConf>();
		List<Element> tables = XmlUtil.getChildElements(module, "table");
		for (Element e : tables) {
			TableConf m = initTableConf(e);
			List<TableConf> subTables = readTableConfList(e);
			if (subTables!=null && !subTables.isEmpty()) {
				m.getSubTables().addAll(subTables);
			}
			tableList.add(m);
		}
		return tableList;
	}
	/**
	 * 初始化配置的表格信息
	 * @param e
	 * @return
	 */
	private static TableConf initTableConf(Element e){
		TableConf m = new TableConf();
		Attribute attr = XmlUtil.getAttribute(e, "entityName");
		if (attr!=null) {
			m.setEntityName(attr.getValue());
		}
		Attribute name = XmlUtil.getAttribute(e, "name");
		if (name!=null) {
			m.setName(name.getValue().toUpperCase());
		}
		Attribute prefix = XmlUtil.getAttribute(e, "prefix");
		if (prefix!=null) {
			m.setPrefix(prefix.getValue());
		}
		Attribute parentField = XmlUtil.getAttribute(e, "parentField");
		if (parentField!=null) {
			m.setParentField(parentField.getValue());
		}
		Attribute refType =XmlUtil.getAttribute(e, "refType");
		if (refType!=null) {
			m.setRefType(refType.getValue());
		} else {
			m.setRefType("OneToMany"); //默认OneToMany
		}
		return m;
	}
	
	public static void main(String[] args) {
		Config.loadConfig();
	}
	
}
