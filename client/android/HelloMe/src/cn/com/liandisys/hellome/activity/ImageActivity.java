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
		// TODO Auto-generated method stub
		super.onDestroy();
		if (null != bitmap) {
			bitmap.recycle();
			bitmap = null;
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_image);
		String imagePath = getIntent().getStringExtra("imagePath");
		ImageView image = (ImageView) findViewById(R.id.image);
		bitmap = BitmapFactory.decodeFile(imagePath);
	    image.setImageBitmap(bitmap);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.image, menu);
		return true;
	}
	
	public void cancelAction(View view) {
		finish();
		overridePendingTransition(R.anim.right_in, R.anim.left_out);
	}
	
	
}
