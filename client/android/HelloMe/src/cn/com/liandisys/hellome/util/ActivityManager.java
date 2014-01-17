package cn.com.liandisys.hellome.util;

import java.util.LinkedList;
import java.util.List;
import android.app.Activity;
import android.app.Application;

public class ActivityManager extends Application {

	private List<Activity> activityList = new LinkedList<Activity>();

	private static ActivityManager instance;

	private ActivityManager() {
	}

	// 单例模式中获取唯一的MyApplication实例
	public static ActivityManager getInstance() {
		if (null == instance) {
			instance = new ActivityManager();
		}
		return instance;
	}

	// 添加Activity到容器中
	public void addActivity(Activity activity) {
		activityList.add(activity);
	}
	
	// 移除容器中的Activity
	public void removeActivity(Activity activity) {
		activityList.remove(activity);
	}

	// 遍历所有Activity并finish
	public void finishAll() {
		for (Activity activity : activityList) {
			activity.finish();
		}
		while (0 != activityList.size()) {
			activityList.remove(0);
		}
	}

}
