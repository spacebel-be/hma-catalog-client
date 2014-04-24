package spb.mass.navigation.service.search.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

//import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;

public class SearchResultItem {
	private Map<String, SearchResultProperty> properties;
	private Map<String, String> attributes;
	private boolean selectedForBasket;
	private boolean selectedForProcessing = true;
	private String productId;
	private String parentId;

	private String status;

	private String gmlNode;
	// backward compatibility
	private String opOutputXML;
	
	private String uuid;

	private final Logger log = Logger.getLogger(getClass());

	public SearchResultItem() {
		properties = new LinkedHashMap<String, SearchResultProperty>();
		attributes = new HashMap<String, String>();
		uuid = UUID.randomUUID().toString();
	}

	public void setSelectedForBasket(boolean selectedForBasket) {
		this.selectedForBasket = selectedForBasket;
		this.selectedForProcessing = selectedForBasket;
	}

	public void addProperty(String key, SearchResultProperty property) {
		properties.put(key, property);
	}

	public List<String> getPropertyKeys() {
		return new ArrayList<String>(properties.keySet());
	}

	@Override
	public boolean equals(Object obj) {
		boolean result = false;
		if (obj instanceof SearchResultItem) {
			SearchResultItem sri = (SearchResultItem) obj;
			if (productId != null && parentId != null
					&& productId.equals(sri.getProductId())
					&& parentId.equals(sri.getParentId())) {
				result = true;
			}
		}
		return result;
	}

	/* GETTERS AND SETTERS */

	public Map<String, SearchResultProperty> getProperties() {
		return properties;
	}

	public void setProperties(Map<String, SearchResultProperty> properties) {
		this.properties = properties;
	}

	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public boolean isSelectedForProcessing() {
		return selectedForProcessing;
	}

	public void setSelectedForProcessing(boolean selectedForProcessing) {
		this.selectedForProcessing = selectedForProcessing;
	}

	public Map<String, String> getAttributes() {
		return attributes;
	}

	public void setAttributes(Map<String, String> attributes) {
		this.attributes = attributes;
	}

	public String getOpOutputXML() {
		return opOutputXML;
	}

	public void setOpOutputXML(String opOutputXML) {
		this.opOutputXML = opOutputXML;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getGmlNode() {
		return gmlNode;
	}

	public void setGmlNode(String gmlNode) {
		this.gmlNode = gmlNode;
	}

	public boolean isSelectedForBasket() {
		return selectedForBasket;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
}
