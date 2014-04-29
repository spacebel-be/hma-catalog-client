tokenSeparator = ',';
blockSeparator = '@@';

// TODO remove this function - hardcoded workaround for js error (initOption does not exist)
function initOptionSelect()
{}

function setSeparator(tokenS, blockS)
{
tokenSeparator = tokenS;
blockSeparator = blockS;
}
/**
 The function getSLD receive a SOS service request (or any string) and replace non URL compliant
 characters by URL characters
*/
	function getSLD(myrequest,myaddress,myprotocol,mymdsurl,mypropertyname,min,max)
{

var reg1 = new RegExp("\\s","g");
var reg2 = new RegExp('"',"g");
var reg3 = new RegExp('<',"g");
var reg4 = new RegExp('>',"g");

/** This loop is used to replace var reg0 = new RegExp('\+',"g");
	which doesn't seem to work
**/
while (myrequest.indexOf('+') > 0){
	myrequest=myrequest.replace('+',"%2B");
}

myrequest=myrequest.replace(reg1,"+").replace(reg2,"%22").replace(reg3,"%3C").replace(reg4,"%3E");
myaddress=myaddress.replace(reg1,"+").replace(reg2,"%22").replace(reg3,"%3C").replace(reg4,"%3E");
myprotocol=myprotocol.replace(reg1,"+").replace(reg2,"%22").replace(reg3,"%3C").replace(reg4,"%3E");

if(mypropertyname.charAt(mypropertyname.length-1) == '_'){
	mypropertyname = mypropertyname.substring(0,mypropertyname.indexOf('_'));
}

if (mypropertyname.lastIndexOf(':') > 0){
	mypropertynameshort = mypropertyname.substring(mypropertyname.lastIndexOf(':')+1,mypropertyname.length) + '_';
}else{
	mypropertynameshort = mypropertyname + '_';
}
equidistance = (parseFloat(max) - parseFloat(min))/4;
if(equidistance < 0){
	equidistance = equidistance*(-1);
}

mySLD= "<form id=\"mySLDform\" name=\"mySLDform\"><input type=\"hidden\" id=\"hitem\" name=\"hitem\" value=\"2\"/><table><tr><td><input type=\"checkbox\" checked=\"checked\" value=\"true\" name=\"checkContours\"/> Contours	<table style=\"border:#000000 0px solid;\"><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Minimum value:</td><td style=\"border:#000000 0px solid;\"> <input name=\"minvalue\" type=\"text\" value=\"" + min + "\" size=\"10\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Maximum value:</td> <td style=\"border:#000000 0px solid;\"><input name=\"maxvalue\" type=\"text\" value=\"" + max + "\" size=\"10\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Equidistance:</td> <td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"equi\" value=\"" + equidistance + "\" size=\"10\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Offset: </td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"offset\" value=\"0\" size=\"3\"/><input type=\"hidden\" name=\"prop\" value=\"Property\" size=\"15\"/></td></tr><tr style=\"border:#000000 0px solid;\">			<td style=\"border:#000000 0px solid;\">Stroke Color:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" onChange=\"this.form.exempleA.style.backgroundColor=this.form.colorA.value;\" name=\"colorA\" size=\"7\" maxlength=\"7\" value=\"#FFFFFF\" style=\"width:55px;\"/><input type=\"button\" name=\"exempleA\" style=\"margin-left:4px;width:20px; height:18px; background-color:#FFFFFF; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='A';popup_color_picker();\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Stroke Width:</td><td style=\"border:#000000 0px solid;\"> <input name=\"strokewidth\" type=\"text\" value=\"0.5\" size=\"3\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Color:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" onChange=\"this.form.exempleB.style.backgroundColor=this.form.colorB.value;\" name=\"colorB\" size=\"7\" maxlength=\"7\" value=\"#FFFFFF\" style=\"width:55px;\"/><input type=\"button\" name=\"exempleB\" style=\"margin-left:4px;width:20px; height:18px; background-color:#FFFFFF; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='B';popup_color_picker();\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Font:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"labelfont\" value=\"Arial\" size=\"5\"/></td></tr> <tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Size:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"labelsize\" value=\"40\" size=\"5\"/></td></tr>  </table></td><td><input type=\"checkbox\"  checked=\"checked\" value=\"true\" name=\"checkCM\"/>  Color Map	<table style=\"border:#000000 0px solid;\">	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Interpolation:</td><td style=\"border:#000000 0px solid;\"> <select name=\"interpol\"><option name=\"option2\" value=\"linear\" selected=\"selected\">linear</option><option name=\"option1\" value=\"discrete\">discrete</option></select></td></tr>	</table><table id=\"colorTable\" style=\"border:#000000 0px solid;\" align=\"center\">	<tr align=\"center\">	<td>Color</td><td>View</td><td>Quantity</td>	</tr>		<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple1.style.backgroundColor=this.form.color1.value;\" name=\"color1\" size=\"7\" maxlength=\"7\" value=\"#0000FF\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple1\" style=\"width:20px; height:18px; background-color:#0000FF; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='1';popup_color_picker();\"/></td>			<td><input name=\"quantity1\" size=\"10\" value=\"" + min + "\" type=\"text\"/></td>      </tr>		<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple2.style.backgroundColor=this.form.color2.value;\" name=\"color2\" size=\"7\" maxlength=\"7\" value=\"#00FF00\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple2\" style=\"width:20px; height:18px; background-color:#00FF00; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='2';popup_color_picker();\"/></td>			<td><input name=\"quantity2\" size=\"10\" value=\"" + (parseFloat(min) + (parseFloat(max)-parseFloat(min))*1/3) + "\" type=\"text\"/></td>      </tr>      	<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple3.style.backgroundColor=this.form.color3.value;\" name=\"color3\" size=\"7\" maxlength=\"7\" value=\"#FF0000\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple3\" style=\"width:20px; height:18px; background-color:#FF0000; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='3';popup_color_picker();\"/></td>			<td><input name=\"quantity3\" size=\"10\" value=\"" + (parseFloat(min) + (parseFloat(max)-parseFloat(min))*2/3) + "\" type=\"text\"/></td>      </tr>     	<tr align=\"center\">					<td><input type=\"text\" onChange=\"this.form.exemple4.style.backgroundColor=this.form.color4.value;\" name=\"color4\" size=\"7\" maxlength=\"7\" value=\"#FFFF00\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple4\" style=\"width:20px; height:18px; background-color:#FFFF00; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='4';popup_color_picker();\"/></td>			<td><input name=\"quantity4\" size=\"10\" value=\"" + max + "\" type=\"text\"/></td>      </tr>	</table>	<input type=\"button\" value=\"Add\" style=\"margin-left:28px;\" name=\"addcolor\" onclick=\"addColorLine()\"/>	<input type=\"button\" value=\"Delete\" style=\"margin-left:3px;\" name=\"delcolor\" onclick=\"delColorLine()\"/><br/><tr align=\"center\"><table width=\"90%\"><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Method: </td><td style=\"border:#000000 0px solid;\"><select name=\"method\" size=\"1\"/><option value=\"IDWMethod\">IDWMethod</option><option value=\"TINMethod\">TINMethod</option></select></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Resolution: </td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"resolution\" value=\"100\" size=\"3\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Opacity:</td><td style=\"border:#000000 0px solid;\"> <input type=\"text\" name=\"opacity\" size=\"3\" value=\"255\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">MDS URL:</td><td style=\"border:#000000 0px solid;\"> <input type=\"text\" name=\"mdsurl\" value=\"" + mymdsurl + "\" size=\"55\"/></td></tr></table></tr></td>	</tr>    <tr align=\"center\"><table width=\"100%\"><tr><td align=\"center\" width=\"100%\"><input type=\"button\" style=\"margin-top:5px;\" onclick=\"showSLD(this.form);\" value=\"Show\"/> <input onclick=\"displaySingleFileFromPortal('', 'WMSURL');displayWMSURL();\" type=\"button\" value=\"Clear\"/> 		</td></tr><table>	</tr>	</table>";

if (myrequest.indexOf('ObservationId') > 0){
	mySLDhidden= '<input type=\"hidden\" name=\"getobsparam\" value=\"0\"/>' + '<input type=\"hidden\" name=\"getobsbyidparam\" value=\"' + myrequest;
}else{
	mySLDhidden= '<input type=\"hidden\" name=\"getobsbyidparam\" value=\"0\"/>' + '<input type=\"hidden\" name=\"getobsparam\" value=\"' + myrequest;
}



mySLDhclose='\"/>';
myAddresshidden = '<input type=\"hidden\" name=\"getaddressparam\" value=\"' + myaddress;
myProtocolhidden = '<input type=\"hidden\" name=\"getprotocolparam\" value=\"' + myprotocol;
myMDSURLhidden = '<input type=\"hidden\" name=\"getmdsurlparam\" value=\"' + mymdsurl;
myPropertyNamehidden = '<input type=\"hidden\" name=\"getpropertynameparam\" value=\"' + mypropertyname;
myPropertyNameShorthidden = '<input type=\"hidden\" name=\"getpropertynameshortparam\" value=\"' + mypropertynameshort;

mySLDclose = '</form>';
myFullSLD = mySLD + mySLDhidden + mySLDhclose + myAddresshidden + mySLDhclose + myProtocolhidden + mySLDhclose + myMDSURLhidden + mySLDhclose + myPropertyNamehidden + mySLDhclose + myPropertyNameShorthidden + mySLDhclose + mySLDclose;

return myFullSLD;
}
/**
This function compares two input parameters
*/
	function compareLessThan(number1, number2){
		if (number1 < number2){
			return true;
		}else{
			return false;
		}
	}


