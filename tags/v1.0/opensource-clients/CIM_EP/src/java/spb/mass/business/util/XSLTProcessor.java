package spb.mass.business.util;

//Imported java classes
import java.io.File;
import java.io.FileInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Collection;
import java.util.Vector;
import java.util.Iterator;
import java.rmi.RemoteException;

//Imported JAXP classes
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;

//Other
import org.apache.log4j.Logger;
import org.apache.xml.utils.PrefixResolverDefault;
import org.apache.xml.utils.PrefixResolver;

//Apache XPath
import org.apache.xpath.XPathContext;
import org.apache.xpath.XPath;
import org.apache.xpath.objects.XObject;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;

//SAX & DOM import
import org.xml.sax.InputSource;

//Imported Serializer classes
import org.apache.xalan.serialize.Serializer;
import org.apache.xalan.serialize.SerializerFactory;
import org.apache.xalan.templates.OutputProperties;

public class XSLTProcessor {
	private final Logger log = Logger.getLogger(getClass());
	/**
	 * The TransformerFactory.
	 */
	private transient TransformerFactory transformerFactory;
	
	public XSLTProcessor() {
		try {
            transformerFactory = getTransformerFactory();
        } catch (TransformerConfigurationException e) {
            log.debug("unable to get TransformerFactory");           
        }
	}

	/**
	 * Transform an XML file to a DOM tree.
	 * 
	 * @param dir
	 *            - location of XML source file
	 * @param xmlFileName
	 *            - an XML stream used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @param domResult
	 *            - transformed XML document in DOM format
	 * @return void
	 * @exception RemoteException
	 * @pseudo Create a new file object from the input XML filename Use DOM to
	 *         parse this XML file into a DOM tree Create a new transformer with
	 *         input XSL stylesheet Transform to a DOM result
	 */
	public void transformFile2DOM(String dir, String xmlFileName,
			StreamSource xslStreamSource, DOMResult domResult) {

		try {
			File f = new File(dir, xmlFileName);

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setNamespaceAware(true);
			factory.setValidating(true);
			DocumentBuilder documentBuilder = factory.newDocumentBuilder();

			// Use the DocumentBuilder to parse the XSL stylesheet.
			Document xmlDoc = documentBuilder.parse(new InputSource(
					new FileInputStream(f)));

			// Use the DOM Document to define a DOMSource object.
			DOMSource xmlDOMSource = new DOMSource(xmlDoc);

			Transformer transformer = getTransformer(xslStreamSource);
			transformer.transform((DOMSource) xmlDOMSource,
					(DOMResult) domResult);
		} catch (Exception e) {
			log.error("XSLTProcessor.transformFile2DOM(dir=" + dir
					+ ",xmlFileName=" + xmlFileName + ",xslStreamSource="
					+ xslStreamSource + ",domResult=" + domResult + ").error:"
					+ e.getMessage());
		}
	}

	/**
	 * Transform an XML stream to DOM tree with new parameter value.
	 * 
	 * @param xmlStreamSource
	 *            - an XML stream used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @param domResult
	 *            - transformed DOM result
	 * @exception RemoteException
	 * @pseudo Create a new transformer with input XSL stylesheet Transform to a
	 *         DOM result
	 */
	public void transformStream2DOM(StreamSource xmlStreamSource,
			StreamSource xslStreamSource, DOMResult domResult) {
		try {
			Transformer transformer = getTransformer(xslStreamSource);
			transformer.transform((StreamSource) xmlStreamSource,
					(DOMResult) domResult);
		} catch (Exception e) {
			log.error("XSLTProcessor.transformStream2DOM(xmlStreamSource="
					+ xmlStreamSource + ",xslStreamSource=" + xslStreamSource
					+ ",domResult=" + domResult + ").error:" + e.getMessage());
		}
	}

	/**
	 * Transform an XML stream to DOM tree.
	 * 
	 * @param xmlStreamSource
	 *            - an XML stream used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @param parameters
	 *            - collection of XSL parameters
	 * @param domResult
	 *            - transformed DOM result
	 * @exception RemoteException
	 */
	public void transformStream2DOMWithParam(StreamSource xmlStreamSource,
			StreamSource xslStreamSource, Collection parameters,
			DOMResult domResult) {
		try {
			Transformer transformer = getTransformer(xslStreamSource);

			if (parameters != null) {
				Iterator paramIterator = parameters.iterator();

				while (paramIterator.hasNext()) {
					// Get the name / value pair
					String[] param = (String[]) paramIterator.next();
					String paramName = param[0];
					String paramValue = param[1];

					// Set parameter to the transformer
					transformer.setParameter(paramName, paramValue);
				} // end while
			}

			// Transform
			transformer.transform(xmlStreamSource, domResult);
		} catch (Exception e) {
			log.error("XSLTProcessor.transformStream2DOMWithParam().error:"
					+ e.getMessage());
		}
	}

