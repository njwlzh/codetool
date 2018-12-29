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
                        <li class="active">修改${remark!}</li>
                    </ul>
                </div>
                <!-- /Page Breadcrumb -->
                <!-- Page Header -->
                <div class="page-header position-relative">
                    <div class="header-title" style="padding: 3px;">
                    	<a href="${"$"}{contextPath}/${moduleName}/${entityName}/toList${entityCamelName}" class="btn btn-info"><span class="fa fa-chevron-left"></span>返回</a>
					</div>
                </div>
                <!-- /Page Header -->
                <!-- Page Body -->
                <div class="page-body">
                    <div class="row">
                        <div>
                            <div class="widget radius-bordered">
                                <div class="widget-body">
                                    <form id="formData" class="form-horizontal" onsubmit="return false">
                                        <#list primaryKeyList as col>
                                        <input type="hidden" name="${col.propertyName}" value=""/>
                                        </#list>
                                        <div class="form-title"></div>
                                        <#if columns??>
										<#list columns as col>
											<#if !col.primaryKey>
	                                        <div class="form-group">
	                                            <label class="col-md-2 col-sm-2 control-label">${col.remark!}${(col.nullable)?string('','(*)')}</label>
	                                            <div class="col-md-6 col-sm-6">
	                                            	<#if col.length gt 100>
	                                            	<textarea class="form-control" name="${col.propertyName}" ${(col.nullable)?string('','require')} disabled></textarea>
	                                            	<#else>
	                                                <input type="text" class="form-control ${(col.propertyType?index_of('Date')!=-1)?string('datepicker','')}" name="${col.propertyName}" value="" placeholder="请输入${col.remark!}" ${(col.nullable)?string('','require')} disabled/>
	                                            	</#if>
	                                            </div>
	                                        </div>
	                                        </#if>
                                        </#list>
                                        </#if>
                                        <div class="form-title"></div>
                                        
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
        
        $(document).ready(function(){
       		$('.datepicker').datepicker({
       			format: 'yyyy-mm-dd',
       			weekStart: 1
       		});
       		
       		//加载数据
       		$.ajax({
       			url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/load${entityCamelName}",
       			data:{<#list primaryKeyList as col>${col.propertyName}:"${"$"}{param.${col.propertyName}}"</#list>},
       			success:function(res){
        			if (res.state==0){
        				fillFormData(res.data);
        			} else {
        				alert(res.message);
        			}
        		},
        		error:function(error){
        			alert(error);
        		}
       		});
       	});
    </script>
</body>
<!--  /Body -->
</html>
