package ${basePackage}.${moduleName}.${servicePackage}.${serviceImplPackage};

import java.util.Map;
import java.util.List;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ${basePackage}.common.info.Pagination;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import ${basePackage}.api.${moduleName}.pojo.${entityPackage}.${entityCamelName};
import ${basePackage}.api.${moduleName}.${servicePackage}.${entityCamelName}Service;
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;
<#if subTables??>
<#list subTables as sub>
import ${basePackage}.${moduleName}.${daoPackage}.${sub.entityCamelName}Dao;
import ${basePackage}.api.${moduleName}.pojo.${entityPackage}.${sub.entityCamelName};
</#list>
</#if>

/**
 * ${caption!}操作相关
 * <p>${remark!}</p>
 */
@Service(${entityCamelName}Service.BEAN_ID)
public class ${entityCamelName}ServiceImpl extends ServiceImpl<${entityCamelName}Dao, ${entityCamelName}> implements ${entityCamelName}Service {

	Logger logger = LoggerFactory.getLogger(${entityCamelName}ServiceImpl.class);

	@Autowired
	private ${entityCamelName}Dao ${entityName}Dao;

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		this.save(${entityName});
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		this.saveOrUpdate(${entityName});
	}

	@Override
	public void updateState(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyType}[] ${col.propertyName}</#list>,Integer state) {
		UpdateWrapper<${entityCamelName}> w = new UpdateWrapper<>();
        w.set("state", 1);
        <#list primaryKeyList as col>
        w.in("${col.columnName}", ${col.propertyName});
        </#list>
        this.update(w);
	}

	@Override
	public ${entityCamelName} loadByKey(<#list primaryKeyList as col> <#if col_index gt 0>,</#if>${col.propertyType} ${col.propertyName}</#list>) {
		QueryWrapper<${entityCamelName}> queryWrapper = new QueryWrapper<${entityCamelName}>();
		<#list primaryKeyList as col>
        queryWrapper.eq("${col.columnName}", ${col.propertyName});
        </#list>
		return this.getOne(queryWrapper);
	}

	@Override
	public void load${entityCamelName}List(Pagination<${entityCamelName}> paging,
			final Map<String, Object> params) {
		
    	QueryWrapper<${entityCamelName}> queryWrapper = new QueryWrapper<${entityCamelName}>();
    	queryWrapper.allEq(params);
    	if (paging.getPageSize() == -1) {
    		paging.setEntities(this.list(queryWrapper));
    		paging.setEntityCount(paging.getEntities().size());
    		return;
    	}
    	
    	IPage<${entityCamelName}> queryPaging = new Page<>(paging.getPageNo(), paging.getPageSize());
    	IPage<${entityCamelName}> page = this.page(queryPaging, queryWrapper);
    	
    	paging.setEntities(page.getRecords());
    	paging.setEntityCount((int)page.getTotal());
	}

}
