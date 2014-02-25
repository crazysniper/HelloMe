package cn.com.liandisys.hellome.util;

import java.util.Calendar;

public class CalendarUtil {
	/**
	 * @param hour
	 * @param minute
	 * @return 例 8:00
	 */
	public static String timeFormat(int hour, int minute) {
		String format = hour + ":";
		if (hour < 10) {
			format = "0" + format;
		}
		if (minute < 10) {
			format = format + "0";
		}
		format = format + minute;
		return format;
	}

	/**
	 * @param year
	 * @param month
	 * @param day
	 * @return 例 20130930
	 */
	public static String formatDate(int year, int month, int day) {
		String date = "" + year + "/";
		if (month < 10) {
			date = date + "0";
		}
		date = date + month + "/";
		if (day < 10) {
			date = date + "0";
		}
		date = date + day;

		return date;
	}

	/**
	 * 格式化当前时间
	 * 
	 * @param milliseconds
	 *            当前时间
	 * @return
	 */
	public static String formatNow(long milliseconds) {
		/**
		 * Calendar类是抽象类，且Calendar类的构造方法是protected的， 所以无法使用Calendar类的构造方法来创建对象，
		 * API中提供了getInstance方法用来创建对象。
		 */
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(milliseconds);
		int year = c.get(Calendar.YEAR); // 年份
		int month = c.get(Calendar.MONTH) + 1; // 月份
		int day = c.get(Calendar.DAY_OF_MONTH);// 一个月中的某天。它与 DATE
												// 是同义词。一个月中第一天的值为 1
		int hour = c.get(Calendar.HOUR_OF_DAY);// 小时
		int minute = c.get(Calendar.MINUTE);// 分钟
		// %02d，指当月份是5月时，返回的值是05月
		return "" + year + String.format("%02d", month)
				+ String.format("%02d", day) + String.format("%02d", hour)
				+ String.format("%02d", minute);
	}
}
