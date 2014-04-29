package spb.mass.navigation.messages;

import java.util.Iterator;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIViewRoot;
import javax.faces.context.FacesContext;
import javax.faces.event.PhaseEvent;
import javax.faces.event.PhaseId;
import javax.faces.event.PhaseListener;

import org.apache.log4j.Logger;

import spb.mass.navigation.utils.ManagedBeanUtil;

/**
 * Collects messages in the JSF pipe and pushes them to our messaging mechanism.
 * See MessagesBean for more information.
 * 
 * @author jpr
 * 
 */
public class MessagesPhaseListener implements PhaseListener {

	private final Logger log = Logger.getLogger(getClass());

	public void afterPhase(PhaseEvent event) {
		FacesContext fc = event.getFacesContext();
		handlePhase(fc);
	}

	public void beforePhase(PhaseEvent event) {

	}

	private void handlePhase(FacesContext context) {
		UIViewRoot root = context.getViewRoot();

		// this check is needed because we need to be able to retrieve the
		// locale from the view root later on.
		if (root != null) {
			MessagesBean messagesBean = ManagedBeanUtil
					.lookup(MessagesBean.class);

			Iterator<FacesMessage> messages = context.getMessages();
			while (messages.hasNext()) {
				FacesMessage message = messages.next();
				messages.remove();
				message.setDetail("");
				messagesBean.push(message);
			}
		}
	}

	public PhaseId getPhaseId() {
		return PhaseId.ANY_PHASE;

	}
}
