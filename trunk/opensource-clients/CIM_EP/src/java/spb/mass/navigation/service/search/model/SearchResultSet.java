package spb.mass.navigation.service.search.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Node;

import spb.mass.businessdelegate.parsers.XMLParserUtils;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;

public class SearchResultSet implements Serializable {
	private String serviceId;

	private List<SearchResultItem> items;
	private Map<String, String> attributes;
	private String gmlEnveloppe;
	private boolean gmlComplete;
	private SearchResultError searchResultError;

	private final Logger log = Logger.getLogger(getClass());
	public static final String NEXTRECORD = "nextRecord";

	public SearchResultSet() {
		items = new ArrayList<SearchResultItem>();
		attributes = new HashMap<String, String>();
	}

	public void addItem(SearchResultItem item) {
		items.add(item);
	}

	public List<String> getLabels() {
		List<String> list = new ArrayList<String>();
		if (!items.isEmpty()) {
			for (String s : items.get(0).getProperties().keySet()) {
				list.add(s);
			}
		}
		return list;
	}

	/**
	 * @return dynamically generate the GML features for the content of the
	 *         result set used for both search results and the basket
	 */
	public String getGmlFeatures() {
		String result = "";
		try {
			if (!getItems().isEmpty() && StringUtils.isNotBlank(gmlEnveloppe)) {
				if (gmlComplete) {
					result = gmlEnveloppe;
				} else {
					Node features = XMLParserUtils.buildNode(gmlEnveloppe);

					for (SearchResultItem item : getItems()) {
						Node importNode = XMLParserUtils.buildNode(item
								.getGmlNode());
						importNode = features.getOwnerDocument().importNode(
								importNode, true);
						features.appendChild(importNode);
					}
					result = XMLParserUtils.getNodeContent(features);
				}
			}
		} catch (Exception e) {
			log.error("GML Features:error: " + e.getMessage());
		}
		log.debug("GML Features: " + result);
		return result;
	}

	public boolean statusesAvailable() {
		boolean avail = false;
		for (SearchResultItem item : items) {
			if (StringUtils.isNotBlank(item.getStatus())) {
				avail = true;
				break;
			}
		}
		return avail;
	}	

	public String serialize() {
		return new JSONSerializer().deepSerialize(this);
	}

	public static SearchResultSet deserialize(String serializedSet) {
		return new JSONDeserializer<SearchResultSet>()
				.deserialize(serializedSet);
	}

	/* GETTERS AND SETTERS */
	public String getGmlEnveloppe() {
		return gmlEnveloppe;
	}

	public void setGmlEnveloppe(String gmlEnveloppe) {
		this.gmlEnveloppe = gmlEnveloppe;
	}

	public Map<String, String> getAttributes() {
		return attributes;
	}

	public void setAttributes(Map<String, String> attributes) {
		this.attributes = attributes;
	}

	public List<SearchResultItem> getItems() {
		return items;
	}

	public void setItems(List<SearchResultItem> items) {
		this.items = items;
	}

	public SearchResultError getSearchResultError() {
		return searchResultError;
	}

	public void setSearchResultError(SearchResultError searchResultError) {
		this.searchResultError = searchResultError;
	}

	public boolean isGmlComplete() {
		return gmlComplete;
	}

	public void setGmlComplete(boolean gmlComplete) {
		this.gmlComplete = gmlComplete;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
}
