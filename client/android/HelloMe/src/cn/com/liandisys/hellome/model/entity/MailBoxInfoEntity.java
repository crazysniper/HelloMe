package cn.com.liandisys.hellome.model.entity;

public class MailBoxInfoEntity {
	// id
	private int id;
	// 
	private int type;
	// 用户名
	private String host;
	// 发送时间
	private String sendTime;
	// 接收时间
	private String getTime;
	// 标题
	private String title;
	// 内容
	private String content;
	// 图片名
	private String imageName;
	// 图片string
	private String imageBuffer;
	// 0：未读	1：已读
	private int readed;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}

	public String getGetTime() {
		return getTime;
	}

	public void setGetTime(String getTime) {
		this.getTime = getTime;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getImageName() {
		return imageName;
	}

	public void setImageName(String imageName) {
		this.imageName = imageName;
	}

	public String getImageBuffer() {
		return imageBuffer;
	}

	public void setImageBuffer(String imageBuffer) {
		this.imageBuffer = imageBuffer;
	}

	public int getReaded() {
		return readed;
	}

	public void setReaded(int readed) {
		this.readed = readed;
	}

}
