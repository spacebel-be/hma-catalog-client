package spb.mass.navigation.service.search;

import org.ajax4jsf.component.html.HtmlAjaxOutputPanel;

/**
 * Simply extending HtmlAjaxOutputPanel, acts as a flag (instanceof
 * HtmlAjaxOutputPanel) for already wrapped content
 * 
 * @author jpr
 * 
 */
public class HtmlOutputWrapper extends HtmlAjaxOutputPanel {

	public HtmlOutputWrapper() {
		super();
	}

}
