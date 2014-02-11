package cn.com.liandisys.hellome.model.dao;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

public interface MailDao {

	public long insertMail(MailBoxInfoEntity mailbox);

	public long logicDeleteMail(int id);

	public long deleteMail(int id);

	public long clearMail(int type, String host);

	public long updateMail(MailBoxInfoEntity mailbox);

	public long updateMailReaded(int id);

	public List<MailBoxInfoEntity> selectMailByTypeAndHost(int type, String host);

	public MailBoxInfoEntity selectMailById(int id);

}
