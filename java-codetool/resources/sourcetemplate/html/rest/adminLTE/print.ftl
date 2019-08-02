<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<!-- Head -->
	<head>
		<meta charset="utf-8" />
		<title>打印单据</title>
		<!-- Bootstrap 3.3.6 -->
		<link rel="stylesheet" href="/static/adminlte/bootstrap/css/bootstrap.min.css">
		<!-- Font Awesome -->
		<link rel="stylesheet" href="/static/adminlte/dist/css/font-awesome.min.css">
		<!-- Ionicons -->
		<link rel="stylesheet" href="/static/adminlte/dist/css/ionicons.min.css">
		
		<link rel="stylesheet" href="/static/common.css">
	</head>
	<body style="width:80%;">
		<p>
			<select id="printer" class="easyui-combbox" onchange="changePrinter(this)">
			</select>
		   	<a href="https://erp.kmguozhuan.com/upload/soft/lodop.zip" target="_blank">下载打印控件</a>
	   	</p>
		 <div id="printContent">
		 <#if subTables??>
			<#list subTables as subTable>
		 	<p style="padding:5px; background:#fff;">
			 	<a href="javascript:void(0);" class="btn" onclick="executePrint('${subTable.entityName}')">打印</a>
			   	<a href="javascript:void(0);" class="btn" onclick="exportToFile('${subTable.entityName}')">导出到Excel</a>
		   	</p>
			<div id="content_${subTable.entityName}">
				<table id="table_${subTable.entityName}" border="1" cellSpacing="0" cellPadding="1" width="100%" class="main" style="border-collapse:collapse" bordercolor="#333333">
					<caption>
						<div style="line-height: 30px" class="size16" align="center">
							<strong><font style="font-size: 20px;text-decoration: underline;"><span class="printHeader"></span> - <span>${subTable.caption}</span></font></strong>
						</div>
						<table border="0" cellspacing="0" cellpadding="5" style="width:100%;font-size:14px;">
							<tr>
								<td><font>商户：<span property="customerInfo.customerName"></span> <span property="customerInfo.customerTel"></span></font></td>
								<td align="right"><font>订单编号：<span property="sn"></span></font></td>
								<td align="right"><font>开单日期：<span property="orderDate"></span></td>
							</tr>
						</table>
					</caption>
					<thead id="thead_${subTable.entityName}">
					</thead>
					<tbody id="tbody_${subTable.entityName}">
					</tbody>
					<tfoot>
						<tr style="border-style: none;">
							<th colspan="${((subTable.columns)?size)-3}" align="left" style="border-style: none;">总计:<span id="orderTotalAmount"></span>元 <span style="padding-left: 30px;">金额合计(大写)：<span id="orderTotalAmount_big"></span></span></th>
							<th colspan="2" align="right" style="border-style: none;">本页合计:</th>
							<th tdata="SubSum" format="#,##0.00" align="left" style="border-style: none;">#元</th>
							<th style="border-style: none;"></th>
						</tr>
						<tr>
							<td colspan="${(subTable.columns)?size}" style="font-size:13px;">备注：<span property="note"></span></td>
						</tr>
						<tr>
							<td colspan="${(subTable.columns)?size}">
								<table border="0" cellspacing="0" cellpadding="0" style="width:100%;font-size:13px;">
										<tr>
											<td><font>业&nbsp;&nbsp;务&nbsp;&nbsp;员：<span property="bussinessStaff.cname"></span></font></td>
											<td><font>收&nbsp;&nbsp;货&nbsp;&nbsp;员：</font></td>
											<td><font>验&nbsp;&nbsp;货&nbsp;&nbsp;员：</font></td>
											<td><font>开&nbsp;&nbsp;单&nbsp;&nbsp;员：<span property="createStaff.cname"></span></font></td>
										</tr>
										<tr>
											<td colspan="3"><font>地　　址：<span property="businessOrg.address"></span></font></td>
											<td><font>联系电话：<span property="businessOrg.managerPhone"></span></font></td>
										</tr>
								</table>
							</td>
						</tr>
					</tfoot>
					
				</table>
			</div>
			</#list>
		</#if>
		</div>
	</body>
	<script src='https://localhost:8443/CLodopfuncs.js'></script>
	<script src="/static/adminlte/plugins/jQuery/jquery-3.3.1.js"></script>
	<script src="/static/common.js"></script>
	<script src="/static/print_erp.js"></script>
	<script type="text/javascript">
	var URL_DATA="/${moduleName}/${entityName}/ajax/load${entityCamelName}";
	moduleName = "${caption}";
	var orderInfo;
	var columns={
	<#if subTables??>
		<#list subTables as subTable>
		"table_${subTable.entityName}":[
			<#if subTable.columns??>
			<#list subTable.columns as col>
	        {"data": "${col.propertyName!}","title":"${col.caption!}","orderable":true,"name":"${col.propertyName!}","editable":false,"width":${(col.length<60)?string(60,(col.length)?c)} <#if col.dictKey??>,"dictKey":"${col.dictKey!}","editorType":"${col.editorType!}"</#if>},
	        </#list>
	        </#if>
		],
		</#list>
	</#if>
	};
	
	//渲染填充数据
	function fillData(orderInfo){
		fillNodeData(orderInfo);
		//显示各子表的数据
		for (var table in columns) {
			var tableName = table.split("_")[1];
			var datas = orderInfo[tableName+"List"];
			//没有子表数据，则不显示出来
			if (!datas) {
				$("#content_"+table).remove();
				return;
			}
			//表头
			var ths = ["<tr>"];
			for (var i=0; i<columns[table].length; i++) {
				var col = columns[table][i];
				ths.push("<th width='"+((col.length)?c)+"'>"+col.title+"</th>");
			}
			ths.push("</tr>");
			$("#thead_"+tableName).append(ths.join(""));
			//表格内容
			var tdatas = [];
			for (var i=0;i<datas.length;i++) {
				var tds = ["<tr>"];
				for (var cx=0; cx<columns[table].length; cx++) {
					var col = columns[table][cx];
					var val = datas[i][col.data]||"";
					val = transaction(col, val);
					tds.push("<td>"+(val)+"</td>");
				}
				tds.push("</tr>");
				tdatas.push(tds.join(""));
			}
			$("#tbody_"+tableName).append(tdatas.join(""));
		}
	}
	
	$(document).ready(function(){
 		$.ajax({
 			url:URL_DATA,
 			data:UrlParm.params(),
 			success:function(res){
 				orderInfo = res.data;
 				fillData(orderInfo);
 			}
 		});
 	});
	</script>
</html>