<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${basePackage}.${moduleName}.${daoPackage}.${entityCamelName}Mapper" >
  <resultMap id="BaseResultMap" type="${basePackage}.api.pojo.${entityPackage}.${entityCamelName}" >
    <#list primaryKeyList as col>
    <id column="${col.columnName}" property="${col.propertyName}" jdbcType="${col.columnType}" />
    </#list>
    <#list columns as col>
    <#if !col.primaryKey>
    <result column="${col.columnName}" property="${col.propertyName}" jdbcType="${col.columnType}" <#if col.columnType == 'DATE' || col.columnType=='TIMESTAMP'>javaType="java.util.Date"</#if> />
    </#if>
    </#list>
  </resultMap>
  
  <sql id="Base_Column_List" >
    <#list columns as col>${col.columnName}<#if col_index lt columns?size-1>,</#if></#list>
  </sql>
  
  <insert id="save${entityCamelName}" parameterType="${basePackage}.api.pojo.${entityPackage}.${entityCamelName}">
  	insert into ${tableFullName} (<#list columns as col><#if !col.identity>${col.columnName}</#if><#if !col.identity && col_index lt columns?size-1>,</#if></#list>) 
  	values (
  	<#list columns as col>
	  	<#if !col.identity>
	  	${'#'}{${col.propertyName},jdbcType=${col.columnType}}
	  	</#if>
  		<#if !col.identity! && col_index lt columns?size-1>,</#if>
  	</#list>)
  	<#if idGenerateType=="auto">
  	<#if primaryKeyList?size&gt;0>
  		<#list primaryKeyList as col>
  		<#if col.identity>
	    <selectKey resultType="${col.propertyType}" keyProperty="${col.propertyName}" >
	      select last_insert_id()
	    </selectKey>
	    </#if>
	    </#list>
    </#if>
    </#if>
  </insert>
  
  <insert id="batchSave${entityCamelName}" parameterType="java.util.List" <#if idGenerateType=="auto">useGeneratedKeys="true" keyProperty="id"</#if>>
  	insert into ${tableFullName} (<#list columns as col><#if !col.identity>${col.columnName}</#if><#if !col.identity && col_index lt columns?size-1>,</#if></#list>) 
  	values 
  	<foreach collection="list" item="item" index="index" separator=",">
  	(
  	<#list columns as col>
	  	<#if !col.identity>
	  	${'#'}{item.${col.propertyName},jdbcType=${col.columnType}}
	  	</#if>
  		<#if !col.identity! && col_index lt columns?size-1>,</#if>
  	</#list>)
  	</foreach>
  </insert>
  
  <update id="update${entityCamelName}" parameterType="${basePackage}.api.pojo.${entityPackage}.${entityCamelName}">
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
  	update ${tableFullName} set state=${'#'}{state} where <#list primaryKeyList as col> <#if col_index gt 0> and </#if>${col.columnName}=${'#'}{${col.propertyName}}</#list>
  </update>
  
  <select id="findByKey" resultMap="BaseResultMap">
  	select <include refid="Base_Column_List"/> from ${tableFullName} where 
  	<#list primaryKeyList as col> <#if col_index gt 0> and </#if>${col.columnName}=${'#'}{${col.propertyName}}</#list>
  </select>
  
  <sql id="BaseCondition">
    <where>
  	<#list columns as col>
  	<if test="map.${col.propertyName}!=null">
  	and ${col.columnName}=${'#'}{map.${col.propertyName},jdbcType=${col.columnType}}
  	</if>
    </#list>
    <if test="map.keyword!=null">
  	
  	</if>
    </where>
  </sql>
  
  <select id="find${entityCamelName}List" resultMap="BaseResultMap">
  	select <include refid="Base_Column_List"/> from ${tableFullName}
  	<include refid="BaseCondition"/>
  	order by 
  	<if test="map.orderString!=null">
  		${'$'}{map.orderString},
  	</if>
  	<#list primaryKeyList as col><#if col_index gt 0> , </#if>${col.columnName!} desc</#list>
  	<if test="page!=null and page.pageSize>0">
  	limit ${'#'}{page.firstEntityIndex},${'#'}{page.pageSize}
  	</if>
  </select>
  <select id="count${entityCamelName}" resultType="map">
  	select count(*) total from ${tableFullName}
  	<include refid="BaseCondition"/>
  </select>
</mapper>