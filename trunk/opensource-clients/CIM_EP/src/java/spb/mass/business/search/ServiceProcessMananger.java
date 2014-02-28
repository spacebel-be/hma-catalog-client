package spb.mass.business.search;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.NamedNodeMap;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.business.search.Constants.AccessMethod;
import spb.mass.business.search.Constants.OperationName;
import spb.mass.business.util.HTTPInvoker;
import spb.mass.business.util.XMLParser;

public class ServiceProcessMananger {
	private Logger log = Logger.getLogger(getClass());

	public Map<String, ServiceData> getAllServices(
			Map<String, String> preDefinedOSNamespaces,
			Map<String, OpenSearchParameter> preDefinedOSParams, int serverPort)
			throws IOException {
		Map<String, ServiceData> serviceList = new HashMap<String, ServiceData>();
		NodeList serviceNodeList = getServiceNodes();
		for (int i = 0; i < serviceNodeList.getLength(); i++) {
			Node serviceNode = serviceNodeList.item(i);
			NodeList serviceChildren = serviceNode.getChildNodes();
			ServiceData serviceData = getServiceData(serviceChildren,
					preDefinedOSNamespaces, preDefinedOSParams, serverPort);
			if (serviceList.containsKey(serviceData.getId())) {
				throw new IOException(
						"The service id should not be unique. Please correct in the services.xml file.");
			} else {
				serviceList.put(serviceData.getId(), serviceData);
			}
		}
		return serviceList;
	}

	public void loadPreDefinedOSParamsAndNamespaces(
			Map<String, String> preDefinedOSNamespaces,
			Map<String, OpenSearchParameter> preDefinedOSParams)
			throws IOException {

		XMLParser xmlParser = new XMLParser();
		Document osParamsDoc = xmlParser
				.inputStream2Document(ServiceProcessMananger.class
						.getClassLoader().getResourceAsStream(
								Constants.OS_PARAMETERS_XML_FILE));
		/*
		 * get list of namespaces
		 */
		preDefinedOSNamespaces.putAll(getNamespaces(osParamsDoc, false));

		/*
		 * get list of parameters
		 */
		preDefinedOSParams.putAll(getOSParams(osParamsDoc.getDocumentElement(),
				null, null));
	}

	private Map<String, String> getNamespaces(Document doc, boolean keyIsPrefix)
			throws IOException {
		Map<String, String> namespaces = new HashMap<String, String>();
		NamedNodeMap atts = doc.getDocumentElement().getAttributes();
		if (atts != null) {
			for (int i = 0; i < atts.getLength(); i++) {
				Node node = atts.item(i);
				String prefix = node.getNodeName().trim();
				String ns = node.getNodeValue();
				if (StringUtils.startsWithIgnoreCase(prefix, "xmlns:")) {
					if (keyIsPrefix) {
						namespaces.put(StringUtils.substringAfter(prefix, ":"),
								ns);
					} else {
						namespaces.put(ns,
								StringUtils.substringAfter(prefix, ":"));
					}
				}
			}
		}
		return namespaces;
	}

