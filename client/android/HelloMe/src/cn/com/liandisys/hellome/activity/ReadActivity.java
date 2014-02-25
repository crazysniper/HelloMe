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

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_read);
		// 如果获取id的value值为空，则返回-1
		int id = getIntent().getIntExtra(Const.INTENT_ID, -1);
		if (!setMailData(id)) {
			finish();
		}
	}

	private boolean setMailData(int mailId) {
		boolean result = true;
		MailLogic mLogic = new MailLogicImpl(this);
		// 查出指定id的信件
		MailBoxInfoEntity mail = mLogic.queryMail(mailId);

		ImageButton imageButton = (ImageButton) findViewById(R.id.annex);
		if (null == mail.getImageName() || "".equals(mail.getImageName())) {	// 如果没有图片附件，则不可点击
			// imageButton.setEnabled(false),单独的控件可以这样设置变成灰色和不可点击状态，你可以用ImageButton放图标，通过它的监听事件去修改其他控件的setEnabled值。
			imageButton.setEnabled(false);
		} else {	// 如果有图片附件，则设为可以点击
			imageButton.setEnabled(true);
			File filePath = Environment.getExternalStorageDirectory();
			// 图片路径
			imagePath = filePath.getPath() + File.separator + Const.PROJECT_DIRECTORYDIR + File.separator + mail.getImageName() + Const.JPG;
		}

		TextView title = (TextView) findViewById(R.id.title);
		title.setText(mail.getTitle()); // 往画面上塞值 标题
		TextView content = (TextView) findViewById(R.id.content);
		content.setText("\r\n" + "  " + mail.getContent() + "\r\n\r\n\r\n\r\n\r\n" + "  " + "Send At:" + formatTime(mail.getSendTime())); // 往画面上塞值 内容

		return result;
	}

	// 格式化接收时间
	private String formatTime(String beforeFormatTime) {
		String afterFormatTime = beforeFormatTime.substring(0, 4) + "年"
				+ beforeFormatTime.substring(4, 6) + "月"
				+ beforeFormatTime.substring(6, 8) + "日"
				+ beforeFormatTime.substring(8, 10) + ":"
				+ beforeFormatTime.substring(10);
		return afterFormatTime;
	}

	// 打开附件，即打开图片
	public void annexAction(View view) {
		if (null != imagePath && !"".equals(imagePath)) {	// 图片路径不为空，则跳转到浏览图片画面
			Intent intent = new Intent(this, ImageActivity.class);
			intent.putExtra(IMAGE_PATH, imagePath);		// 把文件路径传给ImageActivity中去
			startActivity(intent);
			overridePendingTransition(R.anim.right_in, R.anim.left_out);
		}
	}
}
