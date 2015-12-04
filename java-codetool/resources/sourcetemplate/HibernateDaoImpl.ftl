package ${basePackage}.${moduleName}.${daoPackage}.${daoImplPackage};

import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import com.jryq.mis.common.Pagination;
import com.jryq.mis.dao.HibernateDao;

import com.jryq.mis.utils.StringUtils;
import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;
<#list importClassList as imp>
import ${imp};
</#list>

/**
 * ${remark}操作相关
 */
@Repository(${entityCamelName}Dao.BEAN_ID)
public class ${entityCamelName}DaoImpl extends HibernateDao implements ${entityCamelName}Dao {

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		save(${entityName});
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		update(${entityName});
	}

	@Override
	public void delete${entityCamelName}(${entityCamelName} ${entityName}) {
		delete(${entityName});
	}

	@Override
	public ${entityCamelName} findById(${primaryPropertyType} ${primaryProperty}) {
		return (${entityCamelName})getSession().get(${entityCamelName}.class, ${primaryProperty});
	}

	@Override
	public void find${entityCamelName}List(Pagination<${entityCamelName}> page,
			Map<String, Object> params) {
		DetachedCriteria c = DetachedCriteria.forClass(${entityCamelName}.class);
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
			c.add(Restrictions.eq("${field.propertyName}", ${field.propertyName}));
		}
		<#else>
		if (${field.propertyName}!=null){
			c.add(Restrictions.eq("${field.propertyName}", ${field.propertyName}));
		}
		</#if>
		</#list>
		pagingQuery(page, c);
	}

}
