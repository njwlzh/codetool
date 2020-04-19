<?xml version="1.0" encoding="UTF-8"?>
<ViewConfig>
  <Arguments/>
  <Context/>
  <Model>
    <DataType name="dt${entityCamelName}" parent="global:dt${entityCamelName}">
      <#if subTables??>
		<#list subTables as sub>
      	<#if sub.refType=="OneToOne">
      <Reference name="${sub.entityName?uncap_first}">
      	<Property name="dataType">dt${sub.entityCamelName}</Property>
      	<#else>
      <Reference name="${sub.entityName?uncap_first}List">
        <Property name="dataType">[dt${sub.entityCamelName}]</Property>
        </#if>
        <Property name="parameter">
          <Entity>
          	<#list primaryKeyList as col>
            <Property name="${col.propertyName}">${'$'}${'$'}{this.${sub.parentProperty!}}</Property>
            </#list>
          </Entity>
        </Property>
        <#if sub.refType=="OneToOne">
        <Property name="dataProvider">${sub.entityName}Action${'#'}load${sub.entityCamelName}</Property>
        <#else>
        <Property name="dataProvider">${sub.entityName}Action${'#'}load${sub.entityCamelName}List</Property>
        <Property name="pageSize">20</Property>
        </#if>
      </Reference>
		</#list>
	</#if>
    
    </DataType>
  </Model>
  <View>
    <DataSet id="ds${entityCamelName}">
      <Property name="dataType">[dt${entityCamelName}]</Property>
      <Property name="dataProvider">${entityName}Action#load${entityCamelName}List</Property>
      <Property name="pageSize">20</Property>
      <Property name="parameter">
        <Entity/>
      </Property>
    </DataSet>
    <ToolBar>
      <DataPilot>
        <Property name="dataSet">ds${entityCamelName}</Property>
      </DataPilot>
      <Separator/>
      <ToolBarButton id="btnAdd">
        <ClientEvent name="onClick">view.get(&quot;#ds${entityCamelName}&quot;).insert();&#xD;
view.get(&quot;#dlgEdit&quot;).show();&#xD;
</ClientEvent>
        <Property name="caption">新增</Property>
        <Property name="icon">url(>skin>common/icons.gif) -120px -0px</Property>
      </ToolBarButton>
      <ToolBarButton id="btnEdit">
        <ClientEvent name="onClick">view.get(&quot;#dlgEdit&quot;).show();</ClientEvent>
        <Property name="caption">修改</Property>
        <Property name="icon">url(>skin>common/icons.gif) -300px -60px</Property>
      </ToolBarButton>
      <ToolBarButton id="btnDelete">
        <ClientEvent name="onClick">dorado.MessageBox.confirm(&quot;确定要删除吗？&quot;,function(){&#xD;
	var selection=view.get(&quot;#dg${entityCamelName}.selection&quot;);&#xD;
	selection.slice(0).each(function(e){&#xD;
		e.remove();&#xD;
	});&#xD;
	view.get(&quot;#actionSave&quot;).execute(function(){&#xD;
		dorado.MessageBox.alert(&quot;删除成功！&quot;);&#xD;
	});&#xD;
});&#xD;
</ClientEvent>
        <Property name="caption">删除</Property>
        <Property name="icon">url(>skin>common/icons.gif) -140px -0px</Property>
      </ToolBarButton>
    </ToolBar>
    <DataGrid id="dg${entityCamelName}">
      <Property name="dataSet">ds${entityCamelName}</Property>
      <Property name="readOnly">true</Property>
      <Property name="selectionMode">multiRows</Property>
      <RowSelectorColumn/>
      <#list columns as col>
      <DataColumn name="${col.propertyName}">
        <Property name="property">${col.propertyName}</Property>
      </DataColumn>
      </#list>
    </DataGrid>
    <Dialog id="dlgEdit">
      <Property name="width">500</Property>
      <ClientEvent name="onClose">view.get(&quot;#ds${entityCamelName}&quot;).getData(&quot;#&quot;).cancel();</ClientEvent>
      <Buttons>
        <Button>
          <ClientEvent name="onClick">view.get(&quot;#actionSave&quot;).execute(function(){&#xD;
	dorado.MessageBox.alert(&quot;保存成功！&quot;);&#xD;
	self.get(&quot;parent&quot;).close();&#xD;
});&#xD;
</ClientEvent>
          <Property name="caption">保存</Property>
          <Property name="icon">url(>skin>common/icons.gif) -20px -0px</Property>
        </Button>
        <Button>
          <ClientEvent name="onClick">self.get(&quot;parent&quot;).close();&#xD;
</ClientEvent>
          <Property name="caption">取消</Property>
          <Property name="icon">url(>skin>common/icons.gif) -40px -0px</Property>
        </Button>
      </Buttons>
      <Children>
        <AutoForm>
          <Property name="dataSet">ds${entityCamelName}</Property>
          <#list columns as col>
          <AutoFormElement>
            <Property name="name">${col.propertyName}</Property>
            <Property name="property">${col.propertyName}</Property>
            <Editor/>
          </AutoFormElement>
          </#list>
        </AutoForm>
        <#if subTables??>
			<#list subTables as sub>
				<#if sub.refType=="OneToOne">
        <FieldSet>
	      <Property name="caption">${sub.remark}</Property>
	      <Buttons/>
	      <Children>
	        <AutoForm>
	        <#list sub.columns as col>
            <AutoFormElement>
              <Property name="name">${col.propertyName}</Property>
              <Property name="property">${col.propertyName}</Property>
              <Editor/>
            </AutoFormElement>
            </#list>
	        </AutoForm>
	      </Children>
	    </FieldSet>
	    		</#if>
	    	</#list>
	    </#if>
	    
      </Children>
      <Tools/>
    </Dialog>
    <UpdateAction id="actionSave">
      <Property name="dataResolver">${entityName}Action#save${entityCamelName}</Property>
      <UpdateItem>
        <Property name="dataSet">ds${entityCamelName}</Property>
      </UpdateItem>
    </UpdateAction>
    
    <#if subTables??>
		<#list subTables as sub>
		<#if sub.refType=="OneToMany">
    <Container layoutConstraint="bottom">
      <Property name="height">200</Property>
      <ToolBar>
        <DataPilot>
          <Property name="dataSet">ds${entityCamelName}</Property>
          <Property name="dataPath">#.${sub.entityName}List</Property>
        </DataPilot>
        <Separator/>
        <ToolBarButton>
          <ClientEvent name="onClick">var entity=view.get(&quot;#ds${entityCamelName}&quot;).getData(&quot;#&quot;);&#xD;
var list=entity.get(&quot;${sub.entityName}List&quot;);&#xD;
list.insert({&quot;${primaryKeyList[0].propertyName}&quot;:entity.get(&quot;${primaryKeyList[0].propertyName}&quot;)});&#xD;
view.get(&quot;#dlg${sub.entityCamelName}&quot;).show();&#xD;
</ClientEvent>
          <Property name="caption">新增</Property>
        </ToolBarButton>
        <ToolBarButton>
          <ClientEvent name="onClick">view.get(&quot;#dlg${sub.entityCamelName}&quot;).show();</ClientEvent>
          <Property name="caption">修改</Property>
        </ToolBarButton>
        <ToolBarButton>
          <ClientEvent name="onClick">dorado.MessageBox.confirm(&quot;确定要删除吗？&quot;,function(){&#xD;
	var selection=view.get(&quot;#dg${sub.entityCamelName}.selection&quot;);&#xD;
	selection.slice(0).each(function(e){&#xD;
		e.remove();&#xD;
	});&#xD;
	view.get(&quot;#actionSave&quot;).execute(function(){&#xD;
		dorado.MessageBox.alert(&quot;删除成功！&quot;);&#xD;
	});&#xD;
});&#xD;
</ClientEvent>
          <Property name="caption">删除</Property>
        </ToolBarButton>
      </ToolBar>
      <DataGrid id="dg${sub.entityCamelName}">
        <Property name="dataSet">ds${entityCamelName}</Property>
        <Property name="readOnly">true</Property>
        <Property name="selectionMode">multiRows</Property>
        <Property name="dataPath">#.${sub.entityName}List</Property>
        <RowSelectorColumn/>
        <#list sub.columns as col>
        <DataColumn name="${col.propertyName}">
          <Property name="property">${col.propertyName}</Property>
        </DataColumn>
        </#list>
      </DataGrid>
      <Dialog id="dlg${sub.entityCamelName}">
      	<Property name="width">400</Property>
      	<Property name="height">400</Property>
        <ClientEvent name="onClose">view.get(&quot;#ds${entityCamelName}&quot;).getData(&quot;#.${'#'}${sub.entityName}List&quot;).cancel();</ClientEvent>
        <Buttons>
          <Button>
            <ClientEvent name="onClick">view.get(&quot;#actionSave&quot;).execute(function(){&#xD;
	dorado.MessageBox.alert(&quot;保存成功！&quot;);&#xD;
	self.get(&quot;parent&quot;).close();&#xD;
});&#xD;
</ClientEvent>
            <Property name="caption">保存</Property>
          </Button>
          <Button>
            <ClientEvent name="onClick">self.get(&quot;parent&quot;).close();&#xD;
</ClientEvent>
            <Property name="caption">取消</Property>
          </Button>
        </Buttons>
        <Children>
          <AutoForm>
            <Property name="dataSet">ds${entityCamelName}</Property>
            <Property name="dataPath">#.#${sub.entityName}List</Property>
            <#list sub.columns as col>
            <AutoFormElement>
              <Property name="name">${col.propertyName}</Property>
              <Property name="property">${col.propertyName}</Property>
              <Editor/>
            </AutoFormElement>
            </#list>
          </AutoForm>
        </Children>
        <Tools/>
      </Dialog>
    </Container>
    </#if>
    </#list>
    </#if>
  </View>
</ViewConfig>
