package spb.mass.navigation.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.List;
import java.util.ResourceBundle;
import java.util.TimeZone;
import java.util.Vector;
import java.util.concurrent.Callable;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import javax.annotation.PostConstruct;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;

import org.ajax4jsf.component.html.HtmlAjaxOutputPanel;
import org.ajax4jsf.model.KeepAlive;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.business.search.Constants;
import spb.mass.business.search.ServiceData;
import spb.mass.businessdelegate.parsers.XMLSearchResultParser;
import spb.mass.businessdelegate.service.SearchOperationDelegate;
import spb.mass.navigation.messages.FacesMessageUtil;
import spb.mass.navigation.service.search.model.SearchResultError;
import spb.mass.navigation.service.search.model.SearchResultItem;
import spb.mass.navigation.service.search.model.SearchResultSet;

@KeepAlive
public class ServiceBean implements Serializable {
	private static final long serialVersionUID = 636170254949756092L;

	private SearchOperationDelegate searchOperationDelegate;
	private UMSSOBean ssoBean;
	private List<SelectItem> services;
	private String serviceId;
	private ServiceData serviceData;
	private Map<String, Object> inputFormMap = new HashMap<String, Object>();
	private Map<String, Boolean> renderedFields = new HashMap<String, Boolean>();
	private ResourceBundle searchBundle;
	private HtmlAjaxOutputPanel searchQueryablesPanel;
	private Vector params;
	private boolean changeViewerHeight = false;

	private SearchResultSet resultSet;
	private SearchResultItem presentItem;
	private String presentType;
	private Future<Collection> currentRequest;

	private boolean renderResultTable;

	private long pagesWindow;
	private long currentpage;
	private long maxpages;

	private String wmcPath;

	private boolean showContent = true;
	private Map<String, String> searchLogMsg;
	private Map<String, String> presentLogMsg;

	private Logger log = Logger.getLogger(getClass());

	@PostConstruct
	public void init() {
		log.debug("The ServiceBean is initialized, serviceId = "
				+ this.serviceId);
		String beanAction = StringUtils.stripToNull(NavigationUtils
				.getRequestParameter("beanAction"));
		log.debug("SsoUserID:" + ssoBean.getSsoUserID());
		log.debug("SsoIDP:" + ssoBean.getSsoIDP());
		log.debug("SsoDelegatedIDP:" + ssoBean.getSsoDelegatedIDP());
		if (StringUtils.isNotEmpty(searchOperationDelegate.getErrorMsg())) {
			FacesMessageUtil.addErrorMessage(searchOperationDelegate
					.getErrorMsg());
			showContent = false;
		} else {
			if (StringUtils.isEmpty(beanAction)) {
				log.debug("The first loading.");

				String changeViewerHeight = NavigationUtils
						.getRequestParameter(Constants.MAPVIEWER_HEIGHT);
				if (StringUtils.isNotBlank(changeViewerHeight)) {
					this.changeViewerHeight = new Boolean(changeViewerHeight);
				}

				services = searchOperationDelegate.buildServices();
				pagesWindow = 2;

				if (services.size() > 0) {
					if (this.serviceId == null) {
						log.debug("get the first service in the list.");
						changeService((String) services.get(0).getValue());
					} else {
						log.debug("serviceId is not null :" + serviceId);
					}
				}
			} else {
				log.debug("beanAction: " + beanAction);
			}
		}
	}

	/**
	 * Search done through ajax. This is the actual entry point of the search.
	 * 
	 */
	public void doSearch(ActionEvent ae) {
		log.debug("Do search action..................");
		List<String> errorMessages = new Vector<String>();
		buildParamsVector(ae, errorMessages);
		if (errorMessages.isEmpty()) {
			doSearch();
		} else {
			for (String errorMsg : errorMessages) {
				FacesMessageUtil.addErrorMessage(errorMsg);
			}
		}
	}

