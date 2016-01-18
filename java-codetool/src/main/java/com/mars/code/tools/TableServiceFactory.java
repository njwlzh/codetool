package com.mars.code.tools;

import com.mars.code.tools.dbservice.ITableService;
import com.mars.code.tools.dbservice.impl.MysqlTableService;
import com.mars.code.tools.dbservice.impl.OracleTableService;
import com.mars.code.tools.dbservice.impl.SqlServerTableService;

/**
 * 针对各类数据库的服务创建工厂
 * @author mars.liu
 *
 */
public class TableServiceFactory {
	
	public static ITableService getInstance(String dbType) {
		dbType = dbType.toLowerCase();
		if (dbType.equals("mysql")) {
			return getMysqlService();
		} else if (dbType.equals("oracle")) {
			return getOracleService();
		} else if (dbType.equals("sqlserver")) {
			return getSqlServerService();
		}
		throw new RuntimeException("不支持的数据库类型");
	}
	
	private static ITableService getMysqlService(){
		return new MysqlTableService();
	}
	
	private static ITableService getOracleService(){
		return new OracleTableService();
	}
	
	private static ITableService getSqlServerService(){
		return new SqlServerTableService();
	}

}
