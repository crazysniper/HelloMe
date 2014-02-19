package cn.com.liandisys.hellome.activity;

import cn.com.liandisys.hellome.R;
import android.os.Bundle;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;

public class ImageActivity extends Activity {

	private Bitmap bitmap;

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (null != bitmap) {
			bitmap.recycle(); // 回收位图占用的内存空间，把位图标记为Dead
			bitmap = null;
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_image);
		initView();
	}

	public void initView() {
		String imagePath = getIntent().getStringExtra("imagePath");
		ImageView image = (ImageView) findViewById(R.id.image);
		bitmap = BitmapFactory.decodeFile(imagePath);
		image.setImageBitmap(bitmap); // 显示图片
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.image, menu);
		return true;
	}

	// 点击此按钮，会关闭当前ImageActivity，
	public void cancelAction(View view) {
		finish();
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}
}
