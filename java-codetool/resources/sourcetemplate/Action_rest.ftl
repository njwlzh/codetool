package ${basePackage}.${moduleName}.${actionPackage};
import java.util.Map;
import java.util.HashMap;
import java.io.File;
import java.net.URLEncoder;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
<#if module.persistance=="hibernate" || module.persistance=="jpa">
import javax.validation.Valid;
</#if>

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import ${basePackage}.base.BaseAction;
import ${basePackage}.base.ResponseJson;
import ${basePackage}.common.Pagination;
import ${basePackage}.common.utils.ExcelUtil;
import ${basePackage}.common.utils.FileUtil;
import ${basePackage}.common.utils.StringUtil;
import ${basePackage}.common.utils.RequestUtil;
import ${basePackage}.common.utils.ListUtil;
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
 * ${caption!}相关操作
 * ${remark!}
 */
<#if supportSwagger!false>
@Api(tags = {"${caption!}相关操作"})
</#if>
@RestController
@RequestMapping("/${moduleName}/${entityName}")
public class ${entityCamelName}Action extends BaseAction {
	
	@Resource(name=${entityCamelName}Service.BEAN_ID)
	private ${entityCamelName}Service ${entityName}Service;
	<#if subTables??>
		<#list subTables as sub>
	@Resource(name=${sub.entityCamelName}Service.BEAN_ID)
	private ${sub.entityCamelName}Service ${sub.entityName}Service;
		</#list>
	</#if>
	
	
	/**
	 * 查询${caption!}
	 * @param params 参数列表
	 * @param page
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "查询${caption!}列表", notes = "查询${caption!}列表，根据 entity属性作为键值传入查询参数，以条件组合方式查询", response = ResponseJson.class)
	</#if>
	@RequestMapping(value = "/load${entityCamelName}List")
	public ResponseJson load${entityCamelName}List(HttpServletRequest req){
		Integer pageNo = getPageNo();
		Integer pageSize = getPageSize();
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(pageSize, pageNo);
		
		Map<String,Object> params = RequestUtil.getParameters();
		params.put("state", BaseStateConstants.NORMAL.getIntCode());
		resetOrderString(${entityCamelName}.class, params);
		${entityName}Service.load${entityCamelName}List(paging,params);
		
		return getReturnData(paging);
	}
	
	/**
	 * 加载${caption!}详情
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "根据主键ID查询${caption!}", notes = "根据主键ID查询单个${caption!}", response = ResponseJson.class)
	</#if>
	@RequestMapping(value = "/load${entityCamelName}")
	public ResponseJson load${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		${entityCamelName} ${entityName} = ${entityName}Service.loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
		
	<#if subTables??>
		<#list subTables as sub>
		/*
		${sub.caption}
		*/
		Pagination<${sub.entityCamelName}> paging${sub.entityCamelName} = new Pagination<${sub.entityCamelName}>(-1, 1);
		Map<String,Object> params${sub.entityCamelName} = new HashMap<String,Object>();
		params${sub.entityCamelName}.put("${sub.parentProperty}", id);
		params${sub.entityCamelName}.put("state", BaseStateConstants.NORMAL.getIntCode());
		${sub.entityName}Service.load${sub.entityCamelName}List(paging${sub.entityCamelName},params${sub.entityCamelName});
		${entityName}.set${sub.entityCamelName}List(ListUtil.collection2List(paging${sub.entityCamelName}.getEntities()));
		
		</#list>
	</#if>
		return new ResponseJson(0,${entityName});
	}
	
	/**
	 * 保存${caption!}详情
	 * @param ${entityName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "保存${caption!}", notes = "保存${caption!}", response = ResponseJson.class)
	</#if>
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@PostMapping(value = "/save${entityCamelName}",method=RequestMethod.POST)
	public ResponseJson save${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.save${entityCamelName}(${entityName});
		
		return new ResponseJson(0,${entityName});
	}
	
	/**
	 * 更新${caption!}
	 * @param ${entityCamelName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "更新${caption!}", notes = "更新${caption!}", response = ResponseJson.class)
	</#if>
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@RequestMapping(value = "/update${entityCamelName}",method=RequestMethod.POST)
	public ResponseJson update${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.update${entityCamelName}(${entityName});
		
		return new ResponseJson(0,null);
	}
	/**
	 * 修改${caption!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "更新${caption!}数据状态", notes = "更新${caption!}数据状态，一般用于逻辑删除数据，支持传入ID列表进行更新", response = ResponseJson.class)
	</#if>
	@RequestMapping(value = "/updateState")
	public ResponseJson updateState(HttpServletRequest req,@RequestParam(value="state") Integer state,@RequestParam(value="id[]") Long[] ids){
		${entityName}Service.updateState(ids,state);
		
		return new ResponseJson(0,null);
	}

}
