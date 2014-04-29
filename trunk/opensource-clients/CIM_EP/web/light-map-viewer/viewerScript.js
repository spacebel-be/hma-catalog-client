/**
 * SVIEWER : SSE standard functions
 * @author cnl Christophe Noel Spacebel
 * @email Christophe.Noel@Spacebel.be
 * @date 2012 April 1
 * @version 0.2
 *
 * The map viewer is compatible with standard SSE mechanisms
 * through functions implemented in this file.
 *
 * Implemented functions :
 * - getAOIFromViewer(callbackFunction) get the AOI from the viewer
 * - addMapGML(gml_data) : display GML on map (new function)
 * - displaySingleEmbeddedResultFromStylesheet(gml_data) : display GML on map (old function)
 * - updateSelectedSearchResult(fid,unknown) used with show on map button
 * - displayGMLfilesFromPortal() : NOT IMPLEMENTED TODO ?
 */

/**
 * add a WMS Layer to the map
 */
function addMapWMS(url,layer)
{
	
	var cleanurl = url;
	//if(url.indexOf("?") != -1) {
		//cleanurl = url.substring(0,url.indexOf("?",0));
	//}
	if(typeof layer == 'undefined')
	{layer="so2";}	
	
	SpaceMapUtils.addWMSLayer(cleanurl,layer);
}

function showLayerOnMap(getmapUrl,productName)
{	
	var baseUrl = getmapUrl;
	var queryString = "";
	var layer = {};
	/*
		limit layer title to 20 characters
	*/
	if(productName.length > 20){
		layer["title"] = productName.substring(0,20) + "...";
	}else{
		layer["title"] = productName;
	}	
	layer["abstract"] = productName;
	getmapUrl = getmapUrl.replace("&amp;","&");	
	
	if(getmapUrl.indexOf("?") != -1) {
		baseUrl = getmapUrl.substring(0,getmapUrl.indexOf("?") + 1);
		//alert("baseUrl:" + baseUrl);
		queryString = getmapUrl.substring(getmapUrl.indexOf("?") + 1);
		//alert("queryString:" + queryString);
	}
	
	if(queryString != ""){		
		var params = queryString.split("&");
		var paramsKVP = "";
		for(var i = 0; i < params.length; i++){
			var tmpParam = params[i].toUpperCase();			
			if(tmpParam.indexOf("LAYERS") == -1
				&& tmpParam.indexOf("REQUEST") == -1
				&& tmpParam.indexOf("VERSION") == -1
				&& tmpParam.indexOf("BBOX") == -1
				&& tmpParam.indexOf("SRS") == -1
				&& tmpParam.indexOf("WIDTH") == -1
				&& tmpParam.indexOf("HEIGHT") == -1
				&& tmpParam.indexOf("FORMAT") == -1
				&& tmpParam.indexOf("SERVICE") == -1
				&& tmpParam.indexOf("TRANSPARENT") == -1){
				//alert("another:" + tmpParam);
				if(paramsKVP == "")	{
					paramsKVP = params[i];
				}else{
					paramsKVP = paramsKVP + "&" + params[i];
				}
			}
			if(tmpParam.indexOf("LAYERS") != -1){
				layer["name"] = params[i].split("=")[1];
				//alert("layer name: " + layer["name"]);
			}
			if(tmpParam.indexOf("SRS") != -1){
				layer["srs"] = params[i].split("=")[1];
				//alert("SRS: " + layer["srs"]);
			}
			if(tmpParam.indexOf("BBOX") != -1){
				layer["bbox"] = params[i].split("=")[1];
				//alert("bbox: " + layer["bbox"]);
			}
		}
		baseUrl = baseUrl + paramsKVP;	
	}
	layer["url"] = baseUrl;	
	//alert(layer["url"]);
	SpacemapCommon.addWMSLayer(SpaceMap.spacemap,layer);
}

function displayThumbnail(wmsURL,wmsLayer,version,startDate,endDate)
{
	var wmsFullURL = wmsURL;
	if(wmsFullURL.indexOf("?") == -1){
		wmsFullURL = wmsFullURL + "?";
	}
	var queryString = "REQUEST=GetMap&LAYERS=" + wmsLayer + "&TIME=" + startDate +"/" + endDate;
	if(version !=""){
		wmsFullURL = wmsFullURL + "VERSION=" + version + "&" + queryString;
	}else{
		wmsFullURL = wmsFullURL + queryString;
	}
	//alert(wmsFullURL);
	if(!findWMSLayer(SpaceMap.spacemap,wmsFullURL,wmsLayer)){
		SpaceMapUtils.addWMSLayer(wmsFullURL,wmsLayer);
	}
}

/**
 * getAOIFromViewer(callbackFunction)
 * @param callbackFunction : SSE function that creates the required data for AOI
 * This function get the AOI GML representation and send it to the SSE function
 * (in this case the callback mechanism is useless as the function works synchronously)
 */
