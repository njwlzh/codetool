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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

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
 * ${caption!}
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
	@Resource(name=${sub.entityCamelName}Service.BEAN_ID)
	private ${sub.entityCamelName}Service ${sub.entityName}Service;
		</#list>
	</#if>
	
	
	/**
	 * 查询${caption!}
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
	@RequestMapping(value = "/ajax/load${entityCamelName}")
	public ResponseJson load${entityCamelName}(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		${entityCamelName} ${entityName} = ${entityName}Service.loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
		
	<#if subTables??>
		<#list subTables as sub>
		Pagination<${sub.entityCamelName}> paging${sub.entityCamelName} = new Pagination<${sub.entityCamelName}>(-1, 1);
		Map<String,Object> params${sub.entityCamelName} = new HashMap<String,Object>();
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
	<#assign validate="">
	<#if module.persistance=="hibernate" || module.persistance=="jpa">
	<#assign validate="@Valid ">
	</#if>
	@RequestMapping(value = "/ajax/save${entityCamelName}",method=RequestMethod.POST)
	public ResponseJson save${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.save${entityCamelName}(${entityName});
		
		return new ResponseJson(0,${entityName});
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
	public ResponseJson update${entityCamelName}(@RequestBody ${validate}${entityCamelName} ${entityName}){
		${entityName}Service.update${entityCamelName}(${entityName});
		
		return new ResponseJson(0,null);
	}
	/**
	 * 修改${caption!}状态
	 * @param ${entityCamelName}
	 * @return
	 */
	@RequestMapping(value = "/ajax/updateState")
	public ResponseJson updateState(HttpServletRequest req,${entityCamelName} ${entityName}){
		${entityName}Service.updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${entityName}.get${col.propertyCamelName}()</#list>,${entityName}.getState());
		
		return new ResponseJson(0,null);
	}


	/**
	 * 导出表格数据，前台需传入页面URI和要导出的表格名称，其它为查询的参数
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/file/export", produces = MediaType.MULTIPART_FORM_DATA_VALUE)
	public ResponseEntity<byte[]> export(HttpServletRequest req) throws Exception{
		byte[] fileArray = new byte[0];
		//导出所有数据
		Pagination<${entityCamelName}> paging = new Pagination<${entityCamelName}>(-1, 1);
		
		Map<String,Object> params = RequestUtil.getParameters();
		params.put("state", BaseStateConstants.NORMAL.getIntCode());
		
		String tableConfig = getTableConfig();
		//如果没有查询到表格的配置，则不进行下载
		if (StringUtil.isEmpty(tableConfig)) {
			return null;
		}
		
		${entityName}Service.load${entityCamelName}List(paging,params);
		//转换数据列表为jsonArray，方便导出Excel对应的键值
		JSONArray datas = (JSONArray)JSON.toJSON(paging.getEntities());
		//列头
		List<Map> excelHeaders = JSON.parseArray(tableConfig, Map.class);
		
		File f = new File(FileUtil.getTempRandomFilePath("xls"));
		ExcelUtil.writeExcel(f, excelHeaders, datas);
		fileArray = FileUtil.file2Byte(f);
		
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.setContentDispositionFormData("attachment", URLEncoder.encode("数据列表","UTF-8")+".xls");
		httpHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		
		return new ResponseEntity<byte[]>(fileArray, httpHeaders, HttpStatus.OK);
	}


	/**
	 * 上传Excel，并解析后返回到列表页
	 * @param req
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/ajax/importExcel")
	public ResponseJson importExcel(HttpServletRequest req, MultipartFile file) throws Exception{
		//Map<String,Object> params = RequestUtil.getParameters();
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
	    MultipartHttpServletRequest multiReq = multipartResolver.resolveMultipart(req);
	    
	    String pageUri = multiReq.getParameter("pageUri");
	    String tableId = multiReq.getParameter("tableId");
	    
		String tableConfig = getTableConfig(pageUri, tableId);
		//如果没有查询到表格的配置，则不进行下载
		if (StringUtil.isEmpty(tableConfig)) {
			return null;
		}
		
		//列头
		List<Map> excelHeaders = JSON.parseArray(tableConfig, Map.class);
		//解析Excel文件
		List<Map> datas = ExcelUtil.readExcel(file.getInputStream(), excelHeaders);
		
		return new ResponseJson(0,datas);
	}
}
