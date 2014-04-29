package spb.mass.navigation.service;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletContext;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.primefaces.model.TreeNode;
import org.richfaces.model.UploadItem;
import org.w3c.dom.Node;

import spb.mass.business.search.Constants;
import spb.mass.businessdelegate.parsers.XMLSearchInputParser;
import spb.mass.navigation.utils.TreeNodeData;

public class NavigationUtils {
	private static final String xmlDeclaration = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
	private static final String nsRequestName = "org.ajax4jsf.portlet.NAMESPACE";
	private static final String facesPrefix = "javax.";

	private static final String ajaxRequestName = "AJAXREQUEST";

	/**
	 * For Search queryables
	 */
	private static final String TABDELIMITER = "#";
	private static final String SUBJECTPARAM = "used_subject";
	private static final String KEYWORDPARAM = "used_keyword";
	public static final String TABNAME = "typeHidden";
	public static final String ACQUISITION_TYPE = "used_acquisitionType";
	public static final String ACQUISITION_NOMINAL = "NOMINAL";
	public static final String ACQUISITION_CALIBRATION = "CALIBRATION";
	public static final String ACQUISITION_OTHER = "OTHER";
	public static final String STATUS = "used_status";
	public static final String STATUS_ACQUIRED = "ACQUIRED";
	public static final String STATUS_ARCHIVED = "ARCHIVED";
	public static final String STATUS_PLANNED = "PLANNED";
	public static final String STATUS_POTENTIAL = "POTENTIAL";
	public static final String SENSOR_TYPE = "used_sensorType";
	public static final String SENSOR_ALTIMETRIC = "ALTIMETRIC";
	public static final String SENSOR_ATMOSPHERIC = "ATMOSPHERIC";
	public static final String SENSOR_RADAR = "RADAR";
	public static final String SENSOR_OPTICAL = "OPTICAL";
	public static final String ORBIR_DIRECTION = "used_orbitDirection";
	public static final String ORBIR_DIR_ASC = "ASCENDING";
	public static final String ORBIR_DIR_DES = "DESCENDING";

	private static final Logger log = Logger.getLogger(NavigationUtils.class
			.getName());

	public static String getRequestParameter(String paramName) {
		return getRequest().getParameter(paramName);
	}

	public static HttpServletRequest getRequest() {
		HttpServletRequest request = (HttpServletRequest) FacesContext
				.getCurrentInstance().getExternalContext().getRequest();

		if (request == null) {
			throw new RuntimeException(
					"Sorry. Got a null request from faces context");
		}
		return request;
	}

	public static ServletContext getServletContext() {
		ServletContext context = (ServletContext) FacesContext
				.getCurrentInstance().getExternalContext().getContext();
		if (context == null) {
			throw new RuntimeException(
					"Sorry. Got a null ServletContext from faces context");
		}
		return context;
	}

	public static String removeXMLDeclaration(String inputString) {
		String result = inputString;
		if (result != null) {
			if (result.startsWith(xmlDeclaration)) {
				result = result.substring(xmlDeclaration.length());
			}
			if (result.startsWith(System.getProperty("line.separator"))) {
				result = result.substring(System.getProperty("line.separator")
						.length());
			}
			if (result.startsWith("\r\n")) {
				result = result.substring("\r\n".length());
			}
		}
		return result;
	}

	public static String getParamFromRequest(String paramName) {
		Object o = FacesContext.getCurrentInstance().getExternalContext()
				.getRequest();
		if (o instanceof HttpServletRequest) {
			HttpServletRequest req = (HttpServletRequest) o;
			return (String) req.getParameter(paramName);
		}
		return null;
	}

