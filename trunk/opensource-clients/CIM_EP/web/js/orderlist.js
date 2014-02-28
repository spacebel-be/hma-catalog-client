OrderList = {};
OrderList.selectAllOrders = function(checked) {
	jQuery("input[name*=delete_]").attr('checked', checked);
};