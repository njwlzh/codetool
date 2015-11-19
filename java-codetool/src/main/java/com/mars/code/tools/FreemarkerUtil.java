package com.mars.code.tools;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.mars.office.utils.OfficeUtil;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class FreemarkerUtil {
private static Configuration configuration = null;  
    
    static {  
        configuration = new Configuration(Configuration.VERSION_2_3_23);  
        configuration.setDefaultEncoding("utf-8"); 
        configuration.setClassForTemplateLoading(OfficeUtil.class, "/sourcetemplate");
    } 

    public static void createDoc(Object obj,String template,String saveFilePath) {
    	Template t=null;  
        try {  
            //test.ftl为要装载的模板  
            t = configuration.getTemplate(template+".ftl");
        } catch (IOException e) {  
            e.printStackTrace();  
        }
        Map<String,Object> val = (Map<String,Object>)JSON.toJSON(obj);
      //输出文档路径及名称  
        File outFile = new File(saveFilePath);  
        Writer out = null;  
        FileOutputStream fos=null;
        try {  
            fos = new FileOutputStream(outFile);  
            OutputStreamWriter oWriter = new OutputStreamWriter(fos,"UTF-8");  
            //这个地方对流的编码不可或缺，使用main（）单独调用时，应该可以，但是如果是web请求导出时导出后word文档就会打不开，并且包XML文件错误。主要是编码格式不正确，无法解析。  
            //out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile)));  
             out = new BufferedWriter(oWriter);   
        } catch (FileNotFoundException e1) {  
            e1.printStackTrace();  
        } catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}  
           
        try {  
            t.process(val, out);  
            out.close();  
            fos.close();  
        } catch (TemplateException e) {  
            e.printStackTrace();  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }
    
    public static void createDoc(Map<String,Object> dataMap,String template,String saveFilePath){
    	Template t=null;  
        try {  
            //test.ftl为要装载的模板  
            t = configuration.getTemplate(template+".ftl");
        } catch (IOException e) {  
            e.printStackTrace();  
        }
      //输出文档路径及名称  
        File outFile = new File(saveFilePath);  
        Writer out = null;  
        FileOutputStream fos=null;  
        try {  
            fos = new FileOutputStream(outFile);  
            OutputStreamWriter oWriter = new OutputStreamWriter(fos,"UTF-8");  
            //这个地方对流的编码不可或缺，使用main（）单独调用时，应该可以，但是如果是web请求导出时导出后word文档就会打不开，并且包XML文件错误。主要是编码格式不正确，无法解析。  
            //out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile)));  
             out = new BufferedWriter(oWriter);   
        } catch (FileNotFoundException e1) {  
            e1.printStackTrace();  
        } catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}  
           
        try {  
            t.process(dataMap, out);  
            out.close();  
            fos.close();  
        } catch (TemplateException e) {  
            e.printStackTrace();  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }
    
    public static String createString(Object dataMap,String template){
    	Template t=null;  
        try {  
            //test.ftl为要装载的模板  
            t = configuration.getTemplate(template+".ftl");
        } catch (IOException e) {  
            e.printStackTrace();  
        }
      //输出文档路径及名称  
        StringWriter out = new StringWriter();  
           
        try {  
            t.process(dataMap, out);  
        } catch (TemplateException e) {  
            e.printStackTrace();  
        } catch (IOException e) {  
            e.printStackTrace();  
        }
        return out.getBuffer().toString();
    }
    
}