/**
This function transforms input of the SLD configurator (and SOS GetObservation request)
to a MDS request (HTTP GET request)
*/
	function showSLD(myform)
	{

	/*header = 'http://karlinapp.ethz.ch/fcgi-bin/qgis_map_server/datasource_test/qgis_map_serv.fcgi?SERVICE=WMS&amp;REQUEST=GetMap&amp;VERSION=1.1.1&amp;BBOX=-180,-90,180,90&amp;SRS=EPSG:4326&amp;WIDTH=752&amp;HEIGHT=752&amp;FORMAT=image/png&amp;TRANSPARENT=TRUE&amp;SLD_BODY=';*/
	header = myform.mdsurl.value + '?SERVICE=WMS&amp;REQUEST=GetMap&amp;VERSION=1.1.1&amp;BBOX=-180,-90,180,90&amp;SRS=EPSG:4326&amp;WIDTH=752&amp;HEIGHT=752&amp;FORMAT=image/png&amp;TRANSPARENT=TRUE&amp;SLD_BODY=';
	StyledLayerDescriptorh = '%3CStyledLayerDescriptor+xmlns=%22http://www.opengis.net/sld%22%3E';
	StyledLayerDescriptorf ='%3C/StyledLayerDescriptor%3E';
	NamedLayerh = '%3CUserLayer+xmlns=%22http://www.opengis.net/sld%22%3E';
	NamedLayerf = '%3C/UserLayer%3E';
	NamedLayerDescription = '%3CName+xmlns=%22http://www.opengis.net/sld%22%3Ealbis%3C/Name%3E%3COpacity%3E'+myform.opacity.value+'%3C/Opacity%3E';
	UserStyleh = '%3CUserStyle+xmlns=%22http://www.opengis.net/sld%22%3E';
	UserStyleDescription ='%3CName+xmlns=%22http://www.opengis.net/sld%22%3Einterpolated%3C/Name%3E';
	UserStylef = '%3C/UserStyle%3E';
	RemoteOWS = '%3CRemoteOWS+method=%22'+ myform.getprotocolparam.value +'%22%3E%3CService%3ESOS%3C/Service%3E%3COnlineResource+xmlns:xlink=%22http://www.w3.org/1999/xlink%22+xmlns:type=%22simple%22+xlink:href=%22' + myform.getaddressparam.value + '%22/%3E%3C/RemoteOWS%3E';
	RasterSymbolizerh = '%3CRasterSymbolizer%3E';
	RasterSymbolizerf = '%3C/RasterSymbolizer%3E';

	if (myform.getobsparam.value != '0'){
		GetObsParam = myform.getobsparam.value;
		GetObserv = '%3CGetObservation+xmlns=%22http://www.opengis.net/sos/1.0%22+version=%221.0.0%22+service=%22SOS%22%3E'+GetObsParam+'%3C/GetObservation%3E';
		LayerConstraints = '%3CLayerSensorObservationConstraints%3E%3CSensorObservationTypeConstraint%3E'+GetObserv+'%3C/SensorObservationTypeConstraint%3E%3C/LayerSensorObservationConstraints%3E';
	}else if(myform.getobsbyidparam.value != '0'){
		GetObsByIdParam = myform.getobsbyidparam.value;
		GetObservById = '%3CGetObservationById+xmlns=%22http://www.opengis.net/sos/1.0%22+version=%221.0.0%22+service=%22SOS%22%3E'+GetObsByIdParam+'%3C/GetObservationById%3E';
		LayerConstraints = '%3CLayerSensorObservationConstraints%3E%3CSensorObservationTypeConstraint%3E'+GetObservById+'%3C/SensorObservationTypeConstraint%3E%3C/LayerSensorObservationConstraints%3E';
	}

	/*GetObserv = '%3CGetObservation+xmlns=%22http://www.opengis.net/sos/1.0%22+version=%221.0.0%22+service=%22SOS%22%3E'+GetObsParam+'%3C/GetObservation%3E';
	LayerConstraints = '%3CLayerSensorObservationConstraints%3E%3CSensorObservationTypeConstraint%3E'+GetObserv+'%3C/SensorObservationTypeConstraint%3E%3C/LayerSensorObservationConstraints%3E';*/
	//RasterInter = '%3CRasterInterpolation%3E%3CInterpolation%3E%3CIDWMethod/%3E%3CResolution+ncols=%22100%22+nrows=%22100%22/%3E%3CPropertyName%3Evalue%3C/PropertyName%3E%3C/Interpolation%3E%3C/RasterInterpolation%3E'
	//RasterInter = '%3CRasterInterpolation%3E%3CInterpolation%3E%3CTINMethod+/%3E%3CPropertyName%3E'+ myform.getpropertynameparam.value +'%3C/PropertyName%3E%3C/Interpolation%3E%3CResolution+ncols=%22' + myform.resolution.value + '%22+nrows=%22' + myform.resolution.value + '%22+/%3E%3C/RasterInterpolation%3E';
	RasterInter = '%3CRasterInterpolation%3E%3CInterpolation%3E%3C' + myform.method.value + '+/%3E%3CPropertyName%3E'+ myform.getpropertynameparam.value +'%3C/PropertyName%3E%3C/Interpolation%3E%3CResolution+ncols=%22' + myform.resolution.value + '%22+nrows=%22' + myform.resolution.value + '%22+/%3E%3C/RasterInterpolation%3E';
	ContourS = '%3CContourSymbolizer+minValue=%22'+ myform.minvalue.value+'%22+maxValue=%22'+myform.maxvalue.value+'%22+equidistance=%22'+ myform.equi.value + '%22+offset=%22'+ myform.offset.value+'%22+propertyName=%22'+ myform.getpropertynameshortparam.value.substring(0,myform.getpropertynameshortparam.value.indexOf('_')) +'%22%3E%3CFeatureTypeStyle%3E%3CRule%3E%3CLineSymbolizer%3E%3CStroke%3E%3CCssParameter+sld:name=%22stroke%22%3E%23'+ myform.colorA.value.substring(1)+ '%3C/CssParameter%3E%3CCssParameter+sld:name=%22stroke-width%22%3E'+ myform.strokewidth.value+ '%3C/CssParameter%3E%3C/Stroke%3E%3C/LineSymbolizer%3E%3CTextSymbolizer%3E%3CLabel%3E%3CPropertyName%3E'+ myform.getpropertynameshortparam.value.substring(0,myform.getpropertynameshortparam.value.indexOf('_')) + '%3C/PropertyName%3E%3C/Label%3E%3CFont%3E%3CCssParameter+sld:name=%22font-family%22%3E' + myform.labelfont.value + '%3C/CssParameter%3E%3CCssParameter+sld:name=%22font-size%22%3E' + myform.labelsize.value + '%3C/CssParameter%3E%3C/Font%3E%3CFill%3E%3CCssParameter+sld:name=%22fill%22%3E%23' + myform.colorB.value.substring(1) + '%3C/CssParameter%3E%3C/Fill%3E%3C/TextSymbolizer%3E%3C/Rule%3E%3C/FeatureTypeStyle%3E%3C/ContourSymbolizer%3E';
	if(! myform.checkContours.checked)
	{
	ContourS='';
	}
	ColorMaph = '%3CColorMap+interpolation=%22'+ myform.interpol.value +'%22%3E';
	ColorMapf = '%3C/ColorMap%3E';
		var tbl = document.getElementById('colorTable');
		//alert(tbl.rows.length)
		ColorMapEntries ='';
	for(i=1; i < tbl.rows.length; i++)
	{
	var colori = 'color'+i;
	var quantityi = 'quantity'+i;
		ColorMapEntries += '%3CColorMapEntry+color=%22%23'+ myform.elements[colori].value.substring(1) + '%22+quantity=%22' + myform.elements[quantityi].value  +'%22/%3E';
		}
	RasterAll = RasterSymbolizerh + ColorMaph + ColorMapEntries + ColorMapf + RasterSymbolizerf;
	if(! myform.checkCM.checked)
	 {
	 RasterAll=RasterSymbolizerh + ColorMaph + '%3CColorMapEntry+color=%22%23000000%22+quantity=%220%22/%3E' + ColorMapf + RasterSymbolizerf;
	 }
	FullURL = header + StyledLayerDescriptorh + NamedLayerh + NamedLayerDescription + RemoteOWS + LayerConstraints + RasterInter + UserStyleh + UserStyleDescription + RasterAll+ ContourS + UserStylef + NamedLayerf + StyledLayerDescriptorf;
	//alert(document.getElementById('hitem').innerHTML);
	//myform.ftpurl.value= FullURL;
	displaySingleFileFromPortal(FullURL, 'WMSURL');
	displayWMSURL();
	//alert(FullURL);
	//document.getElementById('mySLDform').innerHTML = '';
	//alert(document.getElementById('hitem').innerHTML);
/*
var winy = open("", "Cool", "width=820, height=810,  resizable= true,  draggable=true, wiredDrag= true");
  winy.document.write(FullURL);
*/
	}

