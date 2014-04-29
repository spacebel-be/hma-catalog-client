package spb.mass.navigation.messages;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;

/**
 * Messages are pushed by the MessagePhaseListener into this bean. The default
 * messaging mechanism is not working with the used version of the bridge.
 * 
 * @author jpr
 * 
 */
public class MessagesBean {
	private List<FacesMessage> messages;	

	@PostConstruct
	public void init() {
		messages = new ArrayList<FacesMessage>();
	}

	public void push(FacesMessage message) {
		if (!messages.contains(message)) {
			messages.add(message);
		}
	}

	public String getCSS(FacesMessage message) {
		String css = "";
		if (FacesMessage.SEVERITY_ERROR.equals(message.getSeverity())) {
			css = "portlet-msg-error";
		} else if (FacesMessage.SEVERITY_INFO.equals(message.getSeverity())) {
			css = "portlet-msg-success";
		} else if (FacesMessage.SEVERITY_WARN.equals(message.getSeverity())) {
			css = "portlet-msg-alert";
		}
		return css;
	}

	public String getCSS(FacesMessage.Severity severity) {
		String css = "";
		if (FacesMessage.SEVERITY_ERROR.equals(severity)) {
			css = "portlet-msg-error";
		} else if (FacesMessage.SEVERITY_INFO.equals(severity)) {
			css = "portlet-msg-success";
		} else if (FacesMessage.SEVERITY_WARN.equals(severity)) {
			css = "portlet-msg-alert";
		}
		return css;
	}
	
	public boolean isError(FacesMessage message) {
		return FacesMessage.SEVERITY_ERROR.equals(message.getSeverity());
	}

	/* GETTERS AND SETTERS */
	public List<FacesMessage> getMessages() {
		return messages;
	}

	public void setMessages(List<FacesMessage> messages) {
		this.messages = messages;
	}	
}
