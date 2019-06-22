<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/jstl.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
    <meta charset="utf-8" />
	<title>后台管理系统</title>

	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

   	<%@include file="../common/admin_css.jsp" %>
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
                        <li class="active">${caption!}管理</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Header -->
                <div class="page-header position-relative">
                    <div class="header-title">
                    	<form action="${"$"}{contextPath}/${moduleName}/list${entityCamelName}" method="get">
                        <a class="btn btn-info" href="${"$"}{contextPath}/${moduleName}/list${entityCamelName}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-search"></i> 所有列表</a>
                        <a class="btn btn-primary" href="${"$"}{contextPath}/${moduleName}/toAdd${entityCamelName}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-plus"></i> 添加</a>
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
                                    <table class="table table-bordered table-hover table-striped">
                                        <thead class="bordered-darkorange">
                                            <tr role="row">
	                                        <#if columns??>
												<#list columns as col>
                                                <th>${col.caption!}</th>
	                                            </#list>
	                                        </#if>
                                                <th>操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${'$'}{paging.entities}" var="${entityName}" varStatus="idx">
	                                            <tr>
	                                             <#if columns??>
													<#list columns as col>
	                                            	<td>${'$'}{${entityName}.${col.propertyName}}</td>
	                                            	</#list>
	                                             </#if>
	                                                <td align="center">
	                                                	<a href="${"$"}{contextPath}/${moduleName}/updateState?<#list primaryKeyList as col><#if col_index gt 0>&</#if>${col.propertyName}=${'$'}{${entityName}.${col.propertyName}}</#list>&state=2" target="_self" class="btn btn-danger btn-xs lock"><i class="fa fa-lock"></i>禁用</a>
	                                                	<a href="${"$"}{contextPath}/${moduleName}/toEdit${entityCamelName}?<#list primaryKeyList as col><#if col_index gt 0>&</#if>${col.propertyName}=${'$'}{${entityName}.${col.propertyName}}</#list>" target="_self" class="btn btn-info btn-xs edit"><i class="fa fa-edit"></i>编辑</a>
	                                                </td>
	                                            </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    
                                    <div class="row DTTTFooter">
					                	<div class="col-sm-6">
					                		<div aria-live="polite" role="status" id="simpledatatable_info" class="dataTables_info">共${"$"}{paging.pageCount}页-- ${"$"}{paging.entityCount }条数据</div></div>
					                		<div class="col-sm-6">
					                			<div id="simpledatatable_paginate" class="dataTables_paginate paging_bootstrap">
									             	<c:set var="currentPage" value="${"$"}{paging.pageNo}" />
													<c:set var="totalPage" value="${"$"}{paging.pageCount}" />
													<c:set var="actionUrl" value="${"$"}{contextPath }/${moduleName}/list${entityCamelName}?page=" />
													<c:set var="urlParas" value="${"$"}{urlSearch}" />
					                				<%@include file="../common/paginate.jsp" %>
					                			</div>
					                		</div>
				                	</div>
				                	
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

   	<%@include file="../common/admin_js.jsp" %>
    <script>
        InitiateSearchableDataTable.init();
    </script>
</body>
<!--  /Body -->
</html>
