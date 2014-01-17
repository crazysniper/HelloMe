package cn.com.liandisys.hellome.activity.base;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.activity.DustbinActivity;
import cn.com.liandisys.hellome.activity.InboxActivity;
import cn.com.liandisys.hellome.activity.DraftBoxActivity;
import cn.com.liandisys.hellome.activity.WriteActivity;
import cn.com.liandisys.hellome.common.Const;
import android.app.ActionBar;
import android.app.Activity;
import android.app.ActionBar.OnNavigationListener;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.widget.SpinnerAdapter;
import android.widget.Toast;

public class ActivityBase extends Activity {

	private int mPosition;

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case R.id.delete:
			Log.d(this.getClass().getSimpleName(), "delete");
			clearBox();
			break;
		case R.id.refresh:
			Log.d(this.getClass().getSimpleName(), "refresh");
			showInbow();
			break;
		case R.id.help:
			Log.d(this.getClass().getSimpleName(), "help");
			// TODO help page
			// Intent intent = new Intent(this, /* 帮助class */.class);
			// startActivity(intent);
			break;
		}
		return super.onOptionsItemSelected(item);
	}
	
	protected void clearBox(){}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	/**
	 * 功能列表
	 */
	public void createActionBar(int mode) {
		mPosition = mode;
		// 生成一个SpinnerAdapter
		SpinnerAdapter spinnerAdapter = ArrayAdapter.createFromResource(this,
				R.array.box, android.R.layout.simple_spinner_dropdown_item);
		// 得到ActionBar
		ActionBar actionBar = getActionBar();
		// 将ActionBar的操作模型设置为NAVIGATION_MODE_LIST
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_LIST);
		// 不显示应用logo和title
		actionBar.setDisplayShowHomeEnabled(false);
		actionBar.setDisplayShowTitleEnabled(false);
		// 为ActionBar设置下拉菜单和监听器
		actionBar.setListNavigationCallbacks(spinnerAdapter,
				new OnNavigationListener() {

					@Override
					public boolean onNavigationItemSelected(int itemPosition,
							long itemId) {
						if (itemPosition != mPosition) {
							switch (itemPosition) {
							case Const.MODE_INBOX:
								showInbow();
								break;
							case Const.MODE_DRAFT_BOX:
								showDraftbow();
								break;
							case Const.MODE_DUSTBIN:
								showDustbin();
								break;
							case Const.MODE_WRITE:
								showWrite();
								break;
							}
						}
						return false;
					}
				});
		actionBar.setSelectedNavigationItem(mPosition);
	}

	/**
	 * 显示收件箱
	 */
	private void showInbow() {
		Log.d(this.getClass().getSimpleName(), "showInbow");
		Intent intent = new Intent(this, InboxActivity.class);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.bottom_in, R.anim.top_out);
	}

	/**
	 * 显示草稿箱
	 */
	private void showDraftbow() {
		Log.d(this.getClass().getSimpleName(), "showDraftbow");
		Intent intent = new Intent(this, DraftBoxActivity.class);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.bottom_in, R.anim.top_out);
	}

	/**
	 * 显示垃圾箱
	 */
	private void showDustbin() {
		Log.d(this.getClass().getSimpleName(), "showDustbin");
		Intent intent = new Intent(this, DustbinActivity.class);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.bottom_in, R.anim.top_out);
	}

	/**
	 * 显示写信page
	 */
	private void showWrite() {
		Log.d(this.getClass().getSimpleName(), "showWrite");
		Intent intent = new Intent(this, WriteActivity.class);
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.bottom_in, R.anim.top_out);
	}

	protected void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
	}

	protected void showToast(String msg) {
		Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onStop() {
		super.onStop();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

}
