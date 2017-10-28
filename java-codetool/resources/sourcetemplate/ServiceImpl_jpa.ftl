package ${basePackage}.${moduleName}.${servicePackage}.${serviceImplPackage};

import java.util.Map;
import java.util.List;
import java.util.Date;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import ${basePackage}.common.Pagination;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;

/**
 * ${remark!}操作相关
 */
@Service(${entityCamelName}Service.BEAN_ID)
public class ${entityCamelName}ServiceImpl implements ${entityCamelName}Service {

	Logger logger = LoggerFactory.getLogger(${entityCamelName}ServiceImpl.class);

	@Autowired
	private ${entityCamelName}Dao ${entityName}Dao;

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.save(${entityName});
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.saveAndFlush(${entityName});
	}

	@Override
	void updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyType} ${col.propertyName}</#list>,Integer state); {
		${entityName}Dao.updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyName}</#list>,state);
	}

	@Override
	public ${entityCamelName} loadById(${primaryPropertyType} ${primaryProperty}) {
		return ${entityName}Dao.findOne(${primaryProperty});
	}

	@Override
	public void load${entityCamelName}List(Pagination<${entityCamelName}> paging,
			final Map<String, Object> params) {
		
		Page<${entityCamelName}> p =${entityName}Dao.findAll(new Specification<${entityCamelName}>() {

			@Override
			public Predicate toPredicate(Root<${entityCamelName}> root, CriteriaQuery<?> query,
					CriteriaBuilder builder) {
                Predicate predicate = builder.conjunction();  
                List<Expression<Boolean>> pList = predicate.getExpressions();
                
				<#list columns as field>
				<#assign type=field.propertyType>
				<#assign type=type?replace("java.util.","")>
				<#assign type=type?replace("java.math.","")>
				<#if type== 'Long'>
				${type} ${field.propertyName} = StringUtil.getLong(params.get("${field.propertyName}"));
				<#elseif type == "Integer">
				${type} ${field.propertyName} = StringUtil.getInt(params.get("${field.propertyName}"));
				<#else>
				${type} ${field.propertyName} = (${type})params.get("${field.propertyName}");
				</#if>
				
				<#if field.propertyType?index_of("String")!=-1>
				if (StringUtil.isNotEmpty(${field.propertyName})){
					<#if field.length &gt; 100>
					pList.add(builder.like(root.<String>get("${field.propertyName}"), "%"+${field.propertyName}+"%"));
					<#else>
					pList.add(builder.equal(root.<String>get("${field.propertyName}"), ${field.propertyName}));
					</#if>
				}
				<#else>
				if (${field.propertyName}!=null){
					pList.add(builder.equal(root.get("${field.propertyName}"), ${field.propertyName}));
				}
				</#if>
				</#list>
                Predicate p = builder.and(pList.toArray(new Predicate[pList.size()]));  
                query.where(p); 
				return null;
                
            }
		}, new PageRequest(paging.getPageNo()-1,paging.getPageSize(),new Sort(Direction.DESC, "${primaryProperty}")));
		
		paging.setEntities(p.getContent());
		paging.setEntityCount((int)p.getTotalElements());
	}

}
