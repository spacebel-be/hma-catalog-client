package spb.mass.businessdelegate.service;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;
import java.util.Vector;

import javax.faces.model.SelectItem;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.primefaces.model.DefaultTreeNode;
import org.primefaces.model.TreeNode;

import spb.mass.business.search.OpenSearchParameter;
import spb.mass.business.search.SearchProcessManager;
import spb.mass.business.search.ServiceData;
import spb.mass.business.search.ServiceProcessMananger;
import spb.mass.business.search.Constants;
import spb.mass.businessdelegate.parsers.XMLSearchInputParser;
import spb.mass.businessdelegate.parsers.XMLSearchResultParser;
import spb.mass.navigation.service.FaceletsUtil;
import spb.mass.navigation.service.NavigationUtils;
import spb.mass.navigation.service.search.model.SearchResultSet;
import spb.mass.navigation.utils.SelectItemComparator;
import spb.mass.navigation.utils.TreeNodeData;

public class SearchOperationDelegate {
	private final Logger log = Logger.getLogger(this.getClass().getName());
	private static String serviceDescDefaultDir = "data";

	private SearchProcessManager searchProcessManager;
	private ServiceProcessMananger serviceProcessMananger;
	private ResourceBundle systemResource;
	private ResourceBundle icdRegexExpressions;
	private ResourceBundle idpList;
	private ResourceBundle idpDelegatedList;
	private Map<String, ServiceData> serviceList;
	private Map<String, String> regexExpressionList = new HashMap<String, String>();
	private static boolean initialized = false;
	private static String serviceDescriptionDirAbsolutePath;
	private String errorMsg;

	public SearchOperationDelegate() {
		log.debug("New instance SearchOperationDelegate().initialized = "
				+ initialized);
		if (!initialized) {
			init();
		}
	}

