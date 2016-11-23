<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${"$"}{pageContext.request.contextPath}" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
    <meta charset="utf-8" />
	<title>后台管理系统</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <jsp:include page="../common/css.jsp" />
</head>
<!-- /Head -->
<!-- Body -->
<body>
    <!-- Main Container -->
    <div class="main-container container-fluid">
        <!-- Page Container -->
        <div class="page-container">
                <!-- Page Breadcrumb -->
                <div class="page-breadcrumbs">
                    <ul class="breadcrumb">
                        <li>
                            <i class="fa fa-home"></i>
                            <a href="${"$"}{contextPath}/index">主页</a>
                        </li>
                        <li class="active">修改${remark!}</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Header -->
                <div class="page-header position-relative">
                    <div class="header-title" style="padding: 3px;">
                    	<a href="${"$"}{contextPath}/${moduleName}/list${entityCamelName}" class="btn btn-info"><span class="fa fa-chevron-left"></span>返回</a>
					</div>
                </div>
                <!-- /Page Header -->
                <!-- Page Body -->
                <div class="page-body">
                    <div class="row">
                        <div>
                            <div class="widget radius-bordered">
                                <div class="widget-body">
                                    <form action="${"$"}{contextPath}/${moduleName}/update${entityCamelName}" method="post" class="form-horizontal" onsubmit="return checkForm()">
                                        <input type="hidden" name="${primaryProperty}" value="${'$'}{${entityName}.${primaryProperty}}"/>
                                        <div class="form-title"></div>
                                        <#if columns??>
										<#list columns as col>
                                        <div class="form-group">
                                            <label class="col-md-2 col-sm-2 control-label">${col.remark!}</label>
                                            <div class="col-md-6 col-sm-6">
                                            	<#if col.length gt 100>
                                            	<textarea class="form-control" name="${col.propertyName}" ${(col.nullable)?string('','require')}>${'$'}{${entityName}.${col.propertyName}}</textarea>
                                            	<#else>
                                                <input type="text" class="form-control" name="${col.propertyName}" value="${'$'}{${entityName}.${col.propertyName}}" placeholder="请输入${col.remark!}" ${(col.nullable)?string('','require')} />
                                            	</#if>
                                            </div>
                                        </div>
                                        </#list>
                                        </#if>
                                        <div class="form-title"></div>
                                        
                                        <div class="form-group">
                                            <label class="col-sm-2"></label>
                                            <div class="col-sm-offset-1 col-sm-8">
                                                <input class="btn btn-primary shiny" type="submit" value="&nbsp;保存&nbsp;" />
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /Page Body -->
            <!-- /Page Content -->
        </div>
        <!-- /Page Container -->
        <!-- Main Container -->
    </div>
    <%@include file="../common/admin_js.jsp" %>
	<script>
        function checkForm(){
        	var inputs=$(":text,select,textarea");
        	var isok=true;
        	var msg=[];
        	$.each(inputs,function(i,obj){
        		var $obj=$(obj);
        		var val=$.trim($obj.val());
        		var require=typeof($obj.attr("require"))!="undefined";
        		if (require && val==""){
        			isok=false;
        			var label=$obj.parent().parent().find(".control-label").html();
        			if (label){
	        			label=label.replace(/[:：]/g,"");
	        			msg.push(label+"不能为空");
        			}
        		}
        	});
        	if (!isok) {
        		alert(msg.join("\n"));
        	}
        	return isok;
        }
    </script>
</body>
<!--  /Body -->
</html>
