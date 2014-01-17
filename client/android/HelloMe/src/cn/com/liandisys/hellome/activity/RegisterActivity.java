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
	
	private void initView() {
		mRegisterLayout = (RelativeLayout) findViewById(R.id.register_layout);
		mRegisterUser = (EditText) findViewById(R.id.register_user);
		mRegisterPassword = (EditText) findViewById(R.id.register_password);
		mRegisterConfirmPassword = (EditText) findViewById(R.id.register_confirm_password);
	}
	
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
			
			if (msg.what != REGISTER_SUCCESS) {
				showToast(R.string.msg_register_error);
				return;
			}
			
			try {
				String status = new JSONObject(msg.obj.toString()).getString("status");
				if ("success".equals(status)) {
					Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
					startActivity(intent);
					finish();
				}
			} catch (JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != progressDialog) {
					progressDialog.dismiss();
				}
			}
		}
	};
	
	private boolean checkString(String keyword) {
		return keyword.matches(Const.REGULAR_EXPRESSION);
	}

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
	public void onBackPressed() {
		super.onBackPressed();
		goBack();
	}
	
	// 返回到登录画面
	private void goBack() {
		Log.d(TAG, "goBack");
		finish();
		overridePendingTransition(R.anim.left_in, R.anim.right_out);
	}
	
	public void registerAction(View view) {
		registerUser = mRegisterUser.getText().toString();
		registerPassword = mRegisterPassword.getText().toString();
		registerConfirmPassword = mRegisterConfirmPassword.getText()
				.toString();
		if ("".equals(registerUser) || "".equals(registerPassword)
				|| "".equals(registerConfirmPassword)) {
			return;
		}
		if (!checkString(registerUser)
				|| !checkString(registerPassword)
				|| !checkString(registerConfirmPassword)) {
			showToast(R.string.msg_string_error);
			return;
		}
		if (!registerPassword.equals(registerConfirmPassword)) {
			showToast(R.string.msg_password_error);
			return;
		}
		Log.i(TAG, registerUser);
		Log.i(TAG, registerPassword);
		
		progressDialog = ProgressDialog.show(this, "", getResources().getString(R.string.msg_register_content));
		
		new Thread(runnable).start();
	}
	
	public void resetAction(View view) {
		mRegisterUser.setText("");
		mRegisterPassword.setText("");
		mRegisterConfirmPassword.setText("");
	}
	
	Runnable runnable = new Runnable() {

		@Override
		public void run() {
			String registerResult = null;
			try {
				registerResult = SoapUtil.getResultString(SoapUtil.setSoapRequestParamter(new String[] {registerUser, registerPassword }, SoapUtil.buildSoapObject(Const.REG)));
				registerHandler.obtainMessage(REGISTER_SUCCESS, registerResult).sendToTarget();
			} catch (IOException e) {
				registerHandler.obtainMessage(REGISTER_FAIL, "").sendToTarget();
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				registerHandler.obtainMessage(REGISTER_FAIL, "").sendToTarget();
				e.printStackTrace();
			}
		}
		
	};
	
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
