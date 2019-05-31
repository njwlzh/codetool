var DEFAULT_TABLE_OPERATION='<div class="btn-group"><a class="btnEdit">编辑</a> | <a class="btnView">查看</a> | <a class="btnDelete">删除</a></div>';
var TABLE_OPERATION_VIEW='<div class="btn-group"><a class="btnView">查看</a></div>';
var TABLE_OPERATION_EDIT='<div class="btn-group"><a class="btnEdit">编辑</a></div>';
var TABLE_OPERATION_DELETE='<div class="btn-group"><a class="btnDelete">删除</a></div>';
var TABLE_OPERATION_VIEW_EDIT='<div class="btn-group"><a class="btnView">查看</a> | <a class="btnEdit">编辑</a></div>';
var TABLE_OPERATION_VIEW_DELETE='<div class="btn-group"><a class="btnView">查看</a> | <a class="btnDelete">删除</a></div>';
var TABLE_OPERATION_ROLE='<div class="btn-group"><a class="btnEdit">编辑</a> | <a class="btnView">查看</a> | <a class="btnDelete">删除</a> |  <a id="editRight" class="editRight">编辑权限</a> </div>';
var TABLE_OPERATION_AREA_DELETE='<div class="btn-group"><a class="btnEditArea">管理地区</a>|<a class="btnDelete">删除</a></div>';

var DEFAULT_TABLE_LANGUAGE={
        lengthMenu: "每页显示_MENU_条",
        processing: "正在加载数据...",
        paginate: {
            previous: "上页",
            next: "后页"
        },
        zeroRecords: "没有数据",
        info: "当前 _START_ 至 _END_ 行 &nbsp;&nbsp;共 _PAGES_ 页",
        infoEmpty: "",
        infoFiltered: "",
        sSearch: "输入关键字："
    };
