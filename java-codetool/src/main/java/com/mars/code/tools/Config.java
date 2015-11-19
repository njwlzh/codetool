package com.mars.code.tools;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.Element;

/**
 * 读取配置文件
 * @author Administrator
 *
 */
public class Config {
	private String baseDir; //文件存放默认路径
	private String basePackage; //包路径的前缀，如com.mars，后面则跟上模块名等
	private Db db; //连接数据库的配置信息
	private List<Module> modules; //要生成的代码模块列表
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
	
	@Override
	public String toString() {
		return "Config [baseDir=" + baseDir + ", basePackage=" + basePackage
				+ ", db=" + db + ", modules=" + modules + "]";
	}
	public static Config loadConfig(){
		Config cfg = new Config();
		
		Document doc = XmlUtil.getDocument(Config.class.getClassLoader().getResourceAsStream("config.xml"));
		Element root = XmlUtil.getRootNode(doc);
		
		cfg.setBaseDir(XmlUtil.getChild(root, "baseDir").getTextTrim());
		cfg.setBasePackage(XmlUtil.getChild(root, "basePackage").getTextTrim());
		
		Element dbNode = XmlUtil.getChild(root, "db");
		Db db = new Db();
		db.setDriver(XmlUtil.getChild(dbNode, "driver").getTextTrim());
		db.setPwd(XmlUtil.getChild(dbNode, "pwd").getTextTrim());
		db.setUrl(XmlUtil.getChild(dbNode, "url").getTextTrim());
		db.setUser(XmlUtil.getChild(dbNode, "user").getTextTrim());
		db.setDbName(XmlUtil.getChild(dbNode, "dbName").getTextTrim());
		cfg.setDb(db);
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
			m.setActionPackage(XmlUtil.getChild(e, "actionPackage").getTextTrim());
			m.setDaoImplPackage(XmlUtil.getChild(e, "daoImplPackage").getTextTrim());
			m.setDaoPackage(XmlUtil.getChild(e, "daoPackage").getTextTrim());
			m.setDeleteTablePrefix(Boolean.valueOf(XmlUtil.getChild(e, "isDeleteTablePrefix").getTextTrim()));
			m.setEntityPackage(XmlUtil.getChild(e, "entityPackage").getTextTrim());
			m.setMapperPackage(XmlUtil.getChild(e, "mapperPackage").getTextTrim());
			m.setSavePath(XmlUtil.getChild(e, "savePath").getTextTrim());
			m.setServiceImplPackage(XmlUtil.getChild(e, "serviceImplPackage").getTextTrim());
			m.setServicePackage(XmlUtil.getChild(e, "servicePackage").getTextTrim());
			m.setViewPackage(XmlUtil.getChild(e, "viewPackage").getTextTrim());
			//加载table
			m.setTables(readTableConfList(e));
			moduleList.add(m);
		}
		cfg.setModules(moduleList);
		return cfg;
	}
	
	private static List<TableConf> readTableConfList(Element module){
		List<TableConf> tableList = new ArrayList<TableConf>();
		List<Element> tables = XmlUtil.getChildElements(module, "table");
		for (Element e : tables) {
			TableConf m = initTableConf(e);
			//获取子表
			List<Element> subTables = XmlUtil.getChildElements(e, "subTable");
			if (subTables!=null) {
				for (Element el : subTables) {
					TableConf sub = initTableConf(el);
					m.getSubTables().add(sub);
				}
			}
			tableList.add(m);
		}
		return tableList;
	}
	
	private static TableConf initTableConf(Element e){
		TableConf m = new TableConf();
		Attribute attr = XmlUtil.getAttribute(e, "entityName");
		if (attr!=null) {
			m.setEntityName(attr.getValue());
		}
		Attribute name = XmlUtil.getAttribute(e, "name");
		if (name!=null) {
			m.setName(name.getValue());
		}
		Attribute prefix = XmlUtil.getAttribute(e, "prefix");
		if (prefix!=null) {
			m.setPrefix(prefix.getValue());
		}
		Attribute parentProperty = XmlUtil.getAttribute(e, "parentProperty");
		if (parentProperty!=null) {
			m.setParentProperty(parentProperty.getValue());
		}
		return m;
	}
	
	public static void main(String[] args) {
		Config.loadConfig();
	}
	
}
/**
 * 数据库连接信息
 * @author mars.liu
 *
 */
class Db{
	private String user;
	private String pwd;
	private String driver;
	private String url;
	private String dbName;
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	
	public String getDbName() {
		return dbName;
	}
	public void setDbName(String dbName) {
		this.dbName = dbName;
	}
	
	@Override
	public String toString() {
		return "Db [user=" + user + ", pwd=" + pwd + ", driver=" + driver
				+ ", url=" + url + ", dbName=" + dbName + "]";
	}
	
}
/**
 * 模块信息
 * @author mars.liu
 *
 */