function getAOIFromViewer(callbackFunction) {
	var fAOI = SpaceMapUtils.createAOIGML();
			/* to format the AOI */
		callbackFunction(fAOI);
	}


/**
 * Not implemeted
 * @return
 */
function displayGMLfilesFromPortal() {}

/**
 * displaySingleEmbeddedResultFromStylesheet(data) was introduced to fix an issue
 * due to the Genesis mechanism : displaySingEmbeddedResultFromPortal is
 * always called by the result portlet and clears the results displayed from
 * the stylesheet call.
 * In the old client, we replaced all the function calls with this new function.
 *
 * It sets a flag variable (lock_map) to true when a stylesheet call has drawn something
 * on the map.
 * The usual display function is executed excepted if this flag is set on.
 */
function displaySingleEmbeddedResultFromStylesheet(data) {
	displaySingleEmbeddedResultFromPortal(data);
	// lock the map for the next portal call
	//lock_map = true;
}
function displaySingleEmbeddedResultFromPortal(data)
{
	//if (typeof (lock_map) == 'undefined' || lock_map == false) {
		SpaceMapUtils.clearResults();
		SpaceMapUtils.displayGML("Results", data);
	
	//}
}
/**
 * Display also GML on map (new Genesis function name)
 * @param data
 * @return
 */
function addMapGML(data) {
	displaySingleEmbeddedResultFromPortal(data);
}

function addAOI(data, center){	
	//alert(data);
		var bbox = data.split(",");
		var polygon = 'POLYGON(('+ bbox[0] +' '+ bbox[1] +','+ bbox[0] +' ' + bbox[3] + ','+ bbox[2] +' '+ bbox[3] +','+ bbox[2] +' '+ bbox[1] +','+ bbox[0] +' '+ bbox[1] +'))';
		document.getElementById('olAOI').value = polygon;
		SpaceMapUtils.displayAOIGML("AOI", SpaceMapUtils.createAOIGML());
		if(center == true){
			var bbox0 = parseFloat(bbox[0]);
			var bbox1 = parseFloat(bbox[1]);
			var bbox2 = parseFloat(bbox[2]);
			var bbox3 = parseFloat(bbox[3]);
			var deltax = (bbox2 - bbox0) / 50;
			var deltay = (bbox3 - bbox1) / 50;
			SpaceMap.spacemap.zoomToExtent(new OpenLayers.Bounds(bbox0 - deltax, bbox1 - deltay, bbox2 + deltax, bbox3 + deltay));
		}
	}

/**
 * Select/unselect a feature on map in accordance with checkbox value
 * @param fid : feature id
 * @param checked : value of the checkbox
 * @return
 */
function setFeatureSelectionStatusOnMap(fid, checked) {
	SpaceMapUtils.changeHighlightByFid(fid,checked);
	}

/**
 * clickLink : ??? was found on the GIM viewerScript.js
 * TODO check this function
 * @param linkId
 * @return
 */
function clickLink(linkId) {
	var fireOnThis = document.getElementById(linkId);
	if (document.createEvent) {
		var evObj = document.createEvent('MouseEvents');
		evObj.initEvent('click', true, false);
		fireOnThis.dispatchEvent(evObj);
	} else if (document.createEventObject) {
		fireOnThis.fireEvent('onclick');
	}
}

/**
 * Selects a feature on map according to its id
 * TODO check this function !
 *
 * @param fid : fied id
 * @param unknown
 * @return
 */
function updateSelectedSearchResult(fid, unknown) {
	SpaceMapUtils.selectFeatureByFid(fid);
}

function searchComplete(data) {
	/**
		MNG: this eventing is not used anymore in the catalogue client component
		SPBEventing.fireEvent(SPBEventing.constants.EVENT_PROCESSCOMPLETE, null);		
	*/	
	displaySingleEmbeddedResultFromPortal(data);
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

/**
	the functions below have been moved from js/viewerScript.js
*/
function selectAllCheckboxesBasket(boolean) {
	var checkboxes = getInputElementByClassName("checkbox-select-basket");	
	for ( var i = 0; i < checkboxes.length; i++) {
		var checkbox = checkboxes[i];
		checkbox.checked = boolean;
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

/**
	the functions below have been moved from js/viewerScript.js
	and modified to corresponde to new WMV
*/

function selectAllFeaturesOnMap() {
	changeHighlightAllFeatures(true);
}

function clearFeaturesSelection() {
	changeHighlightAllFeatures(false);
}

/*
	the functions below have been added for SSE EOLI/Order integration
*/
function changeHighlightAllFeatures(checked){	
	SpaceMapUtils.changeHighlightAllFeatures(checked);
}

function getCurrentAOIFromViewer() {
	return SpaceMapUtils.createAOIGML();			
}

/*
	this function is called by submitSearchForProducts function in portal-jsf-war/web/portlets/searchinput/search.xhtml
	to check required AOI. 
*/
function hasAOI(){
	var xAOI = document.getElementById('olAOI').value;
	if (xAOI == '') {
		return false;
	} 
	return true;
}