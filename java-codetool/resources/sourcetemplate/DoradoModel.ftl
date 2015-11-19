
  <DataType name="dt${entityCamelName}">
    <Property name="creationType">${basePackage}.${moduleName}.${entityPackage}.${entityCamelName!}</Property>
    <#list columns as col>
    <#assign type=col.propertyType>
	<#assign type=type?replace("java.util.Date","DateTime")>
	<#assign type=type?replace("java.math.","")>
    <PropertyDef name="${col.propertyName}">
      <Property name="dataType">${type}</Property>
      <Property name="label">${col.remark}</Property>
    </PropertyDef>
    </#list>
  </DataType>