	public static Vector getParamFromRequest(HttpServletRequest request,
			Map<String, String> inputNameAndClientIdMapping) {
		Vector parameters = new Vector();
		if (request != null) {
			Enumeration requestParam = request.getParameterNames();
			while (requestParam.hasMoreElements()) {
				String paramName = (String) requestParam.nextElement();
				String[] paramValues = request.getParameterValues(paramName);

				if ((paramName != null) && (paramValues.length > 0)
						&& paramValues[0].length() > 0) {

					StringBuilder sb = new StringBuilder();
					if (log.isDebugEnabled()) {
						for (int i = 0; i < paramValues.length; i++) {
							sb.append(paramValues[i]);
							if (i != paramValues.length - 1) {
								sb.append(", ");
							}
						}

					}
					if (!paramName.contains(nsRequestName)
							&& !paramName.startsWith(facesPrefix)
							&& !paramName.equals(ajaxRequestName)
							&& !paramName.startsWith("__")) {
						log.debug("param name " + paramName);
						log.debug("param value " + sb);
						if (Constants.DROPDOWN_LIST_ID_NAME_MAPPING
								.equals(paramName)) {
							/*
							 * This parameter contains the mapping between input
							 * name and client identifier of all drop-down
							 * lists. This workaround resolve problem that the
							 * server could not get drop-down list value in
							 * SearchQueryables component as from second search.
							 */
							String strMapping = request
									.getParameter(Constants.DROPDOWN_LIST_ID_NAME_MAPPING);
							/*
							 * store parameter value in a Map with key is the
							 * corresponding input name.
							 */
							if (StringUtils.isNotEmpty(strMapping)) {
								String[] arrayMapping = StringUtils.split(
										strMapping,
										Constants.IDS_NAMES_DELIMITER);
								for (String str : arrayMapping) {
									if (StringUtils.isNotEmpty(str)
											&& StringUtils
													.contains(
															str,
															Constants.ID_NAME_DELIMITER)) {
										String inputName = StringUtils
												.substringBefore(
														str,
														Constants.ID_NAME_DELIMITER);
										String inputClientId = StringUtils
												.substringAfter(
														str,
														Constants.ID_NAME_DELIMITER);
										String inputValue = request
												.getParameter(inputClientId);
										log.debug("dropdown list " + inputName
												+ "=" + inputValue);
										if (StringUtils.isNotEmpty(inputValue)) {
											if (StringUtils.contains(inputName,
													TABDELIMITER)) {
												inputName = StringUtils
														.split(inputName,
																TABDELIMITER)[0];
											}
											inputNameAndClientIdMapping.put(
													inputName, inputValue);
										}
									}
								}
							}
						} else {
							Vector element = new Vector();
							element.add(paramName);
							element.add(paramValues);
							parameters.add(element);
						}
					} else {
						if (paramValues[0].equals(ACQUISITION_NOMINAL)
								|| paramValues[0]
										.equals(ACQUISITION_CALIBRATION)
								|| paramValues[0].equals(ACQUISITION_OTHER)) {
							log.debug("param name " + ACQUISITION_TYPE);
							log.debug("param value " + sb);
							Vector element = new Vector();
							element.add(ACQUISITION_TYPE);
							element.add(paramValues);
							parameters.add(element);
						} else if (paramValues[0].equals(SENSOR_ALTIMETRIC)
								|| paramValues[0].equals(SENSOR_ATMOSPHERIC)
								|| paramValues[0].equals(SENSOR_OPTICAL)
								|| paramValues[0].equals(SENSOR_RADAR)) {
							log.debug("param name " + SENSOR_TYPE);
							log.debug("param value " + sb);
							Vector element = new Vector();
							element.add(SENSOR_TYPE);
							element.add(paramValues);
							parameters.add(element);
						} else if (paramValues[0].equals(STATUS_ACQUIRED)
								|| paramValues[0].equals(STATUS_ARCHIVED)
								|| paramValues[0].equals(STATUS_PLANNED)
								|| paramValues[0].equals(STATUS_POTENTIAL)) {
							log.debug("param name " + STATUS);
							log.debug("param value " + sb);
							Vector element = new Vector();
							element.add(STATUS);
							element.add(paramValues);
							parameters.add(element);
						} else if (paramValues[0].equals(ORBIR_DIR_ASC)
								|| paramValues[0].equals(ORBIR_DIR_DES)) {
							log.debug("param name " + ORBIR_DIRECTION);
							log.debug("param value " + sb);
							Vector element = new Vector();
							element.add(ORBIR_DIRECTION);
							element.add(paramValues);
							parameters.add(element);
						}
					}
				}

			}
		}

		if (request.getParameter("AOI") == null
				|| "".equals(request.getParameter("AOI"))) {
			// TODO remove fix
			log.debug("AOI missing, dirty fix - hardcoded AOI");
			Vector element = new Vector();
			element.add("AOI");
			element.add(new String[] { "<AreaOfInterest xmlns:gml=\"http://www.opengis.net/gml\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:sch=\"http://www.ascc.net/xml/schematron\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" gml:id=\"SSEAOI20090401160430\" xsi:schemaLocation=\"http://www.esa.int/xml/schemas/mass/aoifeatures http://services.eoportal.org/schemas/1.6/gml/GML3.1.1/aoifeatures.xsd\" xmlns:aoi=\"http://www.esa.int/xml/schemas/mass/aoifeatures\" xmlns=\"http://www.esa.int/xml/schemas/mass/aoifeatures\"><gml:boundedBy><gml:Envelope srsName=\"EPSG:4326\"><gml:lowerCorner>-2.2979 -80.9362</gml:lowerCorner><gml:upperCorner>72.2553 45.7021</gml:upperCorner></gml:Envelope></gml:boundedBy><gml:featureMember><aoi:Feature gml:id=\"SSEAOI20090401160430.22324341\"><gml:boundedBy><gml:Envelope srsName=\"EPSG:4326\"><gml:lowerCorner>-2.2979 -80.9362</gml:lowerCorner><gml:upperCorner>72.2553 45.7021</gml:upperCorner></gml:Envelope></gml:boundedBy><aoi:code/><aoi:label/><aoi:geometry><gml:Polygon gml:id=\"polygon.33103573\" srsName=\"EPSG:4326\"><gml:exterior><gml:LinearRing><gml:pos>-2.2979 -80.9362</gml:pos><gml:pos>72.2553 -80.9362</gml:pos><gml:pos>72.2553 45.7021</gml:pos><gml:pos>-2.2979 45.7021</gml:pos><gml:pos>-2.2979 -80.9362</gml:pos></gml:LinearRing></gml:exterior></gml:Polygon></aoi:geometry></aoi:Feature></gml:featureMember></AreaOfInterest>" });
			parameters.add(element);
		}

		return parameters;
	}

