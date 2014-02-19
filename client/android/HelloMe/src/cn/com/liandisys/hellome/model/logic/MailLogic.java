package cn.com.liandisys.hellome.model.logic;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

public interface MailLogic {
	/**
	 * 将从服务器获取到的信件，添加到收件箱
	 */
	public long addMail(MailBoxInfoEntity mailbox);

	/**
	 * 保存草稿箱
	 */
	public long saveDraftMail(MailBoxInfoEntity mailbox);

	/**
	 * 将信件放到回收箱中去
	 */
	public long revokeMail(int id);

	/**
	 * 从本地直接删除指定id的信件，而不是放到回收箱
	 */
	public long deleteMail(int id);

	/**
	 * 清空垃圾箱
	 */
	public long clearDustbin();

	/**
	 * 清空收件箱
	 */
	public long clearInbox();

	public long editMail();

	/**
	 * 阅读信息后更改信件状态，将信件改成已阅读状态
	 */
	public long readMail(int id);

	/**
	 * 根据类型和用户名，列出所有此类的信息,比如列出收件箱中所有信息；列出草稿箱中所有信息；列出垃圾箱中所有信息
	 */
	public List<MailBoxInfoEntity> queryMailList(int type);

	/**
	 * 查出指定id的信件
	 */
	public MailBoxInfoEntity queryMail(int id);

}