/**
This function display the SLD configurator for the WPS (with ftp file as input)
*/
		function getSLDWPS(mymdsurl)
{
mySLD= "<form name=\"mySLDform\"><input type=\"hidden\" name=\"hitem\" value=\"2\"/><table><tr><td><input type=\"checkbox\" checked=\"checked\" value=\"true\" name=\"checkContours\"/> Contours	<table style=\"border:#000000 0px solid;\"><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Minimum value:</td><td style=\"border:#000000 0px solid;\"> <input name=\"minvalue\" type=\"text\" value=\"0\" size=\"10\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Maximum value:</td> <td style=\"border:#000000 0px solid;\"><input name=\"maxvalue\" type=\"text\" value=\"50\" size=\"10\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Equidistance:</td> <td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"equi\" value=\"50\" size=\"10\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Offset: </td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"offset\" value=\"0\" size=\"3\"/></td></tr><tr style=\"border:#000000 0px solid;\">			<td style=\"border:#000000 0px solid;\">Stroke Color:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" onChange=\"this.form.exempleA.style.backgroundColor=this.form.colorA.value;\" name=\"colorA\" size=\"7\" maxlength=\"7\" value=\"#FFFFFF\" style=\"width:55px;\"/><input type=\"button\" name=\"exempleA\" style=\"margin-left:4px;width:20px; height:18px; background-color:#FFFFFF; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='A';popup_color_picker();\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Stroke Width:</td><td style=\"border:#000000 0px solid;\"> <input name=\"strokewidth\" type=\"text\" value=\"0.5\" size=\"3\"/></td></tr>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Color:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" onChange=\"this.form.exempleB.style.backgroundColor=this.form.colorB.value;\" name=\"colorB\" size=\"7\" maxlength=\"7\" value=\"#FFFFFF\" style=\"width:55px;\"/><input type=\"button\" name=\"exempleB\" style=\"margin-left:4px;width:20px; height:18px; background-color:#FFFFFF; border-color:#000000;\" onclick=\"document.getElementById('hitem').value='B';popup_color_picker();\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Font:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"labelfont\" value=\"Arial\" size=\"5\"/></td></tr> <tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Label Size:</td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"labelsize\" value=\"40\" size=\"5\"/></td></tr></table></td><td><input type=\"checkbox\"  checked=\"checked\" value=\"true\" name=\"checkCM\"/>  Color Map	<table style=\"border:#000000 0px solid;\">	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Interpolation:</td><td style=\"border:#000000 0px solid;\"> <select name=\"interpol\"><option name=\"option2\" value=\"linear\" selected=\"selected\">linear</option><option name=\"option1\" value=\"discrete\">discrete</option></select></td></tr>	</table><table id=\"colorTable\" style=\"border:#000000 0px solid;\" align=\"center\">	<tr align=\"center\">	<td>Color</td><td>View</td><td>Quantity</td>	</tr>		<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple1.style.backgroundColor=this.form.color1.value;\" name=\"color1\" size=\"7\" maxlength=\"7\" value=\"#0000FF\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple1\" style=\"width:20px; height:18px; background-color:#0000FF; border-color:#000000;\" onclick=\"this.form.hitem.value='1';popup_color_picker();\"/></td>			<td><input name=\"quantity1\" size=\"10\" value=\"200\" type=\"text\"/></td>      </tr>		<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple2.style.backgroundColor=this.form.color2.value;\" name=\"color2\" size=\"7\" maxlength=\"7\" value=\"#00FF00\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple2\" style=\"width:20px; height:18px; background-color:#00FF00; border-color:#000000;\" onclick=\"this.form.hitem.value='2';popup_color_picker();\"/></td>			<td><input name=\"quantity2\" size=\"10\" value=\"500\" type=\"text\"/></td>      </tr>      	<tr align=\"center\">			<td><input type=\"text\" onChange=\"this.form.exemple3.style.backgroundColor=this.form.color3.value;\" name=\"color3\" size=\"7\" maxlength=\"7\" value=\"#FF0000\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple3\" style=\"width:20px; height:18px; background-color:#FF0000; border-color:#000000;\" onclick=\"this.form.hitem.value='3';popup_color_picker();\"/></td>			<td><input name=\"quantity3\" size=\"10\" value=\"800\" type=\"text\"/></td>      </tr>     	<tr align=\"center\">					<td><input type=\"text\" onChange=\"this.form.exemple4.style.backgroundColor=this.form.color4.value;\" name=\"color4\" size=\"7\" maxlength=\"7\" value=\"#FFFF00\" style=\"width:55px;\"/></td>			<td><input type=\"button\" name=\"exemple4\" style=\"width:20px; height:18px; background-color:#FFFF00; border-color:#000000;\" onclick=\"this.form.hitem.value='4';popup_color_picker();\"/></td>			<td><input name=\"quantity4\" size=\"10\" value=\"1200\" type=\"text\"/></td>      </tr>	</table>	<input type=\"button\" value=\"Add\" style=\"margin-left:28px;\" name=\"addcolor\" onclick=\"addColorLine()\"/>	<input type=\"button\" value=\"Delete\" style=\"margin-left:3px;\" name=\"delcolor\" onclick=\"delColorLine()\"/></td>	</tr><tr align=\"center\"><table>	<tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Property Name: </td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"prop\" value=\"Property\" size=\"15\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Method: </td><td style=\"border:#000000 0px solid;\"><select name=\"method\" size=\"1\"/><option value=\"IDWMethod\">IDWMethod</option><option value=\"TINMethod\">TINMethod</option></select></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Resolution: </td><td style=\"border:#000000 0px solid;\"><input type=\"text\" name=\"resolution\" value=\"100\" size=\"3\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">Opacity:</td><td style=\"border:#000000 0px solid;\"> <input type=\"text\" name=\"opacity\" size=\"3\" value=\"255\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">MDS URL:</td><td style=\"border:#000000 0px solid;\"> <input type=\"text\" name=\"mdsurl\" value=\"" + mymdsurl + "\" size=\"50\"/></td></tr><tr style=\"border:#000000 0px solid;\"><td style=\"border:#000000 0px solid;\">FTP URL:</td><td style=\"border:#000000 0px solid;\"> <input type=\"text\" name=\"ftpurl\" size=\"50\"/></td></tr></table><table width=\"100%\"><tr><td align=\"center\" width=\"100%\"><input type=\"button\" style=\"margin-top:5px;\" onclick=\"showSLDWPS(this.form);\" value=\"Show\"/> <input onclick=\"displaySingleFileFromPortal('', 'WMSURL');displayWMSURL();\" type=\"button\" value=\"Clear\"/> 		</td></tr><table>	</tr>	</table><input type=\"hidden\" name=\"getmdsurlparam\" value=\"" + mymdsurl + "</form>";
return mySLD;
}
	function showSLDWPS(myform)
	{
	/*header = 'http://karlinapp.ethz.ch/fcgi-bin/qgis_map_server/isolines/qgis_map_serv.fcgi?SERVICE=WMS&amp;REQUEST=GetMap&amp;VERSION=1.1.1&amp;BBOX=-180,-90,180,90&amp;SRS=EPSG:4326&amp;WIDTH=752&amp;HEIGHT=752&amp;FORMAT=image/png&amp;TRANSPARENT=TRUE&amp;SLD_BODY=';*/
	header = myform.mdsurl.value +  '?SERVICE=WMS&amp;REQUEST=GetMap&amp;VERSION=1.1.1&amp;BBOX=-180,-90,180,90&amp;SRS=EPSG:4326&amp;WIDTH=752&amp;HEIGHT=752&amp;FORMAT=image/png&amp;TRANSPARENT=TRUE&amp;SLD_BODY=';
	StyledLayerDescriptorh = '%3CStyledLayerDescriptor+xmlns=%22http://www.opengis.net/sld%22%3E';
	StyledLayerDescriptorf ='%3C/StyledLayerDescriptor%3E';
	NamedLayerh = '%3CUserLayer+xmlns=%22http://www.opengis.net/sld%22%3E';
	NamedLayerf = '%3C/UserLayer%3E';
	NamedLayerDescription = '%3CName+xmlns=%22http://www.opengis.net/sld%22%3Esoslayer%3C/Name%3E%3COpacity%3E'+myform.opacity.value+'%3C/Opacity%3E';
	UserStyleh = '%3CUserStyle+xmlns=%22http://www.opengis.net/sld%22%3E';
	UserStyleDescription ='%3CName+xmlns=%22http://www.opengis.net/sld%22%3Einterpolated%3C/Name%3E';
	UserStylef = '%3C/UserStyle%3E';
		RemoteRDS = '%3CRemoteRDS%3E'+myform.ftpurl.value+'%3C/RemoteRDS%3E';
		RemoteVDS = '%3CRemoteVDS+format=%22SOS%22%3E'+myform.ftpurl.value+'%3C/RemoteVDS%3E';
	RasterSymbolizerh = '%3CRasterSymbolizer%3E';
	RasterSymbolizerf = '%3C/RasterSymbolizer%3E';
	RasterInter = '%3CRasterInterpolation%3E%3CInterpolation%3E%3C' + myform.method.value + '+/%3E%3CPropertyName%3E'+ myform.prop.value +'%3C/PropertyName%3E%3C/Interpolation%3E%3CResolution+ncols=%22100%22+nrows=%22100%22+/%3E%3C/RasterInterpolation%3E';
	ContourS = '%3CContourSymbolizer+minValue=%22'+ myform.minvalue.value+'%22+maxValue=%22'+myform.maxvalue.value+'%22+equidistance=%22'+ myform.equi.value + '%22+offset=%22'+ myform.offset.value+'%22+propertyName=%22'+ myform.prop.value.substring(0,myform.prop.value.indexOf('_')) +'%22%3E%3CFeatureTypeStyle%3E%3CRule%3E%3CLineSymbolizer%3E%3CStroke%3E%3CCssParameter+sld:name=%22stroke%22%3E%23'+ myform.colorA.value.substring(1)+ '%3C/CssParameter%3E%3CCssParameter+sld:name=%22stroke-width%22%3E'+ myform.strokewidth.value+ '%3C/CssParameter%3E%3C/Stroke%3E%3C/LineSymbolizer%3E%3CTextSymbolizer%3E%3CLabel%3E%3CPropertyName%3E'+ myform.prop.value.substring(0,myform.prop.value.indexOf('_')) + '%3C/PropertyName%3E%3C/Label%3E%3CFont%3E%3CCssParameter+sld:name=%22font-family%22%3E'+ myform.labelfont.value +  '%3C/CssParameter%3E%3CCssParameter+sld:name=%22font-size%22%3E' + myform.labelsize.value +'%3C/CssParameter%3E%3C/Font%3E%3CFill%3E%3CCssParameter+sld:name=%22fill%22%3E%23' + myform.colorB.value.substring(1) +'%3C/CssParameter%3E%3C/Fill%3E%3C/TextSymbolizer%3E%3C/Rule%3E%3C/FeatureTypeStyle%3E%3C/ContourSymbolizer%3E';
	if(! myform.checkContours.checked)
	{
	ContourS='';
	}
	ColorMaph = '%3CColorMap+interpolation=%22'+ myform.interpol.value +'%22%3E';
	ColorMapf = '%3C/ColorMap%3E';
		var tbl = document.getElementById('colorTable');
		//alert(tbl.rows.length)
		ColorMapEntries ='';
	for(i=1; i < tbl.rows.length; i++)
	{
	var colori = 'color'+i;
	var quantityi = 'quantity'+i;
		ColorMapEntries += '%3CColorMapEntry+color=%22%23'+ myform.elements[colori].value.substring(1) + '%22+quantity=%22' + myform.elements[quantityi].value  +'%22/%3E';
		}
	RasterAll = RasterSymbolizerh + ColorMaph + ColorMapEntries + ColorMapf + RasterSymbolizerf;
	if(! myform.checkCM.checked)
	 {
	 RasterAll=RasterSymbolizerh + ColorMaph + '%3CColorMapEntry+color=%22%23000000%22+quantity=%220%22/%3E' + ColorMapf + RasterSymbolizerf;
	 }
	//FullURL = header + StyledLayerDescriptorh + NamedLayerh + NamedLayerDescription + RemoteRDS + UserStyleh + UserStyleDescription + RasterAll+ ContourS + UserStylef + NamedLayerf + StyledLayerDescriptorf
	FullURL = header + StyledLayerDescriptorh + NamedLayerh + NamedLayerDescription + RemoteVDS + RasterInter + UserStyleh + UserStyleDescription + RasterAll + ContourS + UserStylef +
	NamedLayerf + StyledLayerDescriptorf;
	//myform.ftpurl.value= FullURL;
	displaySingleFileFromPortal(FullURL, 'WMSURL');
	displayWMSURL();
	//alert(FullURL);
	/*var winy = open("", "Cool", "width=820, height=810,  resizable= true,  draggable=true, wiredDrag= true");
  winy.document.write(FullURL);*/
	}


