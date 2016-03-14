package ${basePackage}.${moduleName}.${daoPackage}.${daoImplPackage};

import java.util.Map;
import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Repository;
import ${basePackage}.common.Pagination;
import ${basePackage}.common.dao.JdbcDao;

import ${basePackage}.utils.StringUtils;
import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${daoPackage}.${mapperPackage}.${entityCamelName}RowMapper;
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;
<#list importClassList as imp>
import ${imp};
</#list>

/**
 * ${remark!}操作相关
 */
@Repository(${entityCamelName}Dao.BEAN_ID)
public class ${entityCamelName}DaoImpl extends JdbcDao implements ${entityCamelName}Dao {

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		String sql="insert into ${tableFullName} (<#list columns as col><#if col_index gt 0 && !col.primaryKey>${col.columnName}</#if><#if !col.primaryKey && col_index lt columns?size-1>,</#if></#list>) values (<#list columns as col><#if col_index gt 0 && !col.primaryKey>?</#if><#if !col.primaryKey && col_index lt columns?size-1>,</#if></#list>)";
		List<Object> params = new ArrayList<Object>();
		<#list columns as col>
		<#if !col.primaryKey>
		params.add(${entityName}.get${col.propertyCamelName}());
		</#if>
		</#list>
		jdbcTemplate.update(sql, params.toArray());
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		String sql="update ${tableFullName} set <#list columns as col><#if col_index gt 0 && !col.primaryKey>${col.columnName}=?</#if><#if !col.primaryKey && col_index lt columns?size-1>,</#if></#list> where ${primaryKey}=? ";
		List<Object> params = new ArrayList<Object>();
		<#list columns as col>
		<#if !col.primaryKey>
		params.add(${entityName}.get${col.propertyCamelName}());
		</#if>
		</#list>
		params.add(${entityName}.get${primaryCamelProperty}());
		jdbcTemplate.update(sql, params.toArray());
	}

	@Override
	public void delete${entityCamelName}(${entityCamelName} ${entityName}) {
		String sql="delete from ${tableFullName} where ${primaryKey}=?";
		jdbcTemplate.update(sql, new Object[]{${entityName}.get${primaryCamelProperty}()});
	}

	@Override
	public ${entityCamelName} findById(${primaryPropertyType} ${primaryProperty}) {
		String sql = "select * from ${tableFullName} where ${primaryKey}=?";
		return (${entityCamelName})jdbcTemplate.queryForObject(sql,new Object[]{${primaryProperty}},new ${entityCamelName}RowMapper());
	}

	@Override
	public void find${entityCamelName}List(Pagination<${entityCamelName}> page,
			Map<String, Object> params) {
			
		StringBuffer sql=new StringBuffer(" from ${tableFullName} where 1=1 ");
		List<Object> paramList = new ArrayList<Object>();
		<#list columns as field>
		<#assign type=field.propertyType>
		<#assign type=type?replace("java.util.","")>
		<#assign type=type?replace("java.math.","")>
		<#if type== 'Long'>
		${type} ${field.propertyName} = StringUtils.getLong(params.get("${field.propertyName}"));
		<#elseif type == "Integer">
		${type} ${field.propertyName} = StringUtils.getInt(params.get("${field.propertyName}"));
		<#else>
		${type} ${field.propertyName} = (${type})params.get("${field.propertyName}");
		</#if>
		<#if field.propertyType?index_of("String")!=-1>
		if (StringUtils.isNotEmpty(${field.propertyName})){
			sql.append(" and ${field.columnName}=? ");
			paramList.add(${field.propertyName});
		}
		<#else>
		if (${field.propertyName}!=null){
			sql.append(" and ${field.columnName}=? ");
			paramList.add(${field.propertyName});
		}
		</#if>
		</#list>
		String countSql = "select count(*) "+sql.toString();
		Integer total = jdbcTemplate.queryForObject(countSql,paramList.toArray(),Integer.class);
		page.setEntityCount(total);
		if (total>0){
			sql.insert(0,"select top ? o.* from (select row_number() over(order by orderColumn) as rownumber,* from (select * ").append(" order by ${primaryKey} desc");
			sql.append(") as o where rownumber>?");
			paramList.add(0,page.getPageSize());
			paramList.add(page.getFirstEntityIndex());
			page.setEntities(jdbcTemplate.query(sql.toString(),paramList.toArray(),new ${entityCamelName}RowMapper()));
			
		}
	}

}
