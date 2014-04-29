package spb.mass.navigation.utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.faces.component.UIComponent;
import javax.faces.component.UIComponentBase;
import javax.faces.component.UIParameter;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.navigation.service.URLBuilder;

/**
 * JSF does not bundle any tag to render a simple <a> tag so there it is.
 * 
 * @author jpr
 * 
 */
public class HtmlLinkComponent extends UIComponentBase {
	private final Logger log = Logger.getLogger(this.getClass());
	private String _href;
	private String _onclick;
	private String _target;
	private String _class;
	private String _style;

	public HtmlLinkComponent() {
		this(null, null, null);
	}

	public HtmlLinkComponent(String href, String onclick) {
		this(href, onclick, null);
	}

	public HtmlLinkComponent(String href, String onclick, String target) {
		this._href = href;
		this._onclick = onclick;
		this._target = target;
	}

	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		super.encodeBegin(context);
		ResponseWriter writer = context.getResponseWriter();
		if (_href == null) {
			_href = (String) getAttributes().get("href");
			if (_href == null) {
				_href = "";
			}
		}
		Object onclickObj = getAttributes().get("onclick");
		if (_onclick == null && onclickObj != null) {
			_onclick = (String) onclickObj;
		}

		Object targetObj = getAttributes().get("target");
		if (_target == null && targetObj != null) {
			_target = (String) targetObj;
		}

		Object classObj = getAttributes().get("styleClass");
		if (_class == null && classObj != null) {
			_class = (String) classObj;
		}
		Object styleObj = getAttributes().get("style");
		if (_style == null && styleObj != null) {
			_style = (String) styleObj;
		}

		URLBuilder url = new URLBuilder(_href);

		for (UIComponent comp : getChildren()) {
			if (comp instanceof UIParameter) {
				UIParameter param = (UIParameter) comp;
				String name = param.getName();
				Object value = param.getValue();
				if (name != null && value != null) {
					url.addParam(name, value.toString());
				}
			}
		}

		writer.startElement("a", this);
		if (_href != null) {
			writer.writeAttribute("href", url.build(), null);
		}
		if (_onclick != null) {
			writer.writeAttribute("onclick", _onclick, null);
		}
		if (_target != null) {
			writer.writeAttribute("target", _target, null);
		}
		if (_class != null) {
			writer.writeAttribute("class", _class, null);
		}
	}

	@Override
	public void encodeEnd(FacesContext context) throws IOException {
		super.encodeEnd(context);
		ResponseWriter writer = context.getResponseWriter();
		writer.endElement("a");
	}

	@Override
	public String getFamily() {
		return getClass().getName();
	}
}
