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
	 * @param year
	 * @param month
	 * @param day
	 * @return 例 20130930
	 */
	public static String formatNow(long milliseconds) {
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(milliseconds);
		int year = c.get(Calendar.YEAR);
		int month = c.get(Calendar.MONTH) + 1;
		int day = c.get(Calendar.DAY_OF_MONTH);
		int hour = c.get(Calendar.HOUR_OF_DAY);
		int minute = c.get(Calendar.MINUTE);
		return "" + year + String.format("%02d", month)
				+ String.format("%02d", day) + String.format("%02d", hour)
				+ String.format("%02d", minute);
	}
}
