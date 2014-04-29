var myOriginalOptions;
var myOriginalBuffer;

function checkListValueIn(listValueCSV, listValueToCheckCSV) {
	
	var listValue = listValueCSV.split(",");
	var listValueCheckTo = listValueToCheckCSV.split(",");
	var found = false;
	for(var i=0; i<listValue.length && found == false; i++) {
		
		var valueCheck = StringUtil.trim(listValue[i]);		
		if(valueCheck.length > 0) {
			
			for(var j=0;j<listValueCheckTo.length && found == false;j++) {
			
				var valueCheckTo = StringUtil.trim(listValueCheckTo[j]);
				if (valueCheck == valueCheckTo) {
					found = true;
				}
			}
		}
	}
	
	return found;
}

function addOptionToBuffer(classicOption, tabId, optionBuffer) {

	var newId = "option_" + tabId + "__" + classicOption.id;
	var li = document.createElement("li");
	li.id = newId;
	var newOption = classicOption.cloneNode(true);
	newOption.id = tabId + "__" + newOption.id;
	li.appendChild(newOption);
	optionBuffer.appendChild(li);
}

function initializeOptionBuffer(classicOptions, tabId, optionBuffer) {
	for (var i = 0; i < classicOptions.length; i++) {
		
		var classicOption = classicOptions[i];
		if (classicOption.id != "") {

			//var mandatory 		= classicOption.getAttribute("mandatory");
			var queryableType 	= classicOption.getAttribute("queryableType")
			var exception 		= classicOption.getAttribute("exception");
			
			if (exception != null
				&& checkListValueIn(exception, tabId) == true) {
				addOptionToBuffer(classicOption, tabId, optionBuffer);
      		} else if(queryableType != null 
				&& checkListValueIn(queryableType, "common, " + tabId) == true) {
				addOptionToBuffer(classicOption, tabId, optionBuffer);
      		} 
		}
	}
}

function copyStandartsOptions ()
{
	var classic = document.getElementById("classic");
	var classicOptions;

	if (classic == null) {
		return (false);
	} else {
		classicOptions = classic.childNodes;
	}

	for (var i = 0; i < arrayBuffer.length; i++){
		var optionBuff = document.getElementById(arrayBuffer[i]);
		if (optionBuff != null) {
			initializeOptionBuffer(classicOptions, arrayTabId[i], optionBuff);
		}
	}
}


function removeAllOptions() {

	for (var i = 0; i < arrayBuffer.length; i++) {
		
		var optionBuffer = document.getElementById(arrayBuffer[i]);		
		if (optionBuffer != null) {			
			var options = optionBuffer.childNodes;			
			for (var j = 0; j < options.length; j++) {
				var option = options[j];
				if (option.id != null) {					
				   removeOptionSelect(option.id);
				}
			}
		}
	}
}


function optionValueIndexOf(options,value) {
	for (var i=0;i<options.length;i++) {
		if (options[i].value == value) {
		
			return i;
		}
	}
	return -1;
}

/*
add element to a combobox based on buffer
check if tabid in exception -> add it to view
check if tabid in querytable and mandatory = true  -> add it to view 
check if tabid in querytable and mandatory = true  -> add it to combobox
*/
function addElements2ComboBox(optionBuffer, tabId, index, addPanel){
	var options = optionBuffer.childNodes;
	
	
	for (var i = 0; i < options.length; i++){	
	    var option = options[i];
		//alert(option.id);
		
    	if (option.id != null) {
		    
			var	newId = option.id.split("__")[1];
     		var optionP = option.childNodes[0];
			
			var mandatory 		= optionP.getAttribute("mandatory");
			var queryableType 	= optionP.getAttribute("queryableType")
			var exception 		= optionP.getAttribute("exception");
			
			//--- Begin ---//			
			var listValue = queryableType.split(",");				
			if(listValue.length > 1){			
				for (var j = 0; j < listValue.length; j++) {				
					if(StringUtil.trim(listValue[j])==tabId){
					
					}else{
						var optionSelectOpt = document.getElementById(arrayOption[index]);   	
					    var element = document.createElement("option");						
						element.appendChild(document.createTextNode("--- "+queryableType.toUpperCase()+" ---"));
						element.value = "option_Separat4"+queryableType;
						if( optionValueIndexOf(optionSelectOpt,element.value) < 0 ){
							optionSelectOpt.appendChild(element);
						}						
					}
				}				
			}						
			//--- End ---//
			
			if (exception != null
				&& checkListValueIn(exception, tabId) == true) {
				
				addOption4AllTab(option.id,index,addPanel);
				i--;
      		} else if(queryableType != null 
				&& checkListValueIn(queryableType, "common, " + tabId) == true) {
				
				if (mandatory != null && mandatory == "true") {
					addOption4AllTab(option.id,index,addPanel);
					i--;
	      		} else { 
					addOption4Select(newId, tabId, index);
	      		}
      		} 
    	}     		 
	}

}

