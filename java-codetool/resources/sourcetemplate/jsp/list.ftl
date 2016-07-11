<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
    <meta charset="utf-8" />
	<title>红航后台管理系统</title>

	<meta name="description" content="公告列表" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="shortcut icon" href="${contextPath}/public/page/images/ico/redair_favicon.ico">

   	<jsp:include page="../../common/css.jsp" />
    <!-- dataTables -->
    <link href="${contextPath}/public/plugins/assets/css/dataTables.bootstrap.css" rel="stylesheet" />

    <!--Skin Script: Place this script in head to load scripts for skins and rtl support-->
    <script src="${contextPath}/public/plugins/assets/js/skins.min.js"></script>
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
                            <a href="${contextPath}/index">主页</a>
                        </li>
                        <li class="active">${remark!}管理</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Header -->
                <div class="page-header position-relative">
                    <div class="header-title">
                    	<form action="${contextPath}/goods/list${entityCamelName}" method="get">
                        <a class="btn btn-info" href="${contextPath}/goods/list${entityCamelName}?${primaryProperty }=${param.primaryProperty}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-search"></i> 所有列表</a>
                        <a class="btn btn-primary" href="${contextPath}/goods/toAdd${entityCamelName}?${primaryProperty}=${param.primaryProperty}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-plus"></i> 添加</a>
                        </form>
                    </div>
                </div>
                <!-- /Page Header -->
                <!-- Page Body -->
                <div class="page-body">
                    <div class="row">
                        <div class="col-xs-12 col-md-12">
                            <div class="widget">
                                <div class="widget-body no-padding">
                                	<!-- 
                                	<table class="table table-bordered table-hover table-striped" id="searchable">
                                	-->
                                    <table class="table table-bordered table-hover table-striped">
                                        <thead class="bordered-darkorange">
                                            <tr role="row">
	                                        <#if columns??>
												<#list columns as col>
                                                <th>${col.remark!}</th>
	                                            </#list>
	                                        </#if>
                                                <th>操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${'$'}{paging.entities}" var="restrict" varStatus="idx">
	                                            <tr>
	                                             <#if columns??>
													<#list columns as col>
	                                            	<td>${'$'}{${entityName}.${col.propertyName}</td>
	                                            	</#list>
	                                             </#if>
	                                                <td align="center">
	                                                	<a href="${contextPath}/goods/remove${entityCamelName}?${primaryProperty}=${'$'}{${entityName}.${primaryProperty}}" target="_self" class="btn btn-danger btn-xs lock"><i class="fa fa-lock"></i> 删除</a>
	                                                	<a href="${contextPath}/goods/toEdit${entityCamelName}?${primaryProperty}=${'$'}{${entityName}.${primaryProperty}}" target="_self" class="btn btn-info btn-xs edit"><i class="fa fa-edit"></i> 编辑</a>
	                                                </td>
	                                            </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /Page Body -->
            </div>
            <!-- /Page Content -->
        <!-- /Page Container -->
        <!-- Main Container -->
    </div>

   	<jsp:include page="../../common/js.jsp" />

    <!--Page Related Scripts-->
    <script src="${contextPath}/public/plugins/assets/js/datatable/jquery.dataTables.min.js"></script>
    <script src="${contextPath}/public/plugins/assets/js/datatable/ZeroClipboard.js"></script>
    <script src="${contextPath}/public/plugins/assets/js/datatable/dataTables.tableTools.min.js"></script>
    <script src="${contextPath}/public/plugins/assets/js/datatable/dataTables.bootstrap.min.js"></script>
    <script src="${contextPath}/public/plugins/assets/js/datatable/datatables-init.js"></script>
    <script>
        InitiateSearchableDataTable.init();
    </script>
</body>
<!--  /Body -->
</html>
