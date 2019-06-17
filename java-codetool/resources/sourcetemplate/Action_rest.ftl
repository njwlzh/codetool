package ${basePackage}.${moduleName}.${actionPackage};
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
<#if module.persistance=="hibernate" || module.persistance=="jpa">
import javax.validation.Valid;
</#if>

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import ${basePackage}.base.BaseAction;
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
	@RequestMapping(value = "/ajax/load${entityCamelName}List")
	@ResponseBody
	public Map<String,Object> load${entityCamelName}List(HttpServletRequest req){
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
	@ResponseBody
	public Map<String,Object> load${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		Map<String,Object> res = new HashMap<String,Object>();
		${entityCamelName} ${entityName} = ${entityName}Service.loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
		
		res.put("state",0);
		res.put("data",${entityName});
		return res;
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
	@ResponseBody
	public Map<String,Object> save${entityCamelName}(${validate}${entityCamelName} ${entityName}){
		Map<String,Object> res = new HashMap<String,Object>();
		${entityName}Service.save${entityCamelName}(${entityName});
		
		res.put("state",0);
		return res;
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
	@ResponseBody
	public Map<String,Object> update${entityCamelName}(${validate}${entityCamelName} ${entityName}){
		Map<String,Object> res = new HashMap<String,Object>();
		${entityName}Service.update${entityCamelName}(${entityName});
		
		res.put("state",0);
		return res;
	}
	/**
	 * 修改${remark!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/ajax/updateState")
	@ResponseBody
	public Map<String,Object> updateState(HttpServletRequest req,${entityCamelName} ${entityName}){
		Map<String,Object> res = new HashMap<String,Object>();
		${entityName}Service.updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${entityName}.get${col.propertyCamelName}()</#list>,${entityName}.getState());
		res.put("state",0);
		return res;
	}


}
