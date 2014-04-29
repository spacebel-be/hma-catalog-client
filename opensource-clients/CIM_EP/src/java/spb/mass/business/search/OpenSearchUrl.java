package spb.mass.business.search;

import java.util.List;

public class OpenSearchUrl {
	private String templateUrl;
	private String responseFormat;
	private boolean removeEmptyParams;
	private List<OpenSearchParameter> optionalParameters;
	private List<OpenSearchParameter> requiredParameters;
	private int indexOffset;
	private int pageOffset;

	public OpenSearchUrl() {
		this.responseFormat = "application/atom+xml";
		this.removeEmptyParams = false;
		this.indexOffset = 1;
		this.pageOffset = 1;
	}

	public String getResponseFormat() {
		return responseFormat;
	}

	public void setResponseFormat(String responseFormat) {
		this.responseFormat = responseFormat;
	}

	public boolean isRemoveEmptyParams() {
		return removeEmptyParams;
	}

	public void setRemoveEmptyParams(boolean removeEmptyParams) {
		this.removeEmptyParams = removeEmptyParams;
	}

	public String getTemplateUrl() {
		return templateUrl;
	}

	public void setTemplateUrl(String templateUrl) {
		this.templateUrl = templateUrl;
	}

	public List<OpenSearchParameter> getOptionalParameters() {
		if (optionalParameters != null) {
			OpenSearchParameterComparator.sort(optionalParameters);
		}
		return optionalParameters;
	}

	public void setOptionalParameters(
			List<OpenSearchParameter> optionalParameters) {
		this.optionalParameters = optionalParameters;
	}

	public List<OpenSearchParameter> getRequiredParameters() {
		if (requiredParameters != null) {
			OpenSearchParameterComparator.sort(requiredParameters);
		}

		return requiredParameters;
	}

	public void setRequiredParameters(
			List<OpenSearchParameter> requiredParameters) {
		this.requiredParameters = requiredParameters;
	}

	public int getIndexOffset() {
		return indexOffset;
	}

	public void setIndexOffset(int indexOffset) {
		this.indexOffset = indexOffset;
	}

	public int getPageOffset() {
		return pageOffset;
	}

	public void setPageOffset(int pageOffset) {
		this.pageOffset = pageOffset;
	}

	@Override
	public String toString() {
		return "OpenSearchUrl[ templateUrl = " + templateUrl
				+ ", responseFormat = " + responseFormat
				+ ", removeEmptyParams = " + removeEmptyParams
				+ ", indexOffset = " + indexOffset + ", pageOffset = "
				+ pageOffset + ", optionalParameters = " + optionalParameters
				+ ",requiredParameters = " + requiredParameters + "]";
	}
}