class Module{
	private String name; //模块名称
	/**
	 * 启用的持久层框架，选项有：hibernate,mybatis,jdbc，其中hibernate为默认
	 */
	private String persistance; //
	private boolean isDeleteTablePrefix; //是否删除表前缀
	private String savePath; //默认保存目录，文件保存到该目录下，暂时不使用此属性值
	private String daoPackage;
	private String daoImplPackage;
	private String servicePackage;
	private String serviceImplPackage;
	private String entityPackage;
	private String actionPackage;
	private String viewPackage;
	private String mapperPackage;
	private String myBatisPackage;
	private List<TableConf> tables; //配置的数据表信息
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isDeleteTablePrefix() {
		return isDeleteTablePrefix;
	}
	public void setDeleteTablePrefix(boolean isDeleteTablePrefix) {
		this.isDeleteTablePrefix = isDeleteTablePrefix;
	}
	public String getSavePath() {
		return savePath;
	}
	public void setSavePath(String savePath) {
		this.savePath = savePath;
	}
	public String getDaoPackage() {
		return daoPackage;
	}
	public void setDaoPackage(String daoPackage) {
		this.daoPackage = daoPackage;
	}
	public String getDaoImplPackage() {
		return daoImplPackage;
	}
	public void setDaoImplPackage(String daoImplPackage) {
		this.daoImplPackage = daoImplPackage;
	}
	public String getServicePackage() {
		return servicePackage;
	}
	public void setServicePackage(String servicePackage) {
		this.servicePackage = servicePackage;
	}
	public String getServiceImplPackage() {
		return serviceImplPackage;
	}
	public void setServiceImplPackage(String serviceImplPackage) {
		this.serviceImplPackage = serviceImplPackage;
	}
	public String getEntityPackage() {
		return entityPackage;
	}
	public void setEntityPackage(String entityPackage) {
		this.entityPackage = entityPackage;
	}
	public String getActionPackage() {
		return actionPackage;
	}
	public void setActionPackage(String actionPackage) {
		this.actionPackage = actionPackage;
	}
	public String getViewPackage() {
		return viewPackage;
	}
	public void setViewPackage(String viewPackage) {
		this.viewPackage = viewPackage;
	}
	public String getMapperPackage() {
		return mapperPackage;
	}
	public void setMapperPackage(String mapperPackage) {
		this.mapperPackage = mapperPackage;
	}
	public List<TableConf> getTables() {
		return tables;
	}
	public void setTables(List<TableConf> tables) {
		this.tables = tables;
	}
	
	public String getPersistance() {
		return persistance;
	}
	public void setPersistance(String persistance) {
		this.persistance = persistance;
	}
	
	public String getMyBatisPackage() {
		return myBatisPackage;
	}
	public void setMyBatisPackage(String mybatisPackage) {
		this.myBatisPackage = mybatisPackage;
	}
	
	@Override
	public String toString() {
		return "Module [name=" + name + ", persistance=" + persistance
				+ ", isDeleteTablePrefix=" + isDeleteTablePrefix
				+ ", savePath=" + savePath + ", daoPackage=" + daoPackage
				+ ", daoImplPackage=" + daoImplPackage + ", servicePackage="
				+ servicePackage + ", serviceImplPackage=" + serviceImplPackage
				+ ", entityPackage=" + entityPackage + ", actionPackage="
				+ actionPackage + ", viewPackage=" + viewPackage
				+ ", mapperPackage=" + mapperPackage + ", mybatisPackage="
				+ myBatisPackage + ", tables=" + tables + "]";
	}
	
}
/**
 * 模块中表的定义
 * @author mars.liu
 *
 */
class TableConf{
	private String name; //表名
	private String prefix;//表前缀
	private String entityName;//配置的实体类名
	private String parentProperty;// 如果是主从表，则从表需设置该属性，表示父表的关联属性
	
	private List<TableConf> subTables = new ArrayList<TableConf>();//子表列表，即一对多的子表
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPrefix() {
		return prefix;
	}
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	public String getEntityName() {
		return entityName;
	}
	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}
	
	public List<TableConf> getSubTables() {
		return subTables;
	}
	public void setSubTables(List<TableConf> subTables) {
		this.subTables = subTables;
	}
	
	public String getParentProperty() {
		return parentProperty;
	}
	public void setParentProperty(String parentProperty) {
		this.parentProperty = parentProperty;
	}
	@Override
	public String toString() {
		return "TableConf [name=" + name + ", prefix=" + prefix
				+ ", entityName=" + entityName + ", parentProperty="
				+ parentProperty + ", subTables=" + subTables + "]";
	}
	
}