function addColorLine()
	{
	var tbl = document.getElementById('colorTable');
	var newRow = tbl.insertRow(tbl.rows.length);
	newRow.align = 'center';
		//newRowHTML = '<td></td><td><input name="quantity'+(tbl.rows.length-1)+'" size="5" value="50" type="text"/></td>';
	var newCell1 = newRow.insertCell(0);
	newCell1.innerHTML = '<input type="text" value="#0000FF" onChange="this.form.exemple'+(tbl.rows.length-1)+'.style.backgroundColor=this.form.color'+(tbl.rows.length-1)+'.value;" name="color'+(tbl.rows.length-1)+'" size="7" maxlength="7" style="width:55px;"/>';
var newCell2 = newRow.insertCell(1);
	newCell2.innerHTML = '<input type="button" name="exemple'+(tbl.rows.length-1)+'" style="width:20px; height:18px; background-color:#0000FF; border-color:#000000;" onclick="this.form.hitem.value='+(tbl.rows.length-1)+';popup_color_picker();"/>';
	var newCell3 = newRow.insertCell(2);
	newCell3.innerHTML = '<input name="quantity'+(tbl.rows.length-1)+'" size="10" value="50" type="text"/>';
	//newRow.innerHTML = newRowHTML;
	newRow.insertCell(newRowHTML);
	}

