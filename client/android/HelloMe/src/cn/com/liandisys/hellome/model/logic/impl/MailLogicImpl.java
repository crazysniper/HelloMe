package cn.com.liandisys.hellome.model.logic.impl;

import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;

import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.dao.MailDao;
import cn.com.liandisys.hellome.model.dao.impl.MailDaoImpl;
import cn.com.liandisys.hellome.model.entity.MailBoxInfo;
import cn.com.liandisys.hellome.model.logic.MailLogic;
import cn.com.liandisys.hellome.util.FileUtil;

public class MailLogicImpl implements MailLogic {
	
	private SharedPreferences sp;

	private MailDao dao;

	public MailLogicImpl(Context context) {
		dao = new MailDaoImpl(context);
		sp = context.getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE);
	}

	@Override
	public long addMail(MailBoxInfo mailbox) {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		mailbox.setType(Const.MODE_INBOX);
		mailbox.setHost(host);
		mailbox.setReaded(0);
		if ("".equals(mailbox.getImageName()) || "".equals(mailbox.getImageBuffer())) {
			mailbox.setImageName("");
		} else {
			String fileNmae = String.valueOf(System.currentTimeMillis());
			FileUtil.savePicture(fileNmae, mailbox.getImageBuffer());
			mailbox.setImageName(fileNmae);
		}
		return dao.insertMail(mailbox);
	}

	@Override
	public long saveDraftMail(MailBoxInfo mailbox) {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		mailbox.setType(Const.MODE_DRAFT_BOX);
		mailbox.setHost(host);
		return dao.insertMail(mailbox);
	}

	@Override
	public long revokeMail(int id) {
		return dao.logicDeleteMail(id);
	}

	@Override
	public long deleteMail(int id) {
		return dao.deleteMail(id);
	}

	@Override
	public long clearDustbin() {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		return dao.clearMail(Const.MODE_DUSTBIN, host);
	}

	@Override
	public long clearInbox() {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		return dao.clearMail(Const.MODE_INBOX, host);
	}

	@Override
	public long editMail() {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public long readMail(int id) {
		return dao.updateMailReaded(id);
	}

	@Override
	public List<MailBoxInfo> queryMailList(int type) {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return null;
		}
		return dao.selectMailByTypeAndHost(type, host);
	}

	@Override
	public MailBoxInfo queryMail(int id) {
		return dao.selectMailById(id);
	}

}
