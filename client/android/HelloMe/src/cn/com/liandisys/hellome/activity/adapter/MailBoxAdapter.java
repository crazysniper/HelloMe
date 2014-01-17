package cn.com.liandisys.hellome.activity.adapter;

import java.io.File;
import java.util.List;
import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfo;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MailBoxAdapter extends BaseAdapter {

	private LayoutInflater inflater;

	private List<MailBoxInfo> list;

	public MailBoxAdapter(Context context, List<MailBoxInfo> list) {
		this.list = list;
		inflater = LayoutInflater.from(context);
	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		MailBoxView mailbox = null;
		if (null == convertView) {
			convertView = inflater.inflate(R.layout.adapter_mail_box, null);
			mailbox = new MailBoxView();
			mailbox.id = (TextView) convertView.findViewById(R.id.mail_id);
			// mailbox.sendTime = (TextView) convertView
			// .findViewById(R.id.mail_send_time);
			mailbox.getTime = (TextView) convertView
					.findViewById(R.id.mail_get_time);
			mailbox.title = (TextView) convertView
					.findViewById(R.id.mail_title);
			mailbox.content = (TextView) convertView
					.findViewById(R.id.mail_content);
			mailbox.image = (ImageView) convertView
					.findViewById(R.id.mail_image_view);
			convertView.setTag(mailbox);
		} else {
			mailbox = (MailBoxView) convertView.getTag();
		}
		if (null != list) {
			mailbox.id.setText("" + list.get(position).getId());
			// mailbox.sendTime.setText(list.get(position).getSendTime());

			String getTime = list.get(position).getGetTime();
			String getTimes = getTime.substring(0, 4) + "/"
					+ getTime.substring(4, 6) + "/" + getTime.substring(6, 8)
					+ " " + getTime.substring(8, 10) + ":"
					+ getTime.substring(10);

			mailbox.getTime.setText(getTimes);
			mailbox.title.setText(list.get(position).getTitle());
			mailbox.content.setText(list.get(position).getContent());
			mailbox.title.setText(list.get(position).getTitle());

			if (!(null == list.get(position).getImageName()
					|| "".equals(list.get(position).getImageName()))) {
				String fileFullName = Environment.getExternalStorageDirectory().getPath()
						+ File.separator + Const.PROJECT_DIRECTORYDIR + File.separator
						+ list.get(position).getImageName() 
						+ Const.COMPRESS_NAME  + Const.JPG;
				Bitmap bitmap = BitmapFactory.decodeFile(fileFullName);
				mailbox.image.setImageBitmap(bitmap);
			} else {
				mailbox.image.setImageResource(R.color.dark_gray);
			}
			if (0 == list.get(position).getReaded()) {
				mailbox.title.getPaint().setFakeBoldText(true);
			}
		}
		return convertView;
	}
	
	private class MailBoxView {
		public TextView id;
		// public TextView sendTime;
		public TextView getTime;
		public TextView title;
		public TextView content;
		public ImageView image;
	}

}