	private Map<String, OpenSearchParameter> getOSParams(Element urlElem,
			Map<String, String> namespaceSource,
			Map<String, String> namespaceDest) {
		/*
		 * get list of parameters
		 */
		NodeList params = urlElem.getElementsByTagNameNS(
				"http://a9.com/-/spec/opensearch/extensions/parameters/1.0/",
				"Parameter");
		if (params.getLength() > 0) {
			Map<String, OpenSearchParameter> parameters = new HashMap<String, OpenSearchParameter>();
			for (int pIdx = 0; pIdx < params.getLength(); pIdx++) {
				Node paramNode = params.item(pIdx);

				String value = getAttValueOfNode(paramNode, "value");
				if (StringUtils.isNotEmpty(value)) {
					if (StringUtils.isNotEmpty(StringUtils.substringBetween(
							value, Constants.PARAM_TOKEN_OPEN,
							Constants.PARAM_TOKEN_CLOSE))) {
						value = StringUtils.substringBetween(value,
								Constants.PARAM_TOKEN_OPEN,
								Constants.PARAM_TOKEN_CLOSE);
						if (namespaceSource != null && namespaceDest != null) {
							String validValue = getParamPrefix(value,
									namespaceSource, namespaceDest);
							if (StringUtils.isNotEmpty(validValue)) {
								value = validValue;
							} else {
								log.debug("Could not find the correspoding namespace of parameter prefix in the system:"
										+ value);
							}
						}
						/*
						 * The solution to get parameters: 1/ Ignore all
						 * <Parameter> blocks which are inside URL which is not
						 * the Atom URL (i.e. the URL to obtain an Atom
						 * response). 2/Accept the global <Parameter>. 3/ Accept
						 * the local <Parameter> inside the Atom URL. 4/ In case
						 * a <Parameter> for the same parameter appears in the
						 * global <Parameter> and the local <Parameter>, the
						 * local <Parameter> should have priority.
						 */
						boolean toBeAdded = false;
						Node parent = paramNode.getParentNode();
						/*
						 * load parameters from os-parameters.xml file of ICD
						 */
						if ("osParams".equals(parent.getLocalName())) {
							toBeAdded = true;
						}
						/*
						 * load parameters from whole OSDD document
						 */
						if ("OpenSearchDescription".equals(parent
								.getLocalName())) {
							if (!parameters.containsKey(value)) {
								toBeAdded = true;
							}
						}
						/*
						 * load parameters from the <URL> to obtain an Atom
						 * response
						 */
						if ("Url".equals(parent.getLocalName())) {
							String urlType = getAttValueOfNode(parent, "type");
							if (Constants.OS_ATOM_RESPONSE_FORMAT
									.equals(urlType)) {
								toBeAdded = true;
							} else {
								log.debug("Ignore all <Parameter> blocks which are inside URL which is not the Atom URL. Url/@type = "
										+ urlType);
							}
						}
						/*
						 * log.debug("Parent name:" + parent.getLocalName() +
						 * ", toBeAdded = " + toBeAdded);
						 */
						if (toBeAdded) {
							OpenSearchParameter osParam = new OpenSearchParameter();

							osParam.setIndex(Integer.toString(pIdx + 1));
							osParam.setName(getAttValueOfNode(paramNode, "name"));
							osParam.setValue(value);
							osParam.setTitle(getAttValueOfNode(paramNode,
									"title"));
							osParam.setType(getAttValueOfNode(paramNode, "type"));
							/*
							 * get list of options
							 */
							NodeList opChildren = ((Element) paramNode)
									.getElementsByTagNameNS(
											"http://a9.com/-/spec/opensearch/extensions/parameters/1.0/",
											"Option");
							if (opChildren.getLength() > 0) {
								osParam.setOptions(new HashMap<String, String>());
								for (int idx = 0; idx < opChildren.getLength(); idx++) {
									Node opChild = opChildren.item(idx);
									String key = opChild.getAttributes()
											.getNamedItem("value")
											.getNodeValue();
									String val = opChild.getAttributes()
											.getNamedItem("label")
											.getNodeValue();
									if (StringUtils.isNotEmpty(key)) {
										osParam.getOptions()
												.put(key,
														StringUtils
																.isNotEmpty(val) ? val
																: key);
									}
								}
							}
							parameters.put(osParam.getValue(), osParam);
							/*
							 * log.debug("Added param = " + osParam.getName() +
							 * ":" + osParam.getValue());
							 */
						}
					} else {
						log.debug("Parameter value should be placed between {}:"
								+ value);
					}
				} else {
					log.debug("Parameter value is empty.");
				}
			}
			return parameters;
		} else {
			return null;
		}
	}

	private String getParamPrefix(String fullParam,
			Map<String, String> namespaceSource,
			Map<String, String> namespaceDest) {
		String srcPrefix = StringUtils.substringBefore(fullParam, ":");
		String srcParam = StringUtils.substringAfter(fullParam, ":");
		String destPrefix = namespaceDest.get(namespaceSource.get(srcPrefix));
		if (StringUtils.isNotEmpty(destPrefix)) {
			/*
			 * replace source prefix with the corresponding destination prefix
			 */
			return destPrefix + ":" + srcParam;
		} else {
			return null;
		}
	}

