package spb.mass.navigation.service.search;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import java.util.Random;

import javax.faces.component.UIComponent;
import javax.faces.component.UIComponentBase;
import javax.faces.component.UIInput;
import javax.faces.component.UIParameter;
import javax.faces.component.UISelectOne;
import javax.faces.component.html.HtmlGraphicImage;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;
import javax.faces.el.MethodBinding;
import javax.faces.event.ActionEvent;

import org.ajax4jsf.component.html.HtmlAjaxFunction;
import org.ajax4jsf.component.html.HtmlAjaxOutputPanel;
import org.ajax4jsf.renderkit.RendererUtils.HTML;
import org.apache.commons.beanutils.PropertyUtils;
//import org.apache.log4j.Logger;

import spb.mass.business.search.Constants;
import spb.mass.navigation.utils.HtmlLinkComponent;

/**
 * Wraps the content with the queryable UI PS: probably a good idea to rewrite
 * this in JS only
 * 
 * @author jpr
 * 
 */
public class SearchQueryablesComponent extends UIComponentBase {

	private static final String CSSCLASSNAME = "select-queryable";
	private FacesContext context;
	private ResponseWriter writer;
	//private final Logger log = Logger.getLogger(getClass());
	private Random randomGenerator = new Random();
	private String currentId;
	private String serviceId;

	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		this.context = context;

		writer = context.getResponseWriter();
		super.encodeBegin(context);

		currentId = getClientId(context) + randomGenerator.nextLong();
		// log.debug("currentId: " + currentId);

		writer.write("<div id='" + currentId + "'>");

		addJSFunction("addQueryable", "#{serviceBean.addQueryableToForm}");
		addJSFunction("removeQueryable",
				"#{serviceBean.removeQueryableFromForm}");
		serviceId = (String) this.getAttributes().get("serviceId");

		Map<String, String> dropdownListIdNameMapping = new HashMap<String, String>();
		Map<String, UIInput> map = handleComponent(this,
				new LinkedHashMap<String, UIInput>(),
				dropdownListIdNameMapping, context);
		/*
		 * create a hidden field contains the mapping between input name and
		 * client identifier of all drop-down lists. This workaround resolve
		 * problem that the server could not get drop-down list value in
		 * SearchQueryables component as from second search.
		 */
		if (!dropdownListIdNameMapping.isEmpty()) {
			StringBuffer hiddenValues = new StringBuffer();
			for (String name : dropdownListIdNameMapping.keySet()) {
				hiddenValues.append(name);
				hiddenValues.append(Constants.ID_NAME_DELIMITER);
				hiddenValues.append(dropdownListIdNameMapping.get(name));
				hiddenValues.append(Constants.IDS_NAMES_DELIMITER);
			}
			/*
			 * log.debug(Constants.DROPDOWN_LIST_ID_NAME_MAPPING +
			 * " hidden value: " + hiddenValues.toString());
			 */
			writer.startElement("input", this);
			writer.writeAttribute(HTML.TYPE_ATTR, "hidden", null);
			writer.writeAttribute(HTML.NAME_ATTRIBUTE,
					Constants.DROPDOWN_LIST_ID_NAME_MAPPING, null);
			writer.writeAttribute("value", hiddenValues.toString(), null);
			writer.endElement("hidden");
		}

		writer.startElement("select", this);
		writer.writeAttribute(HTML.class_ATTRIBUTE, CSSCLASSNAME, null);
		writer.writeAttribute("onchange", "addQueryable(this.value, '"
				+ serviceId + "', 'addQueryable')", null);
		writer.startElement("option", this);
		String selectText = null;
		if (map.isEmpty()) {
			/*
			 * selectText = FacesMessageUtil
			 * .getLocalizedString("searchinput.text.nomorequeryables");
			 */
			selectText = "All queryables are shown";

		} else {
			/*
			 * selectText = FacesMessageUtil
			 * .getLocalizedString("searchinput.text.chooseequeryable");
			 */
			selectText = "Choose more queryables";
		}
		writer.write(selectText);
		writer.endElement("option");

		for (String key : map.keySet()) {
			UIInput input = map.get(key);
			writer.startElement("option", this);
			writer.writeAttribute("id",
					"option-mng-" + randomGenerator.nextLong(), null);
			writer.writeAttribute("value", key, null);
			String label = getLabel(input);
			writer.write(label == null ? "Date" : label);
			writer.endElement("option");
		}

