package com.mars.office.utils;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;

import sun.misc.BASE64Encoder;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * 导出数据到word文件，把word格式调整完成后，保存为xml结构的文件，然后用文本编辑器修改数据填充项
 * @author mars.liu
 *
 */
public class OfficeUtil {
    private static Configuration configuration = null;  
    
    static {  
        configuration = new Configuration(Configuration.VERSION_2_3_23);  
        configuration.setDefaultEncoding("utf-8");  
    }  
  
    public static void createDoc(Map<String,Object> dataMap,String fileName) throws UnsupportedEncodingException {  
        //dataMap 要填入模本的数据文件  
        //设置模本装置方法和路径,FreeMarker支持多种模板装载方法。可以重servlet，classpath，数据库装载，  
        //这里我们的模板是放在template包下面  
        configuration.setClassForTemplateLoading(OfficeUtil.class, "/template");  
        Template t=null;  
        try {  
            //test.ftl为要装载的模板  
            t = configuration.getTemplate("template.ftl");
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        //输出文档路径及名称  
        File outFile = new File(fileName);  
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
          
        //System.out.println("---------------------------");  
    }
    
    public static String getImageBinary(String imagepath) {  
        File f = new File(imagepath);  
        BufferedImage bi;  
        try {  
            bi = ImageIO.read(f);  
            ByteArrayOutputStream baos = new ByteArrayOutputStream();  
            ImageIO.write(bi, "jpg", baos);  
            byte[] bytes = baos.toByteArray();  
            BASE64Encoder encoder = new BASE64Encoder();
            //return Base64Util.encode(bytes).trim();  
            return encoder.encode(bytes);
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        return null;  
    }
    
    public static void main(String[] args) throws UnsupportedEncodingException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("title","测试标题");
		params.put("date","2015-11-09");
		Map<String,Object> img = new HashMap<String, Object>();
		img.put("title","图片标题");
		img.put("content", getImageBinary("D:/Documents/Pictures/logo.jpg"));
		img.put("name","logo.jpg");
		
		Map<String,Object> img2 = new HashMap<String, Object>();
		img2.put("title","图片标题");
		img2.put("content", getImageBinary("D:/Documents/Pictures/24586235.jpg"));
		img2.put("name","24586235.jpg");
		params.put("images",new Object[]{img,img2});
	
		createDoc(params,"d:/mytest.doc");
	}
}  
