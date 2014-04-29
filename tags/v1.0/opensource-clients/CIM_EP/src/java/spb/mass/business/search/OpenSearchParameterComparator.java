package spb.mass.business.search;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class OpenSearchParameterComparator implements
		Comparator<OpenSearchParameter> {
	public static OpenSearchParameterComparator instance;

	private OpenSearchParameterComparator() {

	}

	public static void sort(List<OpenSearchParameter> list) {
		Collections.sort(list, getInstance());
	}

	public int compare(OpenSearchParameter o1, OpenSearchParameter o2) {
		if (o1 == null)
			return -1;
		if (o2 == null)
			return 1;
		return compare(o1.getIndex(), o2.getIndex());
	}

	public static OpenSearchParameterComparator getInstance() {
		if (instance == null) {
			instance = new OpenSearchParameterComparator();
		}
		return instance;
	}

	private int compare(String str1, String str2) {
		int result = 0;
		try {
			int num1 = Integer.parseInt(str1);
			int num2 = Integer.parseInt(str2);
			if (num1 > num2) {
				result = 1;
			}
			if (num1 == num2) {
				result = 0;
			}

			if (num1 < num2) {
				result = -1;
			}
		} catch (NumberFormatException e) {
		}
		return result;
	}
}
