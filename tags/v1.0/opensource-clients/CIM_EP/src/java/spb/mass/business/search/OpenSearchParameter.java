package spb.mass.business.search;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.faces.model.SelectItem;

import spb.mass.navigation.utils.SelectItemComparator;

public class OpenSearchParameter {
	private String name;
	private String value;
	private String namespace;
	private String title;
	private String type;
	private String index;
	private Map<String, String> options;

	public OpenSearchParameter() {

	}

	public OpenSearchParameter(String name, String value, String title) {
		this.name = name;
		this.value = value;
		this.title = title;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Map<String, String> getOptions() {
		return options;
	}

	public String getNamespace() {
		return namespace;
	}

	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}

	public String getType() {
		if (isList()) {
			return "list";
		}
		if ("list".equals(type) && !isList()) {
			return "text";
		}
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public List<SelectItem> getOptionsAsSelectItems() {
		if (isList()) {
			List<SelectItem> list = new ArrayList<SelectItem>();
			for (Map.Entry<String, String> entry : options.entrySet()) {
				list.add(new SelectItem(entry.getKey(), entry.getValue()));
			}
			SelectItemComparator.sort(list);
			return list;
		}
		return null;
	}

	public boolean isList() {
		return (options != null && options.size() > 0) ? true : false;
	}

	public void setOptions(Map<String, String> options) {
		this.options = options;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	@Override
	public String toString() {
		String optionValues = "options[";
		if (options != null) {
			for (Map.Entry<String, String> entry : options.entrySet()) {
				optionValues += "value = " + entry.getKey() + ", label = "
						+ entry.getValue() + ",";
			}
		}
		optionValues += "]";

		return "OpenSearchParameter [name = " + name + ", value = " + value
				+ ", title = " + title + ", index = " + index + ", isList = "
				+ isList() + ", options = " + optionValues + "]";
	}
}
