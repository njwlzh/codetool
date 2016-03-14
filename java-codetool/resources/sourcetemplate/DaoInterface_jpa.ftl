package ${basePackage}.${moduleName}.${daoPackage};

import org.springframework.data.jpa.repository.JpaRepository;

import ${basePackage}.${moduleName}.${entityPackage}.${entityCamelName};

/**
 * ${remark!}操作相关
 */
public interface ${entityCamelName}Dao extends JpaRepository<${entityCamelName},${primaryPropertyType}> {
	

}