	public void storePresentSet(ActionEvent ae) {
		cancelRequest();
		presentItem = null;
		final String productId = NavigationUtils
				.getRequestParameter("productId");
		final String collectionId = NavigationUtils
				.getRequestParameter("collectionId");
		final String icd = NavigationUtils.getRequestParameter("icd");

		if (StringUtils.isBlank(this.serviceId)) {
			changeService(NavigationUtils.getRequestParameter("serviceId"));
		}

		presentType = NavigationUtils.getRequestParameter("presentType");

		log.debug("productId::::" + productId);
		log.debug("collectionId::::" + collectionId);
		log.debug("icd::::" + icd);
		log.debug("presentType::::" + presentType);

		// Invoke with a timeout
		ExecutorService executor = Executors.newCachedThreadPool();
		Callable<Collection> task = new Callable<Collection>() {
			public Collection call() throws Exception {
				presentLogMsg = new HashMap<String, String>();
				return searchOperationDelegate.submitPresent(getServiceId(),
						collectionId, productId, icd, ssoBean.getSsoUserID(),
						ssoBean.getSsoIDP(), ssoBean.getSsoDelegatedIDP(),
						presentLogMsg);
			}
		};
		currentRequest = executor.submit(task);
		try {
			Collection result = currentRequest.get(90, TimeUnit.SECONDS);
			handlePresentResult(result, productId);
		} catch (TimeoutException ex) {
			FacesMessageUtil
					.addWarningMessage("searchresults.text.processtoolong");
		} catch (InterruptedException e) {
			FacesMessageUtil.addWarningMessage("Process interrupted");
		} catch (ExecutionException e) {
			FacesMessageUtil.addErrorMessageWithDetails(
					"common.unexpectederror", e.getCause().getMessage());
		} catch (CancellationException e) {
			// request was cancelled, do nothing
		} finally {
			cancelRequest();
		}

	}

	private void handlePresentResult(Collection col, String productId) {
		try {
			String xmlSource = (String) col.iterator().next();

			SearchResultSet presentSet = new XMLSearchResultParser()
					.buildResultSetFromXML(xmlSource);
			if (!presentSet.getItems().isEmpty()) {
				presentItem = presentSet.getItems().get(0);
				presentItem.setProductId(productId);
			}
			SearchResultError error = presentSet.getSearchResultError();
			if (error != null) {
				presentItem = null;
				FacesMessageUtil.addWarningMessageWithDetails(
						"searchinput.text.error.duringprocesspresent",
						StringUtils.isNotEmpty(error.getErrorMessage()) ? error
								.getErrorMessage() : "Unknown");
			} else if (presentSet.getItems().isEmpty()) {
				presentItem = null;
				FacesMessageUtil
						.addWarningMessage("searchresults.text.metadatanotfound");
			}

		} catch (Exception e) {
			presentItem = null;
			FacesMessageUtil.addErrorMessage(e.getMessage());
		}

	}

	public void changePage(ActionEvent ae) {
		String nextRecord = NavigationUtils
				.getRequestParameter(SearchResultSet.NEXTRECORD);
		String serviceId = NavigationUtils
				.getRequestParameter(Constants.SERVICE_ID_PARAM);
		if (StringUtils.isNotBlank(serviceId)) {
			this.serviceId = serviceId;
		}

		for (Object o : params) {
			Vector param = (Vector) o;
			if ("used_cursor".equals(param.get(0))) {
				log.debug("changing cursor to " + nextRecord);
				String[] paramValues = (String[]) param.get(1);
				paramValues[0] = nextRecord;
			}
		}
		doSearch();
	}

