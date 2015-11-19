package ${basePackage}.${moduleName}.${daoPackage};

import java.util.Map;

import tt.wifi.common.Pagination;
<#if module.persistance == 'mybatis'>
import java.util.List;
import org.apache.ibatis.annotations.Param;
</#if>

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${remark}操作相关
 */
public interface ${entityCamelName}Dao {
	
	public final static String BEAN_ID="${entityName}Dao";
	
	/**
	 * 新增保存${remark}
	 * @param info
	 */
	void save${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 修改${remark}
	 * @param info
	 */
	void update${entityCamelName}(${entityCamelName} ${entityName});

	/**
	 * 删除${remark}
	 * @param info
	 */
	void delete${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 根据编号查询${remark}细信息
	 * @param placeId
	 * @return
	 */
	${entityCamelName} findById(${primaryPropertyType} ${primaryProperty});
	
	/**
	 * 根据不同条件组合查询${remark}，可分页查询
	 * @param page
	 * @param 
	 */
	 <#assign ret="void">
	 <#if module.persistance=="mybatis">
	 <#assign ret="List<"+entityCamelName+">">
	 </#if>
	${ret} find${entityCamelName}List(<#if module.persistance == 'mybatis'>@Param(value="page") </#if>Pagination<${entityCamelName}> page,<#if module.persistance == 'mybatis'>@Param(value="map") </#if>Map<String,Object> params);

	<#if module.persistance=="mybatis">
	Integer count${entityCamelName}(@Param(value="map") Map<String,Object> params);
	</#if>

}
