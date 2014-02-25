package cn.com.liandisys.hellome.activity;

import java.io.IOException;
import java.util.List;

import org.ksoap2.serialization.SoapObject;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.activity.adapter.MailBoxAdapter;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
import cn.com.liandisys.hellome.model.logic.MailLogic;
import cn.com.liandisys.hellome.model.logic.impl.MailLogicImpl;
import cn.com.liandisys.hellome.service.DownloadService;
import cn.com.liandisys.hellome.util.ActivityManager;
import cn.com.liandisys.hellome.util.CalendarUtil;
import cn.com.liandisys.hellome.util.JSonUtil;
import cn.com.liandisys.hellome.util.SoapUtil;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
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
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.ListView;

/**
 * 收件箱
 * @author gaofeng2
 *
 */
public class InboxActivity extends Activity implements View.OnClickListener {

	private final static String TAG = "InboxActivity";

	private ListView mMailbox;

	private ProgressDialog mProgressDialog;

	private LinearLayout mUserBtn;

	private LinearLayout mRefresh;

	private LinearLayout mNewMail;

	private LinearLayout mClearMail;
	
	private RelativeLayout mMailboxLayout;

	private List<MailBoxInfoEntity> mList;

	private TextView mUserName;

	private MailLogic mLogic;

	private GestureDetector mGestureDetector;

