package spb.mass.business.search;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.OutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.Map;
import java.util.HashMap;

import javax.xml.soap.SOAPMessage;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.apache.commons.lang.StringUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import spb.mass.business.search.Constants.AccessMethod;
import spb.mass.business.util.HTTPInvoker;
import spb.mass.business.util.UserManager;
import spb.mass.business.util.WebServiceInvoker;
import spb.mass.business.util.XMLParser;
import spb.mass.business.util.XSLTProcessor;

public class SearchProcessManager {
	private final Logger log = Logger.getLogger(getClass());

	/**
	 * Gets HTML string by appllied the xsl with the specified stylesheet
	 * parameter.
	 * 
	 * @param serviceId
	 *            , The service identifier.
	 * @param xslPara
	 *            The stylesheet parameter named "Part"
	 * @param subscriptionFlag
	 *            The String subscription flag.
	 * @return the HTML string.
	 */
	public String getHTMLStr(String serviceId, String xslPara,
			String xmlFilePath, String xslFilePath) {

		Collection xslParameter = createXSLParameterVector(xslPara, null);
		return transformServiceXMLInstance(serviceId, xslParameter,
				xmlFilePath, xslFilePath);
	}

	/**
	 * Create an XML document that contains Search information and start the
	 * workflow engine. Workflow engine will parse this XML <br>
	 * document to start the corresponding workflow. <br>
	 * Content of the XML document is defined based on the ICD and Service
	 * description. Returns a vector that contains : orderInputXml string, html
	 * result string
	 * 
	 * @param serviceId
	 *            - identifier of Service
	 * @param operationName
	 *            - the name of the synchronous operation :
	 *            OrderConstant.LIFE_CYCLE_... (SEARCH, PRESENT)
	 * @param opRequestParams
	 *            a 2-dimension collection (name/value pair) of the operation
	 *            (Search/Present) input info
	 */
	public Collection processSynchronousOperation(ServiceData serviceData,
			String operationName, Collection opRequestParams,
			String serviceDescriptionDir, String userId, String idp,
			String delegatedIdp, String serviceDefaultNS,
			Map<String, String> logMsg) throws IOException {
		log.debug("PERF MEAS start processSynchronousOperation");
		try {
			ServiceOperation sOperation = serviceData.getOperations().get(
					operationName);
			String operationRootTag = Constants.TAG_PRESENTINPUT;
			String xsl_sendOpInput_XML = Constants.XSL_SENDPRESENTINPUT_SYNC_XML;
			String xsl_opOutput_HTML = Constants.XSL_GETPRESENTOUTPUT_HTML;
			File xslFile = new File(serviceDescriptionDir + "/"
					+ sOperation.getXslFile());
			AccessMethod method = sOperation.getBinding();
			boolean isNextOp = false;
			if (operationName.equals(Constants.LIFE_CYCLE_SEARCH)) {
				isNextOp = true;
				operationRootTag = Constants.TAG_SEARCHINPUT;
				xsl_sendOpInput_XML = Constants.XSL_SENDSEARCHINPUT_SYNC_XML;
				xsl_opOutput_HTML = Constants.XSL_GETSEARCHOUTPUT_HTML;
			}
			log.debug(":::xslFile:::" + xslFile.getAbsolutePath());

			XMLParser xmlParser = new XMLParser();
			XSLTProcessor xsltProcessor = new XSLTProcessor();

			Document opXMLDoc = xmlParser.createDOM(false, true);
			Document htmlDom = createCollectionDom(opRequestParams,
					operationRootTag, serviceDefaultNS);

			log.debug(":::htmlDom:::" + xmlParser.serializeDOM(htmlDom));

			DOMResult domResult = new DOMResult(opXMLDoc);

			Vector paramVector = createXSLParameterVector(xsl_sendOpInput_XML,
					null);
			xsltProcessor.transformDOM2DOMWithParam(new DOMSource(htmlDom),
					new StreamSource(xslFile), paramVector, domResult);
			String opXMLDocStr = xmlParser.serializeDOM(opXMLDoc);

			log.debug(":::opXMLDocStr:::" + opXMLDocStr);

			String opResultXMLStr = null;

			if (serviceData.isOsService()) {
				NodeList osReqParamsNL = opXMLDoc
						.getElementsByTagName("opensearchParameters");
				if (osReqParamsNL.getLength() > 0) {
					Node root = osReqParamsNL.item(0);
					NodeList osReqParamsChildren = root.getChildNodes();
					Map<String, String> osReqParams = new HashMap<String, String>();
					log.debug("opensearchParameters:");
					for (int i = 0; i < osReqParamsChildren.getLength(); i++) {
						Node param = osReqParamsChildren.item(i);
						String name = param.getNodeName();
						String value = param.getFirstChild().getNodeValue();
						log.debug(name + "=" + value);
						osReqParams.put(name, value);
					}
					Map<String, String> exchangeMsg = new HashMap<String, String>();

					opResultXMLStr = processOpenSearch(serviceData
							.getOsDescription().getOpenSearchUrl()
							.getTemplateUrl(), serviceData.getOsDescription()
							.getOpenSearchUrl().isRemoveEmptyParams(),
							serviceData.getOsDescription().getOpenSearchUrl()
									.getIndexOffset(), osReqParams, exchangeMsg);
					/*
					 * get log messages
					 */
					logMsg.put(Constants.LOG_REQUEST,
							exchangeMsg.get(Constants.HTTP_GET_DETAILS_URL));
					if (exchangeMsg.get(Constants.HTTP_GET_DETAILS_RESPONSE) != null) {
						logMsg.put(Constants.LOG_RESPONSE, exchangeMsg
								.get(Constants.HTTP_GET_DETAILS_RESPONSE));
					} else {
						logMsg.put(Constants.LOG_RESPONSE, exchangeMsg
								.get(Constants.HTTP_GET_DETAILS_ERROR_MSG));
					}
				} else {
					log.error("Could not find element 'opensearchParameters' in template 'sendSearchInput' of the stylesheet "
							+ serviceDescriptionDir
							+ "/"
							+ sOperation.getXslFile());
				}

			} else {
				if (AccessMethod.soap.equals(method)) {
					log.debug("TNN::INVOKING VIA SOAP");
					UserManager uManager = new UserManager();
					if (userId == null | idp == null || delegatedIdp == null
							|| !uManager.needSAMLToken(serviceData.getId())) {
						log.debug("sso info is not available");
						SOAPMessage wsResult = WebServiceInvoker
								.callSynService(sOperation.getEndpoint(),
										sOperation.getBindingAction(),
										opXMLDocStr, logMsg);
						Node msg = wsResult.getSOAPBody().getFirstChild();
						NodeList childs = wsResult.getSOAPBody()
								.getChildNodes();
						for (int i = 0; i < childs.getLength(); i++) {
							Node child = childs.item(i);
							if (child.getNodeType() == Node.ELEMENT_NODE) {
								msg = child;
								break;
							}
						}
						log.debug("Root element of the response:::"
								+ msg.getNodeName() + ":"
								+ msg.getNamespaceURI());
						opResultXMLStr = Node2String(msg);

					} else {

						List<Node> faultNode = new Vector<Node>();

						Node saml = uManager.getSamlToken(userId, idp,
								serviceData.getId(), delegatedIdp, faultNode);

						if (saml != null) {
							SOAPMessage wsResult = WebServiceInvoker
									.callSynServiceWithAuthentication(
											sOperation.getEndpoint(),
											sOperation.getBindingAction(),
											opXMLDocStr, saml, logMsg);
							Node msg = wsResult.getSOAPBody().getFirstChild();
							NodeList childs = wsResult.getSOAPBody()
									.getChildNodes();
							for (int i = 0; i < childs.getLength(); i++) {
								Node child = childs.item(i);
								if (child.getNodeType() == Node.ELEMENT_NODE) {
									msg = child;
									break;
								}
							}
							log.debug("Root element of the response:::"
									+ msg.getNodeName() + ":"
									+ msg.getNamespaceURI());
							opResultXMLStr = Node2String(msg);
						} else {
							log.debug("SAML is not available");

							opResultXMLStr = Node2String(faultNode.get(0));
						}
					}

				} else if (AccessMethod.httppost.equals(method)) {
					log.debug("* INVOKING VIA HTTP POST: "
							+ sOperation.getEndpoint());
					opResultXMLStr = HTTPInvoker.invokePOST(
							sOperation.getEndpoint(), opXMLDocStr);
					/*
					 * get log messages
					 */
					logMsg.put(Constants.LOG_REQUEST, opXMLDocStr);
					logMsg.put(Constants.LOG_RESPONSE, opResultXMLStr);

				} else if (AccessMethod.httpget.equals(method)) {
					log.debug("* INVOKING VIA HTTP GET *");
					// Result of the transform should be the GET URL with all
					// the
					// parameters set
					// http://hostname/param1=value1&param2=value2
					// the URL will be unescaped
					XPathFactory factory = XPathFactory.newInstance();
					XPath xpath = factory.newXPath();
					XPathExpression expr = xpath.compile("//URL");
					Node result = (Node) expr.evaluate(
							xmlParser.stream2Document(opXMLDocStr),
							XPathConstants.NODE);
					String params = result.getTextContent();
					params = URLDecoder.decode(params);
					params = params.replaceAll("[ \t\n\f\r]", "");
					/*
					 * The HTTP GET base URL is defined in services.xml file and
					 * the dynamic parameters are in XSL file. Therefore we have
					 * to concatenate them to have a full URL
					 */
					log.debug("HTTP GET URL:::" + sOperation.getEndpoint()
							+ params);

					Map<String, String> exchangeMsg = new HashMap<String, String>();

					opResultXMLStr = processHTTPGET(sOperation.getEndpoint()
							+ params, exchangeMsg);
					/*
					 * get log messages
					 */
					logMsg.put(Constants.LOG_REQUEST,
							exchangeMsg.get(Constants.HTTP_GET_DETAILS_URL));
					if (exchangeMsg.get(Constants.HTTP_GET_DETAILS_RESPONSE) != null) {
						logMsg.put(Constants.LOG_RESPONSE, exchangeMsg
								.get(Constants.HTTP_GET_DETAILS_RESPONSE));
					} else {
						logMsg.put(Constants.LOG_RESPONSE, exchangeMsg
								.get(Constants.HTTP_GET_DETAILS_ERROR_MSG));
					}
				}
			}

			/*
			 * opResultXMLStr = opResultXMLStr.replaceAll("&gt;", ">").replace(
			 * "&lt;", "<");
			 */
			log.debug("##############################################################################");
			log.debug(":::opResultXMLStr:::" + opResultXMLStr);

			paramVector = createXSLParameterVector(xsl_opOutput_HTML,
					Constants.XSLPARAM_DISPLAYFILTER_ALLRESULTS);

			Document opResultXMLDoc = xmlParser.stream2Document(opResultXMLStr);

			Document opResultHMLDoc = xmlParser.createDOM(false, false);
			DOMResult opResultHMLDOM = new DOMResult(opResultHMLDoc);
			if (serviceData.isOsService()) {
				xsltProcessor.transformDOM2DOMWithParam(new DOMSource(
						opResultXMLDoc.getDocumentElement()), new StreamSource(
						xslFile), paramVector, opResultHMLDOM);
			} else {
				xsltProcessor.transformDOM2DOMWithParam(new DOMSource(
						opResultXMLDoc), new StreamSource(xslFile),
						paramVector, opResultHMLDOM);
			}

			String opResultHMLStr = xmlParser.serializeDOM(opResultHMLDoc);
			log.debug(":::opResultHMLStr:::" + opResultHMLStr);

			Vector result = new Vector();
			result.add(opResultHMLStr);
			if (isNextOp) {
				result.add(opXMLDocStr);
				result.add(opResultXMLStr);
			}
			return result;
		} catch (Exception ex) {
			String msg = "An error while processing: " + ex.getMessage();
			throw new IOException(msg);
		}

	}

