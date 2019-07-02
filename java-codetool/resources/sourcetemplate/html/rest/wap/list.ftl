<!doctype html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
		<meta name="format-detection" content="telephone=yes"/>
		<title>${caption!}管理</title>
		<link href="/static/wap/mui/css/mui.min.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/icons-extra.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/iconfont.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/mui.picker.min.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/mui.poppicker.css" rel="stylesheet" />
		<link href="/static/wap/common.css" rel="stylesheet" />
	</head>
<body>
	<header class="mui-bar mui-bar-nav" style="max-width: 720px; margin: 0 auto;">
		<a class="mui-icon mui-icon-left-nav mui-pull-left mui-action-back"></a>
		<h1 class="mui-title">${caption!}管理</h1>
		<a class="mui-pull-right mui-action-menu mui-icon mui-icon-list" href="#menuPopover"></a>
	</header>
	<div class="mui-content">
		<div id="pullrefresh_Main" class="mui-scroll-wrapper main-list">
			<div class="mui-scroll">
				<ul class="mui-table-view mui-table-view-chevron" id="ulListBox_Main">
				</ul>
				
			</div>
		</div>	
	</div>
	<!--右上角弹出菜单-->
	<div id="menuPopover" class="mui-popover" style="height:110px;">
		<div class="mui-scroll-wrapper" style="margin-top:0">
			<div class="mui-scroll">
				<ul class="mui-table-view">
					<li class="mui-table-view-cell">
						<a href="javascript:void(0);" id="menuAdd"><i class="mui-icon mui-icon-plus"></i> 添加</a>
					</li>
					<li class="mui-table-view-cell">
						<a href="#dlgShowSearch"><i class="text-orange mui-icon mui-icon-search"></i> 查询</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- 菜单 end -->
	<!-- 显示查询弹窗 -->
	<div id="dlgShowSearch" class="mui-popover mui-popover-bottom mui-popover-action" style="height:550px;max-height:550px;background:#efefef;top:45px;overflow-y:auto;">
		<div class="mui-bar mui-bar-nav">
			<a class="mui-icon mui-icon-close mui-pull-right" href="#dlgShowSearch"></a>
			<h1 class="mui-title">查询${caption!}</h1>
		</div>
		<form id="formQuery" style="margin-top:50px;">
			<div class="searchBox" style="overflow-y:auto;height:450px;">
			<#if columns??>
				<#list columns as col>
				<#if col.length lte 100>
				<div class="mui-input-row">
					<label>${col.caption!}</label>
					<#if col.dictKey??>
					<span class="value" property="${col.propertyName}" type="${col.editorType?default('select')}" role="dict" dictKey="${col.dictKey!}" defaultValue="${col.defaultValue!}"></span>
					<#else>
					<input type="text" class="form-control ${(col.propertyType?index_of('Date')!=-1)?string('datepicker','')}" name="${col.propertyName}" value="${col.defaultValue!}" placeholder="请输入${col.caption!}" autocomplete="off"/>
					</#if>
				</div>
				</#if>
				</#list>
			</#if>
			</div>
 			<div class="mui-row mui-text-center" style="padding:10px;">
				<button id="btnSearch" type="button" class="mui-btn mui-btn-primary" >查询</button>
				<button id="btnSearchReset" type="button" class="mui-btn mui-btn-default" >重置</button>
			</div>
		</form>
	</div>
	<!-- 查询end -->
	<!--列表项模板-->
	<script type="text/html" id="itemTmpl_Main">
	<li class="mui-table-view-cell mui-media">
		<div class="mui-slider-right">
			<a class="mui-btn mui-btn-danger btn-edit" <#list primaryKeyList as col>${col.propertyName}="${"$"}{${col.propertyName!}}"</#list>>修改</a>
			<a class="mui-btn mui-btn-danger btn-delete" <#list primaryKeyList as col>${col.propertyName}="${"$"}{${col.propertyName!}}"</#list>>删除</a>
		</div>
		<div class="mui-slider-handle data-item" <#list primaryKeyList as col>${col.propertyName}="${"$"}{${col.propertyName!}}"</#list>>
			<span class="mui-pull-left">
				<#list columns as col>
				<span class="mui-ellipsis mui-block">${col.caption!}：<span property="${col.propertyName}" <#if col.dictKey?default("")?trim?length gt 0>dictKey="${col.dictKey!}"</#if> >${"$"}{${col.propertyName!}}</span></span>
				</#list>
			</span>
		</div>
	</li>
	</script>

	<script src="/static/common/jquery.min.js"></script>
	<script src="/static/common/jquery.tmpl.js"></script>
	<script src="/static/wap/mui/js/mui.js"></script>
	<script src="/static/wap/mui/js/mui.picker.min.js"></script>
	<script src="/static/wap/mui/js/mui.poppicker.js"></script>
	<script src="/static/wap/common.js"></script>
	<script type="text/javascript">
	var keyProperties=[<#list primaryKeyList as col><#if col_index!=0>,</#if>"${col.propertyName}"</#list>];
	var URL_ADD="/html/${moduleName}/${entityName}/add${entityCamelName}.html";
	var URL_EDIT="/html/${moduleName}/${entityName}/edit${entityCamelName}.html";
	var URL_DELETE="/${moduleName}/${entityName}/ajax/updateState";
	var URL_SHOW="/html/${moduleName}/${entityName}/show${entityCamelName}.html";
	var URL_LIST="/${moduleName}/${entityName}/ajax/load${entityCamelName}List";
	var URL_ENTITY="/${moduleName}/${entityName}/ajax/load${entityCamelName}";
	var page=1,pageSize=10;
	//默认数据渲染对象标识：主列表
	var defaultDataTargetFlag = "Main";
    
    $(document).ready(function(){
    	initListBox(defaultDataTargetFlag);
    	loadDicts(null,function(){
    		reloadListData(defaultDataTargetFlag);
    	});

    });
    </script>
</body>
<!--  /Body -->
</html>
