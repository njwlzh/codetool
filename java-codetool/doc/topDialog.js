//显示左上角搜索框
var TMPL_HTML_TIP='<div id="tmplTip" class="ym-filter-box box box-widget" style="width: 470px; display: none;position:absolute"></div>';
//页面正在加载进度条
var TMPL_HTML_LOADING='<div class="modal fade" id="topSubmitLoadingTmpl" style="z-index:99999" tabindex="-1" role="dialog" aria-labelledby="modalLabel">'+
			'<div class="modal-dialog" role="document"><div class="modal-content"><p class="text-center info" style="margin-top:50px;height:80px;padding-top:30px;"></p></div></div></div>';
//弹出对话框
var TMPL_HTML_DIALOG='<div class="modal fade" id="topModalTmpl"  tabindex="-1" role="dialog" aria-labelledby="modalLabel">'+
	'<div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><div class="pull-right dlg-btns" style="margin-top:-1px;">' +
	'<div class="pull-left" style="margin-top: -5px;"><a class="dlg-btnSave btn" style="padding-right:0;"><i class="fa fa-floppy-o"></i> 确定</a></div>' +
	'<button type="button" style="margin-left: 5px;margin-top: 0px;border-left: 1px solid #000;padding-left: 5px;" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>' +
	'<h4 class="modal-title"></h4></div><div class="dlg-content-body"><iframe style="width:100%;height:400px;" class="dlg-iframe" frameborder="0"></iframe></div></div></div></div>';

var dialogs=[];
//关闭所有对话框
function closeAlldialogs(){
	$.each(dialogs,function(i,dlg){
		if (dlg){
			dlg.closeDlg();
		}
	});
	dialogs=[];
}

//显示一个对话框
function showTopDialog(opts){
	var dlg = new TopDialog(opts);
	dialogs.push(dlg);
	return dlg;
}

//取得当前的对话框
function getCurrentDialog(){
	if (dialogs.length>0){
		return dialogs[dialogs.length-1];
	}
	return null;
}

//显示加载程序进度
var isSubmiting=false;
function showSubmitLoading(info){
	if (isSubmiting){
		throw "正在提交数据，请勿重复提交！";
	}
	if (!info) {
		info="<i class='fa fa-refresh fa-spin'></i> 正在提交数据......";
	} else {
		info="<i class='fa fa-refresh fa-spin'></i> "+info;
	}
	isSubmiting=true;
	var modal=$("#topSubmitLoadingTmpl");
	if (modal.length==0){
		modal=$(TMPL_HTML_LOADING);
		modal.find(".info").html(info);
		modal.modal({backdrop: 'static', keyboard: false});
		modal.on("hidden.bs.modal",function(){
			isSubmiting=false;
		});
		$(document.body).append(modal);
	}
	return modal;
}
 

/**
 * opts包含参数：
 title 窗口标题
 contentType 窗口显示内容的内型，0=独立url页面（默认），1=dom结构
 topPos 距顶部距离
 width 窗口宽
 height 窗口高
 btns 窗口显示的按钮组
 win 弹出窗口的窗口对象
 html 显示到窗口的html代码
 onOpen: 窗口打开后执行事件
 onClose: 窗口关闭时执行事件
 */
