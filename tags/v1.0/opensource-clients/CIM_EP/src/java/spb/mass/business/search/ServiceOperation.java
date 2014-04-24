package spb.mass.business.search;

import spb.mass.business.search.Constants.AccessMethod;
import spb.mass.business.search.Constants.OperationName;

public class ServiceOperation {
	private AccessMethod binding;
	private OperationName name;
	private String xslFile;
	private String bindingAction;
	private String endpoint;

	public AccessMethod getBinding() {
		return binding;
	}

	public void setBinding(AccessMethod binding) {
		this.binding = binding;
	}

	public OperationName getName() {
		return name;
	}

	public void setName(OperationName name) {
		this.name = name;
	}

	public String getXslFile() {
		return xslFile;
	}

	public void setXslFile(String xslFile) {
		this.xslFile = xslFile;
	}

	public String getBindingAction() {
		return bindingAction;
	}

	public void setBindingAction(String bindingAction) {
		this.bindingAction = bindingAction;
	}

	public String getEndpoint() {
		return endpoint;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	@Override
	public String toString() {
		return "ServiceOperation [name = " + name + ",binding = " + binding
				+ ",xslFile = " + xslFile + ",bindingAction = " + bindingAction
				+ ",endpoint = " + endpoint + "]";

	}

}