	private synchronized void init() {
		log.debug("SearchOperationDelegate initializing...................");
		try {
			systemResource = PropertyResourceBundle.getBundle("resources");
			icdRegexExpressions = PropertyResourceBundle
					.getBundle("icd-regex-expressions");
			idpList = PropertyResourceBundle.getBundle("idp");
			idpDelegatedList = PropertyResourceBundle
					.getBundle("delegated-idp");
			searchProcessManager = new SearchProcessManager();
			serviceProcessMananger = new ServiceProcessMananger();
			int serverPort = NavigationUtils.getRequest().getServerPort();

			/*
			 * get predefined namespaces and parameters of OpenSearch ICD
			 */
			Map<String, String> preDefinedOSNamespaces = new HashMap<String, String>();
			Map<String, OpenSearchParameter> preDefinedOSParams = new HashMap<String, OpenSearchParameter>();

			serviceProcessMananger.loadPreDefinedOSParamsAndNamespaces(
					preDefinedOSNamespaces, preDefinedOSParams);
			/*
			 * get all services data
			 */
			serviceList = serviceProcessMananger.getAllServices(
					preDefinedOSNamespaces, preDefinedOSParams, serverPort);

			/*
			 * get absolute path of data service description directory
			 */
			serviceDescriptionDirAbsolutePath = FaceletsUtil.getAbsolutePath()
					+ getServiceDescriptionDir();
			log.debug("serviceDescriptionDirAbsolutePath : "
					+ serviceDescriptionDirAbsolutePath);
			/*
			 * load list of Regex Expressions of the ICDs
			 */
			loadRegexExpressions();

			/*
			 * Follow the services configuration file, create facelets files for
			 * services
			 */
			createFaceletFiles4Services();

			initialized = true;
		} catch (Exception e) {
			if (log.isDebugEnabled()) {
				e.printStackTrace();
			}
			errorMsg = e.getMessage();
		}
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public List<SelectItem> buildServices() {
		List<SelectItem> list = new ArrayList<SelectItem>();
		for (ServiceData serviceData : serviceList.values()) {
			list.add(new SelectItem(serviceData.getId(), serviceData.getName()));
		}
		SelectItemComparator.sort(list);
		return list;
	}

	public String generateInputForm(String serviceId) {
		String inputSearchForm = "";
		try {
			ServiceData serviceData = getServiceData(serviceId);
			String xmlFilePath = serviceDescriptionDirAbsolutePath + "/"
					+ Constants.MASS_XML_FILE;
			inputSearchForm = searchProcessManager.getHTMLStr(
					serviceId,
					Constants.XSL_SENDSEARCHINPUT_HTML,
					xmlFilePath,
					serviceDescriptionDirAbsolutePath
							+ "/"
							+ serviceData.getOperations()
									.get(Constants.LIFE_CYCLE_SEARCH)
									.getXslFile());
		} catch (Exception e) {
			log.error("SearchOperationDelegate.generateInputForm(serviceId = "
					+ serviceId + "): error: " + e.getMessage());
		}
		return inputSearchForm;
	}

	public Collection submitSearch(String serviceId, Vector parameters,
			String userId, String idp, String delegatedIdp,
			Map<String, String> logMsg) throws IOException {
		log.debug("enter submitSearch");
		return searchProcessManager.processSynchronousOperation(
				getServiceData(serviceId), Constants.LIFE_CYCLE_SEARCH,
				parameters, serviceDescriptionDirAbsolutePath, userId, idp,
				delegatedIdp, getSystemResource(Constants.SERVICE_DEFAULT_NS),
				logMsg);
	}

	public SearchResultSet getSearchResultSet(String xmlSource) {
		return new XMLSearchResultParser().buildResultSetFromXML(xmlSource);
	}

	public Collection submitPresent(String serviceId, String collectionId,
			String productId, String icd, String userId, String idp,
			String delegatedIdp, Map<String, String> logMsg) throws IOException {
		Collection col = null;
		Vector params = new Vector();
		NavigationUtils.addParameterToVector(params, "serviceId", serviceId);
		NavigationUtils.addParameterToVector(params, "collectionId",
				collectionId);
		NavigationUtils.addParameterToVector(params, "productId", productId);
		NavigationUtils.addParameterToVector(params, "presentation", "full");
		if (StringUtils.isNotEmpty(icd)) {
			NavigationUtils.addParameterToVector(params, "ICD", icd);
		}

		for (Object o : params) {
			Vector v = (Vector) o;
			Iterator it = v.iterator();
			String key = (String) it.next();
			String[] vals = (String[]) it.next();
			log.debug("key: " + key);
			for (String s : vals) {
				log.debug("value: " + s);
			}
		}
		return searchProcessManager.processSynchronousOperation(
				getServiceData(serviceId), Constants.LIFE_CYCLE_PRESENT,
				params, serviceDescriptionDirAbsolutePath, userId, idp,
				delegatedIdp, getSystemResource(Constants.SERVICE_DEFAULT_NS),
				logMsg);

	}

	public Map<String, Object> buildSearchMapWithDefaultValues(
			String xmlSource, String preselectedCollections) {
		Map<String, Object> map = new XMLSearchInputParser()
				.buildSearchMapWithDefaultValues(xmlSource, null);

		handleMapForPreselectedCollections(map, preselectedCollections);
		return map;
	}

	public ServiceData getServiceData(String serviceId) throws IOException {
		return serviceList.get(serviceId);
	}

	public void handleMapForPreselectedCollections(Map<String, Object> map,
			String preselectedCollections) {
		if (StringUtils.isNotBlank(preselectedCollections)) {
			List<String> selectedCollections = Arrays
					.asList(preselectedCollections
							.split(Constants.PARAM_COLLECTIONS_SEPARATOR));
			for (Object o : map.values()) {
				if (o instanceof TreeNode) {
					TreeNode node = (TreeNode) o;
					boolean exactMatch = handleNodeExactMatch(node,
							selectedCollections);
					if (!exactMatch) {
						log.debug("No exact match for "
								+ preselectedCollections
								+ ", searching for the best match now.");
						DefaultTreeNode bestNode = (DefaultTreeNode) handleNodeApproximate(
								node, preselectedCollections, node);
						bestNode.setType("selected");
					}
				}
			}
		}
	}

	/**
	 * Sets a node to selected if its value matches exactly one of the
	 * collection names passed.
	 * 
	 */
	private boolean handleNodeExactMatch(TreeNode tn,
			List<String> selectedCollections) {
		boolean exactMatch = false;
		DefaultTreeNode node = (DefaultTreeNode) tn;
		TreeNodeData data = (TreeNodeData) node.getData();
		if (selectedCollections.contains(data.getValue())) {
			node.setType("selected");
			exactMatch = true;
		}

		for (TreeNode child : node.getChildren()) {
			boolean childMatch = handleNodeExactMatch(child,
					selectedCollections);
			exactMatch |= childMatch;
		}
		return exactMatch;
	}

	/**
	 * Recursively traverses the tree to find the best node that matches the
	 * keywords
	 * 
	 * @param tn
	 *            the current node
	 * @param keywords
	 * @param bestNodeSoFar
	 *            null if just starting
	 * @return
	 */
	private TreeNode handleNodeApproximate(TreeNode tn, String keywords,
			TreeNode bestNodeSoFar) {
		DefaultTreeNode currentNode = (DefaultTreeNode) tn;
		TreeNodeData currentData = (TreeNodeData) currentNode.getData();

		DefaultTreeNode bestNode = (DefaultTreeNode) bestNodeSoFar;
		TreeNodeData bestNodeData = (TreeNodeData) bestNode.getData();

		int currentCount = containsCount(currentData.getValue(),
				keywords.split(" "));
		int bestCount = containsCount(bestNodeData.getValue(),
				keywords.split(" "));

		TreeNode newNode = null;
		if (StringUtils.isBlank(currentData.getValue())) {
			newNode = bestNodeSoFar;
		} else if (StringUtils.isBlank(bestNodeData.getValue())) {
			newNode = currentNode;
		} else if (bestCount > currentCount) {
			newNode = bestNodeSoFar;
		} else if (bestCount < currentCount) {
			newNode = currentNode;
		} else {
			int currentNodeScore = StringUtils.getLevenshteinDistance(
					currentData.getValue().toUpperCase(),
					keywords.toUpperCase());
			int bestNodeScore = StringUtils.getLevenshteinDistance(bestNodeData
					.getValue().toUpperCase(), keywords.toUpperCase());

			if (currentNodeScore < bestNodeScore) {
				newNode = currentNode;
			} else {
				newNode = bestNodeSoFar;
			}
		}

		for (TreeNode child : currentNode.getChildren()) {
			newNode = handleNodeApproximate(child, keywords, newNode);
		}
		return newNode;
	}

	/**
	 * returns true if s contains all elements in tests
	 * 
	 * @param s
	 * @return
	 */
	private int containsCount(String s, String[] tests) {
		int result = 0;
		for (String test : tests) {
			if (StringUtils.containsIgnoreCase(s, test)) {
				result++;
			}
		}
		return result;
	}

	public String getSystemResource(String name) {
		String value = systemResource.getString(name);
		if (StringUtils.isNotEmpty(value)) {
			value = StringUtils.trim(value);
		}
		return value;
	}

	public String getServiceDescriptionDir() {
		String sDir = systemResource.getString(Constants.SERVICE_DESC_DIR);
		if (StringUtils.isEmpty(sDir)) {
			sDir = serviceDescDefaultDir;
		}
		// log.debug(sDir);
		return sDir;
	}

	public String getServiceDescriptionDirAbsolutePath() {
		return serviceDescriptionDirAbsolutePath;
	}

	public List<SelectItem> buildIDPList() {
		List<SelectItem> list = new ArrayList<SelectItem>();
		Enumeration<String> keys = idpList.getKeys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			String value = idpList.getString(key);
			if (StringUtils.isNotEmpty(value)) {
				value = StringUtils.trim(value);
			}
			list.add(new SelectItem(key, value));
		}
		SelectItemComparator.sort(list);
		return list;
	}