function delColorLine()
{

	var tbl = document.getElementById('colorTable');
	if (tbl.rows.length > 1)
	{
	tbl.deleteRow(tbl.rows.length - 1);
	}

}

function todayDate()
{
     var currentDate = new Date();
     var month = currentDate.getMonth() + 1;
     if (month <= 9) {
            month = "0" + month;
     }
     var day = currentDate.getDate();
     if (day <= 9) {
         day = "0" + day;
     }
     return currentDate.getFullYear() + '-' + month + '-' + day;
}

function cvsToArray(inputCSV, cseparator, lseparator)
     {
/** cseparator and lseparator are not used anymore since the value
	is set according to the response content of the GetObservation request
	Anyway if no blockSeparator or tokenSeparator are set, the usual default one are used.
	The function is not depecrated because some functions may still use it.
*/
     var inputLines = inputCSV.split(blockSeparator);
     var output = new Array(inputLines.length);
     for(var i=0; i < inputLines.length ; i++)
          {
          output[i] = inputLines[i].split(tokenSeparator);
          }
     return output;
     }

/** The function that should replace the previous one.
	It uses the global variables of separator.
*/
function cvsToArray(inputCSV)
     {
     var inputLines = inputCSV.split(blockSeparator);
     var output = new Array(inputLines.length);
     for(var i=0; i < inputLines.length ; i++)
          {
          output[i] = inputLines[i].split(tokenSeparator);
          }
     return output;
     }

