package cn.com.liandisys.hellome.service;

import java.io.IOException;

import org.ksoap2.serialization.SoapObject;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.util.CalendarUtil;
import cn.com.liandisys.hellome.util.SoapUtil;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.util.Log;

public class DownloadService extends Service  {

	private static final String TAG = "DownloadService";
	
	private SharedPreferences sharedPreferences;
	

	@Override
	public IBinder onBind(Intent intent) {
		Log.e(TAG, "on bind");
		return null;
	}
	
	/*
	 * 如果Service还没有运行，则先调用onCreate()，然后调用onStartCommand，，旧版本调用onStart()
	 * 如果已经运行，则只要调用onStartCommand，，旧版本调用onStart()
	 * 所有一个Service的onStart()可能会重复调用多次
	 */
	@Override
	public void onCreate() {
		Log.e(TAG, "on creat");
		super.onCreate();
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		sharedPreferences = this.getSharedPreferences(Const.SP_NAME,Context.MODE_PRIVATE);
		return super.onStartCommand(intent, flags, startId);
	}
	
	Runnable runnable = new Runnable() {

		@Override
		public void run() {
			Log.e(TAG, "start service");
			// 获得用户名
			String host = sharedPreferences.getString(Const.HOST, "");
			// 获得当前时间，格式是 201402141503
			String currentTime = CalendarUtil.formatNow(System.currentTimeMillis());
			Log.e(TAG, String.valueOf(currentTime));

			String json = null;
			try {
				// 
				SoapObject soapObject = SoapUtil.buildSoapObject(Const.GET);
				// 塞值
				soapObject = SoapUtil.setSoapRequestParamter(new String[] { host,
						currentTime }, soapObject);
				if (null == soapObject) {
					return;
				}
				// 开始获取邮件，返回到String型的json
				json = SoapUtil.getResultString(soapObject);
				Log.e(TAG, json);
			} catch (IOException e) {
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				e.printStackTrace();
			}
		}
		
	};
	
}
