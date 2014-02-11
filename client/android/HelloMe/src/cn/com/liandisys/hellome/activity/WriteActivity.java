package cn.com.liandisys.hellome.activity;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;

import cn.com.liandisys.hellome.util.CalendarUtil;
import cn.com.liandisys.hellome.util.SoapUtil;
import cn.com.liandisys.hellome.R;
import cn.com.liandisys.hellome.common.Const;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.app.AlertDialog.Builder;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;

public class WriteActivity extends Activity {

	private final static String TAG = "WriteActivity";
	private final static int SEND_SUCCESS = 1;
	private final static int SEND_FAIL = 2;
	
	private EditText title;
	private EditText body;
	private Button dateSelecter;
	private Button timeSelecter;
	private ProgressDialog progressDialog;
	
	/**
	 * 接收时间
	 */
	private Calendar selectTime;	
	private String imagePath;
	private boolean isError = false;
	
	private Handler sendHandler = new Handler() {
		
		public void handleMessage(Message msg) {
			
			if (msg.what != SEND_SUCCESS) {
				return;
			}
			
			try {
				String status = new JSONObject(msg.obj.toString()).getString("status");
				if ("success".equals(status)) {
					finish();
					overridePendingTransition(R.anim.right_in, R.anim.left_out);
				}
			} catch (JSONException e) {
				e.printStackTrace();
			} finally {
				if (null != progressDialog) {
					progressDialog.dismiss();
				}
			}
		}
	};

	private void showToast(int msgId) {
		Toast.makeText(this, msgId, Toast.LENGTH_SHORT).show();
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_write);
		
		Log.d(TAG, "onCreate");
		
		// 初始化控件
		title = (EditText) findViewById(R.id.title);
		body = (EditText) findViewById(R.id.body);
		dateSelecter = (Button) findViewById(R.id.date_select);
		timeSelecter = (Button) findViewById(R.id.time_select);
		
