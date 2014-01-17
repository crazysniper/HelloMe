package cn.com.liandisys.hellome.activity;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.service.DownloadService;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

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
			SharedPreferences sharedPreferences = getSharedPreferences(
					Const.SP_NAME, Context.MODE_PRIVATE);
			String username = sharedPreferences.getString(Const.HOST, "");
			boolean isLogin = sharedPreferences.getBoolean(Const.IS_LOGIN,
					false);

			if (!"".equals(username) && isLogin) {
				startActivity(new Intent(getApplication(), InboxActivity.class));
			} else {
				startActivity(new Intent(getApplication(), LoginActivity.class));
			}
			SplashActivity.this.finish();
			overridePendingTransition(R.anim.right_in, R.anim.left_out);
		}
	}
}
