function searchComplete(data) {
	//SPBEventing.fireEvent(SPBEventing.constants.EVENT_PROCESSCOMPLETE, null);
	displaySingleEmbeddedResultFromPortal(data);
}

function displaySingleEmbeddedResultFromPortal(data) {

	getGVS().clearFeatures("sr", function() {
		if (data != undefined && data != "") {
			getGVS().addFeaturesGML("sr", data, "3.1.1", null);
		}
	});

	// TODO remove when viewer handles execution chain
	if (data != undefined && data != "") {
		getGVS().addFeaturesGML("sr", data, "3.1.1", null);
	}

}

function addMapGML(data) {
	// TTH modify to clear the feature of the previous execution
	// getGVS().addFeaturesGML("sr", data, "3.1.1", null);
	getGVS().clearFeatures("sr", function() {
		getGVS().addFeaturesGML("sr", data, "3.1.1", null);
	});
}

function addAOI(data) {
	getGVS().clearFeatures("aoi", function() {
		getGVS().addFeaturesGML("aoi", bboxToGML(data), "3.1.1", null);
	});
}

function addMapContext(data) {
	getGVS().resetMapContext(function() {
		getGVS().addMapContext(data);
	});
}

function getAOIFromViewer(callbackFunction) {
	if (!validateCollections()) {
		return false;
	}
	// old system
	if (typeof initValidation != "undefined") {
		initValidation();
	}
	// old system
	if (typeof document.getElementById("treeFrame") != "undefined") {
		if (typeof concatValues != "undefined") {
			concatValues();
		}
	}
	disableButtons();
	if (isViewerLoaded()) {
		getGVS().getFeaturesGML("aoi", "3.1.1", "EPSG:4326", function(data) {
			callbackFunction(data);
		});
	} else {
		callbackFunction("");
	}
}

function validateCollections() {
	if (typeof collection_picker == "undefined") {
		return true;
	}
	var validated = collection_picker_validate();
	return validated;
}

function enableButtons() {
	// works but disabled by request
	// jQuery(".btn-process").removeClass("disabled").removeAttr("disabled");
}

function disableButtons() {
	// works but disabled by request
	// jQuery(".btn-process").addClass("disabled").attr("disabled", true);
}

function displayAOIOnViewer() {
	var aoi_data = document.getElementById("previous_aoi");
	if (aoi_data != null) {
		var data = aoi_data.value;
		if (data != null && data != "") {
			// alert("Sending AOI to viewer: " + data);
			getGVS().addFeaturesGML("aoi", data, "3.1.1", null);
		}
	}
	return false;
}

function displayAOIAndFeatures() {
	displaySingleEmbeddedResultFromPortal();
	displayAOIOnViewer();
}

function selectFeatureOnMap(featureId) {
	getGVS().selectFeature("sr", featureId);
	getGVS().zoomToFeatureExtent("sr", featureId);
}

function unselectFeatureOnMap(featureId) {
	getGVS().unselectFeature("sr", featureId);
}

function selectFeaturesOnMap(featuresId) {
	getGVS().selectFeatures("sr", featuresId);
}

function unselectFeaturesOnMap(featuresId) {
	getGVS().unselectFeatures("sr", featuresId);
}

function setFeatureSelectionStatusOnMap(featureId, checked) {
	if (checked == true) {
		selectFeatureOnMap(featureId);
	} else {
		unselectFeatureOnMap(featureId);
	}
}

function selectAllFeaturesOnMap() {
	getGVS().selectAllFeatures("sr");
}

function clearFeaturesSelection() {
	getGVS().unselectAllFeatures("sr");
}

function selectAllCheckboxesBasket(boolean) {
	var checkboxes = getInputElementByClassName("checkbox-select-basket");
	for ( var i = 0; i < checkboxes.length; i++) {
		var checkbox = checkboxes[i];
		checkbox.checked = boolean;
	}
}
function setFeatureSelectionArrayStatusOnMap(items, checked) {
	var featureIds = new Array();
	for ( var i = 0; i < items.length; i++) {
		featureIds[i] = items[i];
	}
	if (checked == true) {
		selectFeaturesOnMap(featureIds);
	} else {
		unselectFeaturesOnMap(featureIds);
	}
}

function tabChangedRefreshFeatures(items, gmlFeatures) {
	/*
	 * gmlFeatures = Object.toJSON(gmlFeatures);
	 * displaySingleEmbeddedResultFromPortal(gmlFeatures);
	 * 
	 * if (items.length > 0) { setFeatureSelectionArrayStatusOnMap(items, true); }
	 */
}

jQuery(function() {
	/*jQuery('.rich-calendar-popup').livequery(function() {
		jQuery(this).css('z-index', '100000');
	});
	jQuery('.rich-modalpanel').livequery(function() {
		jQuery(this).css('z-index', '100000');
	});

	jQuery(".dropdown-menu > div").livequery(function() {
		jQuery(this).css('z-index', '100000');
	});
	*/
	A4J.AJAX.onExpired = function(loc, expiredMsg) {
		if (window.confirm(expiredMsg)) {
			return loc;
		} else {
			return false;
		}
	};
});

