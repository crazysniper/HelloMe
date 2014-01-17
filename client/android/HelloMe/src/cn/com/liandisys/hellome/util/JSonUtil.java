package cn.com.liandisys.hellome.util;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfo;

import android.util.Base64;

public class JSonUtil {
	
	public static String getJSonString(String key, String json) {
		String result = null;
		try {
			if (null != json) {
				JSONObject object = new JSONObject(json);
				result = object.getString(key);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public static List<MailBoxInfo> getMails(String json) {
		List<MailBoxInfo> list = new ArrayList<MailBoxInfo>();;
		try {
			if (null != json) {
				JSONObject response = new JSONObject(json);
				JSONArray array = response.getJSONArray(Const.MAILS);
				for (int i = 0; i < array.length(); i++) {
					JSONObject object = new JSONObject(array.getString(i));
					MailBoxInfo mailbox = new MailBoxInfo();
					mailbox.setSendTime(object.getString(Const.JSON_SEND_TIME));
					mailbox.setGetTime(object.getString(Const.JSON_RECEIVE_TIME));
					mailbox.setHost(object.getString(Const.JSON_USER_NAME));
					mailbox.setTitle(object.getString(Const.JSON_MAIL_TITLE));
					mailbox.setContent(object.getString(Const.JSON_MAIL_CONTENT));
					mailbox.setImageName(object.getString(Const.JSON_IMAGE_NAME));
					mailbox.setImageBuffer(object.getString(Const.JSON_IMAGE_BUFFER));
					list.add(mailbox);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public static byte[] getBytes(String str) {
		byte b[] = Base64.decode(str, Base64.DEFAULT);
		return b;
	}

}
