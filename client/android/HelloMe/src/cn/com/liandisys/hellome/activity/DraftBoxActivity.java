package cn.com.liandisys.hellome.activity;

import java.util.ArrayList;
import java.util.List;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.activity.adapter.MailBoxAdapter;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
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

public class DraftBoxActivity extends Activity {

	private final static String TAG = "DraftActivity";
	
	private ListView mMailbox;

	private List<MailBoxInfoEntity> mList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mail_box);
		Log.d(TAG, "onCreate");

//		createActionBar(Const.MODE_DRAFT_BOX);
		mList = new ArrayList<MailBoxInfoEntity>();
//		for (int i = 0; i < 2; i++) {
//			mList.add(new MailBoxInfo(i, "send : 2012-11-2" + (i + 1),
//					"get : 2013-11-2" + i, "Hello Me!", null));
//		}
		MailBoxAdapter adapter = new MailBoxAdapter(this, mList);
		mMailbox = (ListView) findViewById(R.id.inbox_list);
		mMailbox.setAdapter(adapter);
		mMailbox.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				// TODO showMail
				Intent intent = new Intent(getApplicationContext(), ReadActivity.class);
				intent.putExtra("id", mList.get(position).getId());
				startActivity(intent);
				overridePendingTransition(R.anim.right_in, R.anim.left_out);
			}
		});
		mMailbox.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view,
					int position, long id) {
				// TODO delete mail
				AlertDialog.Builder builder = new AlertDialog.Builder(
						DraftBoxActivity.this)
						.setTitle(R.string.msg_delete_title)
						.setMessage(R.string.msg_delete_content)
						.setNegativeButton(R.string.cancel, null)
						.setPositiveButton(R.string.confirm,
								new OnClickListener() {

									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										/*
										 * dao.delete(mList.get(position).getId())
										 * ;
										 */
										showToast(R.string.msg_delete_complete);
									}
								});
				builder.create().show();
				return true;
			}
		});
	}

	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
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
