package ${basePackage}.api.${moduleName}.${servicePackage};

import java.util.Map;

import ${basePackage}.common.info.Pagination;
import ${basePackage}.api.${moduleName}.pojo.${entityPackage}.${entityCamelName};

/**
 * ${caption!}操作相关
 */
public interface ${entityCamelName}Service {
	
	public final static String BEAN_ID="${entityName}Service";
	
	/**
	 * 新增保存${caption!}
	 * @param ${entityName}
	 */
	void save${entityCamelName}(${entityCamelName} ${entityName});
	
	/**
	 * 修改${caption!}
	 * @param ${entityName}
	 */
	void update${entityCamelName}(${entityCamelName} ${entityName});

	/**
	 * 删除${caption!}，一般情况下是设置记录的状态为删除
	 * @param ${entityName}
	 */
	void updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyType}[] ${col.propertyName}s</#list>,Integer state);
	
	/**
	 * 根据编号查询${caption!}细信息
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return 返回查询到的对象，未查询到返回null
	 */
	${entityCamelName} loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>);
	
	/**
	 * 根据不同条件组合查询${caption!}，可分页查询
	 * @param page 分页对象
	 * @param params 参数列表，key为${entityCamelName}的属性名称
	 */
	void load${entityCamelName}List(Pagination<${entityCamelName}> page,Map<String,Object> params);

}
