package ${basePackage}.${moduleName}.${servicePackage}.${serviceImplPackage};

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;

import ${basePackage}.common.Pagination;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};
import ${basePackage}.${moduleName}.${servicePackage}.${entityCamelName}Service;
import ${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao;

/**
 * ${remark!}操作相关
 */
@Service(${entityCamelName}Service.BEAN_ID)
public class ${entityCamelName}ServiceImpl implements ${entityCamelName}Service {

	Logger logger = LoggerFactory.getLogger(${entityCamelName}ServiceImpl.class);

	@Autowired
	private ${entityCamelName}Dao ${entityName}Dao;

	@Override
	public void save${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.save(${entityName});
	}

	@Override
	public void update${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.saveAndFlush(${entityName});
	}

	@Override
	public void remove${entityCamelName}(${entityCamelName} ${entityName}) {
		${entityName}Dao.delete(${entityName});
	}

	@Override
	public ${entityCamelName} loadById(${primaryPropertyType} ${primaryProperty}) {
		return ${entityName}Dao.findOne(${primaryProperty});
	}

	@Override
	public void load${entityCamelName}List(Pagination<${entityCamelName}> paging,
			Map<String, Object> params) {
		
		Page<${entityCamelName}> p =  ${entityName}Dao.findAll(new PageRequest(paging.getPageNo(),paging.getPageSize(),new Sort(new Order(Direction. DESC,"${primaryProperty}"))));
		paging.setEntities(p.getContent());
		paging.setEntityCount((int)p.getTotalElements());
	}

}