	private String getAttValueOfNode(Node node, String attName) {
		String value = null;
		if (node.getAttributes() != null
				&& node.getAttributes().getNamedItem(attName) != null) {
			value = node.getAttributes().getNamedItem(attName).getNodeValue();
		}
		return value;
	}

	private NodeList getServiceNodes() {
		XMLParser xmlParser = new XMLParser();
		Document servicesDoc = xmlParser
				.inputStream2Document(ServiceProcessMananger.class
						.getClassLoader().getResourceAsStream(
								Constants.SERVICES_XML_FILE));
		NodeList serviceNodeList = servicesDoc.getElementsByTagNameNS(
				Constants.CATALOGUE_CLIENT_NS, Constants.SERVICE_TAG);
		return serviceNodeList;
	}

	private ServiceData getServiceData(NodeList serviceChildren,
			Map<String, String> preDefinedOSNamespaces,
			Map<String, OpenSearchParameter> preDefinedOSParams, int serverPort)
			throws IOException {
		ServiceData serviceData = new ServiceData();
		Map<String, ServiceOperation> operations = new HashMap<String, ServiceOperation>();
		for (int sChildIdx = 0; sChildIdx < serviceChildren.getLength(); sChildIdx++) {
			Node serviceChild = serviceChildren.item(sChildIdx);
			if (serviceChild.getNodeType() == Node.ELEMENT_NODE) {
				if (serviceChild.getFirstChild() != null) {
					String name = serviceChild.getNodeName();
					if (StringUtils.equals(Constants.SERVICE_ID_TAG, name)) {
						serviceData.setId(getNodeValue(serviceChild));
					}
					if (StringUtils.equals(Constants.SERVICE_NAME_TAG, name)) {
						serviceData.setName(getNodeValue(serviceChild));
					}
					if (StringUtils.equals(Constants.SERVICE_ICD_TAG, name)) {
						serviceData.setIcd(getNodeValue(serviceChild));
					}
					if (StringUtils.equals(Constants.SERVICE_OPERATION_TAG,
							name)) {
						ServiceOperation sOperation = getServiceOperation(serviceChild);
						operations.put(sOperation.getName().toString(),
								sOperation);
					}
					if (StringUtils.equals(Constants.SERVICE_AOI_TAG, name)) {
						serviceData.setAoiRequired(Boolean
								.parseBoolean(getNodeValue(serviceChild)));
					}
					if (StringUtils.equals(Constants.SERVICE_OPENSEARCH_TAG,
							name)) {
						serviceData.setOsService(true);
						OpenSearchDescription osdd = new OpenSearchDescription();

						serviceData.setOsDescription(osdd);
						/*
						 * load OpenSearch service data
						 */
						loadOSServiceData(serviceChild, serviceData,
								preDefinedOSNamespaces, preDefinedOSParams,
								serverPort);
					}
				}
			}
		}
		if (StringUtils.isEmpty(serviceData.getId())) {
			throw new IOException(
					"The service id should not be empty. Please correct in the services.xml file.");
		}
		if (StringUtils.isEmpty(serviceData.getName())) {
			throw new IOException(
					"The service name should not be empty. Please correct in the services.xml file.");
		}
		if (StringUtils.isEmpty(serviceData.getIcd())) {
			throw new IOException(
					"The service icd should not be empty. Please correct in the services.xml file.");
		}
		if (StringUtils.isEmpty(serviceData.getId())) {
			throw new IOException(
					"The service id should not be empty. Please correct in the services.xml file.");
		}
		if (!operations.containsKey(Constants.LIFE_CYCLE_SEARCH)) {
			throw new IOException(
					"Search operation is mandatory for every service. Please correct in the services.xml file.");
		}
		serviceData.setOperations(operations);
		// log.debug("ServiceData::::::::" + serviceData);
		return serviceData;
	}

