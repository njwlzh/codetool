<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao" >
  <resultMap id="BaseResultMap" type="${basePackage}.${moduleName}.${entityPackage}.${entityCamelName}" >
    <id column="${primaryKey}" property="${primaryProperty}" jdbcType="${primaryKeyType}" />
    <#list columns as col>
    <#if !col.primaryKey>
    <result column="${col.columnName}" property="${col.propertyName}" jdbcType="${col.columnType}" />
    </#if>
    </#list>
  </resultMap>
  
  <sql id="Base_Column_List" >
    <#list columns as col>${col.columnName}<#if col_index lt columns?size-1>,</#if></#list>
  </sql>
  
  <insert id="save${entityCamelName}" parameterType="${basePackage}.${moduleName}.${entityPackage}.${entityCamelName}">
  	insert into ${tableFullName} (<#list columns as col>${col.columnName}<#if col_index lt columns?size-1>,</#if></#list>) 
  	values (<#list columns as col>
  	${'#'}{${col.propertyName},jdbcType=${col.columnType}}
  	<#if col_index lt columns?size-1>,</#if>
  	</#list>)
  </insert>
  
  <update id="update${entityCamelName}" parameterType="${basePackage}.${moduleName}.${entityPackage}.${entityCamelName}">
  	update ${tableFullName} set <#list columns as col>
  	<#if col_index gt 0>,</#if>
  	${col.columnName}=${'#'}{${col.propertyName},jdbcType=${col.columnType}}
  	</#list> 
  	where ${primaryKey!}=${'#'}{${primaryProperty!},jdbcType=${primaryKeyType!}}
  </update>
  
  <delete id="delete${entityCamelName}" parameterType="${basePackage}.${moduleName}.${entityPackage}.${entityCamelName}">
  	delete from ${tableFullName} where ${primaryKey}=${'#'}{${primaryProperty},jdbcType=${primaryKeyType}}
  </delete>
  
  <select id="findById" resultMap="BaseResultMap" parameterType="${primaryPropertyType}">
  	select <include refid="Base_Column_List"/> from ${tableFullName} where ${primaryKey!}=${'#'}{id}
  </select>
  
  <select id="find${entityCamelName}List" resultMap="BaseResultMap">
  	select * from(select a.*,ROWNUM rn from(
  	select <include refid="Base_Column_List"/> from ${tableFullName} where 1=1
  	<#list columns as col>
  	<if test="map.${col.propertyName}!=null">
  	and ${col.columnName}=${'#'}{map.${col.propertyName},jdbcType=${col.columnType}}
  	</if>
    </#list>
  	order by ${primaryKey!} desc
  	) a where 
  	<![CDATA[
  	ROWNUM<=(${'#'}{page.firstEntityIndex}+${'#'}{page.pageSize})) where rn>${'#'}{page.firstEntityIndex}
  	]]>
  </select>
  <select id="count${entityCamelName}" resultType="int">
  	select count(*) from ${tableFullName} where 1=1
  	<#list columns as col>
  	<if test="map.${col.propertyName}!=null">
  	and ${col.columnName}=${'#'}{map.${col.propertyName},jdbcType=${col.columnType}}
  	</if>
    </#list>
  </select>
</mapper>