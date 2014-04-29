package spb.mass.navigation.service;

import java.io.File;

//import org.apache.log4j.Logger;

import spb.mass.business.search.Constants;

/**
 * Facelet utility class handling facelet saving for services, and path
 * retieving.
 * 
 * @author jpr
 * 
 */
public class FaceletsUtil {
	public static final String FACELETEXTENSION = "xhtml";
	public static final String BUNDLEEXTENSION = "properties";

	public static final String CUSTOMFACELET_SEARCH = "search.xhtml";
	public static final String CUSTOMFACELET_RESULTS = "results.xhtml";
	public static final String CUSTOMFACELET_ORDER = "order.xhtml";
	public static final String CUSTOMFACELET_PRESENT = "present.xhtml";

	private static final String CUSTOMFACELET_FILENOTFOUND = "/WEB-INF/servicefacelets/servicefilenotfound.xhtml";
	private static final String CUSTOMFACELET_EMPTY = "/WEB-INF/servicefacelets/empty.xhtml";

	// private final static Logger log = Logger.getLogger(FaceletsUtil.class);

	public static String getEmptyFaceletPath() {
		return CUSTOMFACELET_EMPTY;
	}

	public static String getICDFaceletPath(String serviceId, String icdId,
			String operation, String serviceDescriptionDir) {
		String result = serviceDescriptionDir + "/"
				+ Constants.SERVICES_FACELETS + "/" + serviceId + "/"
				+ operation;
		/*
		 * log.debug("getICDFaceletPath:::absolutePath ::" + getAbsolutePath() +
		 * result);
		 */
		File file = new File(getAbsolutePath() + result);
		if (!file.exists()) {
			result = CUSTOMFACELET_FILENOTFOUND;
		}
		// log.debug("getICDFaceletPath:::before validating ::" + result);
		if (startWith(result)) {
			result = "file:///" + result;
		}
		// log.debug("getICDFaceletPath:::after validating ::" + result);
		return result;
	}

	public static String getAbsolutePath() {
		return NavigationUtils.getServletContext().getRealPath("/");
	}

	private static boolean startWith(String result) {
		result = result.toLowerCase();
		return (result.startsWith("c:") || result.startsWith("d:")
				|| result.startsWith("e:") || result.startsWith("f:") || result
					.startsWith("g:"));

	}
}
