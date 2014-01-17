package cn.com.liandisys.hellome.activity;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.util.ActivityManager;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;

public class SettingActivity extends Activity {

	private final static String TAG = "SettingActivity";

	private GestureDetector mGestureDetector;

	private RelativeLayout mSettingLayout;

	private ListView mMenuList;

	private final static String INBOX = "收件箱";
	private final static String DRAFTBOX = "草稿箱";
	private final static String DUSTBIN = "垃圾箱";
	private final static String HELP = "帮助";
	private final static String LOGOUT = "用户退出";
	String[] titles = new String[] { INBOX, DRAFTBOX, DUSTBIN, HELP, LOGOUT };

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_setting);
		Log.d(TAG, "onCreate");

		initView();
		setListener();
	}

	private void initView() {
		mSettingLayout = (RelativeLayout) findViewById(R.id.setting_layout);
		mMenuList = (ListView) findViewById(R.id.menu_list);
		mMenuList.setAdapter(new ArrayAdapter<String>(this, 
				R.layout.adapter_setting_menu, R.id.setting_menu_title, titles));
	}

	private void setListener() {
		mGestureDetector = new GestureDetector(this,
				new SettingGestureListener());
		mSettingLayout.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});
		mSettingLayout.setLongClickable(true);

		mMenuList.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});
		mMenuList.setLongClickable(true);
		mMenuList.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				if (INBOX.equals(titles[position])) {
					goInbox();
				} else if (DRAFTBOX.equals(titles[position])) {
					goDraftbox();
				} else if (DUSTBIN.equals(titles[position])) {
					goDustbin();
				} else if (HELP.equals(titles[position])) {
					goHelp();
				} else if (LOGOUT.equals(titles[position])) {
					logout();
				}
			}
		});

		findViewById(R.id.forward).setOnClickListener(
				new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						goBack();
					}
				});
	}

	private void logout() {
		new AlertDialog.Builder(this).setTitle(R.string.msg_logout_title)
				.setMessage(R.string.msg_logout_content)
				.setPositiveButton(R.string.confirm, new OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						goLogin();
					}
				}).setNegativeButton(R.string.cancel, null).create().show();
	}

	private void goBack() {
		Log.d(TAG, "goBack");
		finish();
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}

	private void goInbox() {
		Intent intent = new Intent(this, InboxActivity.class);
		
		intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
		intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}

	private void goDraftbox() {
		// TODO
	}

	private void goDustbin() {
		// TODO
	}

	private void goHelp() {
		// TODO
	}

	private void goLogin() {
		Log.d(TAG, "goLogin");
		this.getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE).edit()
				.putBoolean(Const.IS_LOGIN, false).commit();
		
		ActivityManager.getInstance().finishAll();
		Intent intent = new Intent(this, LoginActivity.class);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "onDestroy");
		ActivityManager.getInstance().removeActivity(this);
		if (mGestureDetector != null) {
			mGestureDetector = null;
		}
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		goBack();
	}

	class SettingGestureListener implements GestureDetector.OnGestureListener {

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
					// Fling left
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
