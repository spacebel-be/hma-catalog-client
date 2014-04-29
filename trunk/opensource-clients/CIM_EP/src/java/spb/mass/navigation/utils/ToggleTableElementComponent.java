package spb.mass.navigation.utils;

import java.io.IOException;

import javax.faces.component.UIComponent;
import javax.faces.component.UIComponentBase;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class ToggleTableElementComponent extends UIComponentBase {

	private ResponseWriter writer;
	private Logger log = Logger.getLogger(getClass());
	
	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		writer = context.getResponseWriter();
		writer.startElement("tr", this);

		String _forColumn = (String) getAttributes().get("forColumn");
		String _rowSpan = (String) getAttributes().get("rowSpan");

		int rowSpan = 0;
		int forColumn = 0;
		if (StringUtils.isNotEmpty(_forColumn)
				&& StringUtils.isNotEmpty(_rowSpan)) {
			rowSpan = Integer.parseInt(_rowSpan);
			forColumn = Integer.parseInt(_forColumn);
		}

		int count = 1;
		for (UIComponent child : getChildren()) {
			writer.startElement("td", this);

			if (count == forColumn) {
				writer.writeAttribute("rowspan", rowSpan, null);
			}

			if (count == 1) {
				writer.writeAttribute("class", "firstcolumn", null);
			} else if (count == 2) {
				writer.writeAttribute("class", "secondcolumn", null);
			}
			child.encodeAll(context);
			writer.endElement("td");
			count++;
		}

	}

	@Override
	public void encodeChildren(FacesContext context) throws IOException {

	}

	@Override
	public void encodeEnd(FacesContext arg0) throws IOException {
		writer.endElement("tr");
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