	/**
	 * Creates a param-value DOM tree.
	 * 
	 * @param htmlPara
	 *            The collection contains all para-value pair.
	 * @param tagName
	 *            The name of the first node tag.
	 */
	private Document createCollectionDom(Collection htmlPara, String tagName,
			String tagNS) {

		log.debug("createCollectionDom:::" + tagName + ":" + tagNS);

		XMLParser xmlParser = new XMLParser();
		Document rfqXMLDoc = xmlParser.createDOM(false, true);
		// root named service, we can use any name here
		Element root = (Element) rfqXMLDoc.createElement("service");
		// create child node named tagName
		Node rfqNode = rfqXMLDoc.createElementNS(tagNS, tagName);

		rfqXMLDoc.appendChild(root);
		if (!htmlPara.isEmpty()) {
			Iterator iterate = htmlPara.iterator();
			while (iterate.hasNext()) {
				Vector eleVec = (Vector) iterate.next();
				createCollectionDomHandleNode(xmlParser, rfqXMLDoc, rfqNode,
						eleVec);

			}
			root.appendChild(rfqNode);
		} else { // we have to add this empty node for xalan to transform.
			root.appendChild(rfqNode);
		}
		return rfqXMLDoc;
	}

	private void createCollectionDomHandleNode(XMLParser xmlParser,
			Document root, Node n, Vector v) {
		String paramName = (String) v.elementAt(0);
		Object valueObj = v.elementAt(1);

		if (valueObj instanceof Vector) {
			Node child = root.createElement(paramName);
			n.appendChild(child);
			for (int i = 1; i < v.size(); i++) {
				Vector childVector = (Vector) v.elementAt(i);
				createCollectionDomHandleNode(xmlParser, root, child,
						childVector);
			}

		} else if (valueObj instanceof String[]) {
			String[] paraValues = (String[]) valueObj;
			if ("AOI".equals(paramName)
					|| "massDefaultInputPar".equals(paramName)
					|| "XMLFILE".equals(paramName)) {
				log.debug("createCollectionDomHandleNode:paramName:::"
						+ paramName);

				Node paraNodeName = root.createElement(paramName);
				for (int i = 0; i < paraValues.length; i++) {
					if (paraValues[i] != null && paraValues[i].length() > 1) {
						Document aoiDoc = xmlParser
								.stream2Document(paraValues[i]);
						paraNodeName.appendChild(root.importNode(
								aoiDoc.getFirstChild(), true));
					}
				}
				n.appendChild(paraNodeName);

			} else {
				for (int i = 0; i < paraValues.length; i++) {
					Node paraNodeName = root.createElement(paramName);
					paraNodeName
							.appendChild(root.createTextNode(paraValues[i]));
					n.appendChild(paraNodeName);
				}
			}
		}
	}

