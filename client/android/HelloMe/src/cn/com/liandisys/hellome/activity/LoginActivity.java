package cn.com.liandisys.hellome.activity;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.util.SoapUtil;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

public class LoginActivity extends Activity {

	private final static String TAG = "LoginActivity";

	private GestureDetector mGestureDetector;

	private RelativeLayout mLoginLayout;

	private EditText mLoginUser;
	private EditText mLoginPassword;
	private ProgressDialog progressDialog;

	private String loginUser;
	private String loginPassword;

	private static final int LOGIN_SUCCESS = 1;
	private static final int LOGIN_FAIL = 2;

	private void initView() {
		mLoginLayout = (RelativeLayout) findViewById(R.id.login_layout);
		mLoginUser = (EditText) findViewById(R.id.login_user);
		mLoginPassword = (EditText) findViewById(R.id.login_password);
	}

	// 监听器
	private void setListener() {
		mGestureDetector = new GestureDetector(this, new LoginGestureListener());

		mLoginLayout.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});

		mLoginLayout.setLongClickable(true);
	}

	private Handler loginHandler = new Handler() {

		public void handleMessage(Message msg) {

			if (msg.what != LOGIN_SUCCESS) {
				showToast(R.string.msg_login_error);
				return;
			}

			try {
				String status = new JSONObject(msg.obj.toString()).getString("status");
				// 登录成功后，要将用户名和是否已登录的值存到SharedPreferences中去，并且跳转到InboxActivity
				if ("success".equals(status)) {
					// 打开Preferences，名称为hellome。如果存在则打开它，否则创建新的Preferences
					SharedPreferences hellome = LoginActivity.this.getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE);
					// 让其处于编辑状态
					SharedPreferences.Editor editor = hellome.edit();
					// 存放数据
					editor.putString(Const.HOST, loginUser);	// 用户名
					editor.putBoolean(Const.IS_LOGIN, true);	// 是否登录
					// 获取Preferences
//					SharedPreferences hellome = getPreferences(Const.SP_NAME,Context.MODE_PRIVATE);
//					// 取出数据
//					String loginUser =hellome.getString(Const.HOST, "默认值");
//					String isLogin =hellome.getString(Const.IS_LOGIN, "默认值");
					
					
//					SharedPreferences.Editor editor = LoginActivity.this.getSharedPreferences(Const.SP_NAME,Context.MODE_PRIVATE).edit();
//					editor.putString(Const.HOST, loginUser);
//					editor.putBoolean(Const.IS_LOGIN, true);
					// 完成提交
					editor.commit();
					
					// 跳转到InboxActivity
					Intent intent = new Intent(LoginActivity.this,InboxActivity.class);
					startActivity(intent);
					finish();	// 关闭LoginActivity
				}
			} catch (JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != progressDialog) {
					progressDialog.dismiss();	// 关闭progressDialog
				}
			}
		}
	};

	// 正则验证只能输入数字和字母
	private boolean checkString(String keyword) {
		return keyword.matches(Const.REGULAR_EXPRESSION);
	}

	// 显示提示信息
	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		Log.d(TAG, "onCreate");
		initView();
		setListener();

		// 记住密码时，启动登录画面后，直接从SharedPreferences中读取到用户名，并将值塞到画面上去
		SharedPreferences sharedPreferences = getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE);
		String username = sharedPreferences.getString(Const.HOST, "");
		mLoginUser.setText(username);
	}

	@Override
	protected void onDestroy() {
		super.onStop();
		if (progressDialog != null && progressDialog.isShowing()) {
			progressDialog.dismiss();
			progressDialog = null;
		}
		Log.d(TAG, "onStop");
	}

	// 跳转到注册画面
	public void registerAction(View view) {
		Log.d(TAG, "goRegister");
		Intent intent = new Intent(LoginActivity.this, RegisterActivity.class);
		startActivity(intent);
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}

	// 登录
	public void loginAction(View view) {

		loginUser = mLoginUser.getText().toString();
		loginPassword = mLoginPassword.getText().toString();
		if ("".equals(loginUser) || "".equals(loginPassword)) {
			return;
		}
		if (!checkString(loginUser) || !checkString(loginPassword)) {
			showToast(R.string.msg_string_error);
			return;
		}
		Log.i(TAG, loginUser);
		Log.i(TAG, loginPassword);

		/**
		 * ProgressDialog是用在耗时操作上的一种组件。基本原理是新建一个线程去执行耗时操作，原线程执行 ProgressDialog对话框的绘制。
		 * show(Context context, CharSequence title, CharSequence message)
		 * 参数1：上下文
		 * 参数2：标题
		 * 参数3：信息
		 */
		progressDialog = ProgressDialog.show(this, "", getResources().getString(R.string.msg_login_content));

		overridePendingTransition(R.anim.right_in, R.anim.left_out);

		// 开启线程，进行登录
		new Thread(runnable).start();
	}

	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			String loginResult = null;
			try {
				/**
				 * SoapUtil.buildSoapObject(Const.LOGIN)	服务器中login()方法
				 * SoapUtil.setSoapRequestParamter   		soap塞值
				 */
				loginResult = SoapUtil.getResultString(SoapUtil.setSoapRequestParamter(new String[] { loginUser,loginPassword },SoapUtil.buildSoapObject(Const.LOGIN)));
				loginHandler.obtainMessage(LOGIN_SUCCESS, loginResult).sendToTarget();		// 向handler发消息
			} catch (IOException e) {
				loginHandler.obtainMessage(LOGIN_FAIL, "").sendToTarget();
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				loginHandler.obtainMessage(LOGIN_FAIL, "").sendToTarget();
				e.printStackTrace();
			}
		}

	};
	
	// 手势
	class LoginGestureListener implements GestureDetector.OnGestureListener {

		@Override
		public boolean onDown(MotionEvent e) {
			return false;
		}

		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {
			if (Math.abs(velocityY) * 2 < Math.abs(velocityX)) {
				if (e1.getX() - e2.getX() > Const.FLING_MIN_DISTANCE
						&& Math.abs(velocityX) > Const.FLING_MIN_VELOCITY) {
					Log.d(TAG, "login gesture toRegister");
					// Fling left
					Intent intent = new Intent(LoginActivity.this,RegisterActivity.class);
					startActivity(intent);
					overridePendingTransition(R.anim.right_in, R.anim.left_out);
				}
			}
			return false;
		}

		@Override
		public void onLongPress(MotionEvent e) {

		}

		@Override
		public boolean onScroll(MotionEvent e1, MotionEvent e2,float distanceX, float distanceY) {
			return false;
		}

		@Override
		public void onShowPress(MotionEvent e) {
		}

		@Override
		public boolean onSingleTapUp(MotionEvent e) {
			return false;
		}

	}
}
