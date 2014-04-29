package spb.mass.business.search;

import java.util.Map;
import java.util.Iterator;

public class ServiceData {
	private String id;
	private String name;
	private String icd;
	private Map<String, ServiceOperation> operations;
	private boolean aoiRequired;
	private boolean osService;
	private OpenSearchDescription osDescription;

	public ServiceData() {
	}

	public ServiceData(String id, String name, String icd,
			Map<String, ServiceOperation> operations, boolean aoiRequired) {
		super();
		this.id = id;
		this.name = name;
		this.icd = icd;
		this.operations = operations;
		this.aoiRequired = aoiRequired;
	}	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIcd() {
		return icd;
	}

	public void setIcd(String icd) {
		this.icd = icd;
	}

	public Map<String, ServiceOperation> getOperations() {
		return operations;
	}

	public void setOperations(Map<String, ServiceOperation> operations) {
		this.operations = operations;
	}

	public boolean isAoiRequired() {
		return aoiRequired;
	}

	public void setAoiRequired(boolean aoiRequired) {
		this.aoiRequired = aoiRequired;
	}

	public boolean isOsService() {
		return osService;
	}

	public void setOsService(boolean osService) {
		this.osService = osService;
	}

	public OpenSearchDescription getOsDescription() {
		return osDescription;
	}

	public void setOsDescription(OpenSearchDescription osDescription) {
		this.osDescription = osDescription;
	}

	@Override
	public String toString() {
		String sOperations = "";
		if (operations != null) {
			sOperations = "{";
			Iterator<String> iter = operations.keySet().iterator();
			while (iter.hasNext()) {
				String opName = iter.next();
				sOperations += operations.get(opName).toString() + ";";
			}
			sOperations += "}";
		}
		return "ServiceData [id = " + id + ",name = " + name + ",icd = " + icd
				+ ",operations = " + sOperations + ", aoiRequired = "
				+ aoiRequired + ", osService = " + osService
				+ ", osDescription = " + osDescription + "]";

	}
}
