package cn.com.liandisys.hellome.model.logic;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

public interface MailLogic {

	public long addMail(MailBoxInfoEntity mailbox);

	public long saveDraftMail(MailBoxInfoEntity mailbox);

	public long revokeMail(int id);

	public long deleteMail(int id);

	public long clearDustbin();

	public long clearInbox();

	public long editMail();

	public long readMail(int id);

	public List<MailBoxInfoEntity> queryMailList(int type);

	public MailBoxInfoEntity queryMail(int id);

}