	private SharedPreferences mSharedPreferences;

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.user:
			// 转向设置的画面
			goSetting();
			break;
		case R.id.new_mail:
			// 转向写信的画面
			goWrite();
			break;
		case R.id.refresh:
			Log.d(TAG, "refresh");
			updateMailBox();
			break;
		case R.id.clear:
			Log.d(TAG, "clearInbox");
			new AlertDialog.Builder(InboxActivity.this)
					.setTitle(R.string.msg_delete_title)
					.setMessage(R.string.msg_clear_content)
					.setPositiveButton(R.string.confirm, new OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							// 清空收件箱
							mLogic.clearInbox();
							refreshList();
						}
					}).setNegativeButton(R.string.cancel, null).create().show();
			break;
		}

	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mail_box);
		Log.d(TAG, "onCreate");
		
		/*
		 * DownloadService是一个service。Service不能自己运行，只能后台运行，并且可以和其他组件进行交互
		 * 启动Service有2中方式 context.startService()和context.blindService()
		 *   
		 */
		Intent serviceIntent = new Intent(InboxActivity.this, DownloadService.class);
		// 停止Service
		this.stopService(serviceIntent);
		// 启动Service
		/*
		 * 用startService()启动Service
		 */
		this.startService(serviceIntent);

		ActivityManager.getInstance().addActivity(this);
		initView();
		initData();
		setListener();
	}
	
	private void initView() {
		mUserName = (TextView) findViewById(R.id.username);
		mUserBtn = (LinearLayout) findViewById(R.id.user);
		mRefresh = (LinearLayout) findViewById(R.id.refresh);
		mNewMail = (LinearLayout) findViewById(R.id.new_mail);
		mClearMail = (LinearLayout) findViewById(R.id.clear);
		mMailboxLayout = (RelativeLayout) findViewById(R.id.mail_box_layout);
		mMailbox = (ListView) findViewById(R.id.inbox_list);
	}

	private void initData() {
		mSharedPreferences = this.getSharedPreferences(Const.SP_NAME,
				Context.MODE_PRIVATE);
		String host = mSharedPreferences.getString(Const.HOST, "");
		mUserName.setText(host);
		mLogic = new MailLogicImpl(this);
		updateMailBox();
	}

	private void setListener() {
		mGestureDetector = new GestureDetector(this, new InboxGestureListener());

		mMailboxLayout.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});
		mMailboxLayout.setLongClickable(true);

		mMailbox.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				return mGestureDetector.onTouchEvent(event);
			}
		});
		mMailbox.setLongClickable(true);
		mMailbox.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				mLogic.readMail(mList.get(position).getId());
				Intent intent = new Intent(getApplicationContext(),
						ReadActivity.class);
				intent.putExtra(Const.INTENT_ID, mList.get(position).getId());
				startActivity(intent);
				overridePendingTransition(R.anim.right_in, R.anim.left_out);
			}
		});
		mMailbox.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view,
					int position, long id) {
				final int p = position;
				new AlertDialog.Builder(InboxActivity.this)
						.setTitle(R.string.msg_delete_title)
						.setMessage(R.string.msg_delete_content)
						.setNegativeButton(R.string.cancel, null)
						.setPositiveButton(R.string.confirm,
								new OnClickListener() {

									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										Log.i(TAG, "revoke "
												+ mList.get(p).getId());
										mLogic.deleteMail(mList.get(p).getId());
										// 提示：选中邮件已删除
										showToast(R.string.msg_delete_complete);
										// 刷新信件
										refreshList();
									}
								}).create().show();
				return true;
			}
		});

		mUserBtn.setOnClickListener(this);
		mNewMail.setOnClickListener(this);
		mRefresh.setOnClickListener(this);
		mClearMail.setOnClickListener(this);
	}

	// 转向写信的画面
	private void goWrite() {
		Log.d(TAG, "goWrite");
		Intent intent = new Intent(this, WriteActivity.class);
		startActivity(intent);
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}

	// 转向设置的画面
	private void goSetting() {
		Log.d(TAG, "goSetting");
		Intent intent = new Intent(this, SettingActivity.class);
		startActivity(intent);
		overridePendingTransition(R.anim.left_in, R.anim.right_out);
	}

	// 刷新信件
	private void refreshList() {
		Log.d(TAG, "refresh");
		// 获取收件箱里的所有信件
		mList = mLogic.queryMailList(Const.MODE_INBOX);
		if (null != mList) {
			MailBoxAdapter adapter = new MailBoxAdapter(this, mList);
			mMailbox.setAdapter(adapter);
		}
	}

	
	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
	}

	// 显示提示信息
	private void showToast(String msg) {
		Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
	}

	private void updateMailBox() {
//		mProgressDialog = ProgressDialog.show(this,
//				getResources().getString(R.string.msg_download_title),
//				getResources().getString(R.string.msg_download_content));
//		new Thread() {
//			@Override
//			public void run() {
//				Log.w(TAG, "downloading");
//				Message message = new Message();
//				message.obj = download();
//				mHandler.sendMessage(message);
//			}
//		}.start();
	}

	private String download() {
		String host = mSharedPreferences.getString(Const.HOST, "");
		String currentTime = CalendarUtil.formatNow(System.currentTimeMillis());
		Log.i(TAG, String.valueOf(currentTime));

		String json = null;
		try {
			SoapObject soapObject = SoapUtil.buildSoapObject(Const.GET);
			soapObject = SoapUtil.setSoapRequestParamter(new String[] { host,
					currentTime }, soapObject);
			if (null == soapObject) {
				return null;
			}
			json = SoapUtil.getResultString(soapObject);
			Log.i(TAG, json);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (XmlPullParserException e) {
			e.printStackTrace();
		}
		return json;
	}
	
	@SuppressLint("HandlerLeak")
	private Handler mHandler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			String json = (String) msg.obj;
			if (null != json) {
				if (!Const.SUCCESS.equals(JSonUtil.getJSonString(Const.STATUS, json))) {
					showToast(JSonUtil.getJSonString(Const.MESSAGE, json));
				} else {
					List<MailBoxInfoEntity> list = JSonUtil.getMails(json);
					for (int i = 0; i < list.size(); i++) {
						mLogic.addMail(list.get(i));
					}
				}
			}
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			refreshList();
			if (null != mProgressDialog) {
				mProgressDialog.dismiss();
				mProgressDialog = null;
			}
		}

	};

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "onDestroy");
		ActivityManager.getInstance().removeActivity(this);
		if (null != mProgressDialog) {
			mProgressDialog.dismiss();
			mProgressDialog = null;
		}
		if (mGestureDetector != null) {
			mGestureDetector = null;
		}
	}

	class InboxGestureListener implements GestureDetector.OnGestureListener {

		@Override
		public boolean onDown(MotionEvent e) {
			return false;
		}

		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {
			if (Math.abs(velocityX) > Math.abs(velocityY) * 2) {
				if (e1.getX() - e2.getX() > Const.FLING_MIN_DISTANCE
						&& Math.abs(velocityX) > Const.FLING_MIN_VELOCITY) {
					// Fling left
					goWrite();
				} else if (e2.getX() - e1.getX() > Const.FLING_MIN_DISTANCE
						&& Math.abs(velocityX) > Const.FLING_MIN_VELOCITY) {
					// Fling right
					goSetting();
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
