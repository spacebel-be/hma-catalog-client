package spb.mass.navigation.service;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.faces.event.ActionEvent;
import javax.faces.model.SelectItem;

import org.apache.log4j.Logger;

import spb.mass.businessdelegate.service.SearchOperationDelegate;

public class UMSSOBean {
	private String ssoUserID;
	private String ssoIDP;
	private String ssoDelegatedIDP;
	private List<SelectItem> idpList;
	private List<SelectItem> delegatedIdpList;
	private SearchOperationDelegate searchOperationDelegate;
	private Logger log = Logger.getLogger(getClass());

	@PostConstruct
	public void init() {
		log.debug("The UMSSOBean is initialized.");
		idpList = searchOperationDelegate.buildIDPList();
		delegatedIdpList = searchOperationDelegate.buildDelegatedIDPList();
	}

	public void saveSSOConfiguration(ActionEvent ae) {
		log.debug("SsoUserID:" + getSsoUserID());
		log.debug("SsoIDP:" + getSsoIDP());
		log.debug("SsoDelegatedIDP:" + getSsoDelegatedIDP());
	}

	public String getSsoUserID() {
		return ssoUserID;
	}

	public void setSsoUserID(String ssoUserID) {
		this.ssoUserID = ssoUserID;
	}

	public String getSsoIDP() {
		return ssoIDP;
	}

	public void setSsoIDP(String ssoIDP) {
		this.ssoIDP = ssoIDP;
	}

	public String getSsoDelegatedIDP() {
		return ssoDelegatedIDP;
	}

	public void setSsoDelegatedIDP(String ssoDelegatedIDP) {
		this.ssoDelegatedIDP = ssoDelegatedIDP;
	}

	public List<SelectItem> getIdpList() {
		return idpList;
	}

	public void setIdpList(List<SelectItem> idpList) {
		this.idpList = idpList;
	}

	public List<SelectItem> getDelegatedIdpList() {
		return delegatedIdpList;
	}

	public void setDelegatedIdpList(List<SelectItem> delegatedIdpList) {
		this.delegatedIdpList = delegatedIdpList;
	}

	public SearchOperationDelegate getSearchOperationDelegate() {
		return searchOperationDelegate;
	}

	public void setSearchOperationDelegate(
			SearchOperationDelegate searchOperationDelegate) {
		this.searchOperationDelegate = searchOperationDelegate;
	}
}
