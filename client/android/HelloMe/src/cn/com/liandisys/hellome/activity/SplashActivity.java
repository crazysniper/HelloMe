package cn.com.liandisys.hellome.activity;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

/**
 * 欢迎页面 
 * @author gaofeng2
 *
 */
public class SplashActivity extends Activity {

	private final static String TAG = "SplashActivity";
	private final int SPLASH_DISPLAY_LENGHT = 500;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);

		Log.d(TAG, "onCreate");

		Handler handler = new Handler();
		handler.postDelayed(new splashhandler(), SPLASH_DISPLAY_LENGHT);
	}

	class splashhandler implements Runnable {

		public void run() {
			// 获取sharedPreferences
			SharedPreferences sharedPreferences = getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE);
			// 获取用户名，如果为获取到，则为""
			String username = sharedPreferences.getString(Const.HOST, "");
			// 判断是否已登录，未登录，则为false
			boolean isLogin = sharedPreferences.getBoolean(Const.IS_LOGIN,false);
			// 如果用户名不为空，并且已登录，则跳转到收件箱画面
			if (!"".equals(username) && isLogin) {
				startActivity(new Intent(getApplication(), InboxActivity.class));
			} else {	// 否则跳到登录画面
				startActivity(new Intent(getApplication(), LoginActivity.class));
			}
			SplashActivity.this.finish();
			overridePendingTransition(R.anim.right_in, R.anim.left_out);
		}
	}
}
