package ${basePackage}.${moduleName}.${daoPackage};

import java.util.Map;

import ${basePackage}.common.Pagination;
<#if module.persistance == 'mybatis'>
import java.util.List;
import org.apache.ibatis.annotations.Param;
</#if>

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${remark!}操作相关
 */
public interface ${entityCamelName}Dao {
	
	public final static String BEAN_ID="${entityName}Dao";
	
	/**
	 * 保存新增的${remark!}
	 * @param info 要保存的${remark!}对象
	 */
	void save${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 修改${remark!}
	 * @param info 要保存的${remark!}对象
	 */
	void update${entityCamelName}(${entityCamelName} ${entityName});

	/**
	 * 删除${remark!}
	 * @param info 要删除的${remark!}对象，只需传入主键ID即可
	 */
	void delete${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 根据编号查询${remark!}细信息
	 * @param ${primaryProperty} ${remark!}编号
	 * @return
	 */
	${entityCamelName} findById(${primaryPropertyType} ${primaryProperty});
	
	/**
	 * 根据不同条件组合查询${remark!}，可分页查询
	 * @param page 分页对象
	 * @param params 查询参数，key为${entityCamelName}类属性名
	 */
	 <#assign ret="void">
	 <#if module.persistance=="mybatis">
	 <#assign ret="List<"+entityCamelName+">">
	 </#if>
	${ret} find${entityCamelName}List(<#if module.persistance == 'mybatis'>@Param(value="page") </#if>Pagination<${entityCamelName}> page,<#if module.persistance == 'mybatis'>@Param(value="map") </#if>Map<String,Object> params);
	<#if module.persistance == 'hibernate'>
	${ret} find${entityCamelName}ListByJdbc(<#if module.persistance == 'mybatis'>@Param(value="page") </#if>Pagination<${entityCamelName}> page,<#if module.persistance == 'mybatis'>@Param(value="map") </#if>Map<String,Object> params);
	</#if>

	<#if module.persistance=="mybatis">
	Integer count${entityCamelName}(@Param(value="map") Map<String,Object> params);
	</#if>

}
