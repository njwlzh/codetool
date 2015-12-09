package ${basePackage}.${moduleName}.${daoPackage}.${mapperPackage};
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

public class ${entityCamelName}RowMapper implements RowMapper<${entityCamelName}>{
	@Override
	public ${entityCamelName} mapRow(ResultSet rs, int arg1) throws SQLException {
		${entityCamelName} info = new ${entityCamelName}();
		<#list columns as col>
		<#assign type=col.propertyType>
		<#assign type=type?replace("Integer","Int")>
		<#assign type=type?replace("java.util.","")>
		<#assign type=type?replace("java.math.","")>
		info.set${col.propertyCamelName}(rs.get${type}("${col.columnName}"));
		</#list>
		return info;
	}
	
}