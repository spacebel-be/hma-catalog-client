package spb.mass.navigation.service.search.model;

import java.io.Serializable;
import java.util.Vector;

public class SearchResultEventValue implements Serializable {
	private String serviceId;
	private Vector searchParams;
	private boolean orderStep;

	public Vector getSearchParams() {
		return searchParams;
	}

	public void setSearchParams(Vector searchParams) {
		this.searchParams = searchParams;
	}

	public boolean isOrderStep() {
		return orderStep;
	}

	public void setOrderStep(boolean orderStep) {
		this.orderStep = orderStep;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

}