	/**
	 * Transform a part of service's XML sample instance document to an HTML /
	 * XML-based string.
	 * 
	 * @param serviceId
	 *            - service identifier
	 * @param parameters
	 *            - XSL parameters
	 * @return transformed string
	 * @pseudo Get the XML instance and the XSL files of the specified service
	 *         Set the parameter to the input value to identify which part of
	 *         the XSL to be applied Transform the service's XML instance Return
	 *         the transformed result
	 */
	public String transformServiceXMLInstance(String serviceId,
			Collection parameters, String xmlFilePath, String xslFilePath) {
		log.debug("SearchProcessManager.transformServiceXMLInstance(service.id = "
				+ serviceId + ") invoked");
		/*
		 * File xmlFile = new File(serviceDescriptionDir +
		 * this.massInstanceFile); File xslFile = new File(serviceDescriptionDir
		 * + ServiceLifeCycleUtil.getPresentationFileLocation(lc_data,
		 * operation, serviceBusinessData));
		 */
		try {
			XSLTProcessor xsltProcessor = new XSLTProcessor();
			String transformResult = xsltProcessor
					.transformStream2StringWithParam(new StreamSource(new File(
							xmlFilePath)), new StreamSource(new File(
							xslFilePath)), parameters);
			return transformResult;

		} catch (Exception ex) {
			log.error("SearchProcessManager.transformServiceXMLInstance(serviceId="
					+ serviceId
					+ ",xmlFilePath="
					+ xmlFilePath
					+ ",xslFilePath="
					+ xslFilePath
					+ ").error:"
					+ ex.getMessage());
			return null;
		}
	}