	private ServiceOperation getServiceOperation(Node operation) {
		ServiceOperation sOperation = new ServiceOperation();
		String opName = operation.getAttributes()
				.getNamedItem(Constants.SERVICE_OPERATION_NAME_ATT)
				.getNodeValue();
		sOperation.setName(OperationName.valueOf(opName));
		NodeList opChilds = operation.getChildNodes();
		for (int opcIdx = 0; opcIdx < opChilds.getLength(); opcIdx++) {
			Node opChild = opChilds.item(opcIdx);
			String name = opChild.getNodeName();
			if (StringUtils.equals(Constants.SERVICE_OPERATION_XSL_TAG, name)) {
				sOperation.setXslFile(getNodeValue(opChild));
			}
			if (StringUtils.equals(Constants.SERVICE_OPERATION_BINDING_TAG,
					name)) {
				NodeList opBindingChilds = opChild.getChildNodes();
				for (int opbcIdx = 0; opbcIdx < opBindingChilds.getLength(); opbcIdx++) {
					Node opBindingChild = opBindingChilds.item(opbcIdx);
					if (opBindingChild.getNodeType() == Node.ELEMENT_NODE) {
						if (opBindingChild.getFirstChild() != null) {
							String bindName = opBindingChild.getNodeName();
							log.debug(bindName);
							sOperation.setBinding(AccessMethod
									.valueOf(bindName));
							if (AccessMethod.valueOf(bindName).compareTo(
									AccessMethod.soap) == 0) {
								sOperation
										.setBindingAction(opBindingChild
												.getAttributes()
												.getNamedItem(
														Constants.SERVICE_OPERATION_BINDING_SOAP_ACTION)
												.getNodeValue());
							}
							sOperation
									.setEndpoint(getNodeValue(opBindingChild));
						}
					}
				}

			}
		}
		return sOperation;
	}

	private void loadOSServiceData(Node opensearch, ServiceData serviceData,
			Map<String, String> preDefinedOSNamespaces,
			Map<String, OpenSearchParameter> preDefinedOSParams, int serverPort)
			throws IOException {
		NodeList osChildren = opensearch.getChildNodes();
		OpenSearchUrl osUrl = new OpenSearchUrl();
		for (int idx = 0; idx < osChildren.getLength(); idx++) {
			Node osChild = osChildren.item(idx);
			String name = osChild.getNodeName();
			if (StringUtils.equals(Constants.SERVICE_OPENSEARCH_OSDD_URL_TAG,
					name)) {
				String osddUrl = getNodeValue(osChild);
				if (StringUtils.isNotEmpty(osddUrl)) {
					osddUrl = StringUtils.trim(osddUrl);
					if (osddUrl.startsWith("http://localhost")) {
						osddUrl = osddUrl.replaceFirst("http://localhost",
								"http://localhost:" + serverPort);
					}
					serviceData.getOsDescription().setOsddURL(osddUrl);
				}

			}
			if (StringUtils.equals(
					Constants.SERVICE_OPENSEARCH_RESPONSE_FORMAT_TAG, name)) {
				osUrl.setResponseFormat(getNodeValue(osChild));
			}
			if (StringUtils.equals(
					Constants.SERVICE_OPENSEARCH_REMOVE_EMPTY_PARAMS_TAG, name)) {
				osUrl.setRemoveEmptyParams(Boolean
						.parseBoolean(getNodeValue(osChild)));
			}
		}
		if (StringUtils.isEmpty(serviceData.getOsDescription().getOsddURL())) {
			String msg = "Please specify the locations of OpenSearch Description Document of OpenSearch services in the services.xml file.";
			if (StringUtils.isNotEmpty(serviceData.getName())) {
				msg = "Please specify the location of OpenSearch Description Document of service "
						+ serviceData.getName() + " in the services.xml file.";
			}
			throw new IOException(msg);
		}

		if (!"application/atom+xml".equals(osUrl.getResponseFormat())) {
			throw new IOException(
					"OpenSearch response format of OpenSearch service should be application/atom+xml. Please correct in the services.xml file.");
		}
		serviceData.getOsDescription().setOpenSearchUrl(osUrl);
		/*
		 * load backend's OSDD details
		 */
		loadBackendOsddDetails(serviceData, preDefinedOSNamespaces,
				preDefinedOSParams);
	}

