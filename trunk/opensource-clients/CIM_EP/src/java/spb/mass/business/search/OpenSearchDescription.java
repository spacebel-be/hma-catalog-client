package spb.mass.business.search;

public class OpenSearchDescription {
	private String osddURL;
	private OpenSearchUrl openSearchUrl;

	public String getOsddURL() {
		return osddURL;
	}

	public void setOsddURL(String osddURL) {
		this.osddURL = osddURL;
	}

	public OpenSearchUrl getOpenSearchUrl() {
		return openSearchUrl;
	}

	public void setOpenSearchUrl(OpenSearchUrl openSearchUrl) {
		this.openSearchUrl = openSearchUrl;
	}

	@Override
	public String toString() {
		return "OpenSearchDescription[ osddURL = " + osddURL
				+ ", openSearchUrl = " + openSearchUrl + "]";
	}

}
