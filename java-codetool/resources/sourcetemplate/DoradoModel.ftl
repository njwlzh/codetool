
  <DataType name="dt${entityCamelName}">
    <Property name="creationType">${basePackage}.common.dataobj.${entityPackage}.${entityCamelName!}</Property>
    <#list columns as col>
    <#assign type=col.propertyType>
	<#assign type=type?replace("java.util.Date","DateTime")>
	<#assign type=type?replace("java.math.","")>
    <PropertyDef name="${col.propertyName}">
      <Property name="dataType">${type}</Property>
      <Property name="label">${col.remark!}</Property>
      <#if col.nullable==false && type!="DateTime" && col.primaryKey==false>
      <Property name="required">true</Property>
      </#if>
      <#if type=="String" && col.length gt 0>
      <Validator type="length">
        <Property name="maxLength">${col.length}</Property>
      </Validator>
      </#if>
    </PropertyDef>
    </#list>
  </DataType>