	private void loadBackendOsddDetails(ServiceData serviceData,
			Map<String, String> preDefinedOSNamespaces,
			Map<String, OpenSearchParameter> preDefinedOSParams)
			throws IOException {
		/*
		 * get OpenSearch description document
		 */
		Map<String, String> details = new HashMap<String, String>();
		String strOSDD = HTTPInvoker.invokeGET(serviceData.getOsDescription()
				.getOsddURL(), details);

		if (details.get(Constants.HTTP_GET_DETAILS_ERROR_CODE) != null) {
			String msg = "Could not read the OpenSearch Description Document : "
					+ serviceData.getOsDescription().getOsddURL();
			throw new IOException(msg);
		} else {
			if (StringUtils.isNotEmpty(strOSDD)) {
				XMLParser xmlParser = new XMLParser();
				Document osddDoc = xmlParser.stream2Document(strOSDD);

				/**
				 * get OpenSearch template URLs
				 */
				NodeList openSearchUrls = osddDoc.getElementsByTagNameNS(
						"http://a9.com/-/spec/opensearch/1.1/", "Url");

				for (int urlIdx = 0; urlIdx < openSearchUrls.getLength(); urlIdx++) {
					Node openSearchUrlNode = openSearchUrls.item(urlIdx);
					String type = openSearchUrlNode.getAttributes()
							.getNamedItem("type").getNodeValue();

					if (StringUtils.equalsIgnoreCase(
							Constants.OS_ATOM_RESPONSE_FORMAT, type)) {

						String template = openSearchUrlNode.getAttributes()
								.getNamedItem("template").getNodeValue();

						if (StringUtils.isNotEmpty(template)) {
							Map<String, String> namespacesSource = getNamespaces(
									osddDoc, true);
							String url = validatePrefix4ParamsOfUrl(template,
									namespacesSource, preDefinedOSNamespaces);
							/*
							 * set the valid url to service's osURL
							 */
							serviceData.getOsDescription().getOpenSearchUrl()
									.setTemplateUrl(url);
							/*
							 * set indexOffset of the url if exist
							 */
							String indexOffset = getAttValueOfNode(
									openSearchUrlNode, "indexOffset");
							if (StringUtils.isNotEmpty(indexOffset)) {
								try {
									serviceData
											.getOsDescription()
											.getOpenSearchUrl()
											.setIndexOffset(
													Integer.parseInt(indexOffset));
								} catch (NumberFormatException e) {
								}
							}
							/*
							 * set pageOffset of the url if exist
							 */
							String pageOffset = getAttValueOfNode(
									openSearchUrlNode, "pageOffset");
							if (StringUtils.isNotEmpty(pageOffset)) {
								try {
									serviceData
											.getOsDescription()
											.getOpenSearchUrl()
											.setPageOffset(
													Integer.parseInt(pageOffset));
								} catch (NumberFormatException e) {
								}
							}

							String[] tokens = StringUtils.substringsBetween(
									url, Constants.PARAM_TOKEN_OPEN,
									Constants.PARAM_TOKEN_CLOSE);
							if (tokens != null) {
								Map<String, OpenSearchParameter> osddParams = getOSParams(
										osddDoc.getDocumentElement(),
										namespacesSource,
										preDefinedOSNamespaces);
								for (String token : tokens) {
									token = StringUtils.trim(token);
									OpenSearchParameter osParam = mergeOSParamDetails(
											token, osddParams,
											preDefinedOSParams);
									// log.debug("token = " + token);
									if (osParam != null) {
										// log.debug("osParam = " + osParam);
										if (StringUtils.endsWith(token, "?")) {
											/*
											 * this is an optional parameter
											 */
											if (serviceData.getOsDescription()
													.getOpenSearchUrl()
													.getOptionalParameters() == null) {
												serviceData
														.getOsDescription()
														.getOpenSearchUrl()
														.setOptionalParameters(
																new Vector<OpenSearchParameter>());
											}
											serviceData.getOsDescription()
													.getOpenSearchUrl()
													.getOptionalParameters()
													.add(osParam);
										} else {
											/*
											 * this is a mandatory parameter
											 */
											if (serviceData.getOsDescription()
													.getOpenSearchUrl()
													.getRequiredParameters() == null) {
												serviceData
														.getOsDescription()
														.getOpenSearchUrl()
														.setRequiredParameters(
																new Vector<OpenSearchParameter>());
											}
											serviceData.getOsDescription()
													.getOpenSearchUrl()
													.getRequiredParameters()
													.add(osParam);
										}
									}
								}
							}
							break;
						} else {
							String msg = "The template attribute of <Url> element which has type = application/atom+xml should not be empty."
									+ serviceData.getOsDescription()
											.getOsddURL();
							throw new IOException(msg);
						}
					}
				}

			} else {
				String msg = "Could not read the OpenSearch Description Document : "
						+ serviceData.getOsDescription().getOsddURL();
				throw new IOException(msg);
			}
		}
	}

