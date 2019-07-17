<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
	<meta charset="utf-8" />
	<title>${caption!} 详情</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!-- Bootstrap 3.3.6 -->
	<link rel="stylesheet" href="/static/adminlte/bootstrap/css/bootstrap.min.css">
	<!-- Font Awesome -->
	<link rel="stylesheet" href="/static/adminlte/dist/css/font-awesome.min.css">
	<!-- Ionicons -->
	<link rel="stylesheet" href="/static/adminlte/dist/css/ionicons.min.css">
	<!-- DataTables -->
	<link rel="stylesheet" href="/static/adminlte/plugins/datatables/dataTables.bootstrap.css">
	<link rel="stylesheet" href="/static/adminlte/plugins/iCheck/all.css">

	<!-- Theme style -->
	<link rel="stylesheet" href="/static/adminlte/dist/css/AdminLTE.min.css">
	<!-- AdminLTE Skins. Choose a skin from the css/skins
	folder instead of downloading all of them to reduce the load. -->
	<link rel="stylesheet" href="/static/adminlte/dist/css/skins/all-skins.min.css">

	<!-- 树形结构 -->
	<link href="/static/jquery-treegrid-master/css/jquery.treegrid.css" rel="stylesheet" /> 
	<link href="/static/jquery-treegrid-master/css/treeclick.css" rel="stylesheet" />
	<!---->
	<link rel="stylesheet" href="/static/webContextMenu/css/web.contextmenu.css" />
	<!--bootstrap datepicker插件-->
	<link rel="stylesheet" href="/static/adminlte/plugins/datepicker/datepicker3.css">
	<link rel="stylesheet" href="/static/adminlte/plugins/datetimepicker/datetimepicker.css">
	<!-- 图标扩充-->
	<link rel="stylesheet" href="/static/style/icon/icon.css" />
	<link rel="stylesheet" href="/static/webuploader/webuploader.css" />

	<link rel="stylesheet" href="/static/common.css">
	
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="/static/adminlte/plugins/ie9/html5shiv.min.js"></script>
	<script src="/static/adminlte/plugins/ie9/respond.min.js"></script>
	<![endif]-->
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
				<!-- 以下是明细 -->
				<#if subTables??>
				<#list subTables as subTable>
				<div class="box">
		            <div class="box-header">
		              <h3 class="box-title">${subTable.caption} 列表</h3>
		            </div>
		            <!-- /.box-header -->
		            <div class="box-body no-padding">
		              <table class="table table-bordered table-hover" id="table_${subTable.entityName}">
		                
		              </table>
		            </div>
		            <!-- /.box-body -->
		          </div>
		          <!-- /.box -->
		        </#list>
		        </#if>
			</section>
		</div>
	</div>
	
	<!-- jQuery 2.2.3 -->
	<script src="/static/adminlte/plugins/jQuery/jquery-3.3.1.js"></script>
	<script src="/static/adminlte/plugins/jQueryUI/jquery-ui.min.js"></script>
	<script src="/static/jqplugins/jquery.tmpl.js"></script>
	<script src="/static/bootstrapValidator.min.js"></script>
	<!-- Bootstrap 3.3.6 -->
	<script src="/static/adminlte/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- iCheck 1.0.1 -->
	<script src="/static/adminlte/plugins/iCheck/icheck.min.js"></script>
	
	<script src="/static/adminlte/plugins/datatables/jquery.dataTables.min.js"></script>
	<script src="/static/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
	
	<!-- AdminLTE App -->
	<script src="/static/adminlte/dist/js/app.min.js"></script>
	<!-- AdminLTE for demo purposes -->
	<script src="/static/adminlte/dist/js/demo.js"></script>
	
	<!--bootstrap datepicker插件 -->
	<script src="/static/adminlte/plugins/datepicker/bootstrap-datepicker.js"></script>
	<script src="/static/adminlte/plugins/datepicker/locales/bootstrap-datepicker.zh-CN.js"></script>
	<script src="/static/adminlte/plugins/daterangepicker/moment.min.js"></script>
	<script src="/static/adminlte/plugins/datetimepicker/datetimepicker.js"></script>
	<!-- 消息弹出框 -->
	<script src="/static/adminlte/bootbox/bootbox.min.js"></script>
	
	<script src="/static/bootstrap-treeview.js"></script>
	<script src="/static/toastr/toastr.min.js"></script>
	
	<!-- 文件上传 -->
	<script src="/static/webuploader/webuploader.js"></script>
	<!-- 文本编辑框插件 -->
	<!--日期插件 -->
	<script src="/static/dateformat.js"></script>
	<script src="/static/common.js"></script>
	
	<script language="javascript" src="/static/tabs.js"></script>
	<script language="javascript" src="/static/topDialog.js"></script>
	<script>
	var URL_DATA="/${moduleName}/${entityName}/ajax/load${entityCamelName}";
	var keyProperties=[<#list primaryKeyList as col><#if col_index!=0>,</#if>"${col.propertyName}"</#list>];
	<#if subTables??>
		<#list subTables as subTable>
	URL_LIST["${subTable.entityName}"]="/${moduleName}/${subTable.entityName}/ajax/load${subTable.entityCamelName}List";
	URL_DELETE["${subTable.entityName}"]="/${moduleName}/${subTable.entityName}/ajax/updateState";
		</#list>
	</#if>
	
	var columns={
	<#if subTables??>
		<#list subTables as subTable>
		"table_${subTable.entityName}":[
			<#if subTable.columns??>
			<#list subTable.columns as col>
	        {"data": "${col.propertyName!}","title":"${col.caption!}","orderable":true,"name":"${col.propertyName!}","editable":false <#if col.dictKey??>,"dictKey":"${col.dictKey!}","editorType":"${col.editorType!}"</#if>},
	        </#list>
	        </#if>
		],
		</#list>
	</#if>
	};
	var columnDefs={
	<#if subTables??>
		<#list subTables as subTable>
		"table_${subTable.entityName}":[],
		</#list>
	</#if>
	}
	
	$(document).ready(function(){
 		loadDicts(null,function(){
 			reloadNodeData({params:UrlParm.params()});
 			
 			<#if subTables??>
			<#list subTables as subTable>
			window["tables_${subTable.entityName}"] = loadData("table_${subTable.entityName}",{serverSide:false, paging:false, showFooter: false,autoWidth: false, ordering:false, columns:columns["table_${subTable.entityName}"],columnDefs:columnDefs["table_${subTable.entityName}"],params:UrlParm.params().id});
			</#list>
			</#if>
 		});
 	});
	</script>
</body>
<!--/Body -->
</html>
