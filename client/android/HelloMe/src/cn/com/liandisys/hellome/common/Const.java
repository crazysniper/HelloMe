package cn.com.liandisys.hellome.common;

public class Const {
	
	/************************* DB Key *************************/
	public static final String DB_NAME = "mail_db";
	
	public static final int DB_VWESION = 1;

	public static final String TABLE_NAME = "hellome";
	
	public static final String MAIL_ID = "MAIL_ID";
	
	public static final String MAIL_TYPE = "BOX_ID";
	
	public static final String MAIL_HOST = "HOST";
	
	public static final String MAIL_SEND_TIME = "SEND_TIME";
	
	public static final String MAIL_GET_TIME = "RECEIVE_TIME";
	
	public static final String MAIL_TITLE = "SUBJECT";
	
	public static final String MAIL_CONTENT = "TEXT";
	
	public static final String MAIL_IMAGE_NAME = "SEND_FILE_NAME";
	
	public static final String MAIL_READED = "READED";
	
	/************************* FILE Key *************************/
	
	public final static String PROJECT_DIRECTORYDIR = "HelloMe";

	public final static String JPG = ".jpg";

	public final static String COMPRESS_NAME = "_com";
	
	/************************* SharedPreferences Key *************************/
	
	public static final String SP_NAME = "hellome";
	
	public static final String HOST = "host";
	
	public static final String IS_LOGIN = "isLogin";
	
	/************************* Intent Data Key *************************/
	
	public final static String CURRENT_NAVIGATION_ITEM = "CURRENT_NAVIGATION_ITEM";
	
	public final static String INTENT_ID = "id";
	
	/************************* Mode Key *************************/
	// 收件箱
	public final static int MODE_INBOX = 0;
	// 草稿箱
	public final static int MODE_DRAFT_BOX = 1;
	// 垃圾箱
	public final static int MODE_DUSTBIN = 2;
	
	public final static int MODE_WRITE = 3;
	
	/************************* Login & Register Key *************************/
	
	public static final String REGULAR_EXPRESSION = "[0-9A-Za-z]*";
	
	public final static int MAX_LENGTH = 20;
	
	public final static int MIN_LENGTH = 4;
	
	/************************* SOAP *************************/
	
	public static final String NAMESPACE = "http://impl.hellome.liandisys.com.cn/";
	
	public static final String URL = "http://172.16.51.24/HelloMe";
	
	public static final String LOGIN = "login";
	
	public static final String REG = "register";
	
	public static final String SAVE = "saveMail";
	
	public static final String GET = "getNewMails";
	
	public static final String STATUS = "status";
	
	public static final String MESSAGE = "message";
	
	public static final String MAILS = "mails";
	
	public static final String SUCCESS = "success";
	
	public static final String FAILED = "failed";
	
	/************************* JSon Key *************************/
	
	public static final String JSON_SEND_TIME = "sendTime";
	
	public static final String JSON_RECEIVE_TIME = "receiveTime";
	
	public static final String JSON_USER_NAME = "userName";
	
	public static final String JSON_MAIL_TITLE = "mailTitle";
	
	public static final String JSON_MAIL_CONTENT = "mailContent";
	
	public static final String JSON_IMAGE_NAME = "imageName";
	
	public static final String JSON_IMAGE_BUFFER = "imageBuffer";
	
	/************************* Gesture Value *************************/

	public final static int FLING_MIN_DISTANCE = 100;

	public final static int FLING_MIN_VELOCITY = 200;
	
}
