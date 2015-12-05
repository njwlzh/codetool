package com.mars.code.tools;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.Element;

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
	private PackageSetting packageSetting;
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
		//加载数据库配置
		Element dbNode = XmlUtil.getChild(root, "db");
		Db db = new Db();
		db.setDriver(XmlUtil.getChild(dbNode, "driver").getTextTrim());
		db.setPwd(XmlUtil.getChild(dbNode, "pwd").getTextTrim());
		db.setUrl(XmlUtil.getChild(dbNode, "url").getTextTrim());
		db.setUser(XmlUtil.getChild(dbNode, "user").getTextTrim());
		db.setDbName(XmlUtil.getChild(dbNode, "dbName").getTextTrim());
		cfg.setDb(db);
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
			m.setName(name.getValue());
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
	private String parentField;// 如果是主从表，则从表需设置该属性，表示父表的关联属性
	private String refType; //表关联类型，分为OneToOne,OneToMany等
	
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
	
	public String getParentField() {
		return parentField;
	}
	public void setParentField(String parentField) {
		this.parentField = parentField;
	}
	
	public String getRefType() {
		return refType;
	}
	public void setRefType(String refType) {
		this.refType = refType;
	}
	@Override
	public String toString() {
		return "TableConf [name=" + name + ", prefix=" + prefix
				+ ", entityName=" + entityName + ", parentField=" + parentField
				+ ", refType=" + refType + ", subTables=" + subTables + "]";
	}
}

/**
 * 定义全局表名设置
 * @author mars.liu
 *
 */
class PackageSetting{
	private String daoPackage;
	private String daoImplPackage;
	private String servicePackage;
	private String serviceImplPackage;
	private String entityPackage;
	private String mapperPackage;
	private String actionPackage;
	private String viewPackage;
	private Boolean isDeleteTablePrefix;
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
	public String getMapperPackage() {
		return mapperPackage;
	}
	public void setMapperPackage(String mapperPackage) {
		this.mapperPackage = mapperPackage;
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
	public Boolean getIsDeleteTablePrefix() {
		return isDeleteTablePrefix;
	}
	public void setIsDeleteTablePrefix(Boolean isDeleteTablePrefix) {
		this.isDeleteTablePrefix = isDeleteTablePrefix;
	}
	 
}