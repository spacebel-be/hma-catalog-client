package spb.mass.navigation.service.search.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SearchResultProperty {
	private String value;
	private List<String> values = new ArrayList<String>();
	private List<Map<String, SearchResultProperty>> groups = new ArrayList<Map<String, SearchResultProperty>>();
	private boolean orderInput;

	public SearchResultProperty() {
	}

	public SearchResultProperty(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return value;
	}

	public boolean isOrderInput() {
		return orderInput;
	}

	public void setOrderInput(boolean orderInput) {
		this.orderInput = orderInput;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public List<Map<String, SearchResultProperty>> getGroups() {
		return groups;
	}

	public void setGroups(List<Map<String, SearchResultProperty>> groups) {
		this.groups = groups;
	}

	public List<String> getValues() {
		return values;
	}

	public void setValues(List<String> values) {
		this.values = values;
	}

}