	/**
	 * Used to parse the request to build the Vector used by the Business layer
	 * to invoke the XSL transformation during a service activation.
	 * 
	 * @param map
	 * @param selectedTab
	 * @return
	 * @throws PortalDisplayException
	 */
	public static Vector getParamFromMap(Map<String, Object> map,
			Map<String, Boolean> rendered, String selectedTab, String icd,
			Map<String, String> regexExpressions, List<String> errorMessages,
			Map<String, String> dropdownListsValues) {
		Vector parameters = new Vector();

		for (String s : map.keySet()) {
			if (s.contains(TABDELIMITER) && !s.endsWith(selectedTab)) {
				continue;
			}
			if (XMLSearchInputParser.UNTOUCHED.equals(s)) {
				continue;
			}

			String key = s.split(TABDELIMITER)[0];
			log.debug("param name " + key);
			Object o = map.get(s);
			String[] paramValues = null;

			boolean insert = true;
			if (rendered != null && Boolean.FALSE.equals(rendered.get(s))) {
				// skip this item, it is hidden
				continue;
			}
			if (o != null) {
				if (o instanceof String) {
					String val = (String) o;
					paramValues = new String[] { val };
					validateInputFields(icd, key, val, regexExpressions,
							errorMessages);
					log.debug("param value: " + val);
				} else if (o instanceof Boolean) {
					String val = ((Boolean) o).toString();
					paramValues = new String[] { val };
					log.debug("param value: " + val);
				} else if (o instanceof UploadItem) {
					UploadItem file = (UploadItem) o;
					String data = new String(file.getData());
					paramValues = new String[] { data };
					log.debug("param value: " + data);
				} else if (o instanceof TreeNode[]) {
					TreeNode[] nodes = (TreeNode[]) o;
					paramValues = TreeNodeData.buildString(nodes);
					for (int i = 0; i < paramValues.length; i++) {
						log.debug("param value " + paramValues[i]);
					}
				} else if (o instanceof TreeNode) {
					// this was the node object used to init the collection
					// picker, don't insert
					insert = false;
				} else {
					insert = false;
					log.error("type not handled yet: " + o.toString());
				}
			} else {
				insert = false;
				log.error("value is null, not inserting parameter.");
			}

			/*
			 * the corresponding value in the map will be used if the parameter
			 * value is null or empty. This workaround resolve problem that the
			 * server could not get drop-down list value in SearchQueryables
			 * component as from second search.
			 */
			if (dropdownListsValues.containsKey(key)
					&& StringUtils.isNotEmpty(dropdownListsValues.get(key))) {
				if (paramValues == null
						|| (paramValues != null && (paramValues.length == 0 || StringUtils
								.isEmpty(paramValues[0])))) {
					paramValues = new String[] { dropdownListsValues.get(key) };
					insert = true;
					log.debug(key + "=" + paramValues[0]);
				}
			}

			if (insert) {
				if (key.equals(SUBJECTPARAM) || key.equals(KEYWORDPARAM)) {
					String[] keywordArray = paramValues[0].replaceAll("( )+",
							" ").split(" ");
					String keywords = "";
					if (keywordArray.length == 1) {
						keywords = paramValues[0];
					} else {
						boolean startComboundKeyword = false;
						boolean endComboundKeyword = false;
						boolean isComboundKeyword = false;
						for (int i = 0; i < keywordArray.length; ++i) {
							String keyword = keywordArray[i];
							int length = keyword.length();

							if (key.equals(SUBJECTPARAM)) {
								if (keyword.substring(0, 1).equals("\"")) {
									startComboundKeyword = true;
									isComboundKeyword = true;
								} else if (keyword
										.substring(length - 1, length).equals(
												"\"")) {
									endComboundKeyword = true;
									isComboundKeyword = false;
								}
							} else {
								if (keyword.substring(0, 1).equals("'")) {
									startComboundKeyword = true;
									isComboundKeyword = true;
								} else if (keyword
										.substring(length - 1, length).equals(
												"'")) {
									endComboundKeyword = true;
									isComboundKeyword = false;
								}
							}

							if (startComboundKeyword) {
								keywords = keywords + keyword.substring(1)
										+ " ";
								startComboundKeyword = false;
							} else if (isComboundKeyword) {
								keywords = keywords + keyword + " ";
							} else if (endComboundKeyword) {
								keywords = keywords
										+ keyword.substring(0, length - 1)
										+ ";";
								endComboundKeyword = false;
							} else {
								keywords = keywords + keyword + ";";
							}
						}
						if (keywords.split(";").length == 1) {
							keywords = keywords.substring(0,
									keywords.length() - 1);
						}
					}

					Vector element = new Vector();
					element.add(key);
					element.add(new String[] { keywords });
					parameters.add(element);

				} else {
					Vector element = new Vector();
					element.add(key);
					element.add(paramValues);
					parameters.add(element);
				}
			}

		}

		return parameters;
	}