	public Vector createXSLParameterVector(String part, String displayFilter) {

		// Construct a new vector
		Vector<String[]> paramVector = new Vector<String[]>();

		// Construct arrays containing the "part" and "workflowName" parameters
		if (part != null) {
			String[] partStr = { Constants.XSLPARAM_PART, part };
			paramVector.add(partStr);
		}
		if (displayFilter != null) {
			String[] displayFilterStr = { Constants.XSLPARAM_DISPLAYFILTER,
					displayFilter };
			paramVector.add(displayFilterStr);
			log.warn("####displayFilter: " + displayFilter + "#####");
		}
		return paramVector;
	}

	private String processOpenSearch(String templateURL,
			boolean removeEmptyParams, int indexOffset,
			Map<String, String> osReqParams, Map<String, String> exchangeMsg)
			throws IOException {
		String backendLocation = fillParamValuesToOpenSearchUrl(templateURL,
				indexOffset, osReqParams, removeEmptyParams);
		return processHTTPGET(backendLocation, exchangeMsg);
	}

	private String fillParamValuesToOpenSearchUrl(String opensearchTemplateURL,
			int indexOffset, Map<String, String> params,
			boolean removeEmptyParams) {
		String strStartIndex = null;
		if (params.containsKey("startIndex")
				&& StringUtils.isNotEmpty(params.get("startIndex"))) {
			try {
				/*
				 * calculate startIndex to correspond to the back-end. Default
				 * start value of startIndex is 1.
				 */
				int startIndex = Integer.parseInt(params.get("startIndex"));
				if (indexOffset < 1) {
					strStartIndex = Integer.toString(startIndex - 1);
				}
				if (indexOffset > 1) {
					strStartIndex = Integer.toString(startIndex
							+ (indexOffset - 1));
				}
			} catch (NumberFormatException e) {
			}

		}
		log.debug("Opensearch URL template:" + opensearchTemplateURL);
		String[] tokens = StringUtils.substringsBetween(opensearchTemplateURL,
				Constants.PARAM_TOKEN_OPEN, Constants.PARAM_TOKEN_CLOSE);
		log.debug("List of opensearch parameters:");
		if (tokens != null) {
			for (String token : tokens) {
				String fullToken = Constants.PARAM_TOKEN_OPEN + token
						+ Constants.PARAM_TOKEN_CLOSE;
				log.debug("fullToken : " + fullToken);

				String cleanToken = token.replace("?", "");
				cleanToken = cleanToken.replace(":", "_");
				cleanToken = StringUtils.trim(cleanToken);

				log.debug("cleanToken : " + cleanToken);

				/*
				 * replace the token with user input value if the value is not
				 * empty
				 */
				if (StringUtils.isNotEmpty(params.get(cleanToken))) {
					log.debug(cleanToken + "=" + params.get(cleanToken));
					if ("startIndex".equals(cleanToken)
							&& StringUtils.isNotEmpty(strStartIndex)) {
						/*
						 * replace startIndex with the value that was calculated
						 * above
						 */
						opensearchTemplateURL = StringUtils
								.replace(opensearchTemplateURL, fullToken,
										strStartIndex);
					} else {
						opensearchTemplateURL = StringUtils.replace(
								opensearchTemplateURL, fullToken,
								params.get(cleanToken));
					}
				} else {
					if (removeEmptyParams) {
						/*
						 * remove the empty param
						 */
						opensearchTemplateURL = removeEmptyParamsFromOpensearchURL(
								opensearchTemplateURL, fullToken);
					} else {

						/*
						 * leave empty value for the param
						 */
						opensearchTemplateURL = StringUtils.replace(
								opensearchTemplateURL, fullToken, "");
					}
				}
			}
		}
		return opensearchTemplateURL;
	}

