package ${basePackage}.${moduleName}.${actionPackage};
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import ${basePackage}.base.BaseAction;
import ${basePackage}.common.Pagination;
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
@Controller
@RequestMapping("/${moduleName}")
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
	@RequestMapping(value = "/list${entityCamelName}")
	public ModelAndView load${entityCamelName}List(HttpServletRequest req,@RequestParam(value="page",defaultValue="1",required=false) int page){
		ModelAndView mv = new ModelAndView("/${moduleName}/list${entityCamelName}");
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(10, page);
		Map<String,Object> params = new HashMap<String, Object>();
		${entityName}Service.load${entityCamelName}List(paging,params);
		mv.addObject("paging",paging);
		return mv;
	}
	
	/**
	 * 显示${remark!}详情
	 * @param ${primaryProperty}
	 * @return
	 */
	@RequestMapping(value = "/show${entityCamelName}")
	public ModelAndView load${entityName}(${primaryPropertyType} ${primaryProperty}){
		ModelAndView mv = new ModelAndView("/${moduleName}/show${entityCamelName}");
		${entityCamelName} ${entityName} = ${entityName}Service.loadById(${primaryProperty});
		mv.addObject("${entityName}",${entityName});
		return mv;
	}
	
	@RequestMapping(value="/toAdd${entityCamelName}")
	public String toAdd${entityCamelName}(){
		return "/${moduleName}/add${entityCamelName}";
	}
	
	/**
	 * 保存${remark!}详情
	 * @param ${entityName}
	 * @return
	 */
	@RequestMapping(value = "/save${entityCamelName}",method=RequestMethod.POST)
	public ModelAndView save${entityCamelName}(${entityCamelName} ${entityName}){
		ModelAndView mv = new ModelAndView("redirect:/${moduleName}/list${entityCamelName}");
		${entityName}Service.save${entityCamelName}(${entityName});
		return mv;
	}
	

	@RequestMapping(value="/toEdit${entityCamelName}")
	public ModelAndView toEdit${entityCamelName}(${primaryPropertyType} ${primaryProperty}){
		ModelAndView mv = new ModelAndView("/${moduleName}/edit${entityCamelName}");
		${entityCamelName} ${entityName}= ${entityName}Service.loadById(${primaryProperty});
		mv.addObject("${entityName}",${entityName});
		return mv;
	}
	
	/**
	 * 保存修改的${remark!}
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/update${entityCamelName}",method=RequestMethod.POST)
	public ModelAndView update${entityCamelName}(${entityCamelName} ${entityName}){
		ModelAndView mv = new ModelAndView("redirect:/${moduleName}/list${entityCamelName}");
		${entityName}Service.update${entityCamelName}(${entityName});
		return mv;
	}
	/**
	 * 删除${remark!}
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/remove${entityCamelName}",method=RequestMethod.POST)
	public ModelAndView remove${entityCamelName}(HttpServletRequest req,${entityCamelName} ${entityName}){
		ModelAndView mv = new ModelAndView("redirect:/${moduleName}/list${entityCamelName}");
		${entityName}Service.remove${entityCamelName}(${entityName});
		return mv;
	}


}
