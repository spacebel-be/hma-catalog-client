package spb.mass.navigation.service;

import java.net.MalformedURLException;
import java.net.URL;

public class FaceletFunctions {

	public static String substring(String orig, int start, int length) {
		if (orig == null) {
			return null;
		}
		if (start < 0) {
			start = 0;
		}
		if (length > orig.length()) {
			length = orig.length();
		}
		orig = orig.substring(start, length);
		return orig;
	}

	public static String shortenEOPCollectionNames(String collectionName) {
		String result = null;
		String delim = ":EOP:";
		if (collectionName == null) {
			return null;
		}
		// toUpperCase in order to handle :eop: and variations
		int index = collectionName.toUpperCase().indexOf(delim);
		if (index == -1) {
			// delimiter not found, returning the whole name
			result = collectionName;
		} else {
			// returning everything past the delimiter
			result = collectionName.substring(index + delim.length());
		}

		return result;
	}

	public static String nullIfNotValidURL(String url) {
		String result = url;
		try {
			new URL(url);
		} catch (MalformedURLException e) {
			result = null;
		}
		return result;
	}
}