		// 默认送信时间
		selectTime = Calendar.getInstance();
		selectTime.setTimeInMillis(System.currentTimeMillis());
		selectTime.set(Calendar.SECOND, 0);
		selectTime.set(Calendar.MILLISECOND, 0);
		dateSelecter.setText(CalendarUtil.formatDate(selectTime.get(Calendar.YEAR), selectTime.get(Calendar.MONTH)+1,selectTime.get(Calendar.DAY_OF_MONTH)));
		timeSelecter.setText(CalendarUtil.timeFormat(selectTime.get(Calendar.HOUR_OF_DAY), selectTime.get(Calendar.MINUTE)));
	}
	
	public void addImage(View view) {
		Log.d(TAG, "onClick selectImage");
		
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		startActivityForResult(intent, 1);
	}
	
	public void addVoice(View view) {
		// TODO 音声を添附する
	}
	
	public void addFile(View view) {
		// TODO ファイルを添附する
	}
	
	public void addOther(View view) {
		// TODO 他の資料を添附する
	}
	
	public void addLocation(View view) {
		// TODO 位置を添附する
	}
	
	public void save(View view) {
		// TODO 内容を保存する
	}
	
	public void upload(View view) {
		
		if (!columnsCheck()) {
			progressDialog = ProgressDialog.show(this, "", getResources().getString(R.string.msg_upload_content));
			new Thread(runnable).start();
		} else {
			showToast(R.string.send_error);
		}
	}
	
	/**
	 * 利用Dialog选择接收日期（年月日）
	 */
	public void dateSelect(View view) {
		Log.d(TAG, "dateSelect begin");
			
		final DatePicker datePicker = new DatePicker(this);
		
		// datePickerDialog
		Builder builder = new Builder(this);
		builder.setView(datePicker)
				.setPositiveButton(R.string.confirm, new AlertDialog.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						selectTime.set(Calendar.YEAR, datePicker.getYear());
						selectTime.set(Calendar.MONTH, datePicker.getMonth());
						selectTime.set(Calendar.DAY_OF_MONTH, datePicker.getDayOfMonth());
						
						dateSelecter.setText(CalendarUtil.formatDate(
								selectTime.get(Calendar.YEAR), selectTime.get(Calendar.MONTH)+1,selectTime.get(Calendar.DAY_OF_MONTH)));
					}
				}).setNegativeButton(R.string.cancel, null);
		builder.create().show();
		
		Log.d(TAG, "dateSelect end");
	}
    
	/**
	 * 利用Dialog选择接收时间（时分）
	 */
	public void timeSelect(View view) {
		Log.d(TAG, "timeSelect begin");
		
		final TimePicker timePicker = new TimePicker(this);
		// TimePicker设置为24小时制显示
		timePicker.setIs24HourView(true);
		
		timePicker.setCurrentHour(selectTime.get(Calendar.HOUR_OF_DAY));  
		timePicker.setCurrentMinute(selectTime.get(Calendar.MINUTE));
	
		// timePickerDialog
		Builder builder = new Builder(this);
		builder.setView(timePicker)
				.setPositiveButton(R.string.confirm, new AlertDialog.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						 selectTime.set(Calendar.HOUR_OF_DAY, timePicker.getCurrentHour());
						 selectTime.set(Calendar.MINUTE, timePicker.getCurrentMinute());
						 
						 timeSelecter.setText(CalendarUtil.timeFormat(
								selectTime.get(Calendar.HOUR_OF_DAY), selectTime.get(Calendar.MINUTE)));
						}
				}).setNegativeButton(R.string.cancel, null);
		builder.create().show();
		
		Log.d(TAG, "timeSelect end");
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode != 1) {
			return;
		}
		if (resultCode == Activity.RESULT_OK) {
			/**
			 * 当选择的图片不为空的话，在获取到图片的途径
			 */
			Uri uri = data.getData();
			Log.e(TAG, "uri = " + uri);
			try {
				String[] pojo = { MediaStore.Images.Media.DATA };

				@SuppressWarnings("deprecation")
				Cursor cursor = managedQuery(uri, pojo, null, null, null);
				
				if (cursor != null) {
					ContentResolver cr = this.getContentResolver();
					int colunm_index = cursor
							.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
					cursor.moveToFirst();
					String path = cursor.getString(colunm_index);
					/***
					 * 这里加这样一个判断主要是为了第三方的软件选择，比如：使用第三方的文件管理器的话，你选择的文件就不一定是图片了，
					 * 这样的话，我们判断文件的后缀名 如果是图片格式的话，那么才可以
					 */
					if (path.endsWith("jpg") || path.endsWith("png")) {
						imagePath = path;
						Log.e(TAG, "path = " + path);
						Bitmap bitmap = BitmapFactory.decodeStream(cr
								.openInputStream(uri));
						ImageButton imageButton = (ImageButton) findViewById(R.id.addImage);
						imageButton.setImageBitmap(bitmap);
					} else {
						alert();
					}
				} else {
					alert();
				}

			} catch (Exception e) {
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	private void alert() {
		Dialog dialog = new AlertDialog.Builder(this).setTitle("提示")
				.setMessage("您选择的不是有效的图片")
				.setPositiveButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
//						picPath = null;
					}
				}).create();
		dialog.show();
	}
	
	/**
	 * 入力check， 时间check，图片check
	 */
	private boolean columnsCheck(){
		
		if("".equals(title.getText().toString().trim())){
			return true;
		} else if("".equals(body.getText().toString().trim())) {
			return true;
		} else if (selectTime.getTimeInMillis() < System.currentTimeMillis()) {
			return true;
		}
		return false;
	}
	
	/**
	 * Activity生命周期 onStart
	 */
	@Override
	protected void onStart() {
		Log.d(TAG, "onStart begin");
		isError = false;
		Log.d(TAG, "onStart end");
		super.onStart();
	}
	
	Runnable runnable = new Runnable() {

		@Override
		public void run() {
			if (isError) {
				return;
			}
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmm");     
			Date curDate = new Date(System.currentTimeMillis());
			String sendTime = formatter.format(curDate);
			String timeText = dateSelecter.getText().toString() + "" + timeSelecter.getText().toString();
			String receiveTime = timeText.substring(0, 4) + timeText.substring(5, 7) + timeText.substring(8, 10) + timeText.substring(10, 12) + timeText.substring(13);
        	SharedPreferences sharedPreferences=getSharedPreferences(Const.SP_NAME, 
        			Context.MODE_PRIVATE);
        	String userName = sharedPreferences.getString(Const.HOST, "");
			String mailTitle = title.getText().toString();
			String mailContent = body.getText().toString();
			String imageName = "";
			if (null != imagePath) {
				imageName = imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.lastIndexOf("."));
			}
			String imageBuffer = null;
			String result = null;
			
	        try{
	        	if (imagePath != null) {
		        	FileInputStream fis = new FileInputStream(imagePath);
		            ByteArrayOutputStream baos = new ByteArrayOutputStream();  
		            byte[] buffer = new byte[1024];  
		            int count = 0;  
		            while((count = fis.read(buffer)) >= 0){  
		                baos.write(buffer, 0, count);  
		            }  
		            imageBuffer = new String(Base64.encode(baos.toByteArray(), 1)); 
		            fis.close(); 
	        	}      
	        }catch(Exception e){  
	            e.printStackTrace();  
	        }  
			
	        String[] paramters = {sendTime, receiveTime, userName, mailTitle, mailContent, imageName, imageBuffer};
	        
			try {
				result = SoapUtil.getResultString(SoapUtil.setSoapRequestParamter(paramters, SoapUtil.buildSoapObject(Const.SAVE)));
				sendHandler.obtainMessage(SEND_SUCCESS, result).sendToTarget();
			} catch (IOException e) {
				sendHandler.obtainMessage(SEND_FAIL, "").sendToTarget();
				e.printStackTrace();
			} catch (XmlPullParserException e) {
				sendHandler.obtainMessage(SEND_FAIL, "").sendToTarget();
				e.printStackTrace();
			}
		}
		
	};
}