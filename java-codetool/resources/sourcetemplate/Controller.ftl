package ${basePackage}.${moduleName}.${actionPackage};
import java.util.List;
import java.util.Map;
import java.util.Collection;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import ${basePackage}.base.BaseAction;
import ${basePackage}.common.Pagination;
import ${basePackage}.common.BaseStateConstants;
import ${basePackage}.api.${moduleName}.pojo.${entityPackage}.${entityCamelName};
import ${basePackage}.api.${moduleName}.${servicePackage}.${entityCamelName}Service;

import com.bstek.dorado.annotation.DataProvider;
import com.bstek.dorado.annotation.DataResolver;
import com.bstek.dorado.data.entity.EntityState;
import com.bstek.dorado.data.entity.EntityUtils;
import com.bstek.dorado.data.provider.Page;

<#if subTables??>
	<#list subTables as sub>
import ${basePackage}.api.${moduleName}.pojo.${entityPackage}.${sub.entityCamelName};
	</#list>
</#if>

/**
 * ${caption!}相关接口操作
 * ${remark!}
 *
 */
@Component
public class ${entityCamelName}Controller extends BaseAction {
	
	@Resource(name=${entityCamelName}Service.BEAN_ID)
	private ${entityCamelName}Service ${entityName}Service;
	<#if subTables??>
		<#list subTables as sub>
	@Resource(name="${sub.entityName}Controller")
	private ${sub.entityCamelName}Controller ${sub.entityName}Controller;
		</#list>
	</#if>
	
	/**
	 * 查询${caption!}
	 * @param params 参数列表
	 * @param page
	 */
	@DataProvider
	public void load${entityCamelName}List(Map<String, Object> params,Page<${entityCamelName}> page){
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(page.getPageSize(), page.getPageNo());
		${entityName}Service.load${entityCamelName}List(paging,params);
		page.setEntities(paging.getEntities());
		page.setEntityCount(paging.getEntityCount());
	}
	
	@DataProvider
	public ${entityCamelName} load${entityCamelName}(Map<String, Object> params){
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(1, 1);
		${entityName}Service.load${entityCamelName}List(paging,params);
		Collection<${entityCamelName}> list = paging.getEntities();
		if (list.isEmpty()){
			return null;
		}
		return list.iterator().next();
	}
	
	/**
	 * 保存${caption!}
	 * @param params 
	 */
	@DataResolver
	public void save${entityCamelName}(List<${entityCamelName}> list){
		for (${entityCamelName} ${entityName} : list) {
			EntityState state = EntityUtils.getState(${entityName});
			if (EntityState.NEW.equals(state)) {
				${entityName}Service.save${entityCamelName}(${entityName});
			} else if (EntityState.MODIFIED.equals(state)) {
				${entityName}Service.update${entityCamelName}(${entityName});
			} else if (EntityState.DELETED.equals(state)) {
				${entityName}Service.updateState(new Long[] {${entityName}.getComId()}, new Long[] {${entityName}.getId()}, BaseStateConstants.DELETED.getIntCode());
			}
			
		}
	}


}
