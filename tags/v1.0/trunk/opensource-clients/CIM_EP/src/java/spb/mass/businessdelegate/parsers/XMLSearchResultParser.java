package spb.mass.businessdelegate.parsers;

import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import spb.mass.business.util.BundleUtil;
import spb.mass.navigation.service.NavigationUtils;
import spb.mass.navigation.service.search.model.SearchResultError;
import spb.mass.navigation.service.search.model.SearchResultItem;
import spb.mass.navigation.service.search.model.SearchResultProperty;
import spb.mass.navigation.service.search.model.SearchResultSet;

public class XMLSearchResultParser {

	private final Logger log = Logger.getLogger(this.getClass().getName());
	public static final String UNTOUCHED = "untouched";
	private static final String LISTPREFIX = "list_";

	public SearchResultSet buildResultSetFromXML(String xmlSource) {

		xmlSource = NavigationUtils.removeXMLDeclaration(xmlSource);

		log.debug("buildResultSetFromXML:::xmlSource:::" + xmlSource);

		SearchResultSet set = new SearchResultSet();

		// backward compatibility
		if (!xmlSource.trim().startsWith("<elements")) {
			set.getAttributes().put(UNTOUCHED, xmlSource);			
			return set;
		}

		URL schemaLocation = null;
		if (BundleUtil.getInstance().isXSDValidationOnPortalInputEnabled()) {
			schemaLocation = this
					.getClass()
					.getClassLoader()
					.getResource(
							"/spb/mass/businessdelegate/portalsearchresults.xsd");
		}

		Node root = XMLParserUtils.buildNode(xmlSource, schemaLocation);		

		for (int i = 0; i < root.getAttributes().getLength(); i++) {
			Node attrNode = root.getAttributes().item(i);
			String value = attrNode.getNodeValue();

			// if value is a number, let's remove decimals if value is an
			// integer
			try {
				double dd = Double.parseDouble(value);
				int ii = (int) dd;
				if (dd == ii) {
					value = "" + ii;
				}
			} catch (NumberFormatException e) {
				// do nothing
			}
			set.getAttributes().put(attrNode.getNodeName(), value);
		}

		NodeList children = root.getChildNodes();		

		for (int i = 0; i < children.getLength(); i++) {
			Node n = children.item(i);			
			if ("element".equals(n.getNodeName())) {
				SearchResultItem searchResultItem = buildResultItem(n);				
				set.addItem(searchResultItem);
			} else if ("gmlEnveloppe".equals(n.getNodeName())) {
				set.setGmlEnveloppe(XMLParserUtils.getNodeContent(n
						.getFirstChild()));
				Node completeNode = n.getAttributes().getNamedItem("complete");
				if (completeNode != null) {
					Boolean complete = new Boolean(completeNode.getNodeValue());
					set.setGmlComplete(complete);
				}
			} else if ("error".equals(n.getNodeName())) {
				set.setSearchResultError(buildErrorNode(n));
			} else {
				set.getAttributes().put(n.getNodeName(),
						XMLParserUtils.getNodeContent(n));
			}
		}

		return set;
	}

	private SearchResultError buildErrorNode(Node n) {
		SearchResultError error = new SearchResultError();

		for (int i = 0; i < n.getChildNodes().getLength(); i++) {
			Node child = n.getChildNodes().item(i);
			if ("errorCode".equals(child.getNodeName())) {
				error.setErrorCode(StringUtils.trim(child.getTextContent()));
			} else if ("errorMsg".equals(child.getNodeName())) {
				error.setErrorMessage(StringUtils.trim(child.getTextContent()));
			}
		}

		return error;
	}

	private SearchResultItem buildResultItem(Node n) {
		SearchResultItem searchResultItem = new SearchResultItem();
		String productId = null;
		String parentId = null;
		if (n.getAttributes().getNamedItem("productId") != null) {
			productId = n.getAttributes().getNamedItem("productId")
					.getNodeValue();
		}
		if (n.getAttributes().getNamedItem("parentId") != null) {
			parentId = n.getAttributes().getNamedItem("parentId")
					.getNodeValue();
		}

		searchResultItem.setParentId(parentId);
		searchResultItem.setProductId(productId);

		NodeList childs = n.getChildNodes();
		for (int i = 0; i < childs.getLength(); i++) {
			Node propertyNode = childs.item(i);

			if ("group".equals(propertyNode.getNodeName())) {
				String groupName = propertyNode.getAttributes()
						.getNamedItem("name").getNodeValue();
				SearchResultProperty group = searchResultItem.getProperties()
						.get(groupName);
				if (group == null) {
					group = new SearchResultProperty();
					searchResultItem.getProperties().put(groupName, group);
				}
				Map<String, SearchResultProperty> map = new HashMap<String, SearchResultProperty>();
				for (int j = 0; j < propertyNode.getChildNodes().getLength(); j++) {
					Node propertyGroupNode = propertyNode.getChildNodes().item(
							j);
					String propertyGroupName = propertyNode.getChildNodes()
							.item(j).getAttributes().getNamedItem("name")
							.getNodeValue();
					SearchResultProperty prop = buildSearchResultProperty(
							propertyGroupName, propertyGroupNode);
					map.put(propertyGroupName, prop);
				}
				group.getGroups().add(map);
			} else if ("property".equals(propertyNode.getNodeName())) {
				String propertyName = propertyNode.getAttributes()
						.getNamedItem("name").getNodeValue();
				SearchResultProperty property = buildSearchResultProperty(
						propertyName, propertyNode);
				if (propertyName.startsWith(LISTPREFIX)) {
					SearchResultProperty mapProp = searchResultItem
							.getProperties().get(propertyName);
					if (mapProp == null) {
						mapProp = property;
						searchResultItem.addProperty(propertyName, property);
					}
					mapProp.getValues().add(property.getValue());

				} else {
					searchResultItem.addProperty(propertyName, property);
				}

			} else if ("gmlFeature".equals(propertyNode.getNodeName())) {
				searchResultItem.setGmlNode(XMLParserUtils
						.getNodeContent(propertyNode.getFirstChild()));
			} else {
				searchResultItem.getAttributes().put(
						propertyNode.getNodeName(),
						XMLParserUtils.getNodeContent(propertyNode));
			}
		}
		return searchResultItem;
	}

	private SearchResultProperty buildSearchResultProperty(String propertyName,
			Node propertyNode) {

		Node valueNode = propertyNode.getChildNodes().item(0);
		String propertyValue = "";
		propertyValue = XMLParserUtils.getNodeContent(valueNode);
		
		propertyValue = StringEscapeUtils.unescapeHtml(propertyValue);
		// decode throws an exception if the url is not properly encoded, so
		// we encode it before decoding it
		propertyValue = URLEncoder.encode(propertyValue);
		propertyValue = URLDecoder.decode(propertyValue);
		propertyValue = propertyValue.trim();
		
		SearchResultProperty property = new SearchResultProperty();

		property.setValue(propertyValue);

		if (propertyNode.getAttributes().getNamedItem("orderInput") != null) {
			boolean propertyOrderInput = new Boolean(propertyNode
					.getAttributes().getNamedItem("orderInput").getNodeValue());
			property.setOrderInput(propertyOrderInput);
			log.debug("orderInput: " + propertyName);
		}
		return property;
	}
}
