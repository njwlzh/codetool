package com.mars.code.tools.model;

import java.util.List;

/**
 * 模块信息
 * @author mars.liu
 */
public class Module {
	private String name; //模块名称
	/**
	 * 启用的持久层框架，选项有：hibernate,mybatis,jdbc，其中hibernate为默认
	 */
	private String persistance; //
	private boolean isDeleteTablePrefix; //是否删除表前缀
	private String savePath; //默认保存目录，文件保存到该目录下，暂时不使用此属性值
	private String framework;//使用前端框架，可设置为dorado和mvc，mvc表示使用spring-mvc
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
	
	public String getFramework() {
		return framework;
	}
	public void setFramework(String framework) {
		this.framework = framework;
	}
	@Override
	public String toString() {
		return "Module [name=" + name + ", persistance=" + persistance
				+ ", isDeleteTablePrefix=" + isDeleteTablePrefix
				+ ", savePath=" + savePath + ", framework=" + framework
				+ ", daoPackage=" + daoPackage + ", daoImplPackage="
				+ daoImplPackage + ", servicePackage=" + servicePackage
				+ ", serviceImplPackage=" + serviceImplPackage
				+ ", entityPackage=" + entityPackage + ", actionPackage="
				+ actionPackage + ", viewPackage=" + viewPackage
				+ ", mapperPackage=" + mapperPackage + ", myBatisPackage="
				+ myBatisPackage + ", tables=" + tables + "]";
	}
}