	/**
	 * Transform an XML stream to an XML-based string.
	 * 
	 * @param xmlStreamSource
	 *            - an XML stream used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL-based stream
	 * @param parameters
	 *            - collection of XSL parameters
	 * @return the transformed string
	 * @pseudo Create a new transformer with input XSL stylesheet Set the XSL
	 *         parameter to the new value Transform to a stream result Return
	 *         the transformed string
	 */
	public String transformStream2StringWithParam(StreamSource xmlStreamSource,
			StreamSource xslStreamSource, Collection parameters) {
		ByteArrayOutputStream os = new ByteArrayOutputStream();

		Transformer transformer;
		try {
			TransformerFactory tFactory = TransformerFactory.newInstance();
			transformer = tFactory
					.newTransformer((StreamSource) xslStreamSource);

			if (parameters != null) {
				Iterator paramIterator = parameters.iterator();

				while (paramIterator.hasNext()) {
					// Get the name / value pair
					String[] param = (String[]) paramIterator.next();
					String paramName = param[0];
					String paramValue = param[1];

					// Set parameter to the transformer
					transformer.setParameter(paramName, paramValue);
				} // end while
			}
			transformer.transform((StreamSource) xmlStreamSource,
					(StreamResult) new StreamResult(os));
		} catch (Exception e) {
			log.error("XSLTProcessor.transformStream2StringWithParam().error:"
					+ e.getMessage());
		}
		return os.toString();
	}

	/**
	 * Transform an XML DOM tree to another DOM tree.
	 * 
	 * @param domSource
	 *            - an XML DOM tree used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @param domResult
	 *            - transformed XML document in DOM tree
	 * @pseudo Create a new transformer with input XSL stylesheet Transform to a
	 *         new DOM tree
	 */
	public void transformDOM2DOM(DOMSource domSource,
			StreamSource xslStreamSource, DOMResult domResult) {

		try {
			Transformer transformer = getTransformer(xslStreamSource);
			transformer.transform((DOMSource) domSource, (DOMResult) domResult);
		} catch (Exception e) {
			log.error("XSLTProcessor.transformDOM2DOM().error:"
					+ e.getMessage());
		}
	}

	/**
	 * Transform an XML DOM tree to another DOM tree with specified parameters.
	 * 
	 * @param domSource
	 *            - an XML DOM tree used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @param domResult
	 *            - transformed XML document in DOM tree.
	 * @param para
	 *            Collection of parameters.
	 */
	public void transformDOM2DOMWithParam(DOMSource domSource,
			StreamSource xslStreamSource, Collection param, DOMResult domResult) {
		try {
			Transformer transformer = getTransformer(xslStreamSource);
			if (!param.isEmpty()) {
				Iterator paramIterator = param.iterator();
				while (paramIterator.hasNext()) {
					// Get the name / value pair
					String[] paramStr = (String[]) paramIterator.next();
					String paramName = paramStr[0];
					String paramValue = paramStr[1];
					// Set parameter to the transformer
					transformer.setParameter(paramName, paramValue);
				}
			} // end while
			transformer.transform((DOMSource) domSource, (DOMResult) domResult);
		} catch (Exception e) {
			log.error("XSLTProcessor.transformDOM2DOMWithParam().error:"
					+ e.getMessage());
		}
	}

	/**
	 * Transform XML DOM tree to an XML-based string.
	 * 
	 * @param domSource
	 *            - XML DOM tree used as source of transformation
	 * @param xslStreamSource
	 *            - an XSL stream source
	 * @return transformed XML document in String format
	 * @pseudo Create a new transformer with input XSL stylesheet Transform DOM
	 *         tree to a stream result Transform the stream result into string
	 */
	public String serializeDOMSource(DOMSource domSource,
			StreamSource xslStreamSource) {
		try {
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			Transformer transformer = getTransformer(xslStreamSource);
			transformer.transform((DOMSource) domSource,
					(StreamResult) new StreamResult(os));
			return (os.toString());
		} catch (Exception ex) {
			log.error("XSLTProcessor.serializeDOMSource().error:"
					+ ex.getMessage());
			return null;
		}
	}

