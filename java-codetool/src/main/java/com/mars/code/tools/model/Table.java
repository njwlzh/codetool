package com.mars.code.tools.model;

import java.util.ArrayList;
import java.util.List;

public class Table {
	private Module module;
	private String packageName;
	private String tableFullName;//完整表名
    private String tableName;  // 表名，去掉prefix
    private String entityName; //实体名
    private String entityCamelName; //完整实体类名
    private String remark; //表注释
    private String primaryKey;//主键
    private String primaryProperty;//主键属性名
    private String primaryPropertyType; //主键属性类型
    private String primaryCamelProperty;
    private String primaryKeyType;//主键类型
    
    private String parentProperty; //若为子表，则此属性为上级表的属性
    
    private List<String> importClassList=new ArrayList<String>();
    private List<Column> columns=new ArrayList<Column>();
    private List<Table> subTables = new ArrayList<Table>();
    private String refType; //表间关联类型
      
    public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getTableName() {  
        return tableName;  
    }  
  
    public void setTableName(String tableName) {  
        this.tableName = tableName;  
    }  
  

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(String primaryKey) {
		this.primaryKey = primaryKey;
	}


	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public List<Column> getColumns() {
		return columns;
	}

	public void setColumns(List<Column> columns) {
		this.columns = columns;
	}

	public List<String> getImportClassList() {
		return importClassList;
	}

	public void setImportClassList(List<String> importClassList) {
		this.importClassList = importClassList;
	}

	public String getEntityCamelName() {
		return entityCamelName;
	}

	public void setEntityCamelName(String entityCamelName) {
		this.entityCamelName = entityCamelName;
	}

	public String getPrimaryKeyType() {
		return primaryKeyType;
	}

	public void setPrimaryKeyType(String primaryKeyType) {
		this.primaryKeyType = primaryKeyType;
	}

	public String getPrimaryProperty() {
		return primaryProperty;
	}

	public void setPrimaryProperty(String primaryProperty) {
		this.primaryProperty = primaryProperty;
	}

	public String getPrimaryCamelProperty() {
		return primaryCamelProperty;
	}

	public void setPrimaryCamelProperty(String primaryCamelProperty) {
		this.primaryCamelProperty = primaryCamelProperty;
	}

	public String getPrimaryPropertyType() {
		return primaryPropertyType;
	}

	public void setPrimaryPropertyType(String primaryPropertyType) {
		this.primaryPropertyType = primaryPropertyType;
	}

	public Module getModule() {
		return module;
	}

	public void setModule(Module module) {
		this.module = module;
	}

	public String getTableFullName() {
		return tableFullName;
	}

	public void setTableFullName(String tableFullName) {
		this.tableFullName = tableFullName;
	}

	public List<Table> getSubTables() {
		return subTables;
	}

	public void setSubTables(List<Table> subTables) {
		this.subTables = subTables;
	}

	public String getParentProperty() {
		return parentProperty;
	}

	public void setParentProperty(String parentProperty) {
		this.parentProperty = parentProperty;
	}

	public String getRefType() {
		return refType;
	}

	public void setRefType(String refType) {
		this.refType = refType;
	}

	@Override
	public String toString() {
		return "Table [module=" + module + ", packageName=" + packageName
				+ ", tableFullName=" + tableFullName + ", tableName="
				+ tableName + ", entityName=" + entityName
				+ ", entityCamelName=" + entityCamelName + ", remark=" + remark
				+ ", primaryKey=" + primaryKey + ", primaryProperty="
				+ primaryProperty + ", primaryPropertyType="
				+ primaryPropertyType + ", primaryCamelProperty="
				+ primaryCamelProperty + ", primaryKeyType=" + primaryKeyType
				+ ", parentProperty=" + parentProperty + ", importClassList="
				+ importClassList + ", columns=" + columns + ", subTables="
				+ subTables + ", refType=" + refType + "]";
	}
}