if (!Array.prototype.indexOf) {
	  Array.prototype.indexOf = function(searchElement, fromIndex) {

	    var k;

	    // 1. Let O be the result of calling ToObject passing
	    //    the this value as the argument.
	    if (this == null) {
	      throw new TypeError('"this" is null or not defined');
	    }

	    var O = Object(this);

	    // 2. Let lenValue be the result of calling the Get
	    //    internal method of O with the argument "length".
	    // 3. Let len be ToUint32(lenValue).
	    var len = O.length >>> 0;

	    // 4. If len is 0, return -1.
	    if (len === 0) {
	      return -1;
	    }

	    // 5. If argument fromIndex was passed let n be
	    //    ToInteger(fromIndex); else let n be 0.
	    var n = +fromIndex || 0;

	    if (Math.abs(n) === Infinity) {
	      n = 0;
	    }

	    // 6. If n >= len, return -1.
	    if (n >= len) {
	      return -1;
	    }

	    // 7. If n >= 0, then Let k be n.
	    // 8. Else, n<0, Let k be len - abs(n).
	    //    If k is less than 0, then let k be 0.
	    k = Math.max(n >= 0 ? n : len - Math.abs(n), 0);

	    // 9. Repeat, while k < len
	    while (k < len) {
	      // a. Let Pk be ToString(k).
	      //   This is implicit for LHS operands of the in operator
	      // b. Let kPresent be the result of calling the
	      //    HasProperty internal method of O with argument Pk.
	      //   This step can be combined with c
	      // c. If kPresent is true, then
	      //    i.  Let elementK be the result of calling the Get
	      //        internal method of O with the argument ToString(k).
	      //   ii.  Let same be the result of applying the
	      //        Strict Equality Comparison Algorithm to
	      //        searchElement and elementK.
	      //  iii.  If same is true, return k.
	      if (k in O && O[k] === searchElement) {
	        return k;
	      }
	      k++;
	    }
	    return -1;
	  };
	}    
   
	bootbox.setDefaults("locale", "zh_CN");
	//数组去重
	Array.prototype.distinct = function () {    
    	var newArr = [],obj = {};    
    	for(var i=0, len = this.length; i < len; i++){    
      		if(!obj[typeof(this[i]) + this[i]]){    
        		newArr.push(this[i]);    
        		obj[typeof(this[i]) + this[i]] = 'new';    
      		}    
    	}    
    	return newArr;  
  	}
	
	Array.prototype.contains = function (obj) {
	    var i = this.length;
	    while (i--) {
	        if (this[i] === obj) {
	            return true;
	        }
	    }
	    return false;
	}
	
	Array.prototype.remove=function(dx) {
	　　if(isNaN(dx)||dx>this.length){return false;}
	　　this.splice(dx,1);
	}

	//初始化页面待办事项的数据
	$(function () {
		//backlog();
		$(".treeview-menu>li").on("click",function(){
			$(".treeview-menu>li").not(this).removeClass("current");
			$(this).addClass("current");
		});
	});

	//初始化页面的复选和单选 按钮样式
	function initDictStyle(){
		$('input[type="checkbox"], input[type="radio"]').iCheck({
			checkboxClass: 'icheckbox_minimal-blue',
		      radioClass: 'iradio_flat-blue'
	  	});
	}
  	
  	function fillFormData(data,jqForm){
  		var inputs;
  		if (jqForm){
  			inputs = $("input,textarea,select",jqForm).not(":checkbox,:radio");
  		} else {
  			inputs = $("input,textarea,select").not(":checkbox,:radio");
  		}
  		inputs.each(function(x,inp){
  			var obj = $(inp);
  			var name = obj.attr("name");
  			var names = name.split(".");
  			var val;
  			for (var i=0;i<names.length;i++){
  				if (!val){
	  				val = data[names[i]];
  				} else {
  					val=val[names[i]];
  				}
  			}
  			if (val==0 || val){
  				obj.val(val);
  			}
  		});
  	}
  	
  //异步加载完数据后，填入相应的表单中
  	function fillNodeData(data){
	  	for (var key in data){
	  		var val = data[key];
	  		if (isJson(val)){
	  			for (var k2 in val){
	  				$("[property='"+key+"."+k2+"']").html(val[k2]);
	  			}
	  		} else {
	  			$("[property='"+key+"']").html(data[key]);
	  		}
	  	}
  	}
  

	//判断obj是否为json对象
	function isJson(obj){
		var isjson = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length; 
		return isjson;
	}

	function hideLoading(){
		$(".overlay").hide();
	}
  
  	function showLoading(){
	  	$(".overlay").show();
  	}
	function hideLoadData(){
		 $("#saveData").hide();
	 }
  
  	function showLoadData(){
	  	$("#saveData").show();
  	}
  
  	/**
   	*  加载列表
   	*@param entity 当前页面的实体对象，用于设置radio或checkbox的选中状态，若为空，则不进行状态设置
   	* callback 渲梁完成回调方法
   	* beforeRender 渲染前调用方法
   	* isICheck 是否启用icheck样式，默认为启用
   	*/
   	 function loadDicts(entity,callback,beforeRender,isICheck){
   		
   		isICheck = isICheck==null||isICheck==undefined ? true:isICheck;
   		var dictDivList=$("div[role='dict']");
   		var keys = [];
	   	$.each(dictDivList,function(i,div){
	   		keys.push($(div).attr("dictKey"));
	   	});
	   	$.ajax({
	   		url:"${contextPath}/sys/sysDict/ajax/loadMultiDictItems",
	   		data:{parentKeys:keys},
	   		success:function(res){
	   			if (res.state==0){
	   				//把radio,select,checkbox显示到界面
	   				renderDicts(res.data,beforeRender,isICheck);
	   				//设置选中状态
	   				if (entity){
	      				setDictState(entity);
	   				}
	      			//hideLoading();
	      			if (callback) {
	      				callback.apply(this);
	      			}
	   			}
	   		}
	   	}); 
	   	
	   	if (callback) {
			callback.apply(this);
		}
   	} 
   	/**
   	 * 渲染数据字典列表，页面标签内需要几个属性：role="dict" dictKey="字典属性" type="select|checkbox|radio"
   	 * @param dictJson
   	 * @param beforeRender
   	 * @param isICheck
   	 * @returns
   	 */
   	function renderDicts(dictJson,beforeRender,isICheck){
   		for (var key in dictJson){
   			var dicts=dictJson[key];
   			var $divs=$("div[role='dict'][dictKey='"+key+"']");
   			$.each($divs,function(i,div){
	       		var str=[];
	   			var $div=$(div);
	       		var type=$div.attr("type");
	       		var value = $div.attr("data-value");
	       		var property =$div.attr("property");
	       		var showDefault = $div.attr("showDefault");
	       		var require=typeof($div.attr("require"))!="undefined";
	       		var disabled=typeof($div.attr("disabled"))!="undefined";
	     		var defaultValue = $div.attr("defaultValue") || "";
	       		if (type=="select"){
	       			str.push("<select name='"+property+"' class='form-control' "+(require?"require='true'":"")+" "+(disabled?"disabled":"")+">");
	       			var defaultName = $div.attr("defaultName");
	       			if (defaultName){
	       				str.push("<option value='"+defaultValue+"'>"+defaultName+"</option>");
	       			}
	       		}
	        	$.each(dicts,function(i,dict){
	        		if (type == "select") {
						str.push("<option value='"+dict.dictKey+"'>"+ dict.dictValue+ "</option>");
					} else if (type == "checkbox") {
						str.push("<label class='dict-label'><input type='checkbox' name='"+property+"' value='"+dict.dictKey+"' "+(disabled?"disabled":"")+">"
										+ dict.dictValue+ "</span>");
					} else if (type == "radio") {
						str.push("<label class='dict-label'><input type='radio' name='"+property+"' class='minimal' value='"+dict.dictKey+"' "+(disabled?"disabled":"")+"> "
										+ dict.dictValue+ "</label>");
					}
	        	});
	        	if (type=="select"){
	      			str.push("</select>");
	       		}
        		$div.html(str.join(""));
	        	if (defaultValue){
	        		if (type=="checkbox" || type=="radio") {
	        			$div.find("[name='"+property+"'][value='"+defaultValue+"']").attr("checked",true);
	        		} else {
	        			$div.find("[name='"+property+"']").val(defaultValue);
	        		}
	        	}
   			});
   		}
       	if (beforeRender){
       		beforeRender.apply(this);
       	}
      	//设置radio或checkbox的样式
       	if(isICheck) {
       		initDictStyle();
       	}
   	}
   	//设置选中状态
   	function setDictState(entity){
   		for (var property in entity){
   			var $div=$("div[role='dict'][property='"+property+"']");
   			var type=$div.attr("type");
   			if (type=="select"){
   				$div.find("select[name='"+property+"']").val(entity[property]);
   			} else {
       			var $check=$div.find("input[value='"+entity[property]+"']");
       			$check.parent().addClass("checked");
       			$check.parent().attr("aria-checked",true);
       			$check.attr("checked",true);
   			}
   		}
   	}
   
   	function getLabel($obj){
	   	var $label=$obj.parent().prev("td");
		if ($label.length==0){
			$label=$obj.parents("td").prev("td");
		}
		if ($label.length==0){
			$label=$obj.parent().prev("label");
			if ($label.length==0){
				if ($obj.parent(".input-group").length>0){
					$label=$obj.parent(".input-group").parent().prev("label");
				}
			}
		}
		var label=$label.text();
		if (label){
 			label=label.replace(/[:：]/g,"").replace("*","").replace(/　/g,"");
		}
		return label;
   	}
   	/**
   	* 校验页面表单
   	*/
   	function checkForm(formId){
		var inputs=$(formId).find("input,select,textarea");
	   	var msg=[];
	   	var hasError=false;
	   	for (var i=0;i<inputs.length;i++){
	   		var obj=$(inputs[i]);
	   		//$.each(inputs,function(i,obj){
	   		var $obj=$(inputs[i]);
	   		var val=$.trim($obj.val());
	   		var min = parseInt($obj.attr("min"));
	   		var max = parseInt($obj.attr("max"));
	   		var dataType=$obj.attr("dataType");
	   		var require=isContainsAttr(obj,"require");
	   		var contentType=$obj.attr("contentType");
	   		
   			var label=getLabel($obj);
   			if (contentType!="html"){
   				val=val.replace(/<.+?>/g,"");
   			}
	   		if (require && val==""){
	   			if (label){
       				msg.push(label+"不能为空");
	   			}
	   			hasError=true;
	   			$obj.parent().addClass("has-error");
	   		} else if (isContainsAttr(obj,"min") || isContainsAttr(obj,"max")){ //判断输入长度
	   			var hasError=false;
	   			if (min>0){
	   				if (dataType=="int"){
	   					val = parseInt(val);
	   					if (val<min){
	   						msg.push(label+"数字不能小于"+min);
		   					$obj.parent().addClass("has-error");
		   					hasError=true;
	   					}
	   				} else {
		   				if (val.length<min){
		   					msg.push(label+"长度不足"+min);
		   					$obj.parent().addClass("has-error");
		   					hasError=true;
		   				}
	   				}
	   			}
	   			if (max>0){
	   				if (dataType=="int"){
	   					val = parseInt(val);
	   					if (val>max){
	   						msg.push(label+"超出最大数值"+max);
		   					$obj.parent().addClass("has-error");
		   					hasError=true;
	   					}
	   				} else {
		   				if (val.length>max){
		   					$obj.parent().addClass("has-error");
		   					msg.push(label+"超出长度"+max);
		   					hasError=true;
		   				}
	   				}
	   			}
	   			if (!hasError) {
	   				$obj.parent().removeClass("has-error");
	   			}
	   		} else {
	   			$obj.parent().removeClass("has-error");
	   		}
	   		if (dataType=="int" && isNaN(val)){
	   			val="";
	   		}
	   		$obj.val(val);
	   	}
	   	msg = msg.distinct();
	   	return {state:(msg.length==0 && !hasError),msg:msg}; 
	   	 if (msg.length>0 || hasError) {
	   		top.bootbox.alert(msg.join("<br/>"));
	   		return false;
	   	} else {
	   		$("#btnSubmit").val("正在提交...");
	   		$("#btnSubmit").attr("disabled","disabled");
	   		return true;
	   	} 
   	}
   
   	/**
   	* 判断控件是否包含某个属性
   	*/
   	function isContainsAttr(obj,attrName) {
	   	var require=typeof($(obj).attr(attrName))!="undefined";
	   	return require;
   	}
 	//初始化上传组件
	function initUploader(tagId,successCallBack,formData,opts){
	 	var options={
				// 选完文件后，是否自动上传。
				auto: true,
				timeout:0,
		        // 不压缩image
		        resize: false,
		     	// swf文件路径
		        swf:  '${contextPath}/static/webuploader/Uploader.swf',
		        // 文件接收服务端。
		        server: '${contextPath}/file/ajaxImageUpload',
		        // 选择文件的按钮。可选。
		        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
		        pick: '#'+tagId,
		        duplicate :true,
		        formData:formData,
		        fileSizeLimit:FliseSize
		    }
	 	if (opts){
	 		for (var key in opts) {
	 			options[key]=opts[key];
	 		}
	 	}
	   uploader = WebUploader.create(options);
		uploader.on("uploadStart",function(file){
			uploader.currentFile=file;
		});
		uploader.on("uploadProgress",function(file, percent){
			var $loading=$("#uploadLoading");
			$loading.show();
	    	$("#uploadPercent").html((percent*100).toFixed(0)+"%");
		});
	    uploader.on( 'uploadSuccess', function( file,data ) {
	    	successCallBack.call(this,data);
	    	$("#uploadLoading").hide();
	    });
	    uploader.on( 'uploadError', function( file,data ) {
	    	top.bootbox.alert("文件上传失败！");
	    });
	    uploader.on( 'error', function( type ) {
	    	if (type=="Q_TYPE_DENIED"){
	    		top.bootbox.alert("文件类型不正确，或者您上传的是空文件！");
	    	}else if(type == "Q_EXCEED_SIZE_LIMIT"){
	    		top.bootbox.alert("<span class='C6'>所选附件大小</span>不可超过<span class='C6'>"+parseInt(FliseSize/1024/1024*100)/100+ "M</span>哦！<br>换个小点的文件吧！");
	         }
	    });
	    return uploader; 
	}
 	//把当前页面地址写入到localStorage中，当F5刷新页面时，读取该值，在iframe中加载该页面
 	if (parent.location.href==top.location.href && location.href!=parent.location.href){
 		if (!top.$(".modal-dialog").is(":visible")){
 			localStorage.setItem("defaultUrl",location.href);
 		}
 	}
 
 	$("#btnCancelUpload").click(function(){
 		uploader.cancelFile(uploader.currentFile);
 		$("#uploadLoading").hide();
 	});
 	
 	function closeT2m(){
 	   	$("#t2m_filter").hide();
 	   	$("#btn_filter").removeClass('open');
    }
    function confimT2m(){
 	   	reloadData();
 	   	$("#t2m_filter").hide();
 	   	$("#btn_filter").removeClass('open');
   	}
    
    //设置输入框只能输入数字
    function initNumberInput($input){
    	$input.on("keyup",function(){
			var val = this.value;
			if(/\D/.test(val)){
				this.value=val.replace(/\D/g,'');
			}
		});
    	$input.on("keydown",function(e){
			if((e.keyCode<48 || e.keyCode>57) && e.keyCode!=8 && e.keyCode!=46 && (e.keyCode<96 || e.keyCode>105)) {
				e.keyCode=0;
				e.preventDefault ? e.preventDefault() : e.returnValue = false;
			}
		});
    	$input.on("blur",function(e){
    		var val = this.value;
			if(/\D/.test(val)){
				this.value=val.replace(/\D/g,'');
			}
		});
    }
    
    //把form表单组装成为一个json
    $.fn.getJSON = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [ o[this.name] ];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    }
    

  //点击窗口空白处，关闭筛选框
    $(document).mousedown(function(e){

   	 	if ($("#btn_filter").is(e.target)){
   	 		return;
   	 	}
       	var _con = $(".ym-filter-box");
       	var datepicker=$(".datepicker :visible");
       	if(!_con.is(e.target) && _con.has(e.target).length === 0 && !datepicker.is(e.target) && datepicker.has(e.target).length===0){
       		$(".ym-filter-box").hide();
	        $("#btn_filter").find(".fa").removeClass("fa-caret-down").addClass("fa-caret-right");
	          	
       	}
    });
  
  //对于 dropdown 加上hover的效果
    addDropdownHover = function (){
    	$(".dropdown").hover(function(){
    		$(this).addClass("open")
    	},function(){
    		$(this).removeClass("open")
    	})
    	$("a[data-toggle='control-sidebar'],aside.control-sidebar").hover(function(){
    		$("a[data-toggle='control-sidebar']").css("background-color","#fff");
    		$("a[data-toggle='control-sidebar']").find("img").attr("src",window.jinkeContextPath+"/static/images/icon/pub_setting-hover.png");
    		$("aside.control-sidebar").addClass("control-sidebar-open");
    	},function(){
    		$("a[data-toggle='control-sidebar']").css("background-color","transparent");
    		$("a[data-toggle='control-sidebar']").find("img").attr("src",window.jinkeContextPath+"/static/images/icon/pub_setting.png");
    		$("aside.control-sidebar").removeClass("control-sidebar-open");
    	})
    }
    addDropdownHover();
    //修改颜色 
    $(".ub_color").css("background","#EEEEEE");
   //左侧头像改动 
    $(document).on("click",".sidebar-toggle",function(){  
    	if($("#userImgForCor").attr("isfl")=="true"	){
    		$("#userImgForCor").height("45px").attr("isfl","false");	
    	}else{
    		$("#userImgForCor").height("30px").attr("isfl","true");	
    	}
	
    });
   
     //判断页面是否是缩放
    $(function(){
    	
    	 var scrollFunc=function(e){
    		  e=e || window.event;
    		  if(e.wheelDelta && e.ctrlKey){//IE/Opera/Chrome
    		   e.returnValue=false;
    		  }else if(e.detail){//Firefox
    		   e.returnValue=false;
    		  }
    		 } 
    		   
    		 /*注册事件*/
    		 if(document.addEventListener){
    		 document.addEventListener('DOMMouseScroll',scrollFunc,false);
    		 }//W3C
    		 window.onmousewheel=document.onmousewheel=scrollFunc;//IE/Opera/Chrome/Safari
    		   
        (function (){
      	var isDevicePixelRatio = function(){
      		if(window.devicePixelRatio>1||window.devicePixelRatio<1){		
      			 if (self != top) {  
     			     return false;
     			 }else{
     				 alert("你的页面处于缩放状态，页面显示会有问题，请设置为正常状态。windows:ctrl+0   mac:command+0")
     			 }	
      		}	
      	}
      	isDevicePixelRatio();
      	$(window).resize(function(){
      		if(window.devicePixelRatio>1||window.devicePixelRatio<1){   		 
      		//	isDevicePixelRatio();
      		}
      	})	   
       }());
    })
    
    function formatDate(time){
        var date = new Date(time);

        var year = date.getFullYear(),
            month = date.getMonth()+1,//月份是从0开始的
            day = date.getDate(),
            hour = date.getHours(),
            min = date.getMinutes(),
            sec = date.getSeconds();
        var newTime = year + '-' +
                    (month < 10? '0' + month : month) + '-' +
                    (day < 10? '0' + day : day)  + ' ' +
                    (hour < 10? '0' + hour : hour) + ':' +
                    (min < 10? '0' + min : min) + ':' +
                    (sec < 10? '0' + sec : sec); 

        return newTime;         
    }
   //选择员工
	function initSelectStaff(opts){
		var $id = opts.$id;
		var selectType = opts.selectType || 1;
	   
	   $($id).click(function(){
			var src="${contextPath}/company/staffInfo/showSelectStaff?selectType="+selectType;
			var parameter = [];
			if(opts.parameter){
				for(var key in opts.parameter){
					parameter.push(key+"="+opts.parameter[key]);
				}
				if(parameter.length>0){
					src+="&"+parameter.join("&");
				}
			}
			top.showTopDialogs('选择员工',src,50,500,500,[{
				caption:"确定",
				className:"btn",
				icon:"fa fa-check-square",
				click:function(){
					var data = this.getReturnData();
					opts.callback.apply(this,[data]);
					this.closeDlg();
				}
			},
			{
				caption:"&times;",
				className:"btn",
				click:function(){
					this.closeDlg();
				}
			}],window);
		});
	}