	public static String nodeToString(Node node) {
		StringWriter sw = new StringWriter();
		try {
			Transformer t = TransformerFactory.newInstance().newTransformer();
			t.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			t.transform(new DOMSource(node), new StreamResult(sw));
		} catch (TransformerException te) {
			te.printStackTrace();
		}
		return sw.toString();
	}

	public static Vector addParameterToVector(Vector vector, String key,
			String value) {
		Vector element = new Vector();
		element.add(key);
		element.add(new String[] { value });
		vector.add(element);
		return vector;
	}

	public static String getURLContent(String urlString) throws IOException {
		StringBuilder urlContent = new StringBuilder();
		URL url = new URL(urlString);

		URLConnection conn = url.openConnection();
		BufferedReader in = new BufferedReader(new InputStreamReader(
				conn.getInputStream()));
		String inputLine;

		while ((inputLine = in.readLine()) != null) {
			urlContent.append(inputLine.trim());
			urlContent.append(System.getProperty("line.separator"));
		}
		in.close();
		return urlContent.toString();
	}

	public static byte[] getURLContentAsByteArray(String urlString)
			throws IOException {
		URL url = new URL(urlString);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		int code = conn.getResponseCode();
		if (code != 200) {
			throw new IOException(urlString + " : error " + code);
		}
		InputStream in = conn.getInputStream();
		int c;
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		while ((c = in.read()) != -1) {
			stream.write((char) c);
		}

		in.close();
		return stream.toByteArray();
	}

	private static void validateInputFields(String icd, String inputName,
			String inputValue, Map<String, String> regexExpressions,
			List<String> errorMessages) {
		boolean matched = true;
		String paramProp = icd + "." + inputName;
		if (regexExpressions.containsKey(paramProp)) {
			String regex = regexExpressions.get(paramProp);
			if (StringUtils.isNotEmpty(regex)) {
				Pattern p = Pattern.compile(regex);
				Matcher m = p.matcher(inputValue);
				matched = m.matches();
			}
		}
		if (!matched) {
			String msg = regexExpressions.get(paramProp + ".msg");
			errorMessages.add(StringUtils.isNotEmpty(msg) ? msg : "Invalid "
					+ inputName);
		}
	}

}
