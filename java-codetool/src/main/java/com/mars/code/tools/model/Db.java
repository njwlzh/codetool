package com.mars.code.tools.model;

/**
 * 数据库连接信息
 * @author mars.liu
 *
 */
public class Db {
	private String dbType;
	private String user;
	private String pwd;
	private String driver;
	private String url;
	private String dbName;
	
	public String getDbType() {
		return dbType;
	}
	public void setDbType(String dbType) {
		this.dbType = dbType;
	}
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
		return "Db [dbType=" + dbType + ", user=" + user + ", pwd=" + pwd
				+ ", driver=" + driver + ", url=" + url + ", dbName=" + dbName
				+ "]";
	}
}
