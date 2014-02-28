package spb.mass.businessdelegate.parsers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;
import org.apache.xerces.parsers.DOMParser;
import org.richfaces.model.UploadItem;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import com.sun.facelets.Facelet;
import com.sun.facelets.compiler.SAXCompiler;
import com.sun.facelets.impl.DefaultFaceletFactory;
import com.sun.facelets.impl.DefaultResourceResolver;

public class XMLParserUtils {

	private final static Logger log = Logger.getLogger(XMLParserUtils.class
			.getName());

	public static String getNodeContent(Node n) {
		String returnString = "";
		TransformerFactory transfac = TransformerFactory.newInstance();
		try {
			Transformer trans = transfac.newTransformer();
			trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			trans.setOutputProperty(OutputKeys.INDENT, "yes");
			StringWriter sw = new StringWriter();
			StreamResult result = new StreamResult(sw);
			DOMSource source = new DOMSource(n);
			trans.transform(source, result);
			returnString = sw.toString();
		} catch (Exception e) {
			log.error("XMLParserUtils.getNodeContent().error:" + e.getMessage());
		}
		return returnString;
	}

	/**
	 * 
	 * @param xmlSource
	 * @param schemaLocation
	 *            the location for the XSD file, validation is not done if this
	 *            is null
	 * @return
	 * @throws PortalDisplayException
	 */
	public static Node buildNode(String xmlSource, URL schemaLocation) {
		DOMParser parser = new DOMParser();
		try {
			if (schemaLocation != null) {

				XMLReader validator = XMLReaderFactory.createXMLReader();
				validator.setFeature("http://xml.org/sax/features/validation",
						true);
				validator.setFeature(
						"http://apache.org/xml/features/validation/schema",
						true);
				validator
						.setProperty(
								"http://apache.org/xml/properties/schema/external-noNamespaceSchemaLocation",
								schemaLocation.toExternalForm());
				// parser.setContentHandler(new IndexationHandler(this));
				validator.parse(new InputSource(new StringReader(xmlSource)));

			}

			parser.parse(new InputSource(new StringReader(xmlSource)));
		} catch (Exception e) {
			log.error("XMLParserUtils.buildNode().error:" + e.getMessage());
		}
		Document doc = parser.getDocument();
		Node root = doc.getChildNodes().item(0);
		return root;
	}

	public static Node buildNode(String xmlSource) {
		return buildNode(xmlSource, null);
	}

	// *** Validation ***

	/**
	 * Returns true or throws an exception if false
	 */
	public static boolean isXMLWellFormed(String xmlSource, boolean validate) {
		DOMParser parser = new DOMParser();
		boolean valid = true;
		try {
			parser.parse(new InputSource(new StringReader(xmlSource)));

			if (validate) {
				XMLReader validator = XMLReaderFactory.createXMLReader();
				validator.setFeature("http://xml.org/sax/features/validation",
						true);
				validator.setFeature(
						"http://apache.org/xml/features/validation/schema",
						true);
				// validator
				// .setFeature(
				// "http://apache.org/xml/features/validation/schema-full-checking",
				// true);
				validator.setErrorHandler(new ErrorHandler() {

					public void error(SAXParseException exception)
							throws SAXException {
						throw exception;

					}

					public void fatalError(SAXParseException exception)
							throws SAXException {
						throw exception;
					}

					public void warning(SAXParseException exception)
							throws SAXException {
						throw exception;
					}

				});

				validator.parse(new InputSource(new StringReader(xmlSource)));
			}

		} catch (Exception e) {
			log.error("XMLParserUtils.isXMLWellFormed().error:"
					+ e.getMessage());
		}
		return valid;
	}

	public static boolean isFaceletValid(UploadItem facelet) {
		boolean valid = true;
		log.debug("lala");
		try {

			File file = File.createTempFile(
					"tmpfacelet" + System.currentTimeMillis(), null);
			FileOutputStream fos = new FileOutputStream(file);
			fos.write(facelet.getData());
			fos.close();

			URL faceletURL = file.toURI().toURL();
			log.debug(faceletURL.toString());

			new SAXCompiler().compile(faceletURL, "plap");
			DefaultFaceletFactory factory = new DefaultFaceletFactory(
					new SAXCompiler(), new DefaultResourceResolver());
			Facelet f = factory.getFacelet(faceletURL);

		} catch (Exception e) {
			valid = false;
			e.printStackTrace();
		}
		log.debug("Facelet valid: " + valid);
		return valid;
	}

	public static String prettyPrintXML(String source) {
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			TransformerFactory tff = TransformerFactory.newInstance();
			Transformer tf;
			tf = tff.newTransformer();
			tf.setOutputProperty(OutputKeys.INDENT, "yes");
			tf.setOutputProperty("{http://xml.apache.org/xslt}indent-amount",
					"2");
			StreamResult result = new StreamResult(baos);
			tf.transform(new StreamSource(new StringReader(source)), result);
			return new String(baos.toByteArray());
		} catch (Exception e) {
			return source;
		}
	}
}