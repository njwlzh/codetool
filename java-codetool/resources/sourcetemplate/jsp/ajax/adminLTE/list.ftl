<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../common/jstl.jsp"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
	<meta charset="utf-8" />
	<title>${caption!}管理</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style type="text/css">
	#tableMain_length{
		display: none;
	}
	#tableMain_info{
		display: inline;
	}
	</style>
	<%@include file="../../common/admin_css.jsp"%>
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
						<%-- 左侧搜索框 --%>
						<div class="pull-left" style="padding-left: 14px;">
							<button id="btn_filter" type="button" style="margin-right:5px;" class="btn btn-default btn-sm" data-t2mFilterBox="t2m_filter">筛选 <i class="fa fa-caret-right"></i></button>
							<div class="input-group input-group-sm pull-right" id="searchBox" style="width:180px;">
				                <input type="text" class="form-control input-search" id="keyword" placeholder="根据名称进行搜索">
			                    <span class="input-group-addon" class="btn btn-flat" id="btnSearch"><i class="fa fa-search"></i></span>
				             </div>
						</div>
						<%--  右侧按钮组 --%>
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
								<th>${col.caption!}</th>
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
			<label class="col-md-4 col-sm-4">${col.caption!}</label>
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
	<%@include file="../../common/admin_js.jsp"%>
	<script type="text/javascript">
    //刷新列表
	function reloadData(){
		$("#tableMain").DataTable().ajax.reload();
	}
    
    function loadData(){
    	var tableHeight=$(top.window).height()-220;
        var tables = $("#tableMain").dataTable({
        	"scrollX": true,
         	"scrollY": tableHeight+"px",
        	serverSide: true,//分页，取数据等等的都放到服务端去
            processing: true,//载入数据的时候是否显示“载入中”
            lengthMenu:[5,10,20,30,40,50],
            pageLength: 10,  //首次加载的数据条数
            lengthChange:true,
            ordering: false, //排序操作在服务端进行，所以可以关了。
            pagingType: "simple_numbers",
            autoWidth: false,
            stateSave: false,//保持翻页状态，和comTable.fnDraw(false);结合使用
            searching: false,//禁用datatables搜索,
            ajax: {   
                url: "${"$"}{contextPath}/${moduleName}/${entityName}/ajax/load${entityCamelName}List",
                dataSrc: "data",
                data: function (d) {
                       var param = {};
                       param.draw = d.draw;
                       param.start = d.start;
                       param.length =d.length;
                       var $form = $("#formQuery");
                       if($form.is(":visible")){
                    	   var formData = $form.serializeArray();
                    	   formData.forEach(function(e){
                    		   param[e.name] = e.value;	
                    	   });
                       }else{
                    	   var keyword = $("#keyword").val().trim();
                    	   param["keyword"] = keyword;
                       }
                       return param;//自定义需要传递的参数。
                },
                error:function(){
                	if (arguments[0].status==500){
                		top.bootbox.alert("系统忙，请稍候再试！");
                	}
                	else if(arguments[1]=="parsererror"){
                		top.bootbox.alert('登录已失效，请重新登录！',function() {
        						top.location.reload();
        				}); 
                	}
                }
            },
            columns: [//对应上面thead里面的序列
            	<#if columns??>
				<#list columns as col>
                {"data": '${col.propertyName!}'},
                </#list>
                </#if>
                {"data": null}
            ],
            //操作按钮
            columnDefs: [
				{
                 targets: -1,
                 defaultContent: DEFAULT_TABLE_OPERATION
				}
            ],
            language: DEFAULT_TABLE_LANGUAGE,
            //在每次table被draw完后回调函数
            fnDrawCallback: function(){
            	var $tb=$(this);
	            var tbCont =$tb.parents(".dataTables_wrapper");
            	var $tblen=tbCont.find(".dataTables_length");
            	var $tbinfo =tbCont.find(".dataTables_info");
            	$tblen.css({"display":"inline"});
            	$tbinfo.after($tblen);
            	 //编辑信息
                $tb.find("tbody").off().on("click", ".btnEdit", function () {
                      var data = tables.api().row($(this).parents("tr")).data(); 
                     
                     top.showTopDialogs("编辑信息","${"$"}{contextPath}/${moduleName}/${entityName}/toEdit${entityCamelName}?<#list primaryKeyList as col><#if col_index!=0>+"&</#if>${col.propertyName}="+data.${col.propertyName}</#list>,1,1200,600,
                     		[{
                     			caption:"保存",
                     			className:"btn",
                     			icon:"fa fa-check",
                     			click:function(){
                     				this.saveData();
                     			}
         		            },
         		       		{
         		       			caption:"&times;",
         		       			className:"btn",
         		       			click:function(){
         		       				this.closeDlg();
         		       			}
         		       		}]
         		            ,window);
                     
                 }); 
            	 //查看
				$tb.find("tbody").on("click", ".btnView", function () {
					var data = tables.api().row($(this).parents("tr")).data(); 
					top.showTopDialogs("信息详情","${"$"}{contextPath}/${moduleName}/${entityName}/show${entityCamelName}?<#list primaryKeyList as col><#if col_index!=0>+"&</#if>${col.propertyName}="+data.${col.propertyName}</#list>,1,1200,600,
                    		[{
        		       			caption:"&times;",
        		       			className:"btn",
        		       			click:function(){
        		       				this.closeDlg();
        		       			}
        		       		}]
        		            ,window);
                }); 
                
				//删除
        		$tb.find("tbody").on("click", ".btnDelete", function () {
	            	var data = tables.api().row($(this).parents("tr")).data();
	           		top.bootbox.confirm({
		       	        buttons: {  
		       	            confirm: {  
		       	                label: '确定',  
		       	                className: 'btn-primary'  
		       	            },  
		       	            cancel: {  
		       	                label: '取消',  
		       	                className: 'btn-default'  
		       	            }  
		       	        },  
		       	        message: '确定要删除？',  
		       	        callback: function(result) {
		       	            if(result) {  
		       	            	$.ajax({
		       	                    url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/updateState?state=3&<#list primaryKeyList as col><#if col_index!=0>+"&</#if>${col.propertyName}="+data.${col.propertyName}</#list>,
		       	                    dataType: "json",
		       	                    cache: "false",
		       	                    success:function(data){
		       	                        if(data.state == 0){
		       	                            top.bootbox.alert('删除成功！');  
		       	                            reloadData();
		       	                        }else{
		       	                            top.bootbox.alert('删除失败');  
		       	                        }
		       	                    },
		       	                    error:function(){
		       	                        top.bootbox.alert('服务器忙，请稍候再试:'+arguments[0].statusText);  
		       	                    }
		       	                });
		       	            }  
		       	        }
		       	  });  
            
        		});
				
            	hideLoading();
            }
       });
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
        	reloadData();
        });
        
        $("#btnFormReset").click(function(){
        	resetFormQuery()
        });
        
        $("#keyword").on("keyup",function(e){
   			e=e || event;
   			if (e.keyCode==13){
   				reloadData();
   			}
   		});
        loadDicts();
        loadData();	
    });
    //显示添加主数据窗口
    function showAddMainInfo(){
    	top.showTopDialogs("添加信息","${"$"}{contextPath}/${moduleName}/${entityName}/toAdd${entityCamelName}",1,1200,600,
         		[{
         			caption:"保存",
         			className:"btn",
         			icon:"fa fa-check",
         			click:function(){
         				this.saveData();
         			}
	            },
	       		{
	       			caption:"&times;",
	       			className:"btn",
	       			click:function(){
	       				this.closeDlg();
	       			}
	       		}]
	            ,window);
    }
    
    
 	//重置
	function resetFormQuery(){
  		$("#formQuery")[0].reset();
  		$("#formQuery input:hidden").val("");
  		reloadData();
  	}
</script>
</body>
<!--  /Body -->
</html>
