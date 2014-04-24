package spb.mass.business.util;

import java.io.File;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.apache.xml.serialize.DOMSerializer;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class XMLParser {
	private final Logger log = Logger.getLogger(getClass());
	/**
	 * Indicates whether or not the factory is configured to produce parsers
	 * which are namespace aware.
	 */
	private boolean isNamespaceAware = true;

	/**
	 * Indicates whether or not the factory is configured to produce parsers
	 * which validate the XML content during parse.
	 */
	private boolean isValidating = false;

	/**
	 * Set the isNamespaceAware to new value.
	 * 
	 * @param newIsNamespaceAware
	 *            - new value of isNamespaceAware
	 * @exception RemoteException
	 * @pseudo none
	 */
	public void setIsNamespaceAware(boolean newIsNamespaceAware) {
		isNamespaceAware = newIsNamespaceAware;
	}

	/**
	 * Set the isValidating to new value.
	 * 
	 * @param newIsValidating
	 *            - new value of isValidating
	 * @exception RemoteException
	 * @pseudo none
	 */
	public void setIsValidating(boolean newIsValidating) {
		isValidating = newIsValidating;
	}

	/**
	 * Obtain a new instance of a DOM Document object to build a DOM tree with.
	 * 
	 * @param newIsValidating
	 *            - new isValidating flag
	 * @param newIsNamespaceAware
	 *            - new IsNamespaceAware flag
	 * @return an instance of DOM document
	 * @exception RemoteException
	 * @pseudo none
	 */
	public Document createDOM(boolean newIsValidating,
			boolean newIsNamespaceAware) {
		log.debug("createDOM invoked");

		Document doc = null;
		try {
			// Get the current factory properties
			boolean currentIsValidating = isValidating;
			boolean currentIsNamespaceAware = isNamespaceAware;

			// Set the new factory properties
			setIsValidating(newIsValidating);
			setIsNamespaceAware(newIsNamespaceAware);

			// Create a new document instance
			doc = getDocumentBuilder().newDocument();

			// Reset the new factory properties
			setIsValidating(currentIsValidating);
			setIsNamespaceAware(currentIsNamespaceAware);

			// Return the new document
			return doc;
		} catch (Exception ex) {
			String errorMsg = "Error happens when creating a new XML file: "
					+ ex.getMessage();
			log.error(errorMsg);
			return null;
		}
	}

	/**
	 * Parse input XML file to an XML document.
	 * 
	 * @param xmlStream
	 *            - an XML-based text
	 * @return an XML document
	 * @exception ParserConfigurationException
	 *                Description of Exception.
	 * @exception RemoteException
	 *                Description of Exception.
	 * @pseudo none
	 */
	public Document stream2Document(String xmlStream) {
		log.debug("stream2Document invoked");
		Document doc = null;
		try {
			DocumentBuilder builder = getDocumentBuilder();
			if ((xmlStream != null) && (xmlStream.length() > 0)) {
				StringReader stringReader = new StringReader(xmlStream);
				doc = builder.parse(new InputSource(stringReader));
			} else { // null or empty string
				doc = builder.newDocument();
			}
		} catch (Exception e) {
			log.error("stream2Document(xmlStream = " + xmlStream
					+ "): exception occurred while parsing:" + e.getMessage());
		}
		return doc;
	}

	/**
	 * parse a file into an xml document.
	 * 
	 * @param filename
	 *            filename of the file storing xml document
	 * @return an XML document
	 * @exception RemoteException
	 * @pseudo
	 */
	public Document file2Document(String filename) {
		log.debug("file2Document invoked");
		Document doc = null;
		try {

			File f = new File(filename);
			if (f.exists())
				doc = getDocumentBuilder().parse(f);
		} catch (Exception ex) {
			log.error("error at file2Document: " + ex.getMessage());
		}
		return doc;
	}

	/**
	 * Parse input XML file to an XML document.
	 * 
	 * @param xmlStream
	 *            - an XML-based text
	 * @return an XML document
	 * @exception ParserConfigurationException
	 *                Description of Exception.
	 * @exception RemoteException
	 *                Description of Exception.
	 * @pseudo none
	 */
	public Document inputStream2Document(InputStream input) {
		log.debug("inputStream2Document invoked");
		Document doc = null;
		try {
			DocumentBuilder builder = getDocumentBuilder();
			if (input != null) {
				doc = builder.parse(input);
				input.close();
			} else { // null or empty string
				doc = builder.newDocument();
			}
		} catch (Exception e) {
			log.error("inputStream2Document(input = " + input
					+ "): exception occurred while parsing:" + e.getMessage());
		}
		return doc;
	}

	/**
	 * Serialize an XML document to an XML-based string.
	 * 
	 * @param xmlDoc
	 *            - XML document used as source of serialization
	 * @return an XML string
	 * @exception RemoteException
	 * @pseudo Initilaize a new DOM serializer Serialize the DOM tree to a
	 *         stream result and return the output
	 */
	public String serializeDOM(Document xmlDoc) {
		log.debug("serializeDOM invoked");

		try {
			// Create a new string
			StringWriter stringOut = new StringWriter();

			// Serialize the root element of the input document and return the
			// output
			DOMSerializer serializer = (new XMLSerializer(stringOut,
					new OutputFormat(xmlDoc))).asDOMSerializer();
			serializer.serialize(xmlDoc.getDocumentElement());

			// Return the DOM tree as a String
			return stringOut.toString();
		} catch (Exception ex) {
			String errorMsg = "Error happens when serializing the XML document.";
			log.error(errorMsg + ":" + ex.getMessage());
			return null;
		}
	}

	/**
	 * Creates a new instance of a DocumentBuilderFactory using the currently
	 * configured parameters.
	 * 
	 * @return a factory of document builder
	 * @exception RemoteException
	 * @pseudo none
	 */
	private DocumentBuilderFactory getDocumentBuilderFactory() {
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setNamespaceAware(isNamespaceAware);
			factory.setValidating(isValidating);
			return factory;
		} catch (Exception ex) {
			log.error("XMLParser.getDocumentBuilderFactory().error:"
					+ ex.getMessage());
			return null;
		}
	}

	/**
	 * Creates a new instance of DocumentBuilder using the currently configured
	 * parameters.
	 * 
	 * @return a document builder
	 * @exception RemoteException
	 *                Description of Exception.
	 * @exception ParserConfigurationException
	 *                Description of Exception.
	 * @pseudo none
	 */
	private DocumentBuilder getDocumentBuilder()
			throws ParserConfigurationException {
		return getDocumentBuilderFactory().newDocumentBuilder();
	}
}
