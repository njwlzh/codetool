<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Dao" >
  <resultMap id="BaseResultMap" type="${basePackage}.${moduleName}.${entityPackage}.${entityCamelName}" >
    <id column="${primaryKey!}" property="${primaryProperty}" jdbcType="${primaryKeyType}" />
    <#list columns as col>
    <#if !col.primaryKey>
    <result column="${col.columnName}" property="${col.propertyName}" jdbcType="${col.columnType}" <#if col.columnType == 'DATE' || col.columnType=='TIMESTAMP'>javaType="java.util.Date"</#if> />
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
  	update ${tableFullName} 
  	<set>
  	<#list columns as col>
  	<#if col.propertyName != 'id'>
  	<if test="${col.propertyName}!=null">
  	${col.columnName}=${'#'}{${col.propertyName},jdbcType=${col.columnType}},
  	</if>
  	</#if>
    </#list>
    </set>
  	where <#list primaryKeyList as col><#if col_index gt 0> and </#if>${col.columnName!}=${'#'}{${col.propertyName!},jdbcType=${col.columnType!}}</#list>
  </update>
  
  <update id="updateState">
  	update ${tableFullName} set state=${'#'}{${state}} where <#list primaryKeyList as col> <#if col_index gt 0> and </#if>${col.columnName}=${'#'}{${propertyName}}</#list>
  </update>
  
  <select id="findById" resultMap="BaseResultMap" parameterType="${primaryPropertyType}">
  	select <include refid="Base_Column_List"/> from ${tableFullName} where ${primaryKey!}=${'#'}{id}
  </select>
  
  <sql id="BaseCondition">
  	<where>
  	<#list columns as col>
  	<if test="map.${col.propertyName}!=null">
  	and ${col.columnName}=${'#'}{map.${col.propertyName},jdbcType=${col.columnType}}
  	</if>
    </#list>
    </where>
  </sql>
  
  <select id="find${entityCamelName}List" resultMap="BaseResultMap">
  	select * from(select a.*,ROWNUM rn from(
  	select <include refid="Base_Column_List"/> from ${tableFullName}
  	<include refid="BaseCondition"/>
  	order by ${primaryKey!} desc
  	) a 
  	<if test="page!=null and page.pageSize>0">
  	<![CDATA[
  	 where ROWNUM<=(${'#'}{page.firstEntityIndex}+${'#'}{page.pageSize})
  	]]>
  	</if>
  	<![CDATA[
  	)
	<if test="page!=null and page.pageSize>0">
	where rn > ${'#'}{page.firstEntityIndex}
	</if>
  	]]>
  </select>
  <select id="count${entityCamelName}" resultType="int">
  	select count(*) from ${tableFullName}
  	<include refid="BaseCondition"/>
  </select>
</mapper>