package com.mars.code.tools.model;

import java.util.ArrayList;
import java.util.List;
/**
 * 模块中表的定义
 * @author mars.liu
 *
 */
public class TableConf {
	//表名
	private String name;
	//表前缀
	private String prefix;
	//生成的实体类名
	private String entityName;
	// 如果是主从表，则从表需设置该属性，表示父表的关联属性
	private String parentField;
	//表关联类型，分为OneToOne,OneToMany等，如果与父表的关系是多对一，则会在父表对应的 entity中生成该子表的List集合属性
	private String refType; 
	//子表列表，即一对多的子表
	private List<TableConf> subTables = new ArrayList<TableConf>();
	private boolean showPrint; //是否生成打印页面
	
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
	
	public boolean getShowPrint() {
		return showPrint;
	}
	public void setShowPrint(boolean showPrint) {
		this.showPrint = showPrint;
	}
	@Override
	public String toString() {
		return "TableConf [name=" + name + ", prefix=" + prefix + ", entityName=" + entityName + ", parentField="
				+ parentField + ", refType=" + refType + ", subTables=" + subTables + ", showPrint=" + showPrint + "]";
	}
}
