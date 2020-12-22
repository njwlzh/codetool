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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import ${basePackage}.${moduleName}.controller.BaseController;
import com.ynby.common.info.Response;
import com.ynby.common.info.Pagination;
import com.ynby.common.tools.StringUtil;
import com.ynby.common.tools.ListUtil;
import com.ynby.common.constants.BaseStateConstants;
import ${basePackage}.${moduleName}.common.RequestUtil;
import ${basePackage}.api.pojo.${entityPackage}.${entityCamelName};
import ${basePackage}.api.${servicePackage}.${entityCamelName}Service;

<#if subTables??>
	<#list subTables as sub>
import ${basePackage}.api.pojo.${entityPackage}.${sub.entityCamelName};
import ${basePackage}.api.${servicePackage}.${sub.entityCamelName}Service;
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
public class ${entityCamelName}Controller extends BaseController {
	
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
	@ApiOperation(value = "查询${caption!}列表", notes = "查询${caption!}列表，根据 entity属性作为键值传入查询参数，以条件组合方式查询", response = Response.class)
	</#if>
	@GetMapping(value = "/load${entityCamelName}List")
	public Response<Pagination<${entityCamelName}>> load${entityCamelName}List(HttpServletRequest req){
		Integer pageNo = getPageNo();
		Integer pageSize = getPageSize();
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(pageSize, pageNo);
		
		Map<String,Object> params = RequestUtil.getParameters();
		params.put("status", BaseStateConstants.NORMAL.getIntCode());
		${entityName}Service.load${entityCamelName}List(paging,params);
		
		return Response.success(paging);
	}
	
	/**
	 * 加载${caption!}详情
	 <#list primaryKeyList as col>
	 * @param ${col.propertyName}
	 </#list>
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "根据主键ID查询${caption!}", notes = "根据主键ID查询单个${caption!}", response = Response.class)
	</#if>
	@GetMapping(value = "/load${entityCamelName}")
	public Response<${entityCamelName}> load${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		${entityCamelName} ${entityName} = ${entityName}Service.loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
		
	<#if subTables??>
		<#list subTables as sub>
		/*
		${sub.caption}
		*/
		Pagination<${sub.entityCamelName}> paging${sub.entityCamelName} = new Pagination<${sub.entityCamelName}>(-1, 1);
		Map<String,Object> params${sub.entityCamelName} = new HashMap<String,Object>();
		params${sub.entityCamelName}.put("${sub.parentProperty}", id);
		params${sub.entityCamelName}.put("status", BaseStateConstants.NORMAL.getIntCode());
		${sub.entityName}Service.load${sub.entityCamelName}List(paging${sub.entityCamelName},params${sub.entityCamelName});
		${entityName}.set${sub.entityCamelName}List(ListUtil.collection2List(paging${sub.entityCamelName}.getEntities()));
		
		</#list>
	</#if>
		return Response.success(${entityName});
	}
	
	/**
	 * 保存${caption!}详情
	 * @param ${entityName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "保存${caption!}", notes = "保存${caption!}", response = Response.class)
	</#if>
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@PostMapping(value = "/save${entityCamelName}")
	public Response<${entityCamelName}> save${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.save${entityCamelName}(${entityName});
		
		return Response.success(${entityName});
	}
	
	/**
	 * 更新${caption!}
	 * @param ${entityCamelName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "更新${caption!}", notes = "更新${caption!}", response = Response.class)
	</#if>
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@PostMapping(value = "/update${entityCamelName}")
	public Response<${entityCamelName}> update${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.update${entityCamelName}(${entityName});
		
		return Response.success(null);
	}
	/**
	 * 修改${caption!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	<#if supportSwagger!false>
	@ApiOperation(value = "更新${caption!}数据状态", notes = "更新${caption!}数据状态，一般用于逻辑删除数据，支持传入ID列表进行更新", response = Response.class)
	</#if>
	@GetMapping(value = "/updateState")
	public Response<${entityCamelName}> updateState(HttpServletRequest req,@RequestParam(value="state") Integer state,@RequestParam(value="id[]") Long[] ids){
		${entityName}Service.updateState(ids,state);
		
		return Response.success(null);
	}

}