function initOptionSelect() {
	myOriginalOptions = new Array(arrayOption.length); // qth edit
	myOriginalBuffer = new Array(arrayOption.length); // qth edit
	
	removeAllOptions();
	copyStandartsOptions ();

	for (var i = 0; i < arrayBuffer.length; i++){
		var optionBuff = document.getElementById(arrayBuffer[i]);
		if (optionBuff != null) {
			addElements2ComboBox(optionBuff, arrayTabId[i], i, true);
			
			myOriginalOptions[i] = document.createElement("select");
			myOriginalBuffer[i] = document.createElement("ul");
			
			swapBuffer(document.getElementById(arrayOption[i]),myOriginalOptions[i]);						
			swapBuffer(optionBuff,myOriginalBuffer[i]);						
		}
	}
		
}

function  addOption4Select (optionId, type, index){
	
	var optionSelectOpt = document.getElementById(arrayOption[index]);   	
	var option = document.getElementById("option_"+arrayTabId[index]+"__" + optionId);
	
	if ( optionSelectOpt == null || option == null ){	
	    return (false);
	}else{ 	
		
	    var optionContents = option.childNodes;		
	    for ( i = 0; i < optionContents.length; i++ )
	    {
			var optionContent = optionContents[i];

			if(optionContent.tagName == "P")
			{
				var optionText = "";
				for (var j=0; j<optionContent.childNodes.length; j++)
				{
					var nodeContent = optionContent.childNodes[j];
					if(nodeContent.nodeType == 1 && nodeContent.tagName == "LABEL") 
					{
						var optionText = nodeContent.childNodes[0].nodeValue;
						break;
					}
				}

				if (optionText == "") 
				{
					optionText = optionContent.childNodes[0].nodeValue;
				}
				break;
			}
	    }
	    var element = document.createElement("option");
	    element.appendChild(document.createTextNode(optionText));
		element.value = "option_"+arrayTabId[index]+"__" + optionId;
		
	    optionSelectOpt.appendChild(element);
		
	}
}

function removeOption4AllTab (optionId, type, index)
{ 
	var option = document.getElementById(optionId);
	var optionsBuffer = document.getElementById(arrayBuffer[index]);
	
	if (option == null || optionsBuffer == null) {
		return (false);
	}

	var optionContents = option.childNodes;

	for (var i = 0; i < optionContents.length; i++)
	{
		
		var optionContent = optionContents[i];		
		if ( optionContent.tagName == "SPAN" && optionContent.name == "removeButton") {	  			
			removeElement(optionContent);
		}
	}

	
	
	var li = document.createElement ("li");
	if(optionId.indexOf("__") > -1){
		optionId=optionId.split("__")[1];
	}
	
	li.id = "option_"+arrayTabId[index]+"__" + optionId;
	li.appendChild(option);
	
	optionsBuffer.appendChild(li);  
	addOption4Select(optionId, type, index);
	
	//---------------------------------------
	//-- Use to reInit Buffer and Combox 
	//---------------------------------------
	
	//create a temp buffer contain the original Parameter
	var optionsBufferTemp = document.createElement ("ul");
	swapBuffer(myOriginalBuffer[index],optionsBufferTemp);
	
	//get the parameter use in panel 
	var redundancyNodes = new Array();
	redundancyNodes = getUsedNodesInPanel(optionsBufferTemp,optionsBuffer);
	
	//reSet the buffer and the Combox
	setOriginalValueToBuffer(optionsBufferTemp,optionsBuffer,index);			
	reInitalizeCombox(redundancyNodes,optionsBuffer,index)
	
			
}


function addOption4AllTab (mandatoryId, index, addPanel) {  
	
	var selectedOption = "";
	if(mandatoryId != undefined) {  
		selectedOption = mandatoryId;  
	} else {
		var selected;		
		selected = document.getElementById (arrayOption[index]);    
		selectedOption = selected.value;
	}
    
  if (selectedOption == "") {return (false);}
  
  var panel = document.getElementById(arrayTabId[index]);
  
  var option = document.getElementById(selectedOption);
  var options = option.childNodes;

  for (var i = 0; i < options.length; i++)
  {
    if (options[i].nodeType == 1 /* == Node.ELEMENT_NODE*/ )
    {
      var optionToAdd = options[i];
      break;
    }
  
  }
  optionToAdd.id = arrayTabId[index] +"__" + selectedOption.split("__")[1];
  
  if(mandatoryId == undefined)
  {
    var remove = document.createElement("span");    
    remove.appendChild(document.createTextNode("[X]"));
    remove.name = "removeButton";
    remove.className = "removeButton";    	
	remove.onclick = function() {removeOption4AllTab(this.parentNode.id, arrayTabId[index], index)};	
    optionToAdd.appendChild(remove);  
  } 
  else 
  {
    var remove = document.createElement("span");
    remove.appendChild(document.createTextNode(""));
    remove.name = "removeButton";
    remove.className = "removeButton";	
	//remove.onclick = function() {removeOption4AllTab(this.parentNode.id,type)};    
    optionToAdd.appendChild(remove);   
  }
  if(addPanel == true){
	panel.appendChild(optionToAdd);  
  }
  removeElement(option);  
  removeOptionSelect(selectedOption);     
  
}

