package spb.mass.navigation.service;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

/**
 * Utility class helping creating a URL. Usage example: String url = new
 * URLBuilder("http://www.hostname.com/path/to/page").addParam("serviceId",
 * "155841").addParam("mapConfigId","DefaultMap").build();
 * 
 * @author jpr
 * 
 */
public class URLBuilder {
	private String baseURL;
	private List<String> params;

	private Logger log = Logger.getLogger(getClass());

	public enum EncodeType {
		Encode, Untouched
	}

	public URLBuilder(String baseURL) {
		this.baseURL = baseURL;
		this.params = new ArrayList<String>();
	}

	public URLBuilder addParam(String name, String value) {
		return addParam(name, value, EncodeType.Encode);
	}

	public URLBuilder addParam(String name, String value, EncodeType encodeType) {
		if (StringUtils.isNotBlank(name) && StringUtils.isNotBlank(value)) {
			if (EncodeType.Encode.equals(encodeType)) {
				value = URLEncoder.encode(value);
			}
			params.add(name + "=" + value);
		}
		return this;
	}

	public String build() {
		String result = null;
		String paramString = StringUtils.join(params, "&");
		if (baseURL == null) {
			result = paramString;
		} else if (StringUtils.isBlank(paramString)) {
			result = baseURL;
		} else {
			int position = baseURL.indexOf("?");
			if (position == -1) {
				result = baseURL + "?" + paramString;
			} else if (position == baseURL.length() - 1) {
				result = baseURL + paramString;
			} else {
				result = baseURL + "&" + paramString;
			}
		}
		return result;
	}
}
