package ${basePackage}.${moduleName}.${actionPackage};
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import tt.wifi.base.BaseAction;
import tt.wifi.common.Pagination;
import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;

import com.bstek.dorado.annotation.DataProvider;
import com.bstek.dorado.annotation.DataResolver;
import com.bstek.dorado.data.entity.EntityState;
import com.bstek.dorado.data.entity.EntityUtils;
import com.bstek.dorado.data.provider.Page;

<#if subTables??>
	<#list subTables as sub>
import ${basePackage}.${moduleName}.${entityPackage}.${sub.entityCamelName};
	</#list>
</#if>

/**
 * ${remark}
 *
 */
@Component
public class ${entityCamelName}Action extends BaseAction {
	
	@Resource(name=${entityCamelName}Service.BEAN_ID)
	private ${entityCamelName}Service ${entityName}Service;
	<#if subTables??>
		<#list subTables as sub>
	@Resource(name="${sub.entityName}Action")
	private ${sub.entityCamelName}Action ${sub.entityName}Action;
		</#list>
	</#if>
	
	/**
	 * 查询${remark}
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
	
	/**
	 * 保存${remark}
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
				${entityName}Service.remove${entityCamelName}(${entityName});
			}
			<#if subTables??>
				<#list subTables as sub>
			List<${sub.entityCamelName}> ${sub.entityName}List=${entityName}.get${sub.entityCamelName}List();
			if (${sub.entityName}List!=null && !${sub.entityName}List.isEmpty()){
				${sub.entityName}Action.save${sub.entityCamelName}(${sub.entityName}List);
			}
				</#list>
			</#if>
		}
	}


}