	private String removeEmptyParamsFromOpensearchURL(
			String opensearchTemplateURL, String token) {
		log.debug(" Start removing " + token + " from " + opensearchTemplateURL);
		String strBegin = StringUtils.substringBefore(opensearchTemplateURL,
				token);
		String strEnd = StringUtils
				.substringAfter(opensearchTemplateURL, token);
		if (StringUtils.contains(strBegin, "&")) {
			/*
			 * remove key and ampersand before the parameter if it is not the
			 * first parameter
			 */
			strBegin = StringUtils.substringBeforeLast(strBegin, "&");
		} else {
			/*
			 * remove key and question character before the parameter if it is
			 * the first parameter
			 */
			strBegin = StringUtils.substringBeforeLast(strBegin, "?") + "?";
			/*
			 * remove ampersand before the query string
			 */
			if (StringUtils.startsWith(strEnd, "&")) {
				strEnd = StringUtils.substringAfter(strEnd, "&");
			}
		}
		log.debug(" After removing " + strBegin + strEnd);
		return strBegin + strEnd;
	}

	private String Node2String(Node msg) throws Exception {

		DOMSource source = new DOMSource(msg);
		TransformerFactory transformerFactory = TransformerFactory
				.newInstance();
		Transformer transformer = transformerFactory.newTransformer();

		OutputStream outputStream = new ByteArrayOutputStream();
		transformer.transform(source, new StreamResult(outputStream));
		return outputStream.toString();
	}

