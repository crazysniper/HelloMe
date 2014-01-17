package cn.com.liandisys.hellome.dao;

import javax.jws.WebService;

@WebService
public interface HelloMeService {
	
	/**
	 * ユーザを新規する
	 * @param 新規するユーザデータ
	 * @return
	 */
	public String register(String username, String password);
	
	/**
	 * ユーザを登録する
	 * @param ユーザデータ
	 * @return
	 */
	public String login(String username, String password);
	
	/**
	 * メールを保存する
	 * @param メールデータ
	 * @return
	 */
	public String saveMail(String sendTime, String receiveTime, String username, String mailTitle, String mailContent, String imageName, String imageBuffer);
	
//	/**
//	 * 全てのメールを取る
//	 * @param ユーザ名
//	 * @return
//	 */
//	public String getMailList(String username);
	
	/**
	 * 新しいメールを取る
	 * @param ユーザ名と時間
	 * @return
	 */
	public String getNewMails(String username, String currentTime);
	
}