	/**
	 * Serialize a node to an XML-based string.
	 * 
	 * @param xmlNode
	 *            a DOM node
	 * @return transformed XML node in String format
	 * @pseudo Initilaize a new DOM serializer Serialize the DOM tree to a
	 *         stream result and return the output
	 */
	public String serializeNode(Node xmlNode) {
		try {
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			// Instantiate an Xalan XML serializer and use it to serialize the
			// output DOM to System.out
			// using a default output format.
			Serializer serializer = SerializerFactory
					.getSerializer(OutputProperties
							.getDefaultMethodProperties("xml"));
			serializer.setOutputStream(os);
			serializer.asDOMSerializer().serialize(xmlNode);
			return (os.toString());
		} catch (Exception ex) {
			log.error("XSLTProcessor.serializeNode().error:" + ex.getMessage());
			return null;
		}
	}

	/**
	 * Find a node using XPath.
	 * 
	 * @param xpath
	 *            - XPath
	 * @param target
	 *            - the target node
	 * @return a list of nodes that meet the search requirement
	 * @pseudo Build a XPath statement from the input XPath string and target
	 *         node Execute the created XPath statement and return the node list
	 *         found
	 */
	public NodeList findNodeList(String xpath, Node target) {

		XObject list = null;
		try {
			XPathContext xpathContext = new XPathContext();
			PrefixResolver prefixResolver = new PrefixResolverDefault(target);
			// create the XPath
			XPath xp = new XPath(xpath, null, prefixResolver, XPath.SELECT,
					null);
			// now execute the XPath select statement
			list = xp.execute(xpathContext, target, prefixResolver);
			return list != null ? list.nodelist() : null;
		} catch (Exception ex) {
			log.error("XSLTProcessor.findNodeList().error:" + ex.getMessage());
			return null;
		}
	}

	/**
	 * Update the an XML document information extracted from the input vector
	 * 
	 * @param xmlDoc
	 *            an XML document
	 * @param parameters
	 *            a multi-dimension collection (name/values)
	 * @return the updated XML document
	 * @exception RemoteException
	 * @pseudo For each element of the input vector Get the parameter name and
	 *         value Find the XML nodes corresponding to the parameter Update
	 *         their value Return the updated XML document.
	 */
	public Document updateDocument(Document xmlDoc, Collection parameters){		
		log.debug("XSLTProcessor.updateDocument() invoked");
		try {
			Vector paramVector = new Vector(parameters);
			for (int i = 0; i < paramVector.size(); i++) {
				Vector paramInstance = (Vector) paramVector.elementAt(i);
				String paramName = (String) paramInstance.elementAt(0);
				log.debug("param Name: " + paramName);
				String[] paramValue = (String[]) paramInstance.elementAt(1);
				NodeList nodeList = findNodeList("//" + paramName,
						xmlDoc.getDocumentElement());
				if (nodeList != null) {
					int iteration = nodeList.getLength();
					if (iteration > paramValue.length) {
						iteration = paramValue.length;
					}
					log.debug("nodeList length: " + iteration);
					// Update nodes' values
					Node node = null;
					for (int j = 0; j < iteration; j++) {
						node = nodeList.item(j);
						if ((paramValue[j] != null)
								&& (paramValue[j].length() > 0)) {
							if (!node.hasChildNodes()) {
								Node textNode = xmlDoc
										.createTextNode(paramValue[j]);
								node.appendChild(textNode);
								log.debug("paramValue: "
										+ (String) paramValue[j]);
							} else {
								node.getFirstChild().setNodeValue(
										(String) paramValue[j]);
								log.debug("paramValue: "
										+ (String) paramValue[j]);
							}
						} else {
							if (node.hasChildNodes())
								node.removeChild(node.getFirstChild());
						}
					} // for
				} // if
			} // for
			return xmlDoc;
		} catch (Exception e) {
			String errorMsg = "XSLTProcessor.updateDocument() : system error. ";
			log.error(errorMsg);
			return null;
		}
	}

	/**
	 * Creates a new instance of Transformer using the currently configured
	 * parameters.
	 * 
	 * @param xslStreamSource
	 *            Description of Parameter.
	 * @return a transformer
	 * @exception RemoteException
	 *                Description of Exception.
	 * @exception TransformerConfigurationException
	 *                Description of Exception.
	 * @pseudo none
	 */
	private Transformer getTransformer(StreamSource xslStreamSource)
			throws TransformerConfigurationException {

		if (transformerFactory == null) {
			transformerFactory = getTransformerFactory();
		}
		if (xslStreamSource != null) {
			return transformerFactory.newTransformer(xslStreamSource);
		} else {
			return transformerFactory.newTransformer();
		}
	}

	/**
	 * Creates a new instance of a Transformer Factory using the currently
	 * configured parameters.
	 * 
	 * @return a factory of Transformer
	 * @exception TransformerConfigurationException
	 */
	private TransformerFactory getTransformerFactory()
			throws TransformerConfigurationException {
		return TransformerFactory.newInstance();
	}

}
