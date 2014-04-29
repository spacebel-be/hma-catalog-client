package spb.mass.navigation.messages;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.navigation.utils.ManagedBeanUtil;

/**
 * Utility class to display error and info messages on the client, or retrieve
 * localized strings from the bundle.
 * 
 * @author jpr
 * 
 */
public class FacesMessageUtil {

	private ResourceBundle bundle;
	private final static Logger log = Logger.getLogger(FacesMessageUtil.class);

	private FacesMessageUtil(FacesContext fc, Locale locale) {
		bundle = ResourceBundle.getBundle(fc.getApplication()
				.getMessageBundle(), locale);
	}

	public static void addInfoMessage(String bundleKey, String... params) {
		addInfoMessageWithDetails(bundleKey, "", params);
	}

	public static void addInfoMessageWithDetails(String bundleKey,
			String details, String... params) {
		getInstance().addMessage(bundleKey, details,
				FacesMessage.SEVERITY_INFO, params);
	}

	public static void addInfoMessage(Throwable e) {
		log.error(e.getMessage(), e);
		getInstance().addMessage(e.getMessage(), getStackTraceAsString(e),
				FacesMessage.SEVERITY_INFO);
	}

	public static void addWarningMessage(String bundleKey, String... params) {
		addWarningMessageWithDetails(bundleKey, "", params);
	}

	public static void addWarningMessageWithDetails(String bundleKey,
			String details, String... params) {
		getInstance().addMessage(bundleKey, details,
				FacesMessage.SEVERITY_WARN, params);
	}

	public static void addWarningMessage(Throwable e) {
		log.error(e.getMessage(), e);
		getInstance().addMessage(e.getMessage(), getStackTraceAsString(e),
				FacesMessage.SEVERITY_WARN);
	}

	public static void addErrorMessage(String bundleKey, String... params) {
		addErrorMessageWithDetails(bundleKey, "", params);
	}

	public static void addErrorMessageWithDetails(String bundleKey,
			String details, String... params) {
		getInstance().addMessage(bundleKey, details,
				FacesMessage.SEVERITY_ERROR, params);
	}

	public static void addErrorMessage(Throwable e) {
		log.error(e.getMessage(), e);
		getInstance().addMessage(e.getMessage(), getStackTraceAsString(e),
				FacesMessage.SEVERITY_ERROR);
	}

	public static String getLocalizedString(String bundleKey, String... params) {
		return getInstance().getStringFromBundle(bundleKey, params);
	}

	private static FacesMessageUtil getInstance() {
		FacesContext fc = FacesContext.getCurrentInstance();
		Locale locale = null;
		try {
			locale = fc.getViewRoot().getLocale();

		} catch (NullPointerException npe) {
			locale = Locale.US;
		}
		return new FacesMessageUtil(fc, locale);
	}

	private void addMessage(String bundleKey, String details,
			FacesMessage.Severity severity, String... params) {
		String text = "null";
		if (bundleKey != null) {
			text = getStringFromBundle(bundleKey, params);
		}
		details = handleMessageFormatFromWorkflow(details);
		details = StringUtils.isNotEmpty(details) ? details : text;

		MessagesBean messagesBean = ManagedBeanUtil.lookup(MessagesBean.class);
		messagesBean.push(new FacesMessage(severity, messagesBean
				.getCSS(severity), details));
	}

	/**
	 * If details are coming from the workflow, we follow a specific pattern for
	 * separating messages.
	 * 
	 * @param details
	 * @return
	 */
	private String handleMessageFormatFromWorkflow(String details) {
		String messageDelimiter = "||";
		String contentDelimiter = "//";

		details = details.replace(messageDelimiter, "<br/><br/>");
		details = details.replace(contentDelimiter, "<br/>");

		return details;
	}

	private String getStringFromBundle(String bundleKey, String... params) {
		String text = null;
		try {
			text = bundle.getString(bundleKey);
		} catch (MissingResourceException e) {
			// property not found, we leave the text as is
			text = bundleKey;
		}

		if (params != null) {
			try {
				MessageFormat mf = new MessageFormat(text);
				text = mf.format(params, new StringBuffer(), null).toString();
			} catch (Exception e) {
				// message parsing failed, leave the text untouched
			}
		}
		return text;
	}

	public static String getStackTraceAsString(Throwable t) {
		return "";
		// return PortalDisplayException.getStackTraceAsString(t, true);
	}

}
