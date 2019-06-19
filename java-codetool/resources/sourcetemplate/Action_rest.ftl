package ${basePackage}.${moduleName}.${actionPackage};
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
<#if module.persistance=="hibernate" || module.persistance=="jpa">
import javax.validation.Valid;
</#if>

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import ${basePackage}.base.BaseAction;
import ${basePackage}.base.ResponseJson;
import ${basePackage}.common.Pagination;
import ${basePackage}.common.utils.RequestUtil;
import ${basePackage}.common.constant.BaseStateConstants;
import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;

<#if subTables??>
	<#list subTables as sub>
import ${basePackage}.${moduleName}.${entityPackage}.${sub.entityCamelName};
	</#list>
</#if>

/**
 * ${remark!}
 *
 */
@SuppressWarnings("rawtypes")
@RestController
@RequestMapping("/${moduleName}/${entityName}")
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
	 * 查询${remark!}
	 * @param params 参数列表
	 * @param page
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ajax/load${entityCamelName}List")
	public ResponseJson load${entityCamelName}List(HttpServletRequest req){
		Integer pageNo = getPageNo();
		Integer pageSize = getPageSize();
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(pageSize, pageNo);
		
		Map<String,Object> params = RequestUtil.getParameters();
		params.put("state", BaseStateConstants.NORMAL.getIntCode());
		
		${entityName}Service.load${entityCamelName}List(paging,params);
		
		return getReturnData(paging);
	}
	
	/**
	 * 加载${remark!}详情
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return
	 */
	@RequestMapping(value = "/ajax/load${entityCamelName}")
	public ResponseJson load${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		${entityCamelName} ${entityName} = ${entityName}Service.loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
		
		return new ResponseJson(0,${entityName});
	}
	
	/**
	 * 保存${remark!}详情
	 * @param ${entityName}
	 * @return
	 */
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@RequestMapping(value = "/ajax/save${entityCamelName}",method=RequestMethod.POST)
	public ResponseJson save${entityCamelName}(${validate}${entityCamelName} ${entityName}){
		${entityName}Service.save${entityCamelName}(${entityName});
		
		return new ResponseJson(0,${entityName});
	}
	
	/**
	 * 保存修改的${remark!}
	 * @param ${entityCamelName}
	 * @return
	 */
	 <#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@RequestMapping(value = "/ajax/update${entityCamelName}",method=RequestMethod.POST)
	public ResponseJson update${entityCamelName}(${validate}${entityCamelName} ${entityName}){
		${entityName}Service.update${entityCamelName}(${entityName});
		
		return new ResponseJson(0,null);
	}
	/**
	 * 修改${remark!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/ajax/updateState")
	public ResponseJson updateState(HttpServletRequest req,${entityCamelName} ${entityName}){
		${entityName}Service.updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${entityName}.get${col.propertyCamelName}()</#list>,${entityName}.getState());
		
		return new ResponseJson(0,null);
	}


}
