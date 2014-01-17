package cn.com.liandisys.hellome.database;

import cn.com.liandisys.hellome.common.Const;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class MailDBHelper extends SQLiteOpenHelper {

	private final static String TAG = "MailDBHelper";
	
	private static MailDBHelper mMailDBHelper;
	
	public static MailDBHelper getInstance(Context context) {
		if (null == mMailDBHelper) {
			mMailDBHelper = new MailDBHelper(context);
		}
		return mMailDBHelper;
	}

	public MailDBHelper(Context context) {
		super(context, Const.DB_NAME, null, Const.DB_VWESION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		Log.d(TAG, "onCreate");
		db.execSQL("create table if not exists " + Const.TABLE_NAME + " ( "
				+ Const.MAIL_ID + " Integer Primary Key autoincrement, " 
				+ Const.MAIL_TYPE + " Integer Default 0, " 
				+ Const.MAIL_HOST + " Varchar(20), " 
				+ Const.MAIL_SEND_TIME + " Varchar(12), " 
				+ Const.MAIL_GET_TIME + " Varchar(12), " 
				+ Const.MAIL_TITLE + " Varchar(100), " 
				+ Const.MAIL_CONTENT + " Varchar(200), " 
				+ Const.MAIL_IMAGE_NAME + " Varchar(100), " 
				+ Const.MAIL_READED + " Integer Default 0 " 
				+ " );");
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		Log.d(TAG, "onUpgrade");
	}

}