function filterAlreadySelected(fids, bool) {
	var featureIds = new Array();
	var j = 0;
	for ( var i = 0; i < fids.length; i++) {
		var checkbox = getInputElementByClassName(fids[i])[0];
		if (checkbox.checked == bool) {
			featureIds[j] = fids[i];
			j = j + 1;
		}
	}
	return featureIds;
}

function clickLink(linkId) {
	var fireOnThis = document.getElementById(linkId)
	if (document.createEvent) {
		var evObj = document.createEvent('MouseEvents');
		evObj.initEvent('click', true, false);
		fireOnThis.dispatchEvent(evObj);
	} else if (document.createEventObject) {
		fireOnThis.fireEvent('onclick');
	}
}

function getInputElementByClassName(classname, node) {
	var returnArray = new Array();
	var j = 0;
	if (!node)
		node = document.getElementsByTagName("body")[0];
	var re = new RegExp('\\b' + classname + '\\b');
	var els = node.getElementsByTagName("input");
	for ( var i = 0; i < els.length; i++) {
		if (re.test(els[i].className)) {
			returnArray[j] = els[i];
			j = j + 1;
		}
	}
	return returnArray;
}

function getQueryParameter(url, parameterName) {
	var parameters = url.slice(url.indexOf('?') + 1).split('&');
	var value = "";
	for ( var i = 0; i < parameters.length; i++) {
		var parameter = parameters[i].split('=');
		if (parameter[0] == parameterName) {
			value = parameter[1];
			break;
		}
	}
	return decodeURIComponent(value);
}

function addMapWMS(serviceURL) {

	var bbox = getQueryParameter(serviceURL, "BBOX");
	bbox = bbox.split(',');
	var minX = bbox[0];
	var minY = bbox[1];
	var maxX = bbox[2];
	var maxY = bbox[3];

	var serviceVersion = '1.1.1';

	var layerName = getQueryParameter(serviceURL, "LAYERS");
	var title = "WMS";

	var styleName = getQueryParameter(serviceURL, "STYLES");

	var time = getQueryParameter(serviceURL, "TIME");
	var timeElement = "";
	if (time !== "") {
		timeElement = '<DimensionList>'
				+ '   <Dimension name="TIME" default="2004-09-04T09:16:46Z/2004-09-04T09:17:20Z"/>'
				+ '</DimensionList>';

	}

	// serviceURL = encodeURIComponent(serviceURL);
	serviceURL = serviceURL.slice(0, serviceURL.indexOf('?'));
	var wmc = '<ViewContext version="1.1.0" id="sos_map_context" xmlns="http://www.opengis.net/context" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sld="http://www.opengis.net/sld">'
			+ '  <General>' + '    <BoundingBox SRS="EPSG:4326" minx="'
			+ minX
			+ '" miny="'
			+ minY
			+ '" maxx="'
			+ maxX
			+ '" maxy="'
			+ maxY
			+ '"/>'
			+ '    <Title>Map Context</Title>'
			+ '    <Abstract>Map Context</Abstract>'
			+ '  </General>'
			+ '  <LayerList>'
			+ '    <Layer hidden="0" queryable="0">'
			+ '      <Server service="OGC:WMS" version="'
			+ serviceVersion
			+ '" title="Web Map Service">'
			+ '         <OnlineResource xlink:type="simple" xlink:href="'
			+ serviceURL
			+ '"/>'
			+ '      </Server>'
			+ '      <Name>'
			+ layerName
			+ '</Name>'
			+ '      <Title>'
			+ title
			+ '</Title>'
			+ '      <SRS>EPSG:4326</SRS>'
			+ '      <FormatList>'
			+ '         <Format current="1">image/png</Format>'
			+ '      </FormatList>'
			+ '      <StyleList>'
			+ '         <Style current="1">'
			+ '            <Name>'
			+ styleName
			+ '</Name>'
			+ '            <Title>Default</Title>'
			+ '         </Style>'
			+ '      </StyleList>'
			+ timeElement
			+ '       <Extension>'
			+ '        <LayerProperties xmlns="http://specto.gim.be/wmc">'
			+ '          <layerId>dataLayer</layerId>'
			+ '          <maxBoundingBox SRS="EPSG:4326" minx="'
			+ minX
			+ '" miny="'
			+ minY
			+ '" maxx="'
			+ maxX
			+ '" maxy="'
			+ maxY
			+ '"/>'
			+ '          <opacity>1.0</opacity>'
			+ '          <tiled>false</tiled>'
			+ '          <tools>'
			+ '            <value>remove</value>'
			+ '          </tools>'
			+ '          <mapRendering>direct</mapRendering>'
			+ '        </LayerProperties>'
			+ '      </Extension>'
			+ '    </Layer>' + '  </LayerList>' + '</ViewContext>';
	addMapContext(wmc);
}
