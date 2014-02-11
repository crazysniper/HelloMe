package cn.com.liandisys.hellome.model.dao.impl;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;
import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.database.MailDBHelper;
import cn.com.liandisys.hellome.model.dao.MailDao;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

public class MailDaoImpl implements MailDao {

	private final static String TAG = "MailDaoImpl";

	private Context context;

	private final static String[] COLUMNS = new String[] { Const.MAIL_ID,
			Const.MAIL_SEND_TIME, Const.MAIL_GET_TIME, Const.MAIL_TITLE,
			Const.MAIL_CONTENT, Const.MAIL_IMAGE_NAME, Const.MAIL_READED };

	public MailDaoImpl(Context context) {
		this.context = context;
	}

	private SQLiteDatabase getMailDB() {
		return MailDBHelper.getInstance(context).getWritableDatabase();
	}

	// 插入信息
	@Override
	public long insertMail(MailBoxInfoEntity mailbox) {
		Log.d(TAG, "insertMail");
		ContentValues values = new ContentValues();
		// values.put(Const.MAIL_ID, mailbox.getId());
		values.put(Const.MAIL_TYPE, mailbox.getType());
		values.put(Const.MAIL_HOST, mailbox.getHost());
		values.put(Const.MAIL_SEND_TIME, mailbox.getSendTime());
		values.put(Const.MAIL_GET_TIME, mailbox.getGetTime());
		values.put(Const.MAIL_TITLE, mailbox.getTitle());
		values.put(Const.MAIL_CONTENT, mailbox.getContent());
		values.put(Const.MAIL_IMAGE_NAME, mailbox.getImageName());
		values.put(Const.MAIL_READED, mailbox.getReaded());
		return getMailDB().insert(Const.TABLE_NAME, null, values);
	}

	// 本地删除
	@Override
	public long logicDeleteMail(int id) {
		Log.d(TAG, "logicDeleteMail id:" + id);
		ContentValues values = new ContentValues();
		values.put(Const.MAIL_TYPE, Const.MODE_DUSTBIN);
		return getMailDB().update(Const.TABLE_NAME, values,
				Const.MAIL_ID + " = ?", new String[] { String.valueOf(id) });
	}

	// 彻底删除
	@Override
	public long deleteMail(int id) {
		Log.d(TAG, "deleteMail id:" + id);
		return getMailDB().delete(Const.TABLE_NAME, Const.MAIL_ID + " = ?",
				new String[] { String.valueOf(id) });
	}

	// 清空信箱
	@Override
	public long clearMail(int type, String host) {
		Log.d(TAG, "clearMail type:" + type);
		String whereClause = Const.MAIL_TYPE + " = ? and " + Const.MAIL_HOST
				+ " = ? ";
		return getMailDB().delete(Const.TABLE_NAME, whereClause,
				new String[] { String.valueOf(type), host });
	}

	@Override
	public long updateMail(MailBoxInfoEntity mailbox) {
		Log.d(TAG, "updateMail");
		// TODO Auto-generated method stub
		return 0;
	}

	// 接收信息后更改信件状态
	@Override
	public long updateMailReaded(int id) {
		Log.d(TAG, "updateMailReaded id:" + id);
		ContentValues values = new ContentValues();
		values.put(Const.MAIL_READED, 1);
		return getMailDB().update(Const.TABLE_NAME, values,
				Const.MAIL_ID + " = ? ", new String[] { String.valueOf(id) });
	}

	@Override
	public List<MailBoxInfoEntity> selectMailByTypeAndHost(int type, String host) {
		Log.d(TAG, "selectMailByTypeAndHost type:" + type + ", host: " + host);
		Cursor cursor = null;
		try {
			String selection = Const.MAIL_TYPE + " = ? and " + Const.MAIL_HOST
					+ " = ? ";
			String[] selectionArgs = new String[] { String.valueOf(type), host };
			cursor = getMailDB().query(Const.TABLE_NAME, COLUMNS, selection,
					selectionArgs, null, null, Const.MAIL_ID + " desc");
			List<MailBoxInfoEntity> list = new ArrayList<MailBoxInfoEntity>();
			while (cursor.moveToNext()) {
				list.add(createEntity(cursor));
			}
			return list;
		} finally {
			if (null != cursor) {
				cursor.close();
				cursor = null;
			}
		}
	}

	@Override
	public MailBoxInfoEntity selectMailById(int id) {
		Log.d(TAG, "selectMailByTypeAndHost id:" + id);
		Cursor cursor = null;
		try {
			String selection = Const.MAIL_ID + " = ? ";
			String[] selectionArgs = new String[] { String.valueOf(id) };
			cursor = getMailDB().query(Const.TABLE_NAME, COLUMNS, selection,
					selectionArgs, null, null, null);
			MailBoxInfoEntity mailbox = null;
			if (cursor.moveToNext()) {
				mailbox = createEntity(cursor);
			}
			return mailbox;
		} finally {
			if (null != cursor) {
				cursor.close();
				cursor = null;
			}
		}
	}

	private MailBoxInfoEntity createEntity(Cursor cursor) {
		int idx = 0;
		MailBoxInfoEntity entity = new MailBoxInfoEntity();
		entity.setId(cursor.getInt(idx++));
		entity.setSendTime(cursor.getString(idx++));
		entity.setGetTime(cursor.getString(idx++));
		entity.setTitle(cursor.getString(idx++));
		entity.setContent(cursor.getString(idx++));
		entity.setImageName(cursor.getString(idx++));
		entity.setReaded(cursor.getInt(idx++));
		return entity;
	}

}
