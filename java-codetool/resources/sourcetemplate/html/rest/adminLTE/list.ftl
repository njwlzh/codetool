<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
	<meta charset="utf-8" />
	<title>查询${remark}</title>
	
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

	<link rel="stylesheet" href="/static/mycss/common.css">
	<link rel="stylesheet" href="/static/toastr/toastr.min.css">
	
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
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<div id="filterBoxId" class="form-horizontal" >
					<div class="row">
						<!-- 左侧搜索框 -->
						<div class="pull-left" style="padding-left: 14px;">
							<button id="btn_filter" type="button" style="margin-right:5px;" class="btn btn-default btn-sm" data-t2mFilterBox="t2m_filter">筛选 <i class="fa fa-caret-right"></i></button>
							<div class="input-group input-group-sm pull-right" id="searchBox" style="width:180px;">
								<input type="text" class="form-control input-search" id="keyword" placeholder="根据名称进行搜索">
								<span class="input-group-addon" class="btn btn-flat" id="btnSearch"><i class="fa fa-search"></i></span>
							 </div>
						</div>
						<!--右侧按钮组 -->
						<div class="pull-right" style="padding-right: 15px;">
							<a href="javascript:showAddMainInfo();" class="btn btn-primary btn-sm"><i class="fa fa-plus"></i> 添加</a>
						</div>
					</div>
				</div>
			</section>
			<!-- Main content -->
			<section class="content">
				<div class="box">
					<table id="tableMain" class="table table-bordered table-hover table-striped">
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
				</div>
				<!-- /box -->
			</section>
	</div>
	<form id="formQuery" class="form-horizontal" onsubmit="return false" style=" padding:20px 30px 0 30px;display:none;">
	<#if columns??>
		<#list columns as col>
		<div class="form-group">
			<label class="col-md-4 col-sm-4">${col.remark!}</label>
			<div class="col-md-8 col-sm-8">
				<input type="text" class="form-control" name="${col.propertyName!}">
			</div>
		</div>
		</#list>
	</#if>
		<div class="form-group">
			<div class="pull-right" style="padding-right: 20px;">
				<a id="btnFormQuery" class="btn btn-primary btn-sm">确定</a>
				<a id="btnFormReset" class="btn btn-primary btn-sm">重置</a>
			</div>
		</div>
	
	</form>
	
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
	
	<script src="/static/adminlte/plugins/datatables/extensions/ColReorder/js/dataTables.colReorder.min.js"></script>
    <link rel="stylesheet" href="/static/adminlte/plugins/datatables/extensions/ColReorder//css/dataTables.colReorder.min.css">
	
	<script src="/static/adminlte/plugins/datatables/extensions/select/js/dataTables.select.min.js"></script>
    <link rel="stylesheet" href="/static/adminlte/plugins/datatables/extensions/select/css/select.bootstrap.min.css">
	 
    <link rel="stylesheet" href="/static/adminlte/plugins/datatables/extensions/FixedColumns/css/dataTables.fixedColumns.min.css">
	<script src="/static/adminlte/plugins/datatables/extensions/FixedColumns/js/dataTables.fixedColumns.min.js"></script>
	
	<script src="/static/adminlte/plugins/datatables/extensions/colresizable/js/dataTables.colResize.js"></script>
	
	<script src="/static/bootstrap-treeview.js"></script>
	<script src="/static/toastr/toastr.min.js"></script>
	
	<!-- 文件上传 -->
	<script src="/static/webuploader/webuploader.js"></script>
	<!-- 文本编辑框插件 -->
	<!--日期插件 -->
	<script src="/static/dateformat.js"></script>
	<script src="/static/validate.js"></script>
	<script src="/static/common.js"></script>
	<script type="text/javascript">
	var keyProperties=[<#list primaryKeyList as col><#if col_index!=0>,</#if>"${col.propertyName}"</#list>];
	var URL_ADD="/${moduleName}/${entityName}/toAdd${entityCamelName}";
	var URL_EDIT="/${moduleName}/${entityName}/toEdit${entityCamelName}";
	var URL_DELETE="/${moduleName}/${entityName}/ajax/updateState";
	var URL_SHOW="/${moduleName}/${entityName}/show${entityCamelName}";
	var URL_LIST="/${moduleName}/${entityName}/ajax/load${entityCamelName}List";
	//表字段结构定义
	var columns={"tableMain":[
		<#if columns??>
		<#list columns as col>
        {"data": '${col.propertyName!}'},
        </#list>
        </#if>
        {"data": null}
	]};
	var columnDefs={
		"tableMain":[
				{
					targets: -1,
					defaultContent: DEFAULT_TABLE_OPERATION
				}
		]
	}

	
	$(document).ready(function () {
		
	 	// 筛选弹出框
		$('#btn_filter').click(function() {
		 	var isVisible=$("#formQuery").is(":visible");
		 	 if (!isVisible){ 
		 		$(this).find(".fa").removeClass("fa-caret-right").addClass("fa-caret-down");
		 		showTip(this,null,function(){
					$('#'+this.dlg.attr("id")).css('overflow-y','hidden');
				},{height:'auto',tagId:"formQuery"});
		 	}else {
		 		$(".ym-filter-box").hide();
		 		$(this).find(".fa").removeClass("fa-caret-down").addClass("fa-caret-right");
		 	}
		});
		
		$("#btnSearch,#btnFormQuery").click(function(){
			reloadTableData("tableMain");
		});
		
		$("#btnFormReset").click(function(){
			resetFormQuery()
		});
		
		$("#keyword").on("keyup",function(e){
 			e=e || event;
 			if (e.keyCode==13){
 				reloadTableData("tableMain");
 			}
 		});
		loadDicts();
		loadData("tableMain",{columns:columns["tableMain"],columnDefs:columnDefs["tableMain"]});	
	});
</script>
</body>
<!--/Body -->
</html>
