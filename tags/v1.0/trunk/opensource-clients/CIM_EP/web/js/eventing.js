SPBEventing = new Object();
SPBEventing.constants = new Object();
SPBEventing.constants.EVENT_CHANGESERVICE = "SPBEVENT_CHANGESERVICE";
SPBEventing.constants.EVENT_DOSEARCH = "SPBEVENT_DOSEARCH";
SPBEventing.constants.EVENT_DOPRESENT = "SPBEVENT_DOPRESENT";
SPBEventing.constants.EVENT_GETBASKET = "SPBEVENT_GETBASKET";
SPBEventing.constants.EVENT_SENDBASKET = "SPBEVENT_SENDBASKET";
SPBEventing.constants.EVENT_CHANGEORDER = "SPBEVENT_CHANGEORDER";
SPBEventing.constants.EVENT_PROCESSCOMPLETE = "SPBEVENT_PROCESSCOMPLETE";
SPBEventing.constants.EVENT_CHECKOUTCOMPLETE = "SPBEVENT_CHECKOUTCOMPLETE";
SPBEventing.constants.EVENT_ORDERRESULTSTATUSCHANGED = "SPBEVENT_ORDERRESULTSTATUSCHANGED";

SPBEventing.constants.EVENT_ONTOLOGYCHANGED = "SPBEVENT_ONTOLOGYCHANGED";
SPBEventing.constants.EVENT_ONTOLOGYTOGGLE = "SPBEVENT_ONTOLOGYTOGGLE";
SPBEventing.constants.EVENT_ONTOLOGYTRANSLATE = "SPBEVENT_ONTOLOGYTRANSLATE";
SPBEventing.constants.EVENT_ONTOLOGYFOCUSON = "SPBEVENT_ONTOLOGYFOCUSON";
SPBEventing.constants.EVENT_ONTOLOGYCHANGETHESAURUS = "SPBEVENT_ONTOLOGYCHANGETHESAURUS";


SPBEventing.constants.EVENT_ACTIVATESERVICEASYNC = "SPBEVENT_ACTIVATESERVICEASYNC";

SPBEventing.fireEvent = function(eventName, eventValue) {
	jQuery(document).trigger(eventName, eventValue);
	return false;
};

SPBEventing.bindEvent = function(eventName, callbackFunction) {
	jQuery(document).bind(eventName, function(event, data) {
		callbackFunction(event, data);
	});
};
