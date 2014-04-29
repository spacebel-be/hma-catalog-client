package spb.mass.business.util;

import java.util.Arrays;
import java.util.List;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.business.search.Constants;
import spb.mass.navigation.service.FaceletsUtil;

public class BundleUtil {
	private static final BundleUtil bundleUtil = new BundleUtil();		

	private BundleUtil() {

	}

	public static BundleUtil getInstance() {
		return bundleUtil;
	}
	

	

	public boolean isXSDValidationOnPortalInputEnabled() {
		// return new Boolean(bundle.getString("portalinput.xsdvalidation"));
		return new Boolean("false");
	}
	

}
