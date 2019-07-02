<!doctype html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
		<meta name="format-detection" content="telephone=yes"/>
		<title>${caption!}详情</title>
		<link href="/static/wap/mui/css/mui.min.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/icons-extra.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/iconfont.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/mui.picker.min.css" rel="stylesheet" />
		<link href="/static/wap/mui/css/mui.poppicker.css" rel="stylesheet" />
		<link href="/static/wap/common.css" rel="stylesheet" />
	</head>

	<body>
		<header class="mui-bar mui-bar-nav">
			<a class="mui-icon mui-icon-left-nav mui-pull-left mui-action-back"></a>
			<h1 class="mui-title">${caption!}详情</h1>
		</header>
		
		<div class="mui-content" style="margin-bottom:30px;">
			<#if columns??>
				<div class=" mui-content-padded">
					<form id="formData" class="mui-input-group">
					<#list columns as col>
						<#if col.length lte 100>
						<div class="mui-input-row">
							<label>${col.caption!}</label>
							<span class="value" property="${col.propertyName}" <#if col.dictKey?default("")?trim?length gt 0>dictKey="${col.dictKey!}"</#if> ></span>
						</div>
						</#if>
					</#list>
					</form>
				</div>
			</#if>
		</div>
		<script src="/static/common/jquery.min.js"></script>
		<script src="/static/common/jquery.tmpl.js"></script>
		<script src="/static/wap/mui/js/mui.js"></script>
		<script src="/static/wap/mui/js/mui.picker.min.js"></script>
		<script src="/static/wap/mui/js/mui.poppicker.js"></script>
		<script src="/static/wap/common.js"></script>
		<script type="text/javascript">
		var URL_ENTITY="/${moduleName}/${entityName}/ajax/load${entityCamelName}";
		var URL_LIST="/html/${moduleName}/${entityName}/list${entityCamelName}";
		$(document).ready(function(){
			loadDictsForShow(null,function(){
				reloadNodeData(UrlParm.params());
	    	});
		});
		
		</script>
	</body>
</html>
