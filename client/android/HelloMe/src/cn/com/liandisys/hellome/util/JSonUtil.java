package cn.com.liandisys.hellome.util;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

import android.util.Base64;

public class JSonUtil {

	// 获得key对应的value值
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

	// 获取邮件
	public static List<MailBoxInfoEntity> getMails(String json) {
		List<MailBoxInfoEntity> list = new ArrayList<MailBoxInfoEntity>();
		try {
			if (null != json) {
				JSONObject response = new JSONObject(json);
				JSONArray array = response.getJSONArray(Const.MAILS);
				for (int i = 0; i < array.length(); i++) {
					JSONObject object = new JSONObject(array.getString(i));
					MailBoxInfoEntity mailbox = new MailBoxInfoEntity();
					// 获得发送时间
					mailbox.setSendTime(object.getString(Const.JSON_SEND_TIME));
					// 接收时间
					mailbox.setGetTime(object.getString(Const.JSON_RECEIVE_TIME));
					// 用户名
					mailbox.setHost(object.getString(Const.JSON_USER_NAME));
					// 标题
					mailbox.setTitle(object.getString(Const.JSON_MAIL_TITLE));
					// 内容
					mailbox.setContent(object.getString(Const.JSON_MAIL_CONTENT));
					// 图片名
					mailbox.setImageName(object.getString(Const.JSON_IMAGE_NAME));
					// 图片String
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
