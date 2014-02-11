package cn.com.liandisys.hellome.activity;

import java.util.List;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.activity.adapter.MailBoxAdapter;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
import cn.com.liandisys.hellome.model.logic.MailLogic;
import cn.com.liandisys.hellome.model.logic.impl.MailLogicImpl;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;

public class DustbinActivity extends Activity {

	private final static String TAG = "DustbinActivity";

	private ListView mMailbox;

	private List<MailBoxInfoEntity> mList;

	private MailLogic mLogic;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mail_box);
		Log.d(TAG, "onCreate");

		mLogic = new MailLogicImpl(this);
		mMailbox = (ListView) findViewById(R.id.inbox_list);
		mMailbox.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent = new Intent(getApplicationContext(),
						ReadActivity.class);
				intent.putExtra("id", mList.get(position).getId());
				startActivity(intent);
				overridePendingTransition(R.anim.right_in, R.anim.left_out);
			}
		});
		mMailbox.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view,
					int position, long id) {
				final int p = position;
				// TODO delete mail
				AlertDialog.Builder builder = new AlertDialog.Builder(
						DustbinActivity.this)
						.setTitle(R.string.msg_delete_title)
						.setMessage(R.string.msg_delete_content)
						.setNegativeButton(R.string.cancel, null)
						.setPositiveButton(R.string.confirm,
								new OnClickListener() {

									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										mLogic.deleteMail(mList.get(p).getId());
										showToast(R.string.msg_delete_complete);
										refreshList();
									}
								});
				builder.create().show();
				return true;
			}
		});
		refreshList();
	}

	@SuppressWarnings("unused")
	private void clearBox() {
		new AlertDialog.Builder(DustbinActivity.this)
				.setTitle(R.string.msg_delete_title)
				.setMessage(R.string.msg_delete_content)
				.setPositiveButton(R.string.confirm, new OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						mLogic.clearDustbin();
						showToast(R.string.msg_delete_complete);
						refreshList();
					}
				}).setNegativeButton(R.string.cancel, null).create().show();
	}

	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
	}

	private void refreshList() {
		mList = mLogic.queryMailList(Const.MODE_DUSTBIN);
		if (null != mList) {
			MailBoxAdapter adapter = new MailBoxAdapter(this, mList);
			mMailbox.setAdapter(adapter);
		}
	}

	@Override
	protected void onStart() {
		super.onStart();
		Log.d(TAG, "onStart");
	}

	@Override
	protected void onResume() {
		super.onResume();
		Log.d(TAG, "onResume");
	}

	@Override
	protected void onPause() {
		super.onPause();
		Log.d(TAG, "onPause");
	}

	@Override
	protected void onStop() {
		super.onStop();
		Log.d(TAG, "onStop");
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.d(TAG, "onDestroy");
	}

}
