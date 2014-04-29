package spb.mass.business.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.business.search.Constants;

public class HTTPInvoker {
	private final static Logger log = Logger.getLogger(HTTPInvoker.class);

	public static String invokeGET(String urlString) throws IOException {
		return invokeGET(urlString, null);
	}

	public static String invokeGET(String urlString, Map<String, String> details)
			throws IOException {

		/*
		 * log.debug("HTTPInvoker.invokeGET init...............");
		 * log.debug("HTTP GET URL before encoding parameters values: " +
		 * urlString);
		 */
		String result = null;
		/*
		 * Encode the parameter values
		 */
		if (StringUtils.isNotEmpty(urlString)) {
			String baseUrl = StringUtils.substringBefore(urlString, "?");
			String queryString = StringUtils.substringAfter(urlString, "?");
			if (StringUtils.isNotEmpty(queryString)) {
				String[] paramArr = StringUtils.split(queryString, "&");
				/*
				 * log.debug("QueryString before parameters values: " +
				 * queryString);
				 */
				queryString = "";

				for (String param : paramArr) {
					String key = StringUtils.substringBefore(param, "=");
					String value = StringUtils.substringAfter(param, "=");
					if (StringUtils.isNotEmpty(value)) {
						/*
						 * decode the value first
						 */
						value = URLDecoder.decode(value, "UTF-8");
						/*
						 * encode again the value
						 */
						value = URLEncoder.encode(value, "UTF-8");
					}
					queryString += key + "=" + value + "&";
				}
				/*
				 * Remove character "&" at the end of the string
				 */
				queryString = queryString
						.substring(0, queryString.length() - 1);

				/*
				 * log.debug("QueryString after encoding parameters values:  " +
				 * queryString);
				 */

				urlString = baseUrl + "?" + queryString;
				/*
				 * log.debug("HTTP GET URL after encoding parameters values: " +
				 * baseUrl + "?" + queryString);
				 */
			}
		}

		try {
			URL url = new URL(urlString);
			HttpURLConnection httpUrlConnection = (HttpURLConnection) url
					.openConnection();
			details.put(Constants.HTTP_GET_DETAILS_URL, urlString);
			if (httpUrlConnection.getResponseCode() != 200) {
				details.put(Constants.HTTP_GET_DETAILS_ERROR_CODE,
						("" + httpUrlConnection.getResponseCode()));
				details.put(Constants.HTTP_GET_DETAILS_ERROR_MSG,
						IOUtils.toString(httpUrlConnection.getErrorStream()));
			} else {
				result = IOUtils.toString(httpUrlConnection.getInputStream());
			}
		} finally {
		}
		return result;

	}

	public static String invokePOST(String urlString, String data)
			throws IOException {
		InputStream is = null;
		String result = null;
		try {
			URL url = new URL(urlString);
			URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");

			OutputStreamWriter os = new OutputStreamWriter(
					conn.getOutputStream());
			os.write(data);
			os.flush();
			os.close();
			result = IOUtils.toString(conn.getInputStream());
		} finally {
			IOUtils.closeQuietly(is);
		}

		return result;
	}
}