	public long getMaxpages() {
		this.maxpages = 1;
		if (resultSet != null) {
			try {
				String maxRecordsMatched = resultSet.getAttributes().get(
						"maxRecordsMatched");
				String displayedRecords = resultSet.getAttributes().get(
						"displayedRecords");
				this.maxpages = ceil(Double.parseDouble(maxRecordsMatched)
						/ Double.parseDouble(displayedRecords));
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return this.maxpages;
	}

	public long getCurrentpage() {
		this.currentpage = 1;
		if (resultSet != null) {
			try {
				String startPosition = resultSet.getAttributes().get(
						"startPosition");
				String displayedRecords = resultSet.getAttributes().get(
						"displayedRecords");
				this.currentpage = ceil(Double.parseDouble(startPosition)
						/ Double.parseDouble(displayedRecords));
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return this.currentpage;
	}

	/* Utility methods for scroller */
	public long ceil(double number) {
		Double d = Math.ceil(number);
		return d.longValue();
	}

	public List<Long> getBuildPagesList() {
		long startPage = currentpage - this.pagesWindow;
		long endPage = currentpage + this.pagesWindow;

		if (startPage < 1) {
			startPage = 1;
			endPage = 1 + 2 * this.pagesWindow;
			if (endPage > maxpages) {
				endPage = maxpages;
			}
		}

		if (endPage > maxpages) {
			endPage = maxpages;
			startPage = maxpages - (1 + 2 * this.pagesWindow);
			if (startPage < 1) {
				startPage = 1;
			}
		}

		List<Long> list = new ArrayList<Long>();
		for (long i = startPage; i <= endPage; i++) {
			list.add(i);
		}
		return list;
	}

	public List<String> getRerenderIds() {
		List<String> list = new ArrayList<String>();
		if (renderResultTable) {
			list.add("searchresults-panel");
		}
		return list;
	}

	private void doSearch() {
		cancelRequest();

		// Invoke with a timeout
		ExecutorService executor = Executors.newCachedThreadPool();
		Callable<Collection> task = new Callable<Collection>() {
			public Collection call() throws Exception {
				searchLogMsg = new HashMap<String, String>();
				return searchOperationDelegate.submitSearch(getServiceId(),
						getParams(), ssoBean.getSsoUserID(),
						ssoBean.getSsoIDP(), ssoBean.getSsoDelegatedIDP(),
						searchLogMsg);
			}
		};
		renderResultTable = true;
		currentRequest = executor.submit(task);
		try {
			Collection result = currentRequest.get(90, TimeUnit.SECONDS);
			handleSearchResult(result);
		} catch (TimeoutException ex) {
			log.error("Process took too long to execute and was aborted");
		} catch (InterruptedException e) {
			log.error("Process interrupted");
		} catch (ExecutionException e) {
			log.error("An unexpected error occurred during your request:"
					+ e.getCause().getMessage());
			e.printStackTrace();
		} catch (CancellationException e) {
			// don't refresh the table as it will remove the ajax animation
			renderResultTable = false;
		} finally {
			cancelRequest();
		}
	}

	private void handleSearchResult(Collection result) {
		try {
			Iterator iter = result.iterator();
			String r = (String) iter.next();

			resultSet = searchOperationDelegate.getSearchResultSet(r);
			Object[] keys = resultSet.getAttributes().keySet().toArray();
			for (Object key : keys) {
				log.debug(key + " = " + resultSet.getAttributes().get(key));
			}

			SearchResultError error = resultSet.getSearchResultError();

			if (error != null) {
				FacesMessageUtil.addWarningMessageWithDetails(
						"searchinput.text.error.duringprocess",
						StringUtils.isNotEmpty(error.getErrorMessage()) ? error
								.getErrorMessage() : "Unknown");

			} else if (resultSet.getItems().isEmpty()
					&& resultSet.getAttributes().get(
							XMLSearchResultParser.UNTOUCHED) == null) {
				log.debug("test::::"
						+ resultSet.getAttributes().get(
								XMLSearchResultParser.UNTOUCHED));
				/*
				 * FacesMessageUtil
				 * .addInfoMessage("searchresults.search.noresult");
				 */
				FacesMessageUtil.addInfoMessage("Search gave no results");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			FacesMessageUtil.addErrorMessage(e);
		}
	}

	/**
	 * Cancels any request that may still be executing
	 */
	private void cancelRequest() {
		if (currentRequest != null) {
			currentRequest.cancel(true);
		}
	}

	private void buildParamsVector(ActionEvent ae, List<String> errorMessages) {

		HttpServletRequest req = (HttpServletRequest) FacesContext
				.getCurrentInstance().getExternalContext().getRequest();
		Map<String, String> dropdownListsValues = new HashMap<String, String>();
		params = NavigationUtils.getParamFromRequest(req, dropdownListsValues);

		String selectedTab = NavigationUtils
				.getRequestParameter(NavigationUtils.TABNAME);
		try {
			params.addAll(NavigationUtils.getParamFromMap(inputFormMap,
					renderedFields, selectedTab, serviceData.getIcd(),
					searchOperationDelegate.getRegexExpressions(),
					errorMessages, dropdownListsValues));
		} catch (Exception e) {
			log.error("ServiceBean.buildParamsVector():::error:::"
					+ e.getMessage());
		}
	}

	public void changeService(ActionEvent ae) {
		String activatedServiceId = StringUtils.stripToNull(NavigationUtils
				.getRequestParameter("activatedServiceId"));
		log.debug("activatedServiceId :" + activatedServiceId);
		changeService(activatedServiceId);

	}

	public void addQueryableToForm(ActionEvent ae) {
		String key = NavigationUtils.getRequestParameter("queryable");
		log.debug("Adding queryable: " + key + " exist: "
				+ renderedFields.get(key));
		log.debug("service id: " + this.serviceId);
		if (!inputFormMap.containsKey(key)) {
			inputFormMap.put(key, "");
		}
		renderedFields.put(key, Boolean.TRUE);
	}

	public void removeQueryableFromForm(ActionEvent ae) {
		String key = NavigationUtils.getRequestParameter("queryable");
		log.debug("Removing queryable: " + key + " exist: "
				+ renderedFields.get(key));
		log.debug("service id: " + this.serviceId);

		renderedFields.put(key, Boolean.FALSE);
	}

	private void changeService(String serviceId) {
		log.debug("changing service: " + serviceId);
		try {
			inputFormMap.clear();
			this.serviceId = serviceId;
			this.serviceData = searchOperationDelegate
					.getServiceData(serviceId);
			log.debug("curent serviceId: " + this.serviceId);
			log.debug("curent serviceData: " + this.serviceData);

			resultSet = null;
			presentType = null;
			presentItem = null;
			searchLogMsg = null;
			presentLogMsg = null;

			String htmlForm = searchOperationDelegate
					.generateInputForm(serviceId);
			log.debug("Before removing XML declaration:" + htmlForm);

			// remove xml processing instruction
			htmlForm = NavigationUtils.removeXMLDeclaration(htmlForm);
			log.debug("After removing XML declaration:" + htmlForm);

			String preselectedCollections = NavigationUtils
					.getRequestParameter(Constants.PARAM_COLLECTIONS);
			log.debug("preselectedCollections:::" + preselectedCollections);

			inputFormMap = searchOperationDelegate
					.buildSearchMapWithDefaultValues(htmlForm,
							preselectedCollections);

			renderedFields.clear();
			for (String key : inputFormMap.keySet()) {
				log.debug("inputFormMap.key:::" + key);
				if (inputFormMap.get(key) != null) {
					renderedFields.put(key, Boolean.TRUE);
				}
			}

		} catch (Exception ex) {
			log.error(ex.getMessage());
		}
	}

	/**
	 * @return The timezone of the client
	 */
	public TimeZone getTimeZone() {
		FacesContext context = FacesContext.getCurrentInstance();
		Locale locale = context.getExternalContext().getRequestLocale();
		Calendar calendar = Calendar.getInstance(locale);
		TimeZone clientTimeZone = calendar.getTimeZone();
		return clientTimeZone;
	}

	public String getServiceFilesRootDirectory() {
		return searchOperationDelegate.getServiceDescriptionDir();
	}

	public String getSearchFaceletPath() {
		return FaceletsUtil.getICDFaceletPath(serviceId, serviceData.getIcd(),
				FaceletsUtil.CUSTOMFACELET_SEARCH,
				searchOperationDelegate.getServiceDescriptionDir());
	}

	public String getResultsFaceletPath() {
		return FaceletsUtil.getICDFaceletPath(serviceId, serviceData.getIcd(),
				FaceletsUtil.CUSTOMFACELET_RESULTS,
				searchOperationDelegate.getServiceDescriptionDir());
	}

	public String getPresentFaceletPath() {
		return FaceletsUtil.getICDFaceletPath(serviceId, serviceData.getIcd(),
				FaceletsUtil.CUSTOMFACELET_PRESENT,
				searchOperationDelegate.getServiceDescriptionDir());
	}

	public List<SelectItem> getServices() {
		return services;
	}

	public void setServices(List<SelectItem> services) {
		this.services = services;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public ServiceData getServiceData() {
		return serviceData;
	}

	public void setServiceData(ServiceData serviceData) {
		this.serviceData = serviceData;
	}

	public Map<String, Object> getInputFormMap() {
		return inputFormMap;
	}

	public void setInputFormMap(Map<String, Object> inputFormMap) {
		this.inputFormMap = inputFormMap;
	}

	public ResourceBundle getSearchBundle() {
		return searchBundle;
	}

	public void setSearchBundle(ResourceBundle searchBundle) {
		this.searchBundle = searchBundle;
	}

	public Map<String, Boolean> getRenderedFields() {
		return renderedFields;
	}

	public void setRenderedFields(Map<String, Boolean> renderedFields) {
		this.renderedFields = renderedFields;
	}

	public HtmlAjaxOutputPanel getSearchQueryablesPanel() {
		return searchQueryablesPanel;
	}

	public void setSearchQueryablesPanel(
			HtmlAjaxOutputPanel searchQueryablesPanel) {
		this.searchQueryablesPanel = searchQueryablesPanel;
	}

	public Vector getParams() {
		return params;
	}

	public void setParams(Vector params) {
		this.params = params;
	}

	public boolean isChangeViewerHeight() {
		return changeViewerHeight;
	}

	public void setChangeViewerHeight(boolean changeViewerHeight) {
		this.changeViewerHeight = changeViewerHeight;
	}

	public SearchResultSet getResultSet() {
		return resultSet;
	}

	public void setResultSet(SearchResultSet resultSet) {
		this.resultSet = resultSet;
	}

	public SearchResultItem getPresentItem() {
		return presentItem;
	}

	public void setPresentItem(SearchResultItem presentItem) {
		this.presentItem = presentItem;
	}

	public String getPresentType() {
		return presentType;
	}

	public void setPresentType(String presentType) {
		this.presentType = presentType;
	}

	public long getPagesWindow() {
		return pagesWindow;
	}

	public void setPagesWindow(long pagesWindow) {
		this.pagesWindow = pagesWindow;
	}

	public void setCurrentpage(long currentpage) {
		this.currentpage = currentpage;
	}

	public void setMaxpages(long maxpages) {
		this.maxpages = maxpages;
	}

	public String getWmcPath() {
		wmcPath = "http://" + NavigationUtils.getRequest().getServerName()
				+ ":" + NavigationUtils.getRequest().getServerPort()
				+ NavigationUtils.getRequest().getContextPath()
				+ "/js/spacemap/wmc.xml";

		return wmcPath;
	}

	public void setWmcPath(String wmcPath) {
		this.wmcPath = wmcPath;
	}

	public SearchOperationDelegate getSearchOperationDelegate() {
		return searchOperationDelegate;
	}

	public void setSearchOperationDelegate(
			SearchOperationDelegate searchOperationDelegate) {
		this.searchOperationDelegate = searchOperationDelegate;
	}

	public UMSSOBean getSsoBean() {
		return ssoBean;
	}

	public void setSsoBean(UMSSOBean ssoBean) {
		this.ssoBean = ssoBean;
	}

	public boolean isShowContent() {
		return showContent;
	}

	public void setShowContent(boolean showContent) {
		this.showContent = showContent;
	}

	public Map<String, String> getSearchLogMsg() {
		return searchLogMsg;
	}

	public void setSearchLogMsg(Map<String, String> searchLogMsg) {
		this.searchLogMsg = searchLogMsg;
	}

	public Map<String, String> getPresentLogMsg() {
		return presentLogMsg;
	}

	public void setPresentLogMsg(Map<String, String> presentLogMsg) {
		this.presentLogMsg = presentLogMsg;
	}
}
