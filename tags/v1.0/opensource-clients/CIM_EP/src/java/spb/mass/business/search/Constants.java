package spb.mass.business.search;

public class Constants {
	public static final String SERVICE_DESC_DIR = "service.description.dir";
	public static final String SERVICE_DEFAULT_NS = "service.default.ns";

	public static final String SERVICE_ID_PARAM = "serviceId";
	public static final String MAPVIEWER_HEIGHT = "changeViewerHeight";

	public static final String XSLPARAM_PART = "part";
	public static final String XSLPARAM_DISPLAYFILTER = "displayFilter";
	public static final String XSL_SENDSEARCHINPUT_HTML = "sendSearchInputHTML";
	public static final String MASS_XML_FILE = "mass.xml";

	public static final String SERVICES_XML_FILE = "services.xml";
	public static final String OS_PARAMETERS_XML_FILE = "os-parameters.xml";
	public static String PARAM_TOKEN_OPEN = "{";
	public static String PARAM_TOKEN_CLOSE = "}";
	public static String OS_ATOM_RESPONSE_FORMAT = "application/atom+xml";

	public static final String CATALOGUE_CLIENT_NS = "http://www.spacebel.be/catalogue/client";
	public static final String SERVICE_TAG = "service";
	public static final String SERVICE_ID_TAG = "id";
	public static final String SERVICE_NAME_TAG = "name";
	public static final String SERVICE_ICD_TAG = "icd";
	public static final String SERVICE_OPERATION_TAG = "operation";
	public static final String SERVICE_OPERATION_NAME_ATT = "name";
	public static final String SERVICE_OPERATION_XSL_TAG = "xsl";
	public static final String SERVICE_OPERATION_BINDING_TAG = "binding";
	public static final String SERVICE_OPERATION_BINDING_SOAP_ACTION = "action";
	public static final String SERVICE_AOI_TAG = "aoiRequired";
	public static final String SERVICE_OPENSEARCH_TAG = "opensearch";
	public static final String SERVICE_OPENSEARCH_OSDD_URL_TAG = "descriptionDocumentURL";
	public static final String SERVICE_OPENSEARCH_RESPONSE_FORMAT_TAG = "responseFormat";
	public static final String SERVICE_OPENSEARCH_REMOVE_EMPTY_PARAMS_TAG = "removeEmptyParams";

	public enum AccessMethod {
		soap, httpget, httppost;
	}

	public enum OperationName {
		Search, Present;
	}

	public static final String PARAM_COLLECTIONS_SEPARATOR = ",";
	public static final String PARAM_COLLECTIONS = "selectedcollections";
	public static final String PARAM_SERVICEID = "serviceId";

	public static final String TAG_SEARCHINPUT = "sendSearchInput";
	public static final String TAG_PRESENTINPUT = "sendPresentInput";
	public static final String XSL_SENDSEARCHINPUT_SYNC_XML = "processSearchInputXML";
	public static final String XSL_SENDPRESENTINPUT_SYNC_XML = "processPresentInputXML";
	public static final String XSL_GETSEARCHOUTPUT_HTML = "getSearchOutputHTML";
	public static final String XSL_GETPRESENTOUTPUT_HTML = "getPresentOutputHTML";

	public static final String XSLPARAM_DISPLAYFILTER_ALLRESULTS = "ALLRESULTS";

	public static final String LIFE_CYCLE_SEARCH = "Search";
	public static final String LIFE_CYCLE_PRESENT = "Present";

	public static final String SERVICES_FACELETS = "servicesfacelets";
	public static final String ICD_FACELETS = "facelets";
	public static final String DROPDOWN_LIST_ID_NAME_MAPPING = "hiddenFieldStoreDropdownListIdsNamesMapping";
	public static final String ID_NAME_DELIMITER = ":::::::::";
	public static final String IDS_NAMES_DELIMITER = ";";

	public static final String HTTP_GET_DETAILS_URL = "url";
	public static final String HTTP_GET_DETAILS_RESPONSE = "response";
	public static final String HTTP_GET_DETAILS_ERROR_CODE = "errorCode";
	public static final String HTTP_GET_DETAILS_ERROR_MSG = "errorMsg";
	public static final String LOG_REQUEST = "logRequestMsg";
	public static final String LOG_RESPONSE = "logResponseMsg";
}
