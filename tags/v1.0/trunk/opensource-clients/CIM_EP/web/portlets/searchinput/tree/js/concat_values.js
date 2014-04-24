//concat_values.js

function concatValues() {
	var obj;
	var e;

	var tFrame = document.getElementById('treeFrame');
	// var tDiv = tFrame.contentDocument.getElementById('treeDiv');
	// var tForm = document.getElementById('treeForm');
	var tForm = tFrame.contentDocument.treeForm;

	var cDiv = document.getElementById('concatVals');
	// delete child objects
	childs = cDiv.childNodes;

	var nbLength = childs.length - 1;
	for ( var i = nbLength; i > -1; i--) {
		cDiv.removeChild(childs[i]);
	}

	if ((tForm != null) && (cDiv != null)) {
		for ( var i = 0; i < tForm.length; i++) {
			obj = tForm.elements[i];

			if (obj.type == 'checkbox') {
				if (obj.checked) {
					if (obj.value) {
						e = document.createElement("INPUT");
						e.setAttribute('type', 'hidden');
						e.setAttribute('value', obj.value);
						e.setAttribute('name', 'collectionId');
						cDiv.appendChild(e);
					}
				}
			}
		}
	}

	//return validateCollectionPicker();
}