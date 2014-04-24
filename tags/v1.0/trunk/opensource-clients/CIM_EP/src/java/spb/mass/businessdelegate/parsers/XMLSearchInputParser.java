package spb.mass.businessdelegate.parsers;

import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import spb.mass.navigation.service.NavigationUtils;
import spb.mass.navigation.utils.TreeNodeData;

/**
 * Builds Map for input parameters, for both search and order
 * 
 * @author jpr
 * 
 */
public class XMLSearchInputParser {

	private final Logger log = Logger.getLogger(getClass());

	private static final String INPUTSEARCHDEFAULTS = "inputSearchDefaults";
	private static final String INPUTORDERDEFAULTS = "inputOrderDefaults";
	public static final String UNTOUCHED = "untouched";

	public Map<String, Object> buildSearchMapWithDefaultValues(
			String xmlSource, Map<String, Object> inputMap) {
		Map<String, Object> map = new HashMap<String, Object>();
		xmlSource = NavigationUtils.removeXMLDeclaration(xmlSource);

		if (!xmlSource.startsWith("<" + INPUTSEARCHDEFAULTS)
				&& !xmlSource.startsWith("<" + INPUTORDERDEFAULTS)) {
			map.put(UNTOUCHED, xmlSource);
			return map;
		}

		URL schemaLocation = null;
		Node root = XMLParserUtils.buildNode(xmlSource, schemaLocation);
		try {
			if (INPUTSEARCHDEFAULTS.equals(root.getNodeName())
					|| INPUTORDERDEFAULTS.equals(root.getNodeName())) {

				NodeList inputs = root.getChildNodes();
				for (int i = 0; i < inputs.getLength(); i++) {
					Node input = inputs.item(i);
					if ("input".equals(input.getNodeName())) {

						if (input.getAttributes().getNamedItem("name") == null) {
							log.error("XMLInputParser : attribute 'name' is mandatory.");
						}
						String name = input.getAttributes()
								.getNamedItem("name").getNodeValue();

						if (input.getAttributes().getNamedItem("type") == null) {
							log.error("XMLInputParser : attribute 'type' is mandatory for element "
									+ name);
						}
						String type = input.getAttributes()
								.getNamedItem("type").getNodeValue();

						String value = "";
						if (input.getAttributes().getNamedItem("value") != null) {
							value = input.getAttributes().getNamedItem("value")
									.getNodeValue();
						}

						if ("string".equals(type)) {
							map.put(name, value);
						} else if ("boolean".equals(type)) {
							map.put(name, new Boolean(value));
						} else if ("integer".equals(type)) {
							map.put(name, value);
						} else if ("date".equals(type)) {
							if (StringUtils.isNotBlank(value)
									&& input.getAttributes().getNamedItem(
											"format") != null) {
								String format = input.getAttributes()
										.getNamedItem("format").getNodeValue();
								long newTime = new Date().getTime()
										+ Long.parseLong(value);
								value = new SimpleDateFormat(format)
										.format(new Date(newTime));
							}
							map.put(name, value);
						} else if ("collections".equals(type)) {
							Node n = input.getChildNodes().item(0);
							if (n != null) {
								value = n.getNodeValue();
								value = value.trim();
								map.put(name, TreeNodeData.buildTree(value));
							} else {
								map.put(name, null);
							}

						} else if ("string_as_child".equals(type)) {
							if (input.getChildNodes().item(0) != null) {
								value = input.getChildNodes().item(0)
										.getNodeValue();
								value = value.replaceAll("(\\r|\\n)", "");
								value = value.trim();
								map.put(name, value);
							}
						} else if ("searchformValue".equals(type)
								&& inputMap != null) {
							Object valueObject = inputMap.get(value);
							if (valueObject instanceof String) {
								valueObject = NavigationUtils
										.removeXMLDeclaration("" + valueObject);
								log.debug("***************" + valueObject);
							}
							map.put(name, valueObject);

						}
					}
				}
			}
		} catch (Exception e) {
			log.error("XMLSearchInputParser.buildSearchMapWithDefaultValues()");
		}
		return map;
	}
}
