package spb.mass.navigation.utils;

import java.io.IOException;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;

import org.ajax4jsf.component.html.HtmlAjaxOutputPanel;
import org.apache.log4j.Logger;
import org.richfaces.component.UITab;
import org.richfaces.component.html.HtmlTabPanel;

public class TabPanelComponent extends HtmlTabPanel {

	private boolean tabRendered = false;
	private ResponseWriter writer;
	private final Logger log = Logger.getLogger(getClass());

	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		init(context);
		if (tabRendered) {
			HtmlTabPanel tabPanel = new HtmlTabPanel();
			tabPanel.setSwitchType((String) getAttributes().get("switchType"));

			// do not iterate over getChildren() directly as the list changes
			// when the parent of children are modified. We need a list that do
			// not change to iterate over all components.
			for (UIComponent comp : getChildren().toArray(new UIComponent[0])) {
				tabPanel.getChildren().add(comp);
				comp.setParent(tabPanel);
			}

			getChildren().clear();
			getChildren().add(tabPanel);
			tabPanel.setParent(this);
		} else {
//			writer.startElement("div", this);
//			writer.writeAttribute("class", "form-border", null);
//			getChildren().iterator().next().encodeChildren(context);
//			writer.endElement("div");
			setStyleClass("form-border");
			UIComponent[] children = getChildren().iterator().next().getChildren().toArray(new UIComponent[0]);
			getChildren().clear();
			for(UIComponent comp : children){
				getChildren().add(comp);
				comp.setParent(this);
			}
		}
	}

	private void init(FacesContext context) {
		writer = context.getResponseWriter();

		int count = 0;
		for (UIComponent comp : getChildren()) {
			if (comp instanceof UITab) {
				count++;
			}
			if (count > 1) {
				tabRendered = true;
				break;
			}
		}
	}

	@Override
	public String getFamily() {
		return getClass().getName();
	}

}
