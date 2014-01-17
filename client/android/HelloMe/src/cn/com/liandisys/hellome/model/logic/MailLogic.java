package cn.com.liandisys.hellome.model.logic;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfo;

public interface MailLogic {
	
	public long addMail(MailBoxInfo mailbox);
	
	public long saveDraftMail(MailBoxInfo mailbox);

	public long revokeMail(int id);
	
	public long deleteMail(int id);
	
	public long clearDustbin();
	
	public long clearInbox();
	
	public long editMail();
	
	public long readMail(int id);
	
	public List<MailBoxInfo> queryMailList(int type);
	
	public MailBoxInfo queryMail(int id);

}
