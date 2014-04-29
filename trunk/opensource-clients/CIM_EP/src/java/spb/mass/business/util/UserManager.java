package spb.mass.business.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.StringWriter;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.util.List;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.Name;
import javax.xml.soap.Node;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.xml.security.signature.XMLSignature;
import org.apache.xml.security.transforms.Transforms;
import org.apache.xml.security.utils.Constants;
import org.apache.xml.security.utils.IdResolver;
import org.apache.xml.serialize.DOMSerializer;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class UserManager {
	/**
	 * this class provides user management functions, such as get user SAML,...
	 */
	private static final String USER_ID = "userId";
	private static final String USER_PASS = "password";
	private static final String SEPARATOR = "::";

	private static final String NAMESPACE = "http://earth.esa.int/um/eop";
	private static final String WST_NAMESPACE_URI = "http://docs.oasis-open.org/ws-sx/ws-trust/200512/";
	private static final String WSSE_NAMESPACE_URI = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
	private static final String XENC_NAMESPACE_URI = "http://www.w3.org/2001/04/xmlenc#";

	private final static Logger log = Logger.getLogger(UserManager.class);

	/**
	 * information for getting private key in order to sign RST
	 */
	private static PrivateKey clientPrivateKey = null;

	private static final String CLIENT_KEYSTORE_LOCATION;
	private static final String CLIENT_KEYSTORE_PASSWORD;
	private static final String CLIENT_CERTIFICATE_ALIAS;
	private static final String CLIENT_CERTIFICATE_PASSWORD;

	private static ResourceBundle bundle;

	static {
		bundle = PropertyResourceBundle.getBundle("um");
		CLIENT_KEYSTORE_LOCATION = bundle.getString("clientKeystoreLocation");
		CLIENT_KEYSTORE_PASSWORD = bundle.getString("clientKeystorePassword");
		CLIENT_CERTIFICATE_ALIAS = bundle.getString("clientCertificateAlias");
		CLIENT_CERTIFICATE_PASSWORD = bundle
				.getString("clientCertificatePassword");
		// STS_URL = bundle.getString("stsURL");

	}

	public boolean needSAMLToken(String serviceId) {
		boolean result = false;
		try {
			String relyingParty = bundle.getString(serviceId);
			if (StringUtils.isNotEmpty(relyingParty)) {
				result = true;
			}
		} catch (Exception e) {

		}
		return result;
	}

	/**
	 * This function retrieves the SAML token associated with inputed user
	 */
	public Node getSamlToken(String userId, String idp, String serviceId,
			String delegatedIdp, List<org.w3c.dom.Node> msg) {

		Node samlToken = null;
		try {
			String relyingParty = bundle.getString(serviceId);
			if (StringUtils.isNotEmpty(relyingParty)) {
				if (delegatedIdp == null || delegatedIdp.equals("na")) {
					samlToken = sendRSTWithSignatureSOAPMessage(
							bundle.getString(idp), userId, relyingParty, null,
							msg);
				} else {
					samlToken = sendRSTWithSignatureSOAPMessage(
							bundle.getString(idp), userId, relyingParty,
							delegatedIdp, msg);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;

		}
		return samlToken;
	}

	private Node sendRSTWithPasswordSOAPMessage(String userServiceURL,
			String username, String password) throws Exception {

		SOAPMessage soapMessage = prepareRSTWithPasswordSOAPMessage(username,
				password);
		SOAPMessage response = WebServiceInvoker.callSynService(soapMessage,
				userServiceURL);
		SOAPBody soapBody = response.getSOAPBody();

		SOAPEnvelope soapEnvelope = response.getSOAPPart().getEnvelope();
		Name rstrName = soapEnvelope.createName("RequestSecurityTokenResponse",
				"ns", WST_NAMESPACE_URI);
		Name requestedSecurityTokenName = soapEnvelope.createName(
				"RequestedSecurityToken", "ns", WST_NAMESPACE_URI);
		Name encryptedDataName = soapEnvelope.createName("EncryptedData",
				"xenc", XENC_NAMESPACE_URI);

		SOAPElement rstrNode = (SOAPElement) soapBody
				.getChildElements(rstrName).next();
		SOAPElement requestedSecurityNode = (SOAPElement) rstrNode
				.getChildElements(requestedSecurityTokenName).next();
		SOAPElement encryptedDataNode = (SOAPElement) requestedSecurityNode
				.getChildElements(encryptedDataName).next();

		return encryptedDataNode;
	}

	private SOAPMessage prepareRSTWithPasswordSOAPMessage(String username,
			String password) throws Exception {

		// Next, create the actual message
		// System.setProperty("javax.xml.soap.MessageFactory","com.sun.xml.messaging.saaj.soap.MessageFactoryImpl");
		MessageFactory messageFactory = MessageFactory.newInstance();
		SOAPMessage soapMessage = messageFactory.createMessage();

		// Create objects for the message parts
		SOAPPart soapPart = soapMessage.getSOAPPart();
		SOAPEnvelope soapEnvelope = soapPart.getEnvelope();

		soapEnvelope.addNamespaceDeclaration("wst", WST_NAMESPACE_URI);
		soapEnvelope.addNamespaceDeclaration("wsse", WSSE_NAMESPACE_URI);

		SOAPBody soapBody = soapEnvelope.getBody();
		SOAPElement rootSoapElement = soapBody.addChildElement(
				"RequestSecurityToken", "wst");
		SOAPElement tokenTypeSoapElement = rootSoapElement.addChildElement(
				"TokenType", "wst");
		tokenTypeSoapElement
				.setValue("http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLV1.1");
		SOAPElement requestTypeSoapElement = rootSoapElement.addChildElement(
				"RequestType", "wst");
		requestTypeSoapElement
				.setValue("http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue");
		SOAPElement usernameTokenSoapElement = rootSoapElement.addChildElement(
				"UsernameToken", "wsse");
		SOAPElement usernameSoapElement = usernameTokenSoapElement
				.addChildElement("Username", "wsse");
		usernameSoapElement.setValue(username);
		SOAPElement passwordSoapElement = usernameTokenSoapElement
				.addChildElement("Password", "wsse");
		passwordSoapElement.setValue(password);

		return soapMessage;
	}

	private Node sendRSTWithSignatureSOAPMessage(String userServiceURL,
			String username, String relyingParty, String delegateTo,
			List<org.w3c.dom.Node> msg) throws Exception {

		log.debug("Enter sendRSTWithSignatureSOAPMessage...........");
		SOAPMessage soapMessage = prepareRSTWithSignatureSOAPMessage(username,
				relyingParty, delegateTo);
		// log.debug("soapMessage :::::::::::::::::::::::::::::");
		// soapMessage.writeTo(System.out);
		SOAPMessage response = WebServiceInvoker.callSynService(soapMessage,
				userServiceURL);
		SOAPBody soapBody = response.getSOAPBody();

		boolean isOK = true;

		NodeList childs = soapBody.getChildNodes();
		for (int i = 0; i < childs.getLength(); i++) {
			org.w3c.dom.Node child = childs.item(i);
			if (child.getNodeType() == Node.ELEMENT_NODE) {
				String localName = child.getLocalName();
				if ("Fault".equalsIgnoreCase(localName)) {
					msg.add(child);
					isOK = false;
					break;
				}
			}
		}
		if (isOK) {
			log.debug("CASE OK...................");
			SOAPEnvelope soapEnvelope = response.getSOAPPart().getEnvelope();
			Name rstrName = soapEnvelope.createName(
					"RequestSecurityTokenResponse", "ns", WST_NAMESPACE_URI);
			Name requestedSecurityTokenName = soapEnvelope.createName(
					"RequestedSecurityToken", "ns", WST_NAMESPACE_URI);
			Name encryptedDataName = soapEnvelope.createName("EncryptedData",
					"xenc", XENC_NAMESPACE_URI);

			SOAPElement rstrNode = (SOAPElement) soapBody.getChildElements(
					rstrName).next();
			SOAPElement requestedSecurityNode = (SOAPElement) rstrNode
					.getChildElements(requestedSecurityTokenName).next();
			SOAPElement encryptedDataNode = (SOAPElement) requestedSecurityNode
					.getChildElements(encryptedDataName).next();

			return encryptedDataNode;
		} else {
			log.debug("CASE NOK...................");

			return null;
		}

	}

	private SOAPMessage prepareRSTWithSignatureSOAPMessage(String username,
			String relyingParty, String delegateTo) throws Exception {

		System.out
				.println("Enter prepareRSTWithSignatureSOAPMessage...........username = "
						+ username);
		// Next, create the actual message
		MessageFactory messageFactory = MessageFactory.newInstance();
		SOAPMessage soapMessage = messageFactory.createMessage();

		// Create objects for the message parts
		SOAPPart soapPart = soapMessage.getSOAPPart();
		SOAPEnvelope soapEnvelope = soapPart.getEnvelope();

		soapEnvelope.addNamespaceDeclaration("wst", WST_NAMESPACE_URI);
		soapEnvelope.addNamespaceDeclaration("wsse", WSSE_NAMESPACE_URI);

		soapEnvelope.addNamespaceDeclaration("wsp",
				"http://schemas.xmlsoap.org/ws/2004/09/policy");
		soapEnvelope.addNamespaceDeclaration("wsa-2005",
				"http://www.w3.org/2005/08/addressing");

		SOAPBody soapBody = soapEnvelope.getBody();
		SOAPElement rootSoapElement = soapBody.addChildElement(
				"RequestSecurityToken", "wst");
		SOAPElement tokenTypeSoapElement = rootSoapElement.addChildElement(
				"TokenType", "wst");
		tokenTypeSoapElement
				.setValue("http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLV1.1");
		SOAPElement requestTypeSoapElement = rootSoapElement.addChildElement(
				"RequestType", "wst");
		requestTypeSoapElement
				.setValue("http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue");

		SOAPElement AppliesToEle = rootSoapElement.addChildElement("AppliesTo",
				"wsp");

		SOAPElement endPointRefEle = AppliesToEle.addChildElement(
				"EndPointReference", "wsa-2005");

		SOAPElement addressEle = endPointRefEle.addChildElement("Address",
				"wsa-2005");

		addressEle.setValue(relyingParty);
		// DelegateTo

		if (delegateTo != null) {
			SOAPElement delegateToEle = rootSoapElement.addChildElement(
					"DelegateTo", "wst");

			SOAPElement dEndPointRefEle = delegateToEle.addChildElement(
					"EndPointReference", "wsa-2005");

			SOAPElement dAddressEle = dEndPointRefEle.addChildElement(
					"Address", "wsa-2005");

			dAddressEle.setValue(delegateTo);

		}

		requestTypeSoapElement
				.setValue("http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue");

		SOAPElement usernameTokenSoapElement = rootSoapElement.addChildElement(
				"UsernameToken", "wsse");
		SOAPElement usernameSoapElement = usernameTokenSoapElement
				.addChildElement("Username", "wsse");
		usernameSoapElement.setValue(username);

		log.debug("SOAPMessage before sign: ");
		// log.debug(soapEnvelope);
		soapMessage.writeTo(System.out);
		// sign RST
		signRST(soapEnvelope);

		/*
		 * Workaround to avoid the exception while the system serialize SOAP
		 * Message to send it to back-end. The exception is:
		 * java.lang.IllegalArgumentException: local part cannot be "null" when
		 * creating a QName at javax.xml.namespace.QName.<init>(QName.java:246)
		 * at javax.xml.namespace.QName.<init>(QName.java:299)
		 */
		Document document = soapEnvelope.getOwnerDocument();
		StringWriter stringOut = new StringWriter();
		DOMSerializer serializer = (new XMLSerializer(stringOut,
				new OutputFormat(document))).asDOMSerializer();
		serializer.serialize(document.getDocumentElement());
		InputStream soapMsgContent = new ByteArrayInputStream(stringOut
				.toString().getBytes());
		soapMessage = messageFactory.createMessage(new MimeHeaders(),
				soapMsgContent);
		log.debug("SOAP MSG Final::::::::::");
		soapMessage.writeTo(System.out);

		return soapMessage;
	}

	private void signRST(SOAPEnvelope soapEnvelope) throws Exception {

		log.debug("Enter signRST .................");
		final String signedElementReferenceURI = "SOAP_BODY";

		PrivateKey privateKey = getClientPrivateKey();

		Document document = soapEnvelope.getOwnerDocument();

		StringWriter stringOut = new StringWriter();

		// Serialize the root element of the input document and return the
		// output
		DOMSerializer serializer = (new XMLSerializer(stringOut,
				new OutputFormat(document))).asDOMSerializer();
		serializer.serialize(document.getDocumentElement());

		log.debug("Document serialize : " + stringOut.toString());

		SOAPHeader soapHeader = soapEnvelope.getHeader();
		SOAPElement securityElement = soapHeader.addChildElement("Security",
				"wsse");

		XMLSignature xmlSignature = null;
		SOAPBody soapBody = null;

		xmlSignature = new XMLSignature(document, "",
				XMLSignature.ALGO_ID_SIGNATURE_RSA);
		soapBody = soapEnvelope.getBody();

		soapBody.setAttribute("Id", signedElementReferenceURI);
		IdResolver.registerElementById(soapBody, signedElementReferenceURI);

		// put detached signature element in Security Element in SOAP header
		securityElement.appendChild(xmlSignature.getElement());

		log.debug("22222222222222222222" + soapEnvelope);

		// specify the signature protocol: detached signature, SHA-1 as
		// digest algorithm
		Transforms transforms = new Transforms(document);

		// exclusive XML canonicalisation
		// this is "http://www.w3.org/2001/10/xml-exc-c14n"
		transforms.addTransform(Transforms.TRANSFORM_C14N_EXCL_OMIT_COMMENTS);

		xmlSignature.addDocument("#" + signedElementReferenceURI, transforms,
				Constants.ALGO_ID_DIGEST_SHA1);

		stringOut = new StringWriter();
		serializer = (new XMLSerializer(stringOut, new OutputFormat(document)))
				.asDOMSerializer();
		serializer.serialize(document.getDocumentElement());

		log.debug("Document before sign : " + stringOut.toString());

		// calculate and insert signature
		xmlSignature.sign(privateKey);

		stringOut = new StringWriter();
		serializer = (new XMLSerializer(stringOut, new OutputFormat(document)))
				.asDOMSerializer();
		serializer.serialize(document.getDocumentElement());

		log.debug("Document after sign : " + stringOut.toString());
	}

	private PrivateKey getClientPrivateKey() throws Exception {
		log.debug("Entere getClientPrivateKey ....................TNN");
		if (clientPrivateKey == null) {

			// first call

			// initialize XML security library
			org.apache.xml.security.Init.init();

			KeyStore clientKeystore = KeyStore.getInstance("JKS");
			out("Client keystore = " + CLIENT_KEYSTORE_LOCATION);
			File clientKeystoreFile = new File(CLIENT_KEYSTORE_LOCATION);
			if (clientKeystoreFile.exists()) {
				FileInputStream input = new FileInputStream(clientKeystoreFile);
				out("client keystore password = " + CLIENT_KEYSTORE_PASSWORD);
				clientKeystore.load(input,
						CLIENT_KEYSTORE_PASSWORD.toCharArray());
				input.close();
			} else {
				String errorMsg = "Required keystore file "
						+ clientKeystoreFile.getAbsolutePath() + " is missing";
				throw new Exception(errorMsg);
			}
			// get private key
			KeyStore.ProtectionParameter clientKeystoreProtection = new KeyStore.PasswordProtection(
					CLIENT_CERTIFICATE_PASSWORD.toCharArray());
			KeyStore.PrivateKeyEntry clientPrivateKeyEntry = (KeyStore.PrivateKeyEntry) clientKeystore
					.getEntry(CLIENT_CERTIFICATE_ALIAS,
							clientKeystoreProtection);
			clientPrivateKey = clientPrivateKeyEntry.getPrivateKey();
		}
		log.debug(clientPrivateKey);
		return clientPrivateKey;
	}

	static private void out(String log) {
		System.out.println(log);
	}

}