var TopDialog=function(opts){
	var winWidth=$(window).width();
	var winHeight=$(window).height();
	var _this=this;
	
	var topPos = opts.topPos || "20";
	var height=opts.height || "400";
	var width=opts.width || "600";
	var btnShow = opts.btnShow===false?0:1;
	
	width=parseInt(width);
	height=parseInt(height);
	if (width>winWidth){
		width=winWidth-50;
	}
	if (height>winHeight){
		height=winHeight-50;
	}
	
	if (opts.window){
		_this.win=opts.window;
	}
	//此方法仅用于iframe弹窗
	_this.saveData=function(){
		_this.iframe.contentWindow.saveData(_this);
	}
	//此方法仅用于iframe弹窗
	_this.getReturnData=function(){
		var data = _this.iframe.contentWindow.getReturnData(_this);
		return data;
	}
	_this.closeDlg=function(){
		_this.modal.on("hidden.bs.modal",function(){
			_this.modal.remove();
		});
		_this.modal.modal("hide");
		
		var dlgIdx=dialogs.indexOf(_this);
		if (dlgIdx!=-1){
			dialogs.remove(dlgIdx);
		}
	}
	_this.mandatoryData=function(){
		var data = _this.iframe.contentWindow.mandatoryData(_this);
		return data;
	}
	var left = (winWidth-width)/2;
	var iframeHeight = height-70;
	var dlgId = "dlg"+(new Date().getTime());
	var $showModal = $(TMPL_HTML_DIALOG);
	this.modal=$showModal;
	$showModal.attr("id",dlgId);
	$showModal.find(".modal-content").css({"width":width+"px","height":height+"px"});
	$showModal.find(".modal-dialog").css({"top":topPos+"px","position":"fixed","width":width+"px","height":height+"px",left:left+"px","margin-top":0});
	//$("#contentModelId").css({"width":width,"height":height,left:left});
	$showModal.modal({backdrop: 'static', keyboard: false});
	if(opts.title){
		$showModal.find(".modal-title").text(opts.title);
	}else{
		$showModal.find('.modal-header').css('display','none');
	}
	if (opts.contentType==1){
		$showModal.find(".dlg-content-body").html(opts.html);
	} else {
		var $iframe = $showModal.find(".dlg-iframe");
		_this.iframe = $iframe[0];
		$iframe.css({height:iframeHeight}).attr("src",opts.url);
	}
	//对话框按钮
	if(btnShow==1){
		if (opts.btns) {
			//dlg-btns
			var $box=$showModal.find(".dlg-btns");
			$box.empty();
			$.each(opts.btns,function(i,btn){
				var $btn=$(" <a id='"+btn.id+"' class='"+btn.className+"'><i class='"+btn.icon+"'></i> "+btn.caption+"</a> ");
				$btn.click(function(){
					if (btn.click){
						btn.click.call(_this);
					}
				});
				$box.append($btn);
			});
		} else {
			$showModal.find(".dlg-btnSave").click(function(){
				if (_this.saveData){
					_this.saveData(_this);
				} else {
					_this.closeDlg();
				}
			});
		}
	}else{
		$showModal.find(".dlg-btns").find('.dlg-btnSave').css('display','none');
	}
	if (opts.onOpen){
		opts.onOpen.call(_this);
	}
	return this;
}
/**
 * 关闭窗口
 * @param dlgId 若没有传入参数，则默认关门全部窗口
 */
function closeDialogs(dlgId){
	//$('#showModal').modal('hide');
	if (dlgId){
		$('#'+dlgId).modal("hide");
		$('#'+dlgId).remove();
	} else {
		$('.modal').modal('hide');
	}
}

/**
 * 显示搜索列表页面左上角的过滤条件框
 */
function showTip(srcObj,data,callback,opts){
	new FilterTip(srcObj,data,callback,opts);
}

/**
 * 显示tip窗口，比如显示用户信息，筛选窗口
 * @param srcObj 从哪里点击显示窗口，即触发按钮或其它标签
 * @param data 如果有参数，用此传递，采用json格式
 * @param callback 显示窗口后的回调函数，比如显示完窗口后，需要填充到tip窗口的内容
 * @param opts 弹窗设置，包含 要显示到tip框的标签tagId,width, height等
 */
 function FilterTip(srcObj,data,callback,opts){
	 	var _this=this;
	 	var obj = $(srcObj);
	 	var offset=obj.offset();
	 	this.close=function(){
	 		_this.dlg.hide();
	 	}
	 	var visibleTip=$(".ym-filter-box:visible");
	 	$.each(visibleTip,function(i,tip){
	 		
		 	$(document.body).append($(tip).children().eq(0).hide());
	 	});
	 	//关闭其它tip窗口
	 	visibleTip.remove();
	 	this.dlg = $(TMPL_HTML_TIP);
	 	this.dlg.attr("id","tip"+(new Date().getTime()));
	 	$(document.body).append(this.dlg);
		this.dlg.show();
		var width=$(window).width();
		var height=$(document.body).prop('scrollHeight');
		this.dlg.empty();
		
		callback.apply(_this,[data]);
		var dlgWidth = Math.max(parseInt(this.dlg.css("width")),this.dlg.width());
		var dlgHeight=Math.max(parseInt(this.dlg.css("height")),this.dlg.height());
		var left=offset.left;
		var _top=offset.top+obj.outerHeight();
		if (left+dlgWidth>width){
			left=left-dlgWidth;
		}
		if (_top+dlgHeight>height){
			_top=_top-dlgHeight-obj.outerHeight();
		}
		//_top=_top+$(document).scrollTop();
		if (_top<0){
			_top=offset.top+obj.outerHeight();
		}
		this.dlg.css({left:left,top:_top});
		if (opts){
			if (opts.width){
				this.dlg.width(opts.width);
			}
			if (opts.height){
				this.dlg.height(opts.height);
			}
			var tagId=opts.tagId;
			if (tagId){
				if (tagId.indexOf("#")!=0) {
					tagId="#"+tagId;
				}
				$(tagId).show().appendTo(this.dlg);
			}
		}
 }
 
