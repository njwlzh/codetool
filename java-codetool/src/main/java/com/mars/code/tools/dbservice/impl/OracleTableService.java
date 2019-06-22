package com.mars.code.tools.dbservice.impl;

import java.sql.Connection;
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

public class OracleTableService extends AbstractTableService {
	
	private Config config;
	public void setConfig(Config config) {
		this.config = config;
	}

	/* 
     * 连接数据库获取所有表信息 
     */  
    public List<TableConf> getAllTables(String pattern) {  
        if (CodeUtil.isEmpty(pattern)) {
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
            showTablesSql = "select table_name from user_tables where table_name like ? and owner=upper(?)"; // ORACLE查询所有表格名称命令  
            ps = con.prepareStatement(showTablesSql);
            ps.setString(1, pattern);
            ps.setString(2, config.getDb().getUser());
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
        	table.setTableName(tableName.toLowerCase().replaceFirst(tbConf.getPrefix().toLowerCase(), ""));  
        }
        //System.out.println(tbConf);
        //获取表各字段的信息
        getTableColumns(table,con);
        table.setPrimaryKey(getTablePrimaryKey(tableName, con));
        table.setPrimaryKeys(getTablePrimaryKeys(tableName, con));
        table.setPrimaryProperty(CodeUtil.convertToFirstLetterLowerCaseCamelCase(table.getPrimaryKey())); 
       
        String remark = getTableRemark(tableName, con);
        String[] remarkArr = seperatRemark(remark);
        table.setCaption(remarkArr[0]);
        table.setRemark(remarkArr[1]);
        
        table.setPrimaryKeyType(getColumnType(table, table.getPrimaryKey()));
        table.setPrimaryPropertyType(CodeUtil.convertType(table.getPrimaryKeyType()));
        table.setPrimaryCamelProperty(CodeUtil.convertToCamelCase(table.getPrimaryKey()));
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
    
    /**
     * 获取数据表的所有字段
     * @param table
     * @param conn
     * @throws SQLException
     */
    public void getTableColumns(Table table,Connection conn) throws SQLException {
    	List<String> primaryKeys = getTablePrimaryKeys(table.getTableFullName(),conn);
    	//查询表主键
    	List<String> priCols=new ArrayList<String>();
		String sql="select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and "
			+" au.constraint_type = 'P' AND cu.table_name = upper(?)";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1,table.getTableFullName());
		ResultSet rs = ps.executeQuery();
		if (rs.next()){
			priCols.add(rs.getString("column_name"));
		}
		rs.close();
		ps.close();
		
		//查询所有字段
		sql="SELECT USER_TAB_COLS.TABLE_NAME, USER_TAB_COLS.COLUMN_NAME , "
			+"USER_TAB_COLS.DATA_TYPE, "
			+"USER_TAB_COLS.DATA_LENGTH , "
			+" USER_TAB_COLS.NULLABLE, "
			+" USER_TAB_COLS.COLUMN_ID, "
			+" user_tab_cols.data_default,"
			+"    user_col_comments.comments " 
			+"FROM USER_TAB_COLS  "
			+"inner join user_col_comments on "
			+" user_col_comments.TABLE_NAME=USER_TAB_COLS.TABLE_NAME " 
			+"and user_col_comments.COLUMN_NAME=USER_TAB_COLS.COLUMN_NAME " 
			+"where  USER_TAB_COLS.Table_Name=upper(?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1,table.getTableFullName());
			rs = ps.executeQuery();
			while (rs.next()) {
				Column col = new Column();
	        	String colName = rs.getString("column_name");
	        	col.setColumnName(colName);
	        	String type = rs.getString("data_type").toUpperCase();
	            type=CodeUtil.convertJdbcType(type);
	        	col.setColumnType(type);
	        	col.setPropertyName(CodeUtil.convertToFirstLetterLowerCaseCamelCase(colName));
	        	//System.out.println(table.getTableFullName()+":::"+colName+":::"+col.getColumnType());
	        	col.setPropertyType(CodeUtil.convertType(col.getColumnType()));
	        	col.setPropertyCamelName(CodeUtil.convertToCamelCase(colName));
	        	col.setLength(rs.getLong("data_length"));
	        	col.setNullable(rs.getString("nullable").equals("YES") || rs.getString("nullable").equals("Y"));
	        	col.setDefaultValue(rs.getString("data_default"));

	        	String remark = rs.getString("comments");
	        	String[] remarkArr = seperatRemark(remark);
	        	col.setCaption(remarkArr[0]);
	        	col.setRemark(remarkArr[1]);

	            //获取定义的数据字典项
	            String[] dictDef = getColumnDict(col.getRemark());
	            if (dictDef != null && dictDef[0].length()>0) {
	            	col.setDictKey(dictDef[0]);
	            	col.setEditorType(dictDef[1]);
	            }
	        	
	        	for (String primaryKey : primaryKeys){
		        	if (colName.equalsIgnoreCase(primaryKey)) {
		        		col.setPrimaryKey(true);
		        		break;
		        	}
	        	}
	        	
	        	if (col.getPropertyType().indexOf(".")!=-1 && !CodeUtil.existsType(table.getImportClassList(),col.getPropertyType())) {
	        		table.getImportClassList().add(col.getPropertyType());
	        	}
	        	table.getColumns().add(col);
			}
			rs.close();
			ps.close();
			
			
    }
        

    public String getTablePrimaryKey(String tableName, Connection con) throws SQLException{
    	List<String> keys = getTablePrimaryKeys(tableName, con);
    	if (keys.size()>0){
    		return keys.get(0);
    	}
    	return null;
    }
    
    public List<String> getTablePrimaryKeys(String tableName, Connection con) throws SQLException{
    	List<String> keys = new ArrayList<String>();
    	String sql="select a.constraint_name,a.column_name from user_cons_columns a, user_constraints b  where a.constraint_name = b.constraint_name  and b.constraint_type = 'P' and a.table_name = ?";
    	PreparedStatement stmt = con.prepareStatement(sql);
    	stmt.setString(1, tableName.toUpperCase());
    	ResultSet rs = stmt.executeQuery();
    	while (rs.next()){
    		keys.add(rs.getString("COLUMN_NAME"));
    	}
    	rs.close();
    	stmt.close();
    	return keys;
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
	 * 表注释
	 * @param tableName
	 * @return
	 * @throws SQLException
	 */
	public String getTableRemark(String tableName, Connection con) throws SQLException {
		String remark="";
		String sql="SELECT COMMENTS FROM USER_TAB_COMMENTS WHERE table_name=upper(?)";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1, tableName);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			remark=rs.getString("comments");
		}
		rs.close();
		ps.close();
		return remark;
	}

}
