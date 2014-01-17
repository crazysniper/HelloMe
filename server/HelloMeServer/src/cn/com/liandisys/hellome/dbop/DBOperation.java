package cn.com.liandisys.hellome.dbop;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import cn.com.liandisys.hellome.dbconnection.DBConnectionManager;
import cn.com.liandisys.hellome.entity.MailEntity;

public class DBOperation {
	
	private static PreparedStatement ps = null;
	private static Connection con = null;
	private static ResultSet rs = null;
	
	private static String getImageBuffer(String imagePath) {
		String imageBuffer = "";
		try {
			if (null == imagePath || "".equals(imagePath)) {
				return imageBuffer;
			}
			FileInputStream fis = new FileInputStream(imagePath);
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();  
	        byte[] buffer = new byte[1024];  
	        int count = 0;  
	        while((count = fis.read(buffer)) >= 0){  
	            baos.write(buffer, 0, count);  
	        }  
	        imageBuffer = new String((new sun.misc.BASE64Encoder()).encode(baos.toByteArray()));
	        fis.close(); 
		} catch(Exception e) {
			e.printStackTrace();
		}
		return imageBuffer;
	}
	
	public static List<MailEntity> excuteMailQuery(String sql, String[] paramters) {
		if (null == paramters) {
			return null;
		}
		List<MailEntity> list = new ArrayList<MailEntity>();
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement(sql);
			if (null != paramters) {
				for (int i = 0; i < paramters.length; i++) {
					ps.setString(i + 1, paramters[i].trim());
				}
			}
			rs = ps.executeQuery();
			
			while (rs.next()) {
				MailEntity mail = new MailEntity();
				mail.setSendTime(rs.getString("SEND_TIME"));
				mail.setReceiveTime(rs.getString("RECEIVE_TIME"));
				mail.setImageName(rs.getString("SEND_FILE_NAME"));
				mail.setImageBuffer(getImageBuffer(rs.getString("IMAGE_PATH")));
				mail.setMailTitle(rs.getString("SUBJECT"));
				mail.setMailContent(rs.getString("TEXT"));
				mail.setUserName(rs.getString("USER_NAME"));
				mail.setMailId(rs.getInt("MAIL_ID"));
				
				list.add(mail);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs ,ps, con);
		}
		return list;
	}
	
	public static String excuteQuery(String sql, String[] paramters) {
		String result = null;
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement(sql);
			if (null != paramters) {
				for (int i = 0; i < paramters.length; i++) {
					ps.setString(i + 1, paramters[i].trim());
				}
			}
			rs = ps.executeQuery();
			while (rs.next()) {
				result = rs.getString("PASSWORD");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs ,ps, con);
		}
		return result;
	}
	
	public static boolean excuteUpdate(String sql, String[] paramters) {		
		if (userNameCheck(paramters[0])) {
			return false;
		}
		boolean result = false;
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement(sql);
			if (null != paramters) {
				for (int i = 0; i < paramters.length; i++) {
					ps.setString(i + 1, paramters[i].trim());
				}
			}
			ps.executeUpdate();
			result = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs, ps, con);
		}
		return result;
	}
	
	public static boolean excuteSendFlagUpdate(String sql, String[] paramters) {
		boolean result = false;
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement(sql);
			if (null != paramters) {
				for (int i = 0; i < paramters.length; i++) {
					ps.setString(i + 1, paramters[i].trim());
				}
			}
			ps.executeUpdate();
			result = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs, ps, con);
		}
		return result;
	}
	
	public static int mailExistsCheck(String userName, String receiveTime) {
		int result = 0;
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement("SELECT COUNT(1) AS NUMBER FROM MAILBOX WHERE RECEIVE_TIME <= ? AND USER_NAME = ? AND SEND_FLAG = 0");
			ps.setString(1, receiveTime);
			ps.setString(2, userName);
			rs = ps.executeQuery();
			while (rs.next()) {
				result = rs.getInt("NUMBER");
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs ,ps, con);
		}
		return result;
	}
	
	private static boolean userNameCheck(String userName) {
		boolean result = false;
		try {
			con = DBConnectionManager.getConnection();
			ps = con.prepareStatement("SELECT USER_NAME FROM USR WHERE USER_NAME = ?");
			ps.setString(1, userName);
			rs = ps.executeQuery();
			while (rs.next()) {
				result = true;
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectionManager.closeConnection(rs ,ps, con);
		}
		return result;
	}
	
}
