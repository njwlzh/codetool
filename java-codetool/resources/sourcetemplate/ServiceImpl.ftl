package ${basePackage}.${moduleName}.${servicePackage}.${serviceImplPackage};

import java.util.Map;
<#if module.persistance=="mybatis">
import java.util.List;
</#if>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ${basePackage}.common.Pagination;
import ${basePackage}.common.constant.BaseStateConstants;
import ${basePackage}.common.persists.BaseEntity;
import ${basePackage}.common.utils.DateUtil;
import ${basePackage}.common.utils.EntityUtil;
import ${basePackage}.common.utils.StringUtil;
<#if idGenerateType=="idWorker">
import ${basePackage}.common.persists.IdWorker;
</#if>
<#if idGenerateType=="uuid">
import java.util.UUID;
</#if>

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

import ${basePackage}.${moduleName}.common.dataobj.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;
<#if subTables??>
<#list subTables as sub>
import ${basePackage}.${moduleName}.${daoPackage}.${sub.entityCamelName}Dao;
import ${basePackage}.${moduleName}.common.dataobj.${entityPackage}.${sub.entityCamelName};
</#list>
</#if>

/**
 * ${caption!}操作相关
 */
@Service(${entityCamelName}Service.BEAN_ID)
public class ${entityCamelName}ServiceImpl implements ${entityCamelName}Service {

	Logger logger = LoggerFactory.getLogger(${entityCamelName}ServiceImpl.class);

	@Resource(name=${entityCamelName}Dao.BEAN_ID)
	private ${entityCamelName}Dao ${entityName}Dao;
	<#if subTables??>
	<#list subTables as sub>
	@Resource(name="${sub.entityName}Dao")
	private ${sub.entityCamelName}Dao ${sub.entityName}Dao;
	</#list>
	</#if>
	<#if idGenerateType=="idWorker">
	@Autowired
	private IdWorker idWorker;
	</#if>
	

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		<#if idGenerateType=="idWorker">
		${entityName}.setId(idWorker.nextId());
		</#if>
		<#if idGenerateType=="uuid">
		${entityName}.setId(UUID.randomUUID().toString());
		</#if>
		${entityName}Dao.save${entityCamelName}(${entityName});
		<#if subTables??>
		<#list subTables as sub>
		if (${entityName}.get${sub.entityCamelName}List() != null && ${entityName}.get${sub.entityCamelName}List().size()>0) {
			for (${sub.entityCamelName} dt : ${entityName}.get${sub.entityCamelName}List()) {
				<#if idGenerateType=="idWorker">
				dt.setId(idWorker.nextId());
				</#if>
				<#if idGenerateType=="uuid">
				dt.setId(UUID.randomUUID().toString());
				</#if>
				dt.set${sub.parentProperty?cap_first}(${entityName}.getId());
				dt.setComId(${entityName}.getComId());
				dt.setCreateUser(${entityName}.getCreateUser());
				dt.setCreateTime(DateUtil.getDate().getTime());
			}
			${sub.entityName}Dao.batchSave${sub.entityCamelName}(${entityName}.get${sub.entityCamelName}List());
		}
		</#list>
		</#if>
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.update${entityCamelName}(${entityName});
		
		<#if subTables??>
		<#list subTables as sub>
		if (${entityName}.get${sub.entityCamelName}List() != null && ${entityName}.get${sub.entityCamelName}List().size()>0) {
			List<${sub.entityCamelName}> newList = EntityUtil.getDataList(${entityName}.get${sub.entityCamelName}List(), BaseEntity.TMP_NEW);
			List<${sub.entityCamelName}> modifyList = EntityUtil.getDataList(${entityName}.get${sub.entityCamelName}List(), BaseEntity.TMP_MODIFY);
			List<${sub.entityCamelName}> deletedList = EntityUtil.getDataList(${entityName}.get${sub.entityCamelName}List(), BaseEntity.TMP_DELETED);
			//新增列表
			if (newList.size()>0) {
				for (${sub.entityCamelName} dt : newList) {
					<#if idGenerateType="idWorker">
					dt.setId(idWorker.nextId());
					</#if>
					<#if idGenerateType=="uuid">
					dt.setId(UUID.randomUUID().toString());
					</#if>
					dt.set${sub.parentProperty?cap_first}(${entityName}.getId());
					dt.setComId(${entityName}.getComId());
					dt.setCreateUser(${entityName}.getCreateUser());
					dt.setCreateTime(DateUtil.getDate().getTime());
				}
				${sub.entityName}Dao.batchSave${sub.entityCamelName}(newList);
			}
			//修改列表
			if (modifyList.size()>0) {
				for (${sub.entityCamelName} dt : modifyList) {
					${sub.entityName}Dao.update${sub.entityCamelName}(dt);
				}
			}
			//删除列表
			if (deletedList.size()>0) {
				for (${sub.entityCamelName} dt : deletedList) {
					${sub.entityName}Dao.updateState(dt.getId(), BaseStateConstants.DELETED.getIntCode());
				}
			}
		}
		</#list>
		</#if>
	}

	@Override
	public void updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyType}[] ${col.propertyName}s</#list>,Integer state){
		<#list primaryKeyList as col> 
			<#if col_index lt 1>
		for (int i=0; i<${col.propertyName}s.length; i++){
			${entityName}Dao.updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyName}s[i]</#list>,state);
		}
			</#if>
		</#list>
	}

	@Override
	public ${entityCamelName} loadByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyType} ${col.propertyName}</#list>){
		return ${entityName}Dao.findByKey(<#list primaryKeyList as col> <#if col_index gt 0> , </#if>${col.propertyName}</#list>);
	}

	@Override
	public void load${entityCamelName}List(Pagination<${entityCamelName}> page,
			Map<String, Object> params) {
		<#if module.persistance=="mybatis">
		if (page.getPageSize()>0){
			Map<String,Object>  countData = ${entityName}Dao.count${entityCamelName}(params);
			page.setCountData(countData);
			if (!countData.containsKey("total")){
				Long total = StringUtil.getLong(countData.get("total"));
				if (total==null || total<1l) {
					return;
				}
			}
		}
		List<${entityCamelName}> list = ${entityName}Dao.find${entityCamelName}List(page,params);
		page.setEntities(list);
		<#elseif module.persistance=="hibernate">
		${entityName}Dao.find${entityCamelName}List(page,params);
		<#else>
		${entityName}Dao.find${entityCamelName}ListByJdbc(page,params);
		</#if>
	}

}
