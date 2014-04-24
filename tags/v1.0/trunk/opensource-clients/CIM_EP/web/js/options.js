var options = {
	show : function(productid, groupid) {
		jQuery("div[name*=spboptions_" + productid + "]").hide();
		jQuery("div[name=spboptions_" + productid + "_" + groupid + "]").show();
	}
};

jQuery(function() {
	jQuery("select[name*=selectedOptions_]").change(function(e) {
		var groupid = e.target.value;
		var productid = e.target.name.substring("selectedOptions_".length);
		options.show(productid, groupid);
	});
});