	public List<SelectItem> buildDelegatedIDPList() {
		List<SelectItem> list = new ArrayList<SelectItem>();
		Enumeration<String> keys = idpDelegatedList.getKeys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			String value = idpDelegatedList.getString(key);
			if (StringUtils.isNotEmpty(value)) {
				value = StringUtils.trim(value);
			}
			list.add(new SelectItem(key, value));
		}
		SelectItemComparator.sort(list);
		return list;
	}

	public Map<String, String> getRegexExpressions() {
		return regexExpressionList;
	}

	private void loadRegexExpressions() {
		log.debug("loadRegexExpressions................");
		Enumeration<String> keys = icdRegexExpressions.getKeys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			String value = icdRegexExpressions.getString(key);
			if (StringUtils.isNotEmpty(value)) {
				value = StringUtils.trim(value);
			}
			regexExpressionList.put(key, value);
		}

	}

	private void createFaceletFiles4Services() throws IOException {
		String faceletDir = serviceDescriptionDirAbsolutePath + "/"
				+ Constants.SERVICES_FACELETS;
		try {
			/*
			 * create servicesfacelets directory
			 */
			File sfDir = new File(faceletDir);
			if (!sfDir.exists()) {
				FileUtils.forceMkdir(sfDir);
			}
			for (ServiceData serviceData : serviceList.values()) {
				/*
				 * create service id directory
				 */
				String faceletsDestDir = faceletDir + "/" + serviceData.getId();
				File destDir = new File(faceletsDestDir);
				if (!destDir.exists()) {
					FileUtils.forceMkdir(destDir);
				}
				String faceletsSrcDir = serviceDescriptionDirAbsolutePath
						+ "/icd/" + serviceData.getIcd() + "/"
						+ Constants.ICD_FACELETS;
				FileUtils.copyDirectory(new File(faceletsSrcDir), destDir);
			}
		} catch (SecurityException s) {
			throw new IOException(s);
		} catch (IOException io) {
			String eMsg = io.getMessage()
					+ ". Please use 'chown' command to set writable permission for directory $TOMCAT_HOME/webapps/catalogueClient/data and then restart Apache Tomcat.";
			throw new IOException(eMsg);
		}
	}
}
