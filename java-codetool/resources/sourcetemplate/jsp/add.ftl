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
	<link rel="shortcut icon" href="${"$"}{contextPath}/public/page/images/ico/redair_favicon.ico">

    <jsp:include page="../../common/css.jsp" />

    <!--Skin Script: Place this script in head to load scripts for skins and rtl support-->
    <script src="${"$"}{contextPath}/public/plugins/assets/js/skins.min.js"></script>
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
                        <li class="active">增加${remark!}</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Body -->
                <div class="page-body">
                    <div class="row">
                        <div>
                            <div class="widget radius-bordered">
                                <div class="widget-body">
                                    <form id="updateForm" action="${"$"}{contextPath}/${moduleName}/save${entityCamelName}" method="post" class="form-horizontal">
                                        <div class="form-title"></div>
                                        <#if columns??>
										<#list columns as col>
                                        <div class="form-group">
                                            <label class="col-sm-2 control-label">${col.remark!}</label>
                                            <div class="col-sm-6">
                                                <input type="text" class="form-control" name="${col.propertyName}" value="" placeholder="请输入${col.remark!}" />
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

</body>
<!--  /Body -->
</html>
