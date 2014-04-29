package spb.mass.navigation.utils;

import java.util.ArrayList;
import java.util.Set;

import javax.faces.model.DataModel;
import javax.faces.model.ListDataModel;

import org.ajax4jsf.component.html.HtmlAjaxRepeat;
import org.ajax4jsf.model.SequenceDataModel;

/**
 * Component extending a4j:repeat but allowing iteration over Sets. Order is of
 * course not guaranteed when iterating because we are using sets. This
 * component is useful to iterate over a map keySet.
 * 
 * @author jpr
 * 
 */
public class UIRepeatComponent extends HtmlAjaxRepeat {
	@Override
	protected DataModel getDataModel() {
		Object current = getValue();
		if (current instanceof Set) {
			return new SequenceDataModel(new ListDataModel(new ArrayList(
					(Set) current)));
		}
		return super.getDataModel();
	}
}