//选择用户
// $id 为jquery格式的控件ID
// selectType 为选择方式：1=多选（默认），2=单选
// params json结构的参数，作为查询条件
// callback 选择后的回调方法
function initSelectUser(opts){
	var selectType = opts.selectType || 1;
	if (!selectType){
		selectType=1;
	}
	if (!opts.$id){
		return;
	}
	var $id=opts.$id;
	//组装参数
	var parameter=[];
	if (opts.params){
		for (var key in opts.params){
			parameter.push(key+"="+opts.params[key]);
		}
	}

	$($id).click(function(){
		var src="${contextPath}/components/showSelectUser?selectType="+selectType;
		if (parameter.length>0){
			src+="&"+parameter.join("&");
		}
		top.showTopDialogs('选择用户',src,50,500,610,[{
			caption:"确定",
			className:"btn",
			icon:"fa fa-check-square",
			click:function(){
				var staffs = this.getReturnData();
				if (opts.callback){
					opts.callback.apply(this,[staffs]);
				}
				this.closeDlg();
			}
		},
			{
				caption:"&times;",
				className:"btn",
				click:function(){
					this.closeDlg();
				}
			}],window);

	});
}
//选择配送员
// $id 为jquery格式的控件ID
// selectType 为选择方式：1=多选（默认），2=单选
// params json结构的参数，作为查询条件
// callback 选择后的回调方法
function initSelectDeliveryStaff(opts){
	var selectType = opts.selectType || 1;
	if (!selectType){
		selectType=1;
	}
	if (!opts.$id){
		return;
	}
	var $id=opts.$id;
	//组装参数
	var parameter=[];
	if (opts.params){
		for (var key in opts.params){
			parameter.push(key+"="+opts.params[key]);
		}
	}

	$($id).click(function(){
		var src="${contextPath}/components/showSelectDeliveryStaff?selectType="+selectType;
		if (parameter.length>0){
			src+="&"+parameter.join("&");
		}
		top.showTopDialogs('选择配送员',src,50,500,610,[{
			caption:"确定",
			className:"btn",
			icon:"fa fa-check-square",
			click:function(){
				var staffs = this.getReturnData();
				if (opts.callback){
					opts.callback.apply(this,[staffs]);
				}
				this.closeDlg();
			}
		},
			{
				caption:"&times;",
				className:"btn",
				click:function(){
					this.closeDlg();
				}
			}],window);

	});
}
	//选择商品
	   // $id 为jquery格式的控件ID
	   // selectType 为选择方式：1=多选（默认），2=单选
	   // params json结构的参数，作为查询条件
	   // callback 选择后的回调方法
		function initSelectProduct(opts){
			var selectType = opts.selectType || 1;
		   	if (!selectType){
				selectType=1;
			}
			if (!opts.$id){
				return;
			}
			var $id=opts.$id;
			//组装参数
			var parameter=[];
			if (opts.params){
				for (var key in opts.params){
					parameter.push(key+"="+opts.params[key]);
				}
			}
			
			$($id).click(function(){
				var src="${contextPath}/components/showSelectProduct?selectType="+selectType;
				if (parameter.length>0){
					src+="&"+parameter.join("&");
				}
				top.showTopDialogs('选择商品',src,50,500,500,[{
		   			caption:"确定",
		   			className:"btn",
		   			icon:"fa fa-check-square",
		   			click:function(){
		   	   			var staffs = this.getReturnData();
		   	   			if (opts.callback){
		   					opts.callback.apply(this,[staffs]);
		   	   			}
		   				this.closeDlg();
		   			}
		   		},
		   		{
		   			caption:"&times;",
		   			className:"btn",
		   			click:function(){
		   				this.closeDlg();
		   			}
		   		}],window);
				
			});
		}

	function getOptionValue(selectName){
		var ret = new Array();
		$("#"+selectName+" option").each(function(){
			//遍历所有option
			var value = $(this).val();   //获取option值
			ret.push(value);
		});
		return ret;
	}
	
	//转换日期格式(datetime格式转YYYY-mm-DD hh:mm:ss)
	function changeDateFormat(cellval) {
	    var dateVal = cellval + "";
	    if (cellval != null) {
	        var date = new Date(parseInt(dateVal.replace("/Date(", "").replace(")/", ""), 10));
	        var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
	        var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
	        
	        var hours = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
	        var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
	        var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
	        
	        return date.getFullYear() + "-" + month + "-" + currentDate + " " + hours + ":" + minutes + ":" + seconds;
	    }
	}
	/**
	 * 手机号验证
	 */
	function isMobile(phone){
		if(isEmpty(phone)){
			return false;
		}else if((/^1[3-9][0-9]\d{8}$/.test(phone))){
			return true;
		}
		return false;
	}
	/**
	 * 是否为空
	 */
	function isEmpty(val){
		if(val==null || val=='' || typeof(val)=='undefined'|| val.length==0){
			return true;
		}
		return false;
	}

	
	//数据表相关操作
	//刷新列表
	function reloadTableData(tableId){
		$("#"+tableId).DataTable().ajax.reload();
	}
	
	function loadData(tableId,opts){
		var tableHeight=$(top.window).height()-220;
		var tableOptions={
			"scrollX": true,
		 	"scrollY": tableHeight+"px",
			serverSide: true,//分页，取数据等等的都放到服务端去
			processing: true,//载入数据的时候是否显示“载入中”
			lengthMenu:[5,10,20,30,40,50],
			pageLength: 10,//首次加载的数据条数
			lengthChange:true,
			ordering: false, //排序操作在服务端进行，所以可以关了。
			pagingType: "simple_numbers",
			autoWidth: false,
			stateSave: false,//保持翻页状态，和comTable.fnDraw(false);结合使用
			searching: false,//禁用datatables搜索,
			scrollCollapse: true,
            dom: 'C<"clear">BRZlfrtip',
            /*
            select: {
            	style: 'os' //multi
            },
            */
			ajax: { 
				url: URL_LIST,
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
			columns: columns[tableId],
			//操作按钮
			columnDefs: columnDefs[tableId],
			language: DEFAULT_TABLE_LANGUAGE,
			//在每次table被draw完后回调函数
			fnDrawCallback: function(){
				var $tb=$(this);
				var tbCont =$tb.parents(".dataTables_wrapper");
				var $tblen=tbCont.find(".dataTables_length");
				var $tbinfo =tbCont.find(".dataTables_info");
				$tblen.css({"display":"inline"});
				$tbinfo.after($tblen);
				
				//设置表格的保存按钮
            	saveTableConfig(tableMain);
				 //编辑信息
				$tb.find("tbody").off().on("click", ".btnEdit", function () {
					var data = tables.api().row($(this).parents("tr")).data(); 
					var url=URL_EDIT+"?";
					for (var i=0;i<keyProperties.length;i++){
						if (i>0){
							url+="&";
						}
						url+=keyProperties[i]+"="+data[keyProperties[i]];
					}
					top.showTopDialog({
					 	title:"编辑信息",
					 	url:url,
					 	top:1,
					 	width:1200,
					 	height:600,
					 	btns:[{
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
		 					,window
		 				});
					 
				 }); 
				 //查看
				$tb.find("tbody").on("click", ".btnView", function () {
					var data = tables.api().row($(this).parents("tr")).data();
					var url=URL_SHOW+"?";
					for (var i=0;i<keyProperties.length;i++){
						if (i>0){
							url+="&";
						}
						url+=keyProperties[i]+"="+data[keyProperties[i]];
					}
					top.showTopDialog({
						title:"信息详情",
						url:url,
						top:1,
						width:1200,
						height:600,
						btns:[{
					 			caption:"&times;",
					 			className:"btn",
					 			click:function(){
					 				this.closeDlg();
					 			}
					 		}],
						win:window
					});
				}); 
				
				//删除
				$tb.find("tbody").on("click", ".btnDelete", function () {
					var data = tables.api().row($(this).parents("tr")).data();
					var url=URL_DELETE+"?state=3&";
					for (var i=0;i<keyProperties.length;i++){
						if (i>0){
							url += "&";
						}
						url += keyProperties[i]+"="+data[keyProperties[i]];
					}
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
			 						url:url,
			 						success:function(data){
			 							if(data.state == 0){
			 								top.bootbox.alert('删除成功！');
			 								reloadData();
			 							}else{
			 								top.bootbox.alert('删除失败');
			 							}
			 						}
			 					});
			 				}
			 			}
			 		});
			
				});
				
				hideLoading();
			}
		};
		if (opts) {
			$.extend(tableOptions, opts);
		}
		var tables = $("#"+tableId).dataTable(tableOptions);
		return tables;
	}
	
	/**
	 * 获取方法名称
	 */
    Function.prototype.getName = function(){
        return this.name || this.toString().match(/function\s*([^(]*)\(/)[1]
    }
    
 	/**
 	设置编辑框
 	editorType分为：Text,Date,Select，默认为Text
 	当为Select时，需要指定dataSrc来源，为数组格式，如：[{label:"男",value:"1"},{label:"女",value:"0"}]
 	*/
 	function editTd(tb,td){
 		var $td=$(td);
		var data=tb.row($td.parents("tr")).data();
		var idxObj = tb.cell(td).index();
		var cell=tb.settings()[0].aoColumns[idxObj.column];
		var rowIndex=idxObj.row;
		var name = cell.name;
		var editorType= cell.editorType;
		//不可编辑，则直接跳过
		if (!cell.editable) {
			return;
		}
		var editor;
		var changeEvent="blur";
		if (editorType=="Select") {
			editor=$("<select></select>");
			if (cell.dataSrc){
				for (var i=0;i<cell.dataSrc.length;i++){
					var d=cell.dataSrc[i];
					editor.append("<option value='"+d.value+"'>"+d.label+"</option>")
				}
			}
			changeEvent="change";
		} else {
			editor= $("<input type='text' style='width:100%;z-index:9999;color:#000;' name='"+cell.name+"'>");
		}
		if (editorType=="Date"){
			$(editor).datepicker({
	   			format: 'yyyy-mm-dd',
	   			language:"zh-CN",
	   			weekStart: 1,
	   			autoclose:true,
	   			onSelect: function(dateText, inst) {
	   				console.log(dateText,inst);
	   			},
	   			onClose: function(dateText, inst) {
	   				console.log(dateText,inst);
	   			}
	   		});
			changeEvent="change";
		}
		
		editor.on(changeEvent,function(){
			data[name]=this.value;
			tb.cell(td).data(this.value);
			if (cell.callback) {
				if (typeof(cell.callback)=="function"){
					cell.callback.apply(tb,[data,idxObj]);
				} else {
					var call = eval("("+cell.callback+")");
					call.apply(tb,[data,idxObj]);
				}
			}
		}).on("keydown",function(e){
			e = e || event;
			//上箭头
			if (e.keyCode==38) {
				var prevTr = $td.parents("tr").prev();
				var cell = prevTr.find("td:eq("+idxObj.column+")");
				cell.trigger("click");
			} else if (e.keyCode==40) { //下箭头
				var prevTr = $td.parents("tr").next();
				var cell = prevTr.find("td:eq("+idxObj.column+")");
				cell.trigger("click");
			} else if (e.keyCode==9 || e.keyCode==13) { //tab或回车键
				//这里要查询下一个可编辑的单元格
				var cell;
				var columns = tb.settings()[0].aoColumns;
				for (var x=idxObj.column+1;x<columns.length;x++){
					if (columns[x].editable){
						cell =$td.parents("tr").find("td:eq("+x+")");
						break;
					}
				}
				if (cell){
					cell.trigger("click");
				}
				e.preventDefault();
			}
		});
		editor.val(data[name]);
		$td.empty().append(editor);
		editor.focus();
		
		
 	}
 	
 	//保存表格的布局
 	function saveTableConfig(tb){
 		var saveTd=$(tb.table().header()).find("th.select-checkbox");
    	if (saveTd.length>0) {
    		var btn=$("<i class='fa fa-save'></i>");
    		btn.on("click",function(){
    			//console.log("保存表格定义");
    			var columns = tb.settings()[0].aoColumns;
    			var newColDefs=new Array();
    			$.each(columns,function(i,col){
    				
    				var width=col.width;
    				if (!width){
    					width=parseInt(col.sWidth);
    				}
    				var opt = {
    					sortable:!!col.bSortable,
    					data:col.data,
    					title:col.title,
    					width:width,
    					name:col.name,
    					editable:!!col.editable
    				};
    				if (col.editorType){
    					opt.editorType=col.editorType;
    				}
    				if (typeof(col.callback)=="function"){
    					opt.callback=col.callback.getName();
    				}
    				if (col.defaultContent){
    					opt.defaultContent = col.defaultContent;
    				}
    				if (col.className){
    					opt.className=col.className;
    				}
    				newColDefs.push(opt);
    			});
    			console.log(JSON.stringify(newColDefs));
    			//这里调用保存请求 TODO
    			
    		});
    		saveTd.empty().append(btn);
    	}
 	}
	
	//显示添加主数据窗口
	function showAddMainInfo(){
		top.showTopDialog({
			title:"添加信息",
			url:URL_ADD,
			top:1,
			width:1200,
			height:600,
		 	btns:[{
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
		 		}
			],
			win:window
		});
	}
	
	//添加页面保存数据
	//保存表单数据
	function saveData(dlg,formId){
		formId=formId || "formData";
		var checkResult=checkForm("#"+formId);
		var msg=checkResult.msg;
 		msg = msg.distinct();
 		if (!checkResult.state){
 			if (msg.length==0){
 				msg.push("请输入必填的内容！");
 			}
 			top.bootbox.alert(msg.join("<br/>"));
	 		return false;
 		}
 		var $submiting = top.showSubmitLoading();
		var data = $("#"+formId).serialize();
		$.ajax({
			url:URL_SAVE,
			type:"post",
			data:data,
			success:function(res){
				$submiting.modal("hide");
				if (res.state==0){
					top.bootbox.alert('保存成功！',function() {
						if (dlg){
							dlg.win.reloadData();
							dlg.closeDlg();
						}
					});
				} else {
					top.bootbox.alert(res.message);
				}
			}
		});
	}
	
	//加载表单主体数据
	function reloadFormData(formId){
		var data={};
		var pageParams=UrlParm.parmMap();
		for (var i=0;i<keyProperties.length;i++){
			data[keyProperties[i]]=pageParams[keyProperties[i]];
		}
		$.ajax({
 			url:URL_DATA,
 			data:data,
 			success:function(res){
				if (res.state==0){
					fillFormData(res.data,formId);
				} else {
					top.bootbox.alert(res.message);
				}
				loadDicts(res.data,function(){
					hideLoading();
				});
			}
 		});
	}
	
	//加载页面dom主体数据
	function reloadNodeData(){
		var data={};
		var pageParams = UrlParm.parmMap();
		for (var i=0;i<keyProperties.length;i++){
			data[keyProperties[i]]=pageParams[keyProperties[i]];
		}
		$.ajax({
 			url:URL_DATA,
 			data:data,
 			success:function(res){
				if (res.state==0){
					fillNodeData(res.data);
				} else {
					alert(res.message);
				}
				hideLoading();
			}
 		});
	}
	

 	//重置表单
	function resetFormQuery(formId){
		formId=formId ||"formQuery";
		$("#"+formId)[0].reset();
		$("#"+formId+" input:hidden").val("");
		reloadData();
	}
	
	var UrlParm = function () { // url参数
	     var data, index;
	     (function init() {
	         data = [];
	         index = {};
	         var u = window.location.search.substr(1);
	         if (u != '') {
	             var parms = decodeURIComponent(u).split('&');
	             for (var i = 0, len = parms.length; i < len; i++) {
	                 if (parms[i] != '') {
	                     var p = parms[i].split("=");
	                     if (p.length == 1 || (p.length == 2 && p[1] == '')) {
	                         data.push(['']);
	                         index[p[0]] = data.length - 1;
	                     } else if (typeof (p[0]) == 'undefined' || p[0] == '') {
	                         data[0] = [p[1]];
	                     } else if (typeof (index[p[0]]) == 'undefined') { // c=aaa
	                         data.push([p[1]]);
	                         index[p[0]] = data.length - 1;
	                     } else {// c=aaa
	                         data[index[p[0]]].push(p[1]);
	                     }
	                 }
	             }
	         }
	     })();
	     return {
	         // 获得参数,类似request.getParameter()
	         parm: function (o) { // o: 参数名或者参数次序
	             try {
	                 return (typeof (o) == 'number' ? data[o][0] : data[index[o]][0]);
	             } catch (e) {
	             }
	         },
	         //获得参数组, 类似request.getParameterValues()
	         parmValues: function (o) { //  o: 参数名或者参数次序
	             try {
	                 return (typeof (o) == 'number' ? data[o] : data[index[o]]);
	             } catch (e) { }
	         },
	         //是否含有parmName参数
	         hasParm: function (parmName) {
	             return typeof (parmName) == 'string' ? typeof (index[parmName]) != 'undefined' : false;
	         },
	         // 获得参数Map ,类似request.getParameterMap()
	         parmMap: function () {
	             var map = {};
	             try {
	                 for (var p in index) { map[p] = data[index[p]]; }
	             } catch (e) { }
	             return map;
	         }
	     }
	 } ();

	//设置ajax添加header，设置出错后的显示
	$.ajaxSetup({
		cache: false,
		dataType: "json",
		headers: { // 默认添加请求头
			"token": sessionStorage.getItem("token")
		} ,
		error: function(jqXHR, textStatus, errorMsg){ // 出错时默认的处理函数
			top.bootbox.alert('网络错误：' + errorMsg );	
		}
	});
	
	//页面初始化
	$(document).ready(function(){

		loadDicts(null,function(){
			hideLoading();
		});
	});