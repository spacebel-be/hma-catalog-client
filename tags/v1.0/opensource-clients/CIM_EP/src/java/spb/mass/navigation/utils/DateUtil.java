package spb.mass.navigation.utils;

import java.util.Calendar;
import java.util.Date;

/**
 * Utility class for comparing dates. Also stores common date patterns.
 * 
 * @author jpr
 * 
 */
public class DateUtil {
	public static final String[] DATEPATTERNS = new String[] { "yyyy-MM-dd",
			"yyyy-MM-dd'T'HH:mm", "yyyy-MM-dd'T'HH:mm:ss",
			"yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss'Z'",
			"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" };

	public static boolean isSameMonth(Date date1, Date date2) {
		if (date1 == null || date2 == null) {
			throw new IllegalArgumentException("The date must not be null");
		}
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(date1);
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(date2);
		return isSameMonth(cal1, cal2);
	}

	private static boolean isSameMonth(Calendar cal1, Calendar cal2) {
		if (cal1 == null || cal2 == null) {
			throw new IllegalArgumentException("The date must not be null");
		}
		return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA)
				&& cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) && cal1
					.get(Calendar.MONTH) == cal2.get(Calendar.MONTH));
	}

	public static boolean isSameYear(Date date1, Date date2) {
		if (date1 == null || date2 == null) {
			throw new IllegalArgumentException("The date must not be null");
		}
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(date1);
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(date2);
		return isSameYear(cal1, cal2);
	}

	private static boolean isSameYear(Calendar cal1, Calendar cal2) {
		if (cal1 == null || cal2 == null) {
			throw new IllegalArgumentException("The date must not be null");
		}
		return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA) && cal1
				.get(Calendar.YEAR) == cal2.get(Calendar.YEAR));
	}
}