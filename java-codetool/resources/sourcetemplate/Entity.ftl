package ${basePackage}.${moduleName}.${entityPackage};

import java.io.Serializable;
<#if subTables?size gt 0>
import java.util.List;
</#if>
<#if module.persistance=="hibernate">
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
<#if subTables?size gt 0>
import javax.persistence.Transient;
</#if>
</#if>
<#if importClassList??>
<#list importClassList as imp>
import ${imp!};
</#list>
</#if>

/**
* ${remark}
*/
<#if module.persistance=="hibernate">
@Entity
@Table(name="${tableFullName!}")
</#if>
public class ${entityCamelName!} implements Serializable {

	private static final long serialVersionUID = 1L;
	
	<#if columns??>
	<#list columns as col>
	/**
	 * ${col.remark!}
	 */
	<#assign type=col.propertyType>
	<#assign type=type?replace("java.util.","")>
	<#assign type=type?replace("java.math.","")>
	private ${type!} ${col.propertyName};
	</#list>
	<#-- 生成子表属性 -->
	<#if subTables??>
		<#list subTables as sub>
		<#if sub.refType=="OneToOne">
	private ${sub.entityCamelName} ${sub.entityName?uncap_first};
		<#else>
	private List<${sub.entityCamelName}> ${sub.entityName?uncap_first}List;
		</#if>
		</#list>
	</#if>
	
	<#list columns as col>
	<#assign type=col.propertyType>
	<#assign type=type?replace("java.util.","")>
	<#assign type=type?replace("java.math.","")>
	public void set${col.propertyCamelName}(${type} ${col.propertyName}){
		this.${col.propertyName}=${col.propertyName};
	}
	<#if module.persistance=="hibernate">
	<#if col.primaryKey>
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	</#if>
	@Column(name="${col.columnName}",columnDefinition="${col.columnType}")
	</#if>
	public ${type} get${col.propertyCamelName}(){
		return this.${col.propertyName};
	}
	
	</#list>
	<#-- 生成子表属性 -->
	<#if subTables??>
		<#list subTables as sub>
		<#if sub.refType=="OneToOne"><#-- 一对一 -->
	public void set${sub.entityCamelName}(${sub.entityCamelName} ${sub.entityName?uncap_first}){
		this.${sub.entityName?uncap_first}=${sub.entityName?uncap_first};
	}
	<#if module.persistance=="hibernate">
	@Transient
	</#if>
	public ${sub.entityCamelName} get${sub.entityCamelName}(){
		return this.${sub.entityName?uncap_first};
	}	
		<#else><#-- 一对多 -->
	public void set${sub.entityCamelName}List(List<${sub.entityCamelName}> ${sub.entityName?uncap_first}List){
		this.${sub.entityName?uncap_first}List=${sub.entityName?uncap_first}List;
	}
	<#if module.persistance=="hibernate">
	@Transient
	</#if>
	public List<${sub.entityCamelName}> get${sub.entityCamelName}List(){
		return this.${sub.entityName?uncap_first}List;
	}
		</#if>
		</#list>
	</#if>
	@Override
	public String toString(){
		StringBuilder sb = new StringBuilder();
		sb.append("${entityCamelName!}[");
		<#list columns as col>
		sb.append("${(col_index gt 0)?string(",","")}${col.propertyName}=");
		sb.append(${col.propertyName});
		</#list>
		sb.append("]");
		return sb.toString();
	}
	</#if>
}
