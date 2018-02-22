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
                        <li class="active">${remark!}管理</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Header -->
                <div class="page-header position-relative">
                    <div class="header-title">
                        <a class="btn btn-info" href="${"$"}{contextPath}/${moduleName}/${entityName}/toList${entityCamelName}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-search"></i> 所有列表</a>
                        <a class="btn btn-primary" href="${"$"}{contextPath}/${moduleName}/${entityName}/toAdd${entityCamelName}" style="margin-top:5px;margin-left:10px;"><i class="fa fa-plus"></i> 添加</a>
                    </div>
                </div>
                <!-- /Page Header -->
                <!-- Page Body -->
                <div class="page-body">
                    <div class="row">
                        <div class="col-xs-12 col-md-12">
                            <div class="widget">
                                <div class="widget-body no-padding">
                                    <table id="tbList" class="table table-bordered table-hover table-striped">
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
                                        </tbody>
                                    </table>
                                    <#--
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
				                	--#>
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
	<script id="itemTmpl" type="text/html">
		<tr>
         <#if columns??>
			<#list columns as col>
        	<td>${'$'}{${col.propertyName}}</td>
        	</#list>
         </#if>
            <td align="center">
            	<a <#list primaryKeyList as col> ${col.propertyName}="${'$'}{${col.propertyName}}"</#list> class="btn btn-danger btn-xs lock btnDelete"><i class="fa fa-lock"></i>禁用</a>
            	<a class="btn btnEdit" href="${"$"}{contextPath}/${moduleName}/${entityName}/toEdit${entityCamelName}?<#list primaryKeyList as col><#if col_index gt 0>&</#if>${col.propertyName}=${'$'}{${col.propertyName}}</#list>" target="_self" class="btn btn-info btn-xs edit"><i class="fa fa-edit"></i>编辑</a>
            </td>
        </tr>
	</script>
   	<%@include file="../common/admin_js.jsp" %>
    <script>
    function loadData(){
    	var data={page:1};
    	$.ajax({
    		url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/load${entityCamelName}List",
    		data:data,
    		success:function(res){
    			if (res.state=0){
    				var $box=$("#tbList").find("tbody").empty();
    				$("#itemTmpl").tmpl(res.data.entities).appendTo($box);
    			}
    		}
    	});
    }
    
    function updateState(<#list primaryKeyList as col><#if col_index gt 0>,</#if>${col.propertyName}</#list>){
    	var data={<#list primaryKeyList as col><#if col_index gt 0>,</#if>${col.propertyName}</#list>,state:2};
    	$.ajax({
    		url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/updateState",
    		data:data,
    		success:function(res){
    			if (res.state==0){
    				reloadData();
    			} else {
    				alert(res.message);
    			}
    		}
    	});
    }
    
    $(document).ready(function(){
    	$(document).on("click",".btnDelete",function(){
    		var $btn=$(this);
    		updateState(<#list primaryKeyList as col><#if col_index gt 0>,</#if>$btn.attr("${col.propertyName}")</#list>);
    	});
    });
    </script>
</body>
<!--  /Body -->
</html>
