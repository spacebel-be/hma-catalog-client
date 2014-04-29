jQuery(function() {
	jQuery13(".mvoc-invoke, #mvoc-label").live('click', function() {
		MVOC.PROXY_URL = "/mvocproxy/proxy.html";
		var label = jQuery("#mvoc-label");
		var offset = label.offset();
		MVOC.LEFT = offset.left;
		MVOC.TOP = offset.top + label.height();
		
		MVOC.display(function(eventObject) {
			jQuery("#mvoc-label").val(eventObject.label);
			jQuery(".mvoc-value").val(eventObject.uri);
		});
		
	});
});