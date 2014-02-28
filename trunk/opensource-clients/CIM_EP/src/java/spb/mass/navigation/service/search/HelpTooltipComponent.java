package spb.mass.navigation.service.search;

import java.io.IOException;

import javax.faces.component.UIComponent;
import javax.faces.component.UIComponentBase;
import javax.faces.component.html.HtmlGraphicImage;
import javax.faces.component.html.HtmlOutputText;
import javax.faces.context.FacesContext;

import org.ajax4jsf.component.html.HtmlAjaxOutputPanel;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.richfaces.component.html.HtmlToolTip;

/**
 * Creates a tooltip with some help text when the mouse is hovered on top of the
 * generated icon. If the component is used as a wrapper around other elements,
 * it will create a div and put the icon as the last element inside the div.
 * 
 * @author jpr
 * 
 */
public class HelpTooltipComponent extends UIComponentBase {

	private String helpString;
	private Logger log = Logger.getLogger(getClass());

	public HelpTooltipComponent() {
		super();
	}

	public HelpTooltipComponent(String helpString) {
		super();
		this.helpString = helpString;
	}

	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		super.encodeBegin(context);

		if (StringUtils.isEmpty(helpString)) {
			helpString = (String) getAttributes().get("value");
		}

		HtmlAjaxOutputPanel panel = new HtmlAjaxOutputPanel();
		HtmlAjaxOutputPanel helpPanel = getHelpPanel();

		panel.encodeBegin(context);

		for (UIComponent comp : getChildren()) {
			comp.encodeAll(context);
		}

		helpPanel.encodeAll(context);
		panel.encodeEnd(context);

	}

	private HtmlAjaxOutputPanel getHelpPanel() throws IOException {
		HtmlAjaxOutputPanel panel = new HtmlAjaxOutputPanel();
		panel.setStyle("padding-left: 3px");

		HtmlGraphicImage image = new HtmlGraphicImage();
		image.setValue("/images/help.png");
		panel.getChildren().add(image);
		image.setParent(panel);

		HtmlToolTip tooltip = new HtmlToolTip();
		tooltip.setDirection("top-right");
		tooltip.setStyleClass("tooltip");
		tooltip.setStyle("z-index: 2147483647");
		panel.getChildren().add(tooltip);
		tooltip.setParent(panel);

		HtmlOutputText text = new HtmlOutputText();
		tooltip.getChildren().add(text);
		text.setParent(tooltip);
		String ls = System.getProperty("line.separator");
		if (helpString != null) {
			helpString = helpString.replaceAll(ls, "<br/>");
		}
		text.setValue(helpString);

		text.setEscape(false);

		return panel;
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
