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
			// 如果和JDBC例子的话，这一步貌似就像是获得了一个Statement，用它就可以操作数据库了。
			mMailDBHelper = new MailDBHelper(context);
		}
		return mMailDBHelper;
	}

	public MailDBHelper(Context context) {
		// 数据库连接的初始化，中间的那个null，是一个CursorFactory参数，没有仔细研究这个参数，暂时置空吧。
		super(context, Const.DB_NAME, null, Const.DB_VWESION);
	}

	/**
	 * 这里面的onCreate是指数据库onCreate时，而不是DatabaseHelper的onCreate。
	 * 也就是说，如果已经指定 database已经存在，那么在重新运行程序的时候，就不会执行这个方法了。
	 * 要不然，岂不是每次重新启动程序都要重新创建一次数据库了！
	 * 在这个方法中，完成了数据库的创建工作。也就是那个execSQL()方法
	 */
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