		writer.endElement("select");
	}

	private void addJSFunction(String name, String methodBinding)
			throws IOException {
		HtmlAjaxFunction addFunc = new HtmlAjaxFunction();
		addFunc.setName(name);
		addFunc.setId("jsFunction-mng-" + randomGenerator.nextLong());

		MethodBinding actionListener = context.getApplication()
				.createMethodBinding(methodBinding,
						new Class[] { ActionEvent.class });
		addFunc.setActionListener(actionListener);

		UIParameter param = new UIParameter();
		param.setId("param-mng-queryable-" + randomGenerator.nextLong());
		param.setName("queryable");
		addFunc.getChildren().add(param);
		param.setParent(addFunc);

		UIParameter sparam = new UIParameter();
		sparam.setId("param-mng-serviceId-" + randomGenerator.nextLong());
		sparam.setName("selectedServiceId");
		sparam.setValue(serviceId);
		addFunc.getChildren().add(sparam);
		sparam.setParent(addFunc);

		UIParameter baParam = new UIParameter();
		baParam.setId("param-mng-beanAction-" + randomGenerator.nextLong());
		baParam.setName("beanAction");
		baParam.setValue(serviceId);
		addFunc.getChildren().add(baParam);
		baParam.setParent(addFunc);

		// addFunc.setReRender(currentId);
		addFunc.setReRender("searchInputWindow");
		// addFunc.setReRender(getId());
		getChildren().add(addFunc);
		addFunc.setParent(this);
		addFunc.encodeAll(context);
	}

	@Override
	public void encodeEnd(FacesContext context) throws IOException {
		super.encodeEnd(context);
		writer.write("</div>");
	}

	private Map<String, UIInput> handleComponent(UIComponent comp,
			Map<String, UIInput> map,
			Map<String, String> dropdownListIdNameMapping, FacesContext context)
			throws IOException {
		UIComponent[] children = comp.getChildren().toArray(new UIComponent[0]);
		for (int i = 0; i < children.length; i++) {
			UIComponent child = children[i];
			if (child instanceof UIInput) {
				UIInput input = (UIInput) child;
				String name = (String) input.getAttributes().get("name");
				if (!input.isRendered()) {
					map.put(name, input);
				}
				if (child instanceof UISelectOne) {
					dropdownListIdNameMapping.put(name,
							input.getClientId(context));
				}
				addRemoveQueryableButton(input, i);
			} else {
				handleComponent(child, map, dropdownListIdNameMapping, context);
			}
		}
		return map;
	}

	private void addRemoveQueryableButton(UIInput input, int inputPosition)
			throws IOException {
		UIComponent parent = input.getParent();
		if (parent instanceof HtmlOutputWrapper) {
			// component already processed, skipping. Although I'm not sure why
			// I need to
			// set rendered to false here but I do
			parent.setRendered(false);
			return;
		}
		// wrapping the input and adding the remove button
		HtmlAjaxOutputPanel wrapper = new HtmlOutputWrapper();
		wrapper.setId("wrapper-mng-" + randomGenerator.nextLong());
		wrapper.setLayout("inline");
		wrapper.setRendered(input.isRendered());
		parent.getChildren().remove(inputPosition);
		parent.getChildren().add(inputPosition, wrapper);
		wrapper.setParent(parent);
		wrapper.getChildren().add(input);
		input.setParent(wrapper);

		HtmlLinkComponent link = new HtmlLinkComponent("javascript:void(0)",
				String.format("removeQueryable('%s','" + serviceId
						+ "', 'removeQueryable'); return false;", input
						.getAttributes().get("name")));
		link.setId("link-mng-" + randomGenerator.nextLong());

		wrapper.getChildren().add(link);
		link.setParent(wrapper);

		HtmlGraphicImage image = new HtmlGraphicImage();
		image.setId("image-mng-" + randomGenerator.nextLong());
		image.setValue("/images/ico_clear.gif");
		image.setStyleClass("removequeryable-image");
		link.getChildren().add(image);
		image.setParent(link);

	}

	private String getLabel(UIInput input) throws IOException {
		String result = null;

		// because UIInput does not have the label property, but the input we
		// use are subclasses and do have one. This calls the getLabel() method.
		try {

			result = (String) PropertyUtils.getProperty(input, "label");
		} catch (Exception e) {
			Object label = input.getAttributes().get("label");
			if (label != null) {
				result = (String) label;
			} else {
				throw new IOException(e);
			}
		}

		return result;
	}

	@Override
	public boolean getRendersChildren() {
		return true;
	}

	@Override
	public String getFamily() {
		return getClass().getName();
	}
}