	private OpenSearchParameter mergeOSParamDetails(String paramToken,
			Map<String, OpenSearchParameter> osddParams,
			Map<String, OpenSearchParameter> defaultParams) {
		/*
		 * remove question mark in the token if exist
		 */
		paramToken = StringUtils.replace(paramToken, "?", "");
		if (defaultParams.containsKey(paramToken)) {
			OpenSearchParameter defaultParam = defaultParams.get(paramToken);
			/*
			 * clone OpenSearchParameter from the default one
			 */
			OpenSearchParameter osParam = new OpenSearchParameter();
			osParam.setIndex(defaultParam.getIndex());
			osParam.setName(defaultParam.getName());
			osParam.setValue(defaultParam.getValue());
			osParam.setTitle(defaultParam.getTitle());
			osParam.setType(defaultParam.getType());
			osParam.setNamespace(defaultParam.getNamespace());
			osParam.setOptions(defaultParam.getOptions());
			/*
			 * update the details in OSDD to the parameter
			 */
			if (osddParams != null && osddParams.containsKey(paramToken)) {
				OpenSearchParameter osddParam = osddParams.get(paramToken);
				if (StringUtils.isNotEmpty(osddParam.getTitle())) {
					osParam.setTitle(osddParam.getTitle());
				}
				if (osddParam.getOptions() != null) {
					osParam.setOptions(osddParam.getOptions());
				}
			}
			return osParam;
		} else {
			return null;
		}

	}

	private String validatePrefix4ParamsOfUrl(String url,
			Map<String, String> namespacesSource,
			Map<String, String> namespacesDest) {
		log.debug("Valid prefix of params of URL: " + url);
		String[] tokens = StringUtils.substringsBetween(url,
				Constants.PARAM_TOKEN_OPEN, Constants.PARAM_TOKEN_CLOSE);
		if (tokens != null) {
			for (String token : tokens) {
				String replacement = getParamPrefix(token, namespacesSource,
						namespacesDest);
				if (replacement != null) {
					replacement = Constants.PARAM_TOKEN_OPEN + replacement
							+ Constants.PARAM_TOKEN_CLOSE;
					String searchString = Constants.PARAM_TOKEN_OPEN + token
							+ Constants.PARAM_TOKEN_CLOSE;
					if (!replacement.equals(searchString)) {
						log.debug("Replace " + searchString + " by "
								+ replacement);
						/*
						 * replace prefix of parameter with the one that is
						 * declared in ICD
						 */
						url = StringUtils.replace(url, searchString,
								replacement);
					}
				}
			}
		}
		return url;
	}

	private String getNodeValue(Node node) {
		String value = null;
		try {
			value = node.getFirstChild().getNodeValue();
		} catch (Exception e) {

		}
		return value;
	}

}