/**
  displayChart()
  */
 function DisplayChart(chartTitle, serieTitle, valueArray, defpos)
          {
          if(isTimeSeries(valueArray))
	          {
	          displayLineChart(chartTitle, serieTitle, getJsArray(valueArray, defpos));
	          }
          else
	          {
	          displayBarChart(chartTitle, serieTitle, getJsArray(valueArray, defpos));
	          }
          }

  /**
  displayLineChart() is the new function that displays a line chart of the JsArray given as a string
  */
 function displayLineChart(chartTitle, serieTitle, valueArray)
          {
          myText = '<div id="resultChart" style="width:780;height:480"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+chartTitle+'", y_axis_caption: "Value",  x_axis_caption: "Date", x_axis_formatter: new EJSC.DateFormatter({format_string: "YY/MM/DD<br/>HH:NN"}) });\n';
          myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+valueArray+'), { title:"'+serieTitle+'"})\n);\n';
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+chartTitle+'</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=800px,height=500px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }
/**
  displayLineChart() is the new function that displays a Bar chart of the JsArray given as a string
  */
function displayBarChart(chartTitle, serieTitle, valueArray)
          {

          myText = '<div id="resultChart" style="width:780;height:480"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+chartTitle+'", y_axis_caption: "Value",  x_axis_caption: "Id"});\n';
          myText = myText + 'chart.addSeries(new EJSC.BarSeries(\nnew EJSC.ArrayDataHandler('+valueArray+'), { title:"'+serieTitle+'"})\n);\n';
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+chartTitle+'</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=800px,height=500px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }

/**
function isTimeSeries(textValues) detects if 1st column values are dates or not
*/
function isTimeSeries(textValues)
	{

	convertedArray = cvsToArray(textValues,",","@@");
	mytest = false;
	if(  parseInt(convertedArray[0][0].substring(0,4)) > 1900 && parseInt(convertedArray[0][0].substring(0,4)) < 2100 && parseInt(convertedArray[0][0].substring(8,10),10) < 32 && parseInt(convertedArray[0][0].substring(8,10),10) > 0 && (convertedArray.length == 1 || convertedArray[0][0].toString() != convertedArray[1][0].toString()))
		{
		mytest = true;;
		}
			return mytest;
	}

/**
 getJsArray is a function that takes a CSV encoded text values as input and convert it to a string of Javascript values
 columnId is the number of the column that contains the values
 First column must be the X reference values (time / position / whatever)
*/
function getJsArray(inputArray, columnId)
{

	// convert to a javascript table
	var convertedArray = cvsToArray(inputArray,",","@@");
	var outputText="[";
	firstadded=false;
	for(var i=0; i < (convertedArray.length - 1) ; i++)
	{

		if(i >= 500)
		 {
		 break;
	 	}
		// convert the X value to a JavaScript Date


			if(  parseInt(convertedArray[0][0].substring(0,4)) > 1900 && parseInt(convertedArray[0][0].substring(0,4)) < 2100 && parseInt(convertedArray[0][0].substring(8,10)) < 32 && parseInt(convertedArray[0][0].substring(8,10)) > 0 && (convertedArray.length == 1 || convertedArray[0][0].toString() != convertedArray[1][0].toString()))
		{

			myDate = new Date();
			myDate.setUTCFullYear(convertedArray[i][0].substring(0,4));
			myDate.setUTCMonth(convertedArray[i][0].substring(5,7)-1);
			myDate.setUTCDate(convertedArray[i][0].substring(8,10));
			myDate.setUTCHours(convertedArray[i][0].substring(11,13),convertedArray[i][0].substring(14,16),convertedArray[i][0].substring(17,19));
			// get the Y value
			myCA  = convertedArray[i][columnId-1];
			if(myCA=='noData' || myCA=='NaN')
			{
			// Do not process empty values (add here other null values code)
			}
			else
			{
			 if(i > 0 && firstadded)
			     {
			     outputText = outputText+",";
			     }
			firstadded=true;
			outputText = outputText+'['+(myDate.getTime())+','+myCA+']';
		     }
		 }
	   else
	   {
		  		myCA  = convertedArray[i][columnId-1];
				if(myCA=='noData' || myCA=='NaN')
				{
				// Do not process empty values (add here other null values code)
				}
				else
				{
				 if(i > 0 && firstadded)
				     {
				     outputText = outputText+",";
				     }
				firstadded=true;
				outputText = outputText+'['+i+','+myCA+']';
		     	}
	   }
	}
	outputText = outputText+"]";

	return outputText;

}

/**
Deprecated function to display Line Series
*/
 function chartXPopup(title,mySeries)
          {
          myText = '<div id="resultChart" style="width:780;height:480"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+title+' Chart", y_axis_caption: "Value",  x_axis_caption: "Date", x_axis_formatter: new EJSC.DateFormatter({format_string: "YY/MM/DD<br/>HH:NN"}) });\n';
          myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+mySeries+'), { title:"'+title+' (m)"})\n);\n';
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+title+' Chart</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=800px,height=500px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }
     /**
     Deprecated not used !
     */
      function alarmPopup(title,mySeries,TmySeries)
          {
          myText = '<div id="resultChart" style="width:740;height:400"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+title+' Chart", y_axis_caption: "Value", show_x_axis:false });\n';
          myText = myText + 'chart.addSeries(new EJSC.BarSeries(\nnew EJSC.ArrayDataHandler('+mySeries+'), { title:"'+title+' (m)"})\n);\n';
          if(TmySeries != '[[0,0]]')
          {
          myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+TmySeries+'), { title:"Treshold", color: "rgb(255,0,0)"})\n);\n';
          }
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+title+' Chart</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=760px,height=420px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }
 /**
 Old function used to display BAR chart (deprecated)
 */
 function chartXPopup2(title,mySeries)
          {
          myText = '<div id="resultChart" style="width:780;height:480"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+title+' Chart", y_axis_caption: "Value",  x_axis_caption: "Id"});\n';
          myText = myText + 'chart.addSeries(new EJSC.BarSeries(\nnew EJSC.ArrayDataHandler('+mySeries+'), { title:"'+title+' (m)"})\n);\n';
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+title+' Chart</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=800px,height=500px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }

      function alarmPopup(title,mySeries,TmySeries)
          {
          myText = '<div id="resultChart" style="width:740;height:400"><script type="text/javascript">\n';
          myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+title+' Chart", y_axis_caption: "Value", show_x_axis:false });\n';
          myText = myText + 'chart.addSeries(new EJSC.BarSeries(\nnew EJSC.ArrayDataHandler('+mySeries+'), { title:"'+title+' (m)"})\n);\n';
          if(TmySeries != '[[0,0]]')
          {
          myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+TmySeries+'), { title:"Treshold", color: "rgb(255,0,0)"})\n);\n';
          }
          myText = myText + '</script></div>\n';
          myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+title+' Chart</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n</head>\n<body>\n'+myText+'\n</body>\n</html>';

        popup = window.open('','_blank','width=760px,height=420px,left=220,top=60,toolbar=no,location=no,menubar=no,status=no');
        popup.document.open();
        popup.document.write(myPage);
        popup.document.close();
        if(navigator.appName == "Microsoft Internet Explorer")
        {
        popup.window.location.reload();
        }
        }

function getJsChart(inputArray, title,serietitle, pos)
{
var convertedArray = cvsToArray(inputArray,",","@@");
var outputText="[";
firstadded=false;
tester= "TEst: "
for(var i=0; i < (convertedArray.length - 1) ; i++)
{
if(i >= 500)
 {
 break;
 }

//tester= tester+convertedArray[i][0].substring(0,4)+" - "+convertedArray[i][0].substring(5,7)+" - "+convertedArray[i][0].substring(8,10)+"\n";
myDate = new Date();

myDate.setUTCFullYear(convertedArray[i][0].substring(0,4));
myDate.setUTCMonth(convertedArray[i][0].substring(5,7)-1);
myDate.setUTCDate(convertedArray[i][0].substring(8,10));
myDate.setUTCHours(convertedArray[i][0].substring(11,13),convertedArray[i][0].substring(14,16),convertedArray[i][0].substring(17,19));
//myDate.setUTCFullYear(convertedArray[i][0].substring(0,4),convertedArray[i][0].substring(5,7),convertedArray[i][0].substring(8,10));

myCA  = convertedArray[i][pos-1];
if(myCA=='noData' || myCA=='NaN')
{
// myCA= '0';
}
else
{
 if(i > 0 && firstadded)
     {
     outputText = outputText+",";
     }
firstadded=true;
outputText = outputText+'['+(myDate.getTime())+','+myCA+']';
//-2592000000

     }
}
outputText = outputText+"]";
jsFunction = 'function cvsToArray(inputCSV, cseparator, lseparator)    {   \n  var inputLines = inputCSV.split(lseparator);   \n  var output = new Array(inputLines.length);    \n for(var i=0; i < inputLines.length ; i++)    \n      {       \n   output[i] = inputLines[i].split(cseparator);      \n    }    return output;     }';
myText = "";
myText = myText + '<div id="resultChart" style="width:740;height:400"><script type="text/javascript">\n';
/* I COMMENT THIS ZONE BECAUSE USELESS
myText = myText + 'var convertedArray = cvsToArray("'+inputArray+'",",","&amp;&amp;");\n';
myText = myText + 'var chartArray = new Array(convertedArray.length);\n';
myText = myText + 'var outputText="[";'
myText = myText + 'for(var i=0; i < convertedArray.length ; i++)\n';
myText = myText + '          {';
myText = myText + '         var simpleArray = new Array(2);\n';
myText = myText + '          chartArray[i] = simpleArray;\n';
myText = myText + '          chartArray[i][0] = i;';
myText = myText + '          outputText = outputText+"["+i+","+i+"]";';
myText = myText + '          if(i < convertedArray.length - 1) { outputText = outputText+",";';
myText = myText + '    //      chartArray[i][1] = convertedArray[i][1];\n';
myText = myText + '          chartArray[i][1] = i;\n';
myText = myText + '          }\n';
myText = myText + '          outputText = outputText+"]";\n';
 END OF COMMENTING
 */
myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "'+title+'", y_axis_caption: "Value", x_axis_caption: "Date", x_axis_formatter: new EJSC.DateFormatter({format_string: "YY/MM/DD<br/>HH:NN"}) });\n';
myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+outputText+'), { title:"'+serietitle+'"})\n);\n';
myText = myText + '</script></div>';
myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>'+title+'</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n<script language="JavaScript">'+jsFunction+'</script></head>\n<body>\n'+myText+'\n</body>\n</html>';
return myPage;
}

function getJsHeader()
{
jsFunction = 'function cvsToArray(inputCSV, cseparator, lseparator)    {   \n  var inputLines = inputCSV.split(lseparator);   \n  var output = new Array(inputLines.length);    \n for(var i=0; i < inputLines.length ; i++)    \n      {       \n   output[i] = inputLines[i].split(cseparator);      \n    }    return output;     }';
myText = "";
myText = myText + '<div id="resultChart" style="width:740;height:400"><script type="text/javascript">\n';
myText = myText + 'var chart= new EJSC.Chart("resultChart", { title: "Result Chart", y_axis_caption: "Value", x_axis_caption: "Date", x_axis_formatter: new EJSC.DateFormatter({format_string: "YY/MM/DD-HH:NN"}) });\n';
myPage = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>Result Chart</title><script language="JavaScript" src="../../html/js/EJSChart/EJSChart.js"></script>\n<script language="JavaScript">'+jsFunction+'</script></head>\n<body>\n'+myText;
return myPage;
}

function getJsFooter()
{
myText = "";
myText = myText + '</script></div>';
myPage = myText+'\n</body>\n</html>';
return myPage;
}


function getJsSeries(inputArray, title, pos)
{
var convertedArray = cvsToArray(inputArray,",","@@");
var outputText="[";
for(var i=0; i < (convertedArray.length - 1) ; i++)
{
myDate = new Date(convertedArray[i][0].substring(0,4),convertedArray[i][0].substring(5,7),convertedArray[i][0].substring(8,10),convertedArray[i][0].substring(11,13),convertedArray[i][0].substring(14,16),convertedArray[i][0].substring(17,19));

myCA  = convertedArray[i][pos-1];
if(myCA=='noData' || myCA=='NaN')
{
// old version myCA= '0';
}
else
{
outputText = outputText+'['+myDate.getTime()+','+myCA+']';
if(i < (convertedArray.length - 2)) {
     outputText = outputText+",";
     }}
}
outputText = outputText+"]";
myText = "";
myText = myText + 'chart.addSeries(new EJSC.LineSeries(\nnew EJSC.ArrayDataHandler('+outputText+'), { title:"'+title+'"}));\n';
return myText;
}

function getMin(inputArray, title, pos)
{
var convertedArray = cvsToArray(inputArray,",","@@");
var outputText="[";
var min = 999999999;
for(var i=0; i < (convertedArray.length - 1) ; i++)
{
myCA  = convertedArray[i][pos-1];
if(myCA=='noData' || myCA=='NaN')
{
// old version myCA= '0';
}
else
{
	if(min >= parseFloat(myCA)){
		min = parseFloat(myCA);
	}
outputText = outputText+'['+myCA+']';
if(i < (convertedArray.length - 2)) {
     outputText = outputText+",";
     }}
	}
outputText = outputText+"]";
myText = "";
myText = myText + outputText;
return min;
}

function getMax(inputArray, title, pos)
{
var convertedArray = cvsToArray(inputArray,",","@@");
var outputText="[";
var max = -999999999;
for(var i=0; i < (convertedArray.length - 1) ; i++)
{
myCA  = convertedArray[i][pos-1];
if(myCA=='noData' || myCA=='NaN')
{
// old version myCA= '0';
}
else
{
	if(max <= parseFloat(myCA)){
		max = parseFloat(myCA);
	}
outputText = outputText+'['+myCA+']';
if(i < (convertedArray.length - 2)) {
     outputText = outputText+",";
     }}
}
outputText = outputText+"]";
myText = "";
myText = myText + outputText;
return max;
}


function selectDiv(selected, container)
{
  var panel = document.getElementById(container);

  if(panel == null) {return false;}
  var children = panel.childNodes;
  for(var i = 0; i < children.length; i++)
  {
    var child = children[i];

    if (child.id == selected)
    {
            child.style.display = "block";
    }
    else if (child.id != null) {
      child.style.display = "none";
    }
  }
}
function todayDate()
{
     var currentDate = new Date();
     var month = currentDate.getMonth() + 1;
     if (month <= 9) {
            month = "0" + month;
     }
     var day = currentDate.getDate();
     if (day <= 9) {
         day = "0" + day;
     }
     return currentDate.getFullYear() + '-' + month + '-' + day;
}

/**
 This function return the TimeZoneOffset in a string format.<b>
 Ths possible returned values are "-01","+00", "+01", "+10", "-10" , etc.
*/
 function getGMT()
            {
                       myDate = Date();
                       myDate = new Date();
 	    			   myGMT = (myDate.getTimezoneOffset() / -60);

 	    			   myfinalGMT= "";
 	    			   if(myGMT < 0 && myGMT > -10)
 	    			   {
 	    			   myfinalGMT = "\-0"+(myGMT/-1);
 	    			   }
 	    			   if(myGMT >= 0 && myGMT < 10)
 	    			   {

 	    			   myfinalGMT = "+0"+ myGMT.toString();
 	    			   }
 	    			   if(myGMT > 9)
 	    			   {
 	    			   myfinalGMT = "\+"+myGMT.toString();
 	    			   }
 	    			   if(myGMT < -9)
 	    			   {
                        myfinalGMT = myGMT.toString();
	                             }

	         return myfinalGMT.toString();
	         }

/**
panelFunctions by ACL
*/


function panelRefreshC (container,selected)
{

  var panel = document.getElementById(container);

  if(panel == null) {return false;}
  var children = panel.childNodes;

  for(var i = 0; i < children.length; i++)
  {
    var child = children[i];

    if (child.id == container)
    {
      var titles = child.childNodes;
        for(var j = 0; j < titles.length; j++)
        {
          title = titles[j];
          if(title.id == "title_" + selected)
          {
            title.className = "selected";
          }
          else if (title.id != null)
          {
            title.className = "";
          }

        }
    }
    else if (child.id == selected)
    {
      child.style.display = "block";
    }
    else if (child.id != null)
    {
      child.style.display = "none";
    }
  }
}



/**
panelFunctions by ACL
*/


function panelRefresh (selected)
{

  var panel = document.getElementById("tabPanel");

  if(panel == null) {return false;}
  var children = panel.childNodes;

  for(var i = 0; i < children.length; i++)
  {
    var child = children[i];

    if (child.id == "tabTitle")
    {
      var titles = child.childNodes;
        for(var j = 0; j < titles.length; j++)
        {
          title = titles[j];
          if(title.id == "title_" + selected)
          {
            title.className = "selected";
          }
          else if (title.id != null)
          {
            title.className = "";
          }

        }
    }
    else if (child.id == selected)
    {
      child.style.display = "block";
    }
    else if (child.id != null)
    {
      child.style.display = "none";
    }
  }
}

/**
End of Javascript
*/