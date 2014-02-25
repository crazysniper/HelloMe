package cn.com.liandisys.hellome.activity.adapter;

import java.io.File;
import java.util.List;
import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
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

	// LayoutInflater是一个用来实例化XML布局为View对象
	// 应用程序运行时会预先加载资源中的布局文件，如果layout布局中的资源比较多，会影响性能，
	// 所以可以选择LayoutInflater方式用的时候加载，这样减轻了应用程序运行时很多负担
	private LayoutInflater inflater;

	private List<MailBoxInfoEntity> list;

	public MailBoxAdapter(Context context, List<MailBoxInfoEntity> list) {
		//  获取将要绑定的数据设置到data中
		this.list = list;
		//  根据context上下文加载布局，这里的是Demo17Activity本身，即this。 从给定的context获取LayoutInflater
		inflater = LayoutInflater.from(context);
	}

	// 在此适配器中所代表的数据集中的条目数
	@Override
	public int getCount() {
		return list.size();		// 决定ListView有几行可见 
	}

	// 获取数据集中与指定索引对应的数据项
	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	// 取在列表中与指定索引对应的行id
	@Override
	public long getItemId(int position) {
		return position;
	}

	
	// 2、然后重写getView
	// 获取一个在数据集中指定索引的视图来显示数据
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		MailBoxView mailbox = null;
		// 通过缓存convertView,这种利用缓存contentView的方式可以判断如果缓存中不存在View才创建View，
		// 如果已经存在可以利用缓存中的View，提升了性能
		// 如果缓存convertView为空，则需要创建View
		if (null == convertView) {
			convertView = inflater.inflate(R.layout.adapter_mail_box, null);	//根据布局文件实例化view
			mailbox = new MailBoxView();
			// 根据自定义的Item布局加载布局
			mailbox.id = (TextView) convertView.findViewById(R.id.mail_id);
			// mailbox.sendTime = (TextView) convertView
			// .findViewById(R.id.mail_send_time);
			mailbox.image = (ImageView) convertView.findViewById(R.id.mail_image_view);
			mailbox.title = (TextView) convertView.findViewById(R.id.mail_title);
			mailbox.getTime = (TextView) convertView.findViewById(R.id.mail_get_time);
			mailbox.content = (TextView) convertView.findViewById(R.id.mail_content);
			// 将设置好的布局保存到缓存中，并将其设置在Tag里，以便后面方便取出Tag
			convertView.setTag(mailbox);
		} else {
			mailbox = (MailBoxView) convertView.getTag();
		}
		if (null != list) {
			mailbox.id.setText("" + list.get(position).getId());
			// mailbox.sendTime.setText(list.get(position).getSendTime());

			String getTime = list.get(position).getGetTime();	// 接收时间	yyyyMMddhhmmss
			String getTimes = getTime.substring(0, 4) + "/" + getTime.substring(4, 6) + "/" + getTime.substring(6, 8)
					+ " " + getTime.substring(8, 10) + ":" + getTime.substring(10);

			mailbox.getTime.setText(getTimes);
			mailbox.title.setText(list.get(position).getTitle());
			mailbox.content.setText(list.get(position).getContent());
			mailbox.title.setText(list.get(position).getTitle());

			if (!(null == list.get(position).getImageName() || "".equals(list.get(position).getImageName()))) {
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
	
	// 1、在外面先定义，ViewHolder静态类
	private class MailBoxView {
		public TextView id;
		// public TextView sendTime;
		public TextView getTime;
		public TextView title;
		public TextView content;
		public ImageView image;
	}

}
