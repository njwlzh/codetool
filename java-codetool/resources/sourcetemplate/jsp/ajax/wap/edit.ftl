<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../common/jstl.jsp" %>
<!doctype html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
		<meta name="format-detection" content="telephone=yes"/>
		<title>修改${caption!}</title>
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
			<h1 class="mui-title">修改${caption!}</h1>
		</header>
		
		<div class="mui-content">
			<form id="formData" class="mui-input-group">
			<#list primaryKeyList as col>
			<input type="hidden" name="${col.propertyName}">
			</#list>
				<#if columns??>
					<div class=" mui-content-padded">
					<#list columns as col>
						<div class="mui-input-row">
							<label>${col.caption!}</label>
							<#if col.dictKey??>
							<span class="value" property="${col.propertyName}" type="${col.editorType?default('select')}" role="dict" dictKey="${col.dictKey!}" defaultValue="${col.defaultValue!}"></span>
							<#else>
								<#if col.length lte 100>
								<input type="text" class="form-control ${(col.propertyType?index_of('Date')!=-1)?string('datepicker','')}" name="${col.propertyName}" value="${col.defaultValue!}" placeholder="请输入${col.caption!}" autocomplete="off" ${(col.nullable)?string('','require')}/>
								<#else>
								<textarea class="form-control" name="${col.propertyName}" value="${col.defaultValue!}" placeholder="请输入${col.caption!}" autocomplete="off" ${(col.nullable)?string('','require')}></textarea>
								</#if>
							</#if>
						</div>
					</#list>
					</div>
				</#if>
				<div class="mui-row mui-text-center" style="padding-bottom:60px;">
					<a class="mui-btn mui-btn-primary" id="btnSave" style="font-size:16px;margin-bottom:20px;">
						<i class="mui-icon mui-icon-checkmarkempty"></i>
						<span>保存</span>
					</a>
				</div>
			</form>
		</div>
		<script src="/static/common/jquery.min.js"></script>
		<script src="/static/common/jquery.tmpl.js"></script>
		<script src="/static/wap/mui/js/mui.js"></script>
		<script src="/static/wap/mui/js/mui.picker.min.js"></script>
		<script src="/static/wap/mui/js/mui.poppicker.js"></script>
		<script src="/static/wap/common.js"></script>
		<script type="text/javascript">
		var URL_ENTITY="/${moduleName}/${entityName}/ajax/load${entityCamelName}";
		var URL_LIST="/${moduleName}/${entityName}/toList${entityCamelName}";
		var URL_SAVE="/${moduleName}/${entityName}/ajax/update${entityCamelName}";
		$(document).ready(function(){

			$("#btnSave").on("tap",function(){
				showProgress("正在保存数据......");
				var chkRes = checkForm("#formData");
				if (!chkRes.state){
					mui.alert(chkRes.msg.join("<br>"));
					return;
				}
				var data=$("#formData").serialize();
				$.ajax({
					url: URL_SAVE,
					data:data,
					type:"post",
					success:function(res){
						if (res.state==0){
							mui.alert("保存成功！",function(){
								location.href=URL_LIST;
							});
						} else {
							mui.alert(res.message);
							hideProgress();
						}
					},
					error:function(){
						hideProgress();
						mui.alert("系统错误，请联系管理员！"+arguments[0].statusText);
					}
				});
			});
			loadDicts(null,function(){
				reloadFormData({params:UrlParm.params()});
			});
		});
		
		</script>
	</body>
</html>
