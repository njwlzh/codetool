<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../common/jstl.jsp"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
	<meta charset="utf-8" />
	<title>${caption!}详情</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="../../common/admin_css.jsp"%>
	<style>
	section.content{margin-top:0px;}
	.form-title{background:#dfd;padding-left:5px;}
	.prop-value{padding-top:7px;}
	</style>
</head>
<!-- /Head -->
<!-- Body -->
<body>
	<!-- Main Container -->
	<div class="wraper">
		<div class="">
			<!-- Main content -->
			<section class="content">
				<div class="box">
					<div class="box-body">
						<form id="formData" class="form-horizontal" onsubmit="return checkForm()">
                        <#if columns??>
						<#list columns as col>
							<#if !col.primaryKey>
                            <div class="form-group">
                                <label class="col-lg-2 col-md-2 col-sm-4 control-label">${col.caption!}${(col.nullable)?string('','(*)')}</label>
                                <div class="col-lg-9 col-md-9 col-sm-7 prop-value" property="${col.propertyName}">
                                </div>
                            </div>
                            </#if>
                        </#list>
                        </#if>
                        </form>
                     </div>
				<!-- /box -->
				</div>
			</section>
		</div>
	</div>
	
	<%@include file="../../common/admin_js.jsp"%>
	<script>
        //加载主体数据
		function reloadData(){
			$.ajax({
	   			url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/load${entityCamelName}",
	   			data:{<#list primaryKeyList as col><#if col_index!=0>,</#if>${col.propertyName}:"${"$"}{fn:escapeXml(param.${col.propertyName})}"</#list>},
	   			success:function(res){
	    			if (res.state==0){
	    				fillNodeData(res.data);
	    			} else {
	    				alert(res.message);
	    			}
    				hideLoading();
	    		},
	    		error:function(error){
	    			alert(error);
	    		}
	   		});
		}
        
        $(document).ready(function(){
       		reloadData();
       	});
    </script>
</body>
<!--  /Body -->
</html>
