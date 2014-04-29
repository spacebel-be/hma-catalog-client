package spb.mass.navigation.service.search.model;

import java.io.Serializable;

public class PresentEventValue implements Serializable{
	private String serviceId;
	private String productId;
	private String collectionId;

	public PresentEventValue(String serviceId, String productId,
			String collectionId) {
		super();
		this.serviceId = serviceId;
		this.productId = productId;
		this.collectionId = collectionId;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getCollectionId() {
		return collectionId;
	}

	public void setCollectionId(String collectionId) {
		this.collectionId = collectionId;
	}

}
