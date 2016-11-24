package ${basePackage}.${moduleName}.${daoPackage};

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${remark!}操作相关
 */
public interface ${entityCamelName}Dao extends JpaRepository<${entityCamelName},${primaryPropertyType}>,JpaSpecificationExecutor<${entityCamelName}> {
	

}
