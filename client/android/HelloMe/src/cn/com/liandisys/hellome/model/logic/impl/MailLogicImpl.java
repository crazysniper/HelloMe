package cn.com.liandisys.hellome.model.logic.impl;

import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;

import cn.com.liandisys.hellome.common.Const;
import cn.com.liandisys.hellome.model.dao.MailDao;
import cn.com.liandisys.hellome.model.dao.impl.MailDaoImpl;
import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;
import cn.com.liandisys.hellome.model.logic.MailLogic;
import cn.com.liandisys.hellome.util.FileUtil;

/**
 * Logic层，相当于Service层
 * 
 * @author gaofeng2
 * 
 */
public class MailLogicImpl implements MailLogic {

	private SharedPreferences sp;

	private MailDao dao;

	public MailLogicImpl(Context context) {
		dao = new MailDaoImpl(context);
		// 从配置中读取到SharedPreferences，属性私有，只能被应用程序读取
		sp = context.getSharedPreferences(Const.SP_NAME, Context.MODE_PRIVATE);
	}

	/**
	 * 将从服务器获取到的信件，添加到收件箱
	 */
	@Override
	public long addMail(MailBoxInfoEntity mailbox) {
		// 从SharedPreferences中读取到用户名
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		mailbox.setType(Const.MODE_INBOX); // 设属性是收件箱
		mailbox.setHost(host);
		mailbox.setReaded(0); // 设信件未读状态
		if ("".equals(mailbox.getImageName())
				|| "".equals(mailbox.getImageBuffer())) { // 如果没有图片，则设为""
			mailbox.setImageName("");
		} else {
			String fileNmae = String.valueOf(System.currentTimeMillis()); // 以当前时间为文件名
			FileUtil.savePicture(fileNmae, mailbox.getImageBuffer()); // 在本地保存图片文件
			mailbox.setImageName(fileNmae);
		}
		return dao.insertMail(mailbox);
	}

	/**
	 * 保存草稿箱
	 */
	@Override
	public long saveDraftMail(MailBoxInfoEntity mailbox) {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		mailbox.setType(Const.MODE_DRAFT_BOX); // 设属性是草稿箱
		mailbox.setHost(host);
		return dao.insertMail(mailbox);
	}

	/**
	 * 将信件放到回收箱中去
	 */
	@Override
	public long revokeMail(int id) {
		return dao.logicDeleteMail(id);
	}

	/**
	 * 从本地直接删除指定id的信件，而不是放到回收箱
	 */
	@Override
	public long deleteMail(int id) {
		return dao.deleteMail(id);
	}

	/**
	 * 清空垃圾箱
	 */
	@Override
	public long clearDustbin() {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return -1;
		}
		return dao.clearMail(Const.MODE_DUSTBIN, host);
	}

	/**
	 * 清空收件箱
	 */
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

	/**
	 * 阅读信息后更改信件状态，将信件改成已阅读状态
	 */
	@Override
	public long readMail(int id) {
		return dao.updateMailReaded(id);
	}

	/**
	 * 根据类型和用户名，列出所有此类的信息,比如列出收件箱中所有信息；列出草稿箱中所有信息；列出垃圾箱中所有信息
	 */
	@Override
	public List<MailBoxInfoEntity> queryMailList(int type) {
		String host = sp.getString(Const.HOST, "");
		if ("".equals(host)) {
			return null;
		}
		return dao.selectMailByTypeAndHost(type, host);
	}

	/**
	 * 查出指定id的信件
	 */
	@Override
	public MailBoxInfoEntity queryMail(int id) {
		return dao.selectMailById(id);
	}

}
