package cn.com.liandisys.hellome.model.dao;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfo;

public interface MailDao {
	
	public long insertMail(MailBoxInfo mailbox);
	
	public long logicDeleteMail(int id);
	
	public long deleteMail(int id);
	
	public long clearMail(int type, String host);
	
	public long updateMail(MailBoxInfo mailbox);
	
	public long updateMailReaded(int id);
	
	public List<MailBoxInfo> selectMailByTypeAndHost(int type, String host);
	
	public MailBoxInfo selectMailById(int id);

}
