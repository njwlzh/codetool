package com.mars.code.tools.dbservice.impl;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mars.code.tools.Config;
import com.mars.code.tools.dbservice.AbstractTableService;
import com.mars.code.tools.model.Column;
import com.mars.code.tools.model.Module;
import com.mars.code.tools.model.Table;
import com.mars.code.tools.model.TableConf;
import com.mars.code.tools.utils.CodeUtil;

public class MysqlTableService extends AbstractTableService {
	
	private Config config;
	public void setConfig(Config config) {
		this.config = config;
	}

	/* 
     * 连接数据库获取所有表信息 
     */  
    public List<TableConf> getAllTables(String pattern) {  
        if (CodeUtil.isEmpty(pattern)) {
        	pattern="%";
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
            showTablesSql = "show tables like '"+pattern+"'";  // MySQL查询所有表格名称命令  
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
      
    /**
     * 获取指定表信息并封装成Table对象 
     * @param tbConf 
     * @param module
     * @param con 
     */  
    public Table getTable(TableConf tbConf,Module module, Connection con) throws SQLException {
    	String tableName =tbConf.getName();
        Table table = new Table(); 
        table.setTableFullName(tableName);
        table.setTableName(tableName);
        if (module.isDeleteTablePrefix() && !CodeUtil.isEmpty(tbConf.getPrefix())){
        	table.setTableName(tableName.toLowerCase().replaceFirst(tbConf.getPrefix(), ""));  
        }
        System.out.println(tbConf);
        //获取表各字段的信息
        getTableColumns(table,con);
        
        //取主键列表
        List<String> keys = getTablePrimaryKeys(tableName, con);
        table.setPrimaryKeyList(getPrimaryColumns(table, keys));
        
        String remark = getTableRemark(tableName, con);
        String[] remarkArr = seperatRemark(remark);
        table.setCaption(remarkArr[0]);
        table.setRemark(remarkArr[1]);
        
        table.setEntityCamelName(CodeUtil.isEmpty(tbConf.getEntityName())?CodeUtil.convertToCamelCase(table.getTableName()):tbConf.getEntityName());
        table.setEntityName(CodeUtil.convertToFirstLetterLowerCaseCamelCase(table.getTableName()));
        table.setModule(module);
        //设置子表的entity属性
        if (!tbConf.getSubTables().isEmpty()) {
        	List<Table> subTables = new ArrayList<Table>();
        	for (TableConf tc : tbConf.getSubTables()) {
        		Table tb = getTable(tc,module,con);
        		tb.setParentProperty(CodeUtil.convertToFirstLetterLowerCaseCamelCase(tc.getParentField()));
        		tb.setRefType(tc.getRefType());
        		subTables.add(tb);
        	}
        	table.setSubTables(subTables);
        }
        return table;  
    }
    
    private List<Column> getPrimaryColumns(Table table,List<String> keys){
    	List<Column> primaryKeyList = new ArrayList<Column>();
    	for (String key : keys){
    		for (Column col : table.getColumns()){
    			if (key.equalsIgnoreCase(col.getColumnName())){
    				primaryKeyList.add(col);
    				break;
    			}
    		}
        }
    	return primaryKeyList;
    }
    
    /**
     * 获取数据表的所有字段
     * @param table
     * @param conn
     * @throws SQLException
     */
    public void getTableColumns(Table table,Connection conn) throws SQLException {
    	if (config.getDb().getDbType().equals("mysql")) {
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
	        	type=CodeUtil.convertJdbcType(type);
	        	col.setColumnType(type);
	        	
	        	String remark = rs.getString("column_comment");
	        	String[] remarkArr = seperatRemark(remark);
	            col.setCaption(remarkArr[0]);
	            col.setRemark(remarkArr[1]);
	            
	            //获取定义的数据字典项
	            String[] dictDef = getColumnDict(remark);
	            if (dictDef != null && dictDef[0].length()>0) {
	            	col.setDictKey(dictDef[0]);
	            	col.setEditorType(dictDef[1]);
	            }
	             
	        	col.setPropertyName(CodeUtil.convertToFirstLetterLowerCaseCamelCase(colName));
	        	col.setPropertyType(CodeUtil.convertType(col.getColumnType()));
	        	col.setPropertyCamelName(CodeUtil.convertToCamelCase(colName));
	        	col.setNullable(rs.getString("is_nullable").equals("YES"));
	        	col.setLength(rs.getLong("character_maximum_length"));
	        	col.setDefaultValue(rs.getString("column_default"));
	        	col.setIdentity("auto_increment".equalsIgnoreCase(rs.getString("extra")));
	        	
	        	String colKey = rs.getString("column_key");
	        	if (!CodeUtil.isEmpty(colKey) && colKey.toLowerCase().equals("pri")) {
	        		col.setPrimaryKey(true);
	        	}
	        	if (col.getPropertyType().indexOf(".")!=-1 && !CodeUtil.existsType(table.getImportClassList(),col.getPropertyType())) {
	        		table.getImportClassList().add(col.getPropertyType());
	        	}
	        	table.getColumns().add(col);
			}
			rs.close();
			ps.close();
		} else { //其它数据库
			
		}
    }
    
    public List<String> getTablePrimaryKeys(String tableName, Connection con) throws SQLException{
		DatabaseMetaData dbMeta = con.getMetaData(); 
		ResultSet rs = dbMeta.getPrimaryKeys(null,null,tableName);
		List<String> keys = new ArrayList<String>();
		while (rs.next()){
			keys.add(rs.getString("COLUMN_NAME"));
		}
		return keys;
	}
    
    public String getTablePrimaryKey(String tableName, Connection con) throws SQLException{
    	List<String> keys = getTablePrimaryKeys(tableName, con);
    	if (keys.size()>0){
    		return keys.get(0);
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
			if (col.getColumnName().equalsIgnoreCase(column)) {
				return col.getColumnType();
			}
		}
		return colType;
	}
	/**
	 * 表注释，若为null，则返回空字段串
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public String getTableRemark(String tableName, Connection con) throws SQLException {
		String remark="";
		String sql="show table status where name=?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1, tableName);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			remark=rs.getString("comment");
		}
		rs.close();
		ps.close();
		return remark == null ?"":remark;
	}

}