	private String processHTTPGET(String backendLocation,
			Map<String, String> exchangeMsg) throws IOException {
		Map<String, String> details = new HashMap<String, String>();
		String result = HTTPInvoker.invokeGET(backendLocation, details);
		/*
		 * store the request message
		 */
		exchangeMsg.put(Constants.HTTP_GET_DETAILS_URL,
				details.get(Constants.HTTP_GET_DETAILS_URL));

		if (details.get(Constants.HTTP_GET_DETAILS_ERROR_CODE) != null) {
			StringBuffer errorMsg = new StringBuffer();
			errorMsg.append("<error xmlns=\"http://www.spacebel.be/sse\" >");
			errorMsg.append("<errorCode>"
					+ details.get(Constants.HTTP_GET_DETAILS_ERROR_CODE)
					+ "</errorCode>");
			String msg = details.get(Constants.HTTP_GET_DETAILS_ERROR_MSG);
			/*
			 * check if the error message is a valid document
			 */
			XMLParser xmlParser = new XMLParser();
			if (xmlParser.stream2Document(msg) != null) {
				if (StringUtils.contains(msg, "<?xml")
						&& StringUtils.contains(msg, "?>")) {
					String prolog = "<?xml"
							+ StringUtils.substringBetween(msg, "<?xml", "?>")
							+ "?>";
					log.debug("Error message prolog:" + prolog);
					msg = StringUtils.remove(msg, prolog);
				}
				errorMsg.append("<errorMsg>" + msg + "</errorMsg>");
			} else {
				errorMsg.append("<errorMsg><![CDATA[" + msg + "]]></errorMsg>");
			}
			errorMsg.append("</error>");
			result = errorMsg.toString();

			/*
			 * store the response message
			 */
			exchangeMsg.put(Constants.HTTP_GET_DETAILS_ERROR_MSG,
					details.get(Constants.HTTP_GET_DETAILS_ERROR_MSG));
		} else {
			/*
			 * store the response message
			 */
			exchangeMsg.put(Constants.HTTP_GET_DETAILS_RESPONSE, result);
		}
		return result;
	}
}
