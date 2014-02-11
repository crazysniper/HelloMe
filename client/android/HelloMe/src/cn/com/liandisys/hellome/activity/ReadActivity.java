package cn.com.liandisys.hellome.activity;

import java.io.File;

import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
import cn.com.liandisys.hellome.model.logic.MailLogic;
import cn.com.liandisys.hellome.model.logic.impl.MailLogicImpl;
import cn.com.liandisys.hellome.common.Const;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

public class ReadActivity extends Activity {
	
	private static final String IMAGE_PATH = "imagePath";
	private String imagePath = "";
	
	private boolean setMailData(int mailId) {
		boolean result = true;
		MailLogic mLogic = new MailLogicImpl(this);
		MailBoxInfoEntity mail = mLogic.queryMail(mailId);
		
		ImageButton imageButton = (ImageButton) findViewById(R.id.annex);
		if (null == mail.getImageName() || "".equals(mail.getImageName())) {
			imageButton.setEnabled(false);
		} else {
			imageButton.setEnabled(true);
			File filePath = Environment.getExternalStorageDirectory();
			imagePath = filePath.getPath() + File.separator
					+ Const.PROJECT_DIRECTORYDIR + File.separator + mail.getImageName() + Const.JPG;
		}
	
		TextView title = (TextView) findViewById(R.id.title);
		title.setText(mail.getTitle());
		TextView content = (TextView) findViewById(R.id.content);
		content.setText("\r\n" + "  " + mail.getContent() + "\r\n\r\n\r\n\r\n\r\n" + "  " + "Send At:" + formatTime(mail.getSendTime()));
		
		return result;
	}
	
	private String formatTime(String beforeFormatTime) {
		String afterFormatTime = beforeFormatTime.substring(0, 4) + "年" + beforeFormatTime.substring(4, 6) + "月" + beforeFormatTime.substring(6, 8) + "日" + beforeFormatTime.substring(8, 10) + ":" + beforeFormatTime.substring(10);
		return afterFormatTime;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_read);
		int id = getIntent().getIntExtra(Const.INTENT_ID, -1);
		if (!setMailData(id)) {
			finish();
		}
	}

	public void annexAction(View view) {
		if (null != imagePath && !"".equals(imagePath)) {
			Intent intent = new Intent(this, ImageActivity.class);
			intent.putExtra(IMAGE_PATH, imagePath);
			startActivity(intent);
			overridePendingTransition(R.anim.right_in, R.anim.left_out);
		}
	}
}
