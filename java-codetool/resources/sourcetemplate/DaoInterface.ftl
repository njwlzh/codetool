package ${basePackage}.${moduleName}.${daoPackage};

import java.util.Map;

import ${basePackage}.common.Pagination;
<#if module.persistance == 'mybatis'>
import java.util.List;
import org.apache.ibatis.annotations.Param;
</#if>

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${caption!}操作相关
 * ${remark!}
 */
public interface ${entityCamelName}Dao {
	
	public final static String BEAN_ID="${entityName}Dao";
	
	/**
	 * 保存新增的${caption!}
	 * @param info 要保存的${caption!}对象
	 */
	void save${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 批量新增的${caption!}
	 * @param info 要保存的${caption!}列表
	 */
	void batchSave${entityCamelName}(@Param(value="list")List<${entityCamelName}> list);
	
	/**
	 * 修改${caption!}
	 * @param info 要保存的${caption!}对象
	 */
	void update${entityCamelName}(${entityCamelName} ${entityName});

	/**
	 * 删除${caption!}
	 * @param info 要删除的${caption!}对象，只需传入主键ID即可
	 */
	void updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if><#if module.persistance == 'mybatis'>@Param(value="${col.propertyName}") </#if>${col.propertyType} ${col.propertyName}</#list>,@Param(value="state")Integer state);
	
	/**
	 * 根据编号查询${caption!}详细信息
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return
	 */
	${entityCamelName} findByKey(<#list primaryKeyList as col> <#if col_index gt 0>,</#if><#if module.persistance == 'mybatis'>@Param(value="${col.propertyName}") </#if>${col.propertyType} ${col.propertyName}</#list>);
	
	/**
	 * 根据不同条件组合查询${caption!}，可分页查询
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
	Map<String,Object> count${entityCamelName}(@Param(value="map") Map<String,Object> params);
	</#if>

}
