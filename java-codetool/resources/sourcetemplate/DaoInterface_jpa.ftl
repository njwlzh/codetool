package ${basePackage}.${moduleName}.${daoPackage};

import java.util.Map;
import org.springframework.data.repository.CrudRepository;
import ${basePackage}.common.Pagination;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${remark!}操作相关
 */
public interface ${entityCamelName}Dao extends CrudRepository<${entityCamelName},${primaryPropertyType}> {
	

}
