package com.mars.code.tools.model;
/**
 * 定义全局表名设置
 * @author mars.liu
 *
 */
public class PackageSetting {
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