function getTargetValidation() {
	var panel = document.getElementById("tabPanel");
	if(panel == null) {
		return null;
	}
	
	for(var i=0;i<arrayTabId.length;i++) {
		
		var tabId = arrayTabId[i];
		var titleTabId = "title_" + tabId;
		var titleElement = document.getElementById(titleTabId);
		
		if (titleElement != null && titleElement.className == "selected") {
			var target = document.getElementById(tabId);
			return target;
		}
	}
	
	return null;
}

function addTargetUsedParametersField(element) {
	
	if (element.tagName == "P" && element.id != null) {

		var childIds = new Array();
		var childs = element.childNodes;
		var type = element.getAttribute("type");
		var notNull = element.getAttribute("notNull");

		if (notNull == null) {
			notNull =  false;
		}

		for (var j = 0; j < childs.length; j++) {
			var child = childs[j];
			if (
				(child.tagName == "INPUT" || child.tagName == "SELECT") 
				&& child.id != null && child.id != "optionSelect"
				&& child.value != null
			   ) {

				if (child.value != "" || notNull == "true") {
					childIds.push(addUsedParametersField (child.id, child.value));
				}
			}
		}

		/* TODO move this code to a specialised function */
		if (type == "percentage") {
			for (var k = 0; k < childIds.length; k++) {
				element.setAttribute("check", "javascript:checkPercentage('" + childIds[k] + "', " + notNull + ");");
			}
		}

		if (type == "positiveInteger") {
			for (var k = 0; k < childIds.length; k++) {
				element.setAttribute("check", "javascript:checkPositiveInteger('" + childIds[k] + "', " + notNull + ");");
			}
		}

		if (type == "positiveReal") {
			for (var k = 0; k < childIds.length; k++) {
				element.setAttribute("check", "javascript:checkPositiveReal('" + childIds[k] + "', " + notNull + ");");
			}
		}
	}
}

function initValidation() {
	var target = getTargetValidation();
	if(target != null) {
		
		removeAllChilds(document.getElementById("usedParameters"));
		elements = target.childNodes;

		for (var i = 0; i < elements.length; i++) {
			addTargetUsedParametersField(elements[i]);
		}
	} else {
		return (false);
	}
}

function choiceSelectChange(comboboxObject, tabIndex) {
	
	addOption4AllTab(undefined, tabIndex, true);
}




function swapBuffer(bufferSource,bufferDestination){
	var childNodes = bufferSource.childNodes;
		
	for (var j = 0; j < childNodes.length; j++){			
		newOption = childNodes[j].cloneNode(true);		  		
		bufferDestination.appendChild(newOption);			
	}
}

function getUsedNodesInPanel(optionsBufferTemp,optionsBuffer){
	var bufferTempChildNodes = optionsBufferTemp.childNodes;
	var redundancyNodes = new Array();
	var idx=0;
			
	for (var i = 0; i < bufferTempChildNodes.length; i++){
	
		var optionsBufferChildNodes = optionsBuffer.childNodes;
		var j=0;
		var exist=false;
		for ( j=0; j < optionsBufferChildNodes.length; j++){
			if(optionsBufferChildNodes[j].id==bufferTempChildNodes[i].id){				
				exist=true;
				break;				
			}		
		}  
		
		//get the parameters use in the panel
		if( j >=optionsBufferChildNodes.length && exist == false ){						
			redundancyNodes[idx]=bufferTempChildNodes[i].id;
			idx++;			
		}
	}
	return redundancyNodes;
}


function reInitalizeCombox(redundancyNodes,optionsBuffer,index){

	var optionSelect = document.getElementById(arrayOption[index]);   	
	var element = document.createElement("option");						
	//element.appendChild(document.createTextNode("Make your choice"));
	//optionSelect.appendChild(element);
	
	//set the option to original value
	swapBuffer(myOriginalOptions[index],document.getElementById(arrayOption[index]));
	
	var optionChilds = document.getElementById(arrayOption[index]).childNodes;
	var bufferChilds =  optionsBuffer.childNodes;
	
	for (var i = 0; i < redundancyNodes.length; i++){
		//remove the parameter in the panel out of the option
		for (var j = 0; j < optionChilds.length; j++){
				if(optionChilds[j].value == redundancyNodes[i]){
					document.getElementById(arrayOption[index]).removeChild(optionChilds[j]);
				}
				
		}
		
		//remove the parameter in the panel out of the buffer
		for (var f = 0; f < bufferChilds.length; f++){
				if(bufferChilds[f].id == redundancyNodes[i]){
					optionsBuffer.removeChild(bufferChilds[f]);
				}				
		}
	}

}

function setOriginalValueToBuffer(bufferOriginal,bufferDestination,index){
	removeAllChilds(bufferDestination);			
	removeAllChilds(document.getElementById(arrayOption[index]));
	swapBuffer(bufferOriginal,bufferDestination);
}

function setMaxOccurPages(ObjectOccurPages,currentNumber){
	if( currentNumber >=  ObjectOccurPages.value ){
		ObjectOccurPages.value = currentNumber;
	}

}