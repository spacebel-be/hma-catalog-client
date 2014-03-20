package spb.mass.business.util;

import java.io.ByteArrayOutputStream;
import java.util.Map;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPFactory;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.Element;

import spb.mass.business.search.Constants;

public class WebServiceInvoker {

	/* SOAP envelope namespace */
	public static final String SOAP_ENV_NAMESPACE = "http://schemas.xmlsoap.org/soap/envelope/";

	/* SOAP Action */
	public static final String SOAP_BODY = "Body";

	private final static Logger log = Logger.getLogger(WebServiceInvoker.class);

	public static SOAPMessage prepareSOAPMessage(String action, String xmlInput) {
		try {
			log.debug("xmlInput = " + xmlInput);
			log.debug("action = " + action);
			XMLParser xmlParser = new XMLParser();
			xmlParser.setIsValidating(false);
			xmlParser.setIsNamespaceAware(true);
			Document inputDom = xmlParser.stream2Document(xmlInput);

			MessageFactory messageFactory = MessageFactory.newInstance();
			SOAPMessage message = messageFactory.createMessage();

			SOAPPart soapPart = message.getSOAPPart();
			SOAPEnvelope envelope = soapPart.getEnvelope();
			SOAPBody body = envelope.getBody();
			body.addDocument(inputDom);
			if (action != null) {
				message.getMimeHeaders().setHeader("SOAPAction", "\"" + action + "\"");
			}
			message.saveChanges();
			return message;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	public static SOAPMessage callSynService(String destination, String action,
			String message, Map<String, String> logMsg) throws SOAPException {
		log.debug("Enter callSynService");
		SOAPMessage soapMessage = prepareSOAPMessage(action, message);

		SOAPPart soapPart = soapMessage.getSOAPPart();
		SOAPEnvelope envelope = soapPart.getEnvelope();

		SOAPConnectionFactory soapConnFactory = SOAPConnectionFactory
				.newInstance();
		SOAPConnection connection = soapConnFactory.createConnection();

		log.debug("--------------------------requestXML----------------------------------");
		log.debug(getSOAPMessageAsString(soapMessage));
		log.debug("----------------------------------------------------------------------");

		log.debug("------------------------------------");
		log.debug("sent message to: " + destination);
		log.debug("------------------------------------");

		/*
		 * get log request
		 */
		logMsg.put(Constants.LOG_REQUEST, getSOAPMessageAsString(soapMessage));

		SOAPMessage reply = null;
		try {
			reply = connection.call(soapMessage, destination);
			/*
			 * get log response
			 */
			
			logMsg.put(Constants.LOG_RESPONSE, getSOAPMessageAsString(reply));
		} catch (SOAPException soapException) {

			log.debug(soapException.getMessage());
		}

		connection.close();

		log.debug("--------------------------responseXML----------------------------------");
		log.debug(getSOAPMessageAsString(reply));
		log.debug("----------------------------------------------------------------------");
		log.debug("Exit callSynServiceWithAuthentication Case1 OK");
		return reply;

	}

	private static void addSAMLToSOAPHeader(Node saml, SOAPHeader header)
			throws SOAPException {
		if (saml != null) {
			SOAPFactory soapFactory = SOAPFactory.newInstance();
			SOAPElement securityElement = header
					.addChildElement(
							"Security",
							"wssecurity",
							"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd");
			SOAPElement samlTokenSOAP = soapFactory
					.createElement((Element) saml);
			Node soapChild = securityElement.getOwnerDocument().importNode(
					samlTokenSOAP, true);
			securityElement.appendChild(soapChild);

		}

	}

	public static SOAPMessage callSynServiceWithAuthentication(
			String destination, String action, String message, Node saml,
			Map<String, String> logMsg) throws SOAPException {

		log.debug("Enter callSynServiceWithAuthentication Case 1");

		SOAPMessage soapMessage = prepareSOAPMessage(action, message);

		SOAPPart soapPart = soapMessage.getSOAPPart();
		SOAPEnvelope envelope = soapPart.getEnvelope();

		SOAPHeader header = envelope.getHeader();

		addSAMLToSOAPHeader(saml, header);
		
		soapMessage.saveChanges();
		
		SOAPConnectionFactory soapConnFactory = SOAPConnectionFactory
				.newInstance();
		
		SOAPConnection connection = soapConnFactory.createConnection();
		

		log.debug("--------------------------requestXML----------------------------------");
		log.debug(getSOAPMessageAsString(soapMessage));
		log.debug("----------------------------------------------------------------------");
		/*
		 * get log request
		 */
		//logMsg.put(Constants.LOG_REQUEST, getSOAPMessageAsString(soapMessage));

		SOAPMessage reply = null;
		try {
			log.debug("sent message to: " + destination);
			
			reply = connection.call(soapMessage, destination);
			/*
			 * get log response
			 */
			//logMsg.put(Constants.LOG_RESPONSE, getSOAPMessageAsString(reply));
		} catch (SOAPException soapException) {
			log.debug(soapException.getMessage());
		}

		connection.close();

		log.debug("--------------------------responseXML----------------------------------");
		//log.debug(getSOAPMessageAsString(reply));
		log.debug("----------------------------------------------------------------------");
		log.debug("Exit callSynServiceWithAuthentication Case1 OK");
		return reply;
	}

	public static SOAPMessage callSynService(SOAPMessage message,
			String location) throws SOAPException {
		try {
			SOAPConnectionFactory soapConnFactory = SOAPConnectionFactory
					.newInstance();
			SOAPConnection connection = soapConnFactory.createConnection();
			log.debug("sent message to: " + location);
			SOAPMessage reply = connection.call(message, location);
			log.debug("response: " + getSOAPMessageAsString(reply));
			connection.close();
			return reply;
		} catch (SOAPException soapEx) {
			System.out.println(soapEx.getMessage());
			throw soapEx;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private static String getSOAPMessageAsString(SOAPMessage message) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			TransformerFactory tff = TransformerFactory.newInstance();
			Transformer tf;
			tf = tff.newTransformer();
			tf.setOutputProperty(OutputKeys.INDENT, "yes");
			tf.setOutputProperty("{http://xml.apache.org/xslt}indent-amount",
					"2");
			StreamResult result = new StreamResult(baos);
			tf.transform(message.getSOAPPart().getContent(), result);
		} catch (Exception e) {
			// throw new IOException(e);
		}
		return new String(baos.toByteArray());
	}

}
