package cn.com.liandisys.hellome.activity;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.util.SoapUtil;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

public class RegisterActivity extends Activity {
	
	private final static String TAG = "RegisterActivity";
	
	private GestureDetector mGestureDetector;

	private RelativeLayout mRegisterLayout;

	private EditText mRegisterUser;
	private EditText mRegisterPassword;
	private EditText mRegisterConfirmPassword;
	private ProgressDialog progressDialog;
	
	private String registerUser;
	private String registerPassword;
	private String registerConfirmPassword;
	
	private static final int REGISTER_SUCCESS = 1;
	private static final int REGISTER_FAIL = 2;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		Log.d(TAG, "onCreate");
		initView();
		setListener();
	}
	
	//载入id
	private void initView() {
		mRegisterLayout = (RelativeLayout) findViewById(R.id.register_layout);
		mRegisterUser = (EditText) findViewById(R.id.register_user);
		mRegisterPassword = (EditText) findViewById(R.id.register_password);
		mRegisterConfirmPassword = (EditText) findViewById(R.id.register_confirm_password);
	}
	
	//设置手势监听器
	private void setListener() {
		mGestureDetector = new GestureDetector(this, new RegisterGestureListener());
		
		mRegisterLayout.setOnTouchListener(new OnTouchListener() {
			
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});
		
		mRegisterLayout.setLongClickable(true);
	}
	
	@SuppressLint("HandlerLeak")
	private Handler registerHandler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			
			if (msg.what != REGISTER_SUCCESS) {		// 返回值不等于1，则提示注册失败
				showToast(R.string.msg_register_error);	
				return;
			}
			
			try {
				String status = new JSONObject(msg.obj.toString()).getString("status");
				if ("success".equals(status)) {
					// 跳转
					Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
					startActivity(intent);
					finish();
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
	
	// 正则判断是否符合要求数字和英文
	private boolean checkString(String keyword) {
		return keyword.matches(Const.REGULAR_EXPRESSION);
	}

	// Toast
	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
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
	
	@Override
	public void onBackPressed() {	// 返回键
		super.onBackPressed();
		goBack();
	}
	
	// 返回到登录画面
	private void goBack() {
		Log.d(TAG, "goBack");
		finish();	// 关闭当前Activity
		overridePendingTransition(R.anim.left_in, R.anim.right_out);
	}
	
	// 注册Action
	public void registerAction(View view) {
		registerUser = mRegisterUser.getText().toString();
		registerPassword = mRegisterPassword.getText().toString();
		registerConfirmPassword = mRegisterConfirmPassword.getText().toString();
		
		// 判断用户名和密码是否为空
		if ("".equals(registerUser) || "".equals(registerPassword)|| "".equals(registerConfirmPassword)) {
			return;
		}
		// 验证用户名和密码是否合法
		// 调用checkString()方法
		if (!checkString(registerUser)|| !checkString(registerPassword)|| !checkString(registerConfirmPassword)) {
			// 调用showToast()方法显示提示信息
			showToast(R.string.msg_string_error);
			return;
		}
		// 密码和确认密码是否一致
		if (!registerPassword.equals(registerConfirmPassword)) {
			showToast(R.string.msg_password_error);
			return;
		}
		Log.i(TAG, registerUser);
		Log.i(TAG, registerPassword);
		
		/**
		 * ProgressDialog是用在耗时操作上的一种组件。基本原理是新建一个线程去执行耗时操作，原线程执行 ProgressDialog对话框的绘制。
		 * show(Context context, CharSequence title, CharSequence message)
		 * 参数1：上下文
		 * 参数2：标题
		 * 参数3：信息
		 */
		progressDialog = ProgressDialog.show(this, "", getResources().getString(R.string.msg_register_content));
		
		// 开启线程，进行注册
		new Thread(runnable).start();
		
		Bundle bundle=new Bundle();
		bundle.putString("11","222");
		Intent intent =new Intent(this,LoginActivity.class);
		intent.putExtras(bundle);
		startActivity(intent);
	}
	
	// 重置
	public void resetAction(View view) {
		mRegisterUser.setText("");
		mRegisterPassword.setText("");
		mRegisterConfirmPassword.setText("");
	}
	
	// 线程
	Runnable runnable = new Runnable() {

		// 在android中，通常我们无法在单独的线程中更新UI，而要在主线程中，这也就是为什么我们要使用 Handler了，
		// 当handler收到消息中，它会把它放入到队列中等待执行，通常来说这会很快被执行。 
		
		@Override
		public void run() {
			String registerResult = null;
			try {
				registerResult = SoapUtil.getResultString(SoapUtil.setSoapRequestParamter(new String[] {registerUser, registerPassword }, SoapUtil.buildSoapObject(Const.REG)));
				registerHandler.obtainMessage(REGISTER_SUCCESS, registerResult).sendToTarget();			// 向handler发消息 
			} catch (IOException e) {
				registerHandler.obtainMessage(REGISTER_FAIL, "").sendToTarget();
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				registerHandler.obtainMessage(REGISTER_FAIL, "").sendToTarget();
				e.printStackTrace();
			}
		}
		
	};
	
	// 手势
	class RegisterGestureListener implements GestureDetector.OnGestureListener {

		@Override
		public boolean onDown(MotionEvent e) {
			return false;
		}

		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {
			if (Math.abs(velocityY) * 2 < Math.abs(velocityX)) {
				if (e2.getX() - e1.getX() > Const.FLING_MIN_DISTANCE
						&& Math.abs(velocityX) > Const.FLING_MIN_VELOCITY) {
					Log.d(TAG, "register gesture back");
					// Fling right
					goBack();
				}
			}
			return false;
		}

		@Override
		public void onLongPress(MotionEvent e) {

		}

		@Override
		public boolean onScroll(MotionEvent e1, MotionEvent e2,
				float distanceX, float distanceY) {
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
