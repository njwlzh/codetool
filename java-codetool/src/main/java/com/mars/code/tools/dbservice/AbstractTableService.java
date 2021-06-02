/**
 * 
 */
package com.mars.code.tools.dbservice;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.mars.code.tools.Config;
import com.mars.code.tools.model.Module;
import com.mars.code.tools.model.Table;
import com.mars.code.tools.model.TableConf;

/**
 * 获取数据表和数据字段信息接口
 * @author mars.liu
 *
 */
public abstract class AbstractTableService {
	
	/**
	 * 注释分割符
	 */
	protected String REMARK_SEPERATOR = ":";
	protected String REMARK_SEPERATOR2 = "：";
	
	public abstract void setConfig(Config config);
	
	/**
     * 连接数据库获取所有表信息 
     */  
	public abstract List<TableConf> getAllTables(String pattern);
	
	 /**
     * 获取指定表信息并封装成Table对象 
     * @param tbConf 
     * @param module
     * @param con 
     */
	public abstract Table getTable(TableConf tbConf,Module module, Connection con) throws SQLException;
	
	/**
     * 获取数据表的所有字段
     * @param table
     * @param conn
     * @throws SQLException
     */
	public abstract void getTableColumns(Table table,Connection conn) throws SQLException;
	
	/**
	 * 获取表主键
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public abstract String getTablePrimaryKey(String tableName, Connection con) throws SQLException;
	/**
	 * 取表的联合主键
	 * @param tableName
	 * @param con
	 * @return
	 * @throws SQLException
	 */
	public abstract List<String> getTablePrimaryKeys(String tableName, Connection con) throws SQLException;
	
	/**
	 * 获取字段类型
	 * @param tableName
	 * @param column 指定列名
	 * @return
	 * @throws SQLException
	 */
	public abstract String getColumnType(Table table,String column) throws SQLException;
	
	/**
	 * 表注释
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public abstract String getTableRemark(String tableName, Connection con) throws SQLException;
	
	/**
	 * 分割注释中的名称和详细注释
	 * @param remark
	 * @return 返回标题和注释
	 */
	protected String[] seperatRemark(String remark) {
		
		if (remark == null || remark.trim().length()==0) {
			return new String[] {"",""};
		}
		//先判断是否定义了数据字典信息，若有，则截取前段内容为注释信息
		int idx = remark.lastIndexOf("||");
		if (idx != -1) {
			remark = remark.substring(0,idx);
		}
		
		String caption = remark;
		int dotIdx = remark.indexOf(REMARK_SEPERATOR);
        if (dotIdx == -1) {
        	dotIdx = remark.indexOf(REMARK_SEPERATOR2);
        }
        if (dotIdx != -1) {
        	caption = filterChar(remark.substring(0, dotIdx));
        	remark = remark.substring(dotIdx+1);
        }
        return new String[]{caption,remark};
	}
	
	private static String filterChar(String str) {
		str = filterHtml(str);
		str = str.replaceAll("'", "").replaceAll("\"", "");
		return str;
	}
	
	private static String filterHtml(String s) {
		if (s==null || s.length() == 0)
			return "";
		String s1 = s;
		s1 = s1.replaceAll("<[^>]*>", "");
		s1 = s1.replaceAll("&{1}[^(&|;)]{2,5};", "");
		s1 = s1.replaceAll("<", "〈");
		s1 = s1.replaceAll(">", "〉");
		return s1;
	}
	
	/**
	 * 解析字段定义的字典和编辑框类型，尽量避免定义错误导致的解析失败
	 * 先解析json格式，若解析失败，则进行字符串分析
	 * @param remark
	 * @return 返回数组["字典关键字","编辑框类型"]，编辑框类型默认为下拉框select
	 */
	protected static String[] getColumnDict(String remark) {
		if (remark == null || remark.trim().length()==0) {
			return new String[] {"",""};
		}
		int idx = remark.lastIndexOf("||");
		if (idx == -1) {
			return null;
		}
		String dictJson = remark.substring(idx+2);
		if (dictJson.length()==0) {
			return null;
		}
		try {
			JSONObject json = JSON.parseObject(dictJson);
			
			String dictKey = json.getString("dictKey");
			if (dictKey==null || dictKey.length()==0) {
				return null;
			}
			return new String[] {dictKey, json.getString("editorType")};
		} catch (Exception e) {
			//e.printStackTrace();
			String[] arr = new String[2];
			if (dictJson.indexOf("dictKey")==-1) {
				return null;
			}
			dictJson=dictJson.replaceAll("[\\{\\}]", "");
			System.out.println(dictJson);
			String[] keys = dictJson.split(",");
			for (String kv : keys) {
				if (kv.indexOf(":")==-1) {
					continue;
				}
				String[] k = kv.split(":");
				String key =filterChar(k[0].trim());
				if (key.equals("dictKey")) {
					arr[0]=filterChar(k[1].trim());
				} else if (key.equals("editorType")) {
					arr[1]=filterChar(k[1].trim());
				}
			}
			if (arr[0]==null) {
				return null;
			}
			if (arr[1]==null) {
				arr[1]="select";
			}
			return arr;
		}
	}
	
	public static void main(String[] args) {
		String remark="测试内容||{'editorType':select,'dictKey':sex}";
		//String remark="测试内容";
		String[] arr = getColumnDict(remark);
		System.out.println(Arrays.toString(arr));
	}
	
}
