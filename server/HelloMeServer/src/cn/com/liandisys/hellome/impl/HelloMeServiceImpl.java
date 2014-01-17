package cn.com.liandisys.hellome.impl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jws.WebService;

import net.sf.json.JSONObject;
import sun.misc.BASE64Decoder;
import cn.com.liandisys.hellome.dao.HelloMeService;
import cn.com.liandisys.hellome.dbconnection.DBConnectionManager;
import cn.com.liandisys.hellome.dbop.DBOperation;
import cn.com.liandisys.hellome.entity.MailEntity;

@WebService
public class HelloMeServiceImpl implements HelloMeService {
	
	private static final String SAVE_PATH = "E:\\HelloMeServerImage\\";
	private static final String REGISTER_SQL = "INSERT INTO  USR(USER_NAME, PASSWORD) VALUES(?, ?)";
	private static final String LOGIN_SQL = "SELECT PASSWORD FROM USR WHERE USER_NAME = ?";
	private static final String SAVE_SQL = "INSERT INTO MAILBOX(SEND_FLAG, SEND_TIME, RECEIVE_TIME, SUBJECT, TEXT, SEND_FILE_NAME, IMAGE_PATH, USER_NAME) VALUES(0, ?, ?, ?, ?, ?, ?, ?)";
	private static final String GETNEWMAIL_SQL = "SELECT MAIL_ID, SUBJECT, TEXT, SEND_TIME, RECEIVE_TIME, IMAGE_PATH, SEND_FILE_NAME, USER_NAME FROM MAILBOX WHERE RECEIVE_TIME <= ? AND USER_NAME = ? AND SEND_FLAG = 0";
	private static final String UPDATEFLAG_SQL = "UPDATE MAILBOX SET SEND_FLAG = 1 WHERE MAIL_ID = ?";
	
	@Override
	public String register(String username, String password) {
		if (null == username || null == password || "".equals(username) || "".equals(password)) {
			return convertToJson("failed", "用户名或者密码不能为空！", null);
		}
		boolean result = DBOperation.excuteUpdate(REGISTER_SQL, new String[]{username, password});
		if (result == false) {
			return convertToJson("failed", "注册失败！", null);
		}
		return convertToJson("success", "注册成功！", null);
	}

	@Override
	public String login(String username, String password) {
		System.out.println(username + "~~~~~~~~~~~~~~~~~~~~~~~~" + password);
		if (null == username.trim() || null == password.trim() || "".equals(username.trim()) || "".equals(password.trim())) {
			return convertToJson("failed", "用户名或者密码不能为空！", null);
		}
		String dbPswd = DBOperation.excuteQuery(LOGIN_SQL, new String[]{username.trim()});
		System.out.println(dbPswd + "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		if (password.trim().equals(dbPswd)) {
			return convertToJson("success", "登录成功！", null);
		} else {
			return convertToJson("failed", "用户名密码错误！", null);
		}
		
	}

	@Override
	public String saveMail(String sendTime, String receiveTime, String username, String mailTitle, String mailContent, String imageName, String imageBuffer) {
		if (null == mailContent || "".equals(mailContent)) {
			return convertToJson("failed", "邮件不能为空！", null);
		}
		
        FileOutputStream fos = null;
        Date now = new Date(); 
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        String name = dateFormat.format(now);
        try{
        	boolean result = false;
        	if (null != imageBuffer && !"".equals(imageBuffer)) {
        		result = DBOperation.excuteUpdate(SAVE_SQL, new String[]{sendTime, receiveTime, mailTitle, mailContent, imageName, SAVE_PATH + name + ".jpg", username});
        	} else {
        		result = DBOperation.excuteUpdate(SAVE_SQL, new String[]{sendTime, receiveTime, mailTitle, mailContent, imageName, "", username});
        	}
             
            if (result == false) {
            	return convertToJson("failed", "保存失败！", null);
            }
//            System.out.print(imageBuffer);
        	if (null != imageBuffer && !"".equals(imageBuffer)) {
                String toDir = SAVE_PATH;  
                byte[] buffer = new BASE64Decoder().decodeBuffer(imageBuffer);
                File destDir = new File(toDir);  
                if(!destDir.exists()) {
                	destDir.mkdir();
                }
                fos = new FileOutputStream(new File(destDir, name + ".jpg"));  
                fos.write(buffer);  
                fos.flush();  
                fos.close();
        	}
            return convertToJson("success", "保存成功！", null);
        }catch(Exception e){  
            e.printStackTrace();
            
        }
        
        return convertToJson("failed", "保存失败！", null);
	}

//	@Override
//	public String getMailList(String username) {
//		// TODO Auto-generated method stub
//		return null;
//	}

	@Override
	public String getNewMails(String username, String currentTime) {
		if (null == username || null == currentTime || "".equals(username) || "".equals(currentTime)) {
			return convertToJson("failed", "获取失败！", null);
		}
		int result = DBOperation.mailExistsCheck(username, currentTime);
		if (result == 0) {
			return convertToJson("failed", "没有新邮件！", null);
		}
		List<MailEntity> list = DBOperation.excuteMailQuery(GETNEWMAIL_SQL, new String[]{currentTime, username});
		if (null == list) {
			return convertToJson("failed", "获取失败！", null);
		}
		MailEntity mail = null;
		for (int i = 0; i < list.size(); i++) {
			mail = list.get(i);
			DBOperation.excuteSendFlagUpdate(UPDATEFLAG_SQL, new String[]{mail.getMailId() + ""});
		}
		return convertToJson("success", "获取成功！", list);
	}
	
	private String convertToJson (String status, String message, List<MailEntity> list) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		map.put("message", message);
		if (null != list) {
			map.put("mails", list);
		}

		JSONObject jsonObject = JSONObject.fromObject(map);
		
		return jsonObject.toString();
	}
}
