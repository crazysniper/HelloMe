package cn.com.liandisys.hellome.model.dao;

import java.util.List;

import cn.com.liandisys.hellome.model.entity.MailBoxInfoEntity;

public interface MailDao {
	// 插入信息到本地数据中去
	public long insertMail(MailBoxInfoEntity mailbox);

	// 将信件放到回收箱中去
	public long logicDeleteMail(int id);

	// 从本地直接删除指定id的信件，而不是放到回收箱
	public long deleteMail(int id);

	/**
	 * 清空某个信箱，不如收件箱，或者草稿箱 此处是直接删除，而不是放到回收箱中去
	 */
	public long clearMail(int type, String host);

	public long updateMail(MailBoxInfoEntity mailbox);

	/**
	 * 阅读信息后更改信件状态，将信件改成已阅读状态
	 */
	public long updateMailReaded(int id);

	/**
	 * 根据类型和用户名，列出所有此类的信息, 比如列出收件箱中所有信息；列出草稿箱中所有信息；列出垃圾箱中所有信息
	 */
	public List<MailBoxInfoEntity> selectMailByTypeAndHost(int type, String host);

	// 查出指定id的信件
	public MailBoxInfoEntity selectMailById(int id);

}
