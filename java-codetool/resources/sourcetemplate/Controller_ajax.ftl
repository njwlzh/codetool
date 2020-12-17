package ${basePackage}.${moduleName}.${actionPackage};
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
<#if module.persistance=="hibernate" || module.persistance=="jpa">
import javax.validation.Valid;
</#if>
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ${basePackage}.base.BaseController;
import ${basePackage}.common.Pagination;
import ${basePackage}.common.utils.RequestUtil;
import ${basePackage}.common.constant.BaseStateConstants;
import ${basePackage}.${moduleName}.common.dataobj.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;

<#if subTables??>
	<#list subTables as sub>
import ${basePackage}.${moduleName}.common.dataobj.${entityPackage}.${sub.entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${sub.entityCamelName}Service;
	</#list>
</#if>

/**
 * ${caption!}
 * ${remark!}
 */
@Controller
@RequestMapping("/${moduleName}/${entityName}")
public class ${entityCamelName}Controller extends BaseController {
	
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
	@RequestMapping(value = "/toList${entityCamelName}")
	public ModelAndView toList${entityCamelName}(HttpServletRequest req){
		ModelAndView mv = new ModelAndView("/${moduleName}/${entityName}/list${entityCamelName}");
		return mv;
	}
	
	/**
	 * 查询${caption!}
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
	 * 显示${caption!}详情页面
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return
	 */
	@RequestMapping(value = "/show${entityCamelName}")
	public ModelAndView show${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		ModelAndView mv = new ModelAndView("/${moduleName}/${entityName}/show${entityCamelName}");
		return mv;
	}
	
	/**
	 * 加载${caption!}详情
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
	
	@RequestMapping(value="/toAdd${entityCamelName}")
	public ModelAndView toAdd${entityCamelName}(){
		ModelAndView mv = new ModelAndView("/${moduleName}/${entityName}/add${entityCamelName}");
		return mv;
	}
	
	/**
	 * 保存${caption!}详情
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
	

	@RequestMapping(value="/toEdit${entityCamelName}")
	public ModelAndView toEdit${entityCamelName}(<#list primaryKeyList as col><#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		ModelAndView mv = new ModelAndView("/${moduleName}/${entityName}/edit${entityCamelName}");
		return mv;
	}
	
	/**
	 * 保存修改的${caption!}
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
	 * 修改${caption!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/ajax/updateState")
	public ResponseJson updateState(HttpServletRequest req,@RequestParam(value="state") Integer state,@RequestParam(value="id[]") Long[] ids){
		${entityName}Service.updateState(ids,state);
		
		return new ResponseJson(0,null);
	}


}
