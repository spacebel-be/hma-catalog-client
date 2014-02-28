/* This file contains a snumber of javascript which are available inside all mass pages.
   They are included from the mass template.
   They can be sued inside stylesheet to avoid the problem with characters such as <, >, &....
*/

/* add breadcrumb at top of page */
function addBreadCrumb(html)
{
  var path = document.getElementById("breadCrumb");
  if (path != null) {
	path.innerHTML = html;
  }
}

/*
 * add infocenter link at top of page @param path the jsp path @param
 * linkMessage the message for the link
 */
function addInfoCenter(servletPath, contextPath, linkMessage)
{
	// create the mapping tab between the infocenter pages and the portal pages
	var mapping = new Array();
	
	// mapping for the home page
	mapping["MyHomePage.jsp"]="134.htm";
	
	// mapping for the user registration page
	mapping["UserRegistrationUI.jsp"]="131.htm";
	
	// mapping for the user agreement page
	mapping["UserAgreement.jsp"]="159.htm";
	
	// mapping for user registration confirmation page
	mapping["UserRegistrationConfirmUI.jsp"]="161.htm";
	
	// mapping for user login page
	mapping["UserLoginFormUI.jsp"]="133.htm";
	
	// mapping for user update page
	mapping["UserUpdateUI.jsp"]="130.htm";
	
	// mapping for the order info page (for an anonymous user)
	mapping["OrderIdUI.jsp"]="104.htm";
	
	// mapping for order list page (for a registered user)
	mapping["OrderListUI.jsp"]="106.htm";
	
	// mapping for the order info page (informations about the order)
	mapping["OrderInfoUI.jsp"]="102.htm";
	
	// mapping for service category directory page
	mapping["ServiceCategoryDirectoryUI.jsp"]="118.htm";
	
	// mapping for company category directory page
	mapping["CompanyCategoryDirectoryUI.jsp"]="117.htm";
	
	// mapping for the search page (search in a catalogue)
	mapping["SearchProcessUI.jsp"]="138.htm";
	
	// mapping for the service registration page
	mapping["ServiceRegistrationUI.jsp"]="120.htm";
	
	// mapping for the AOI configuration page
	mapping["DisplayAOIConfigUI.jsp"]="120.htm";
	
	// mapping for the advance search page
	mapping["AdvancedSearchUI.jsp"]="111.htm";
	
	// mapping for the about us page
	mapping["AboutUsUI.jsp"]="121.htm";
	
	// mapping for the company directory page
	mapping["CompanyDirectoryUI.jsp"]="115.htm";
	
	// mapping for company info page
	mapping["CompanyInfoUI.jsp"]="113.htm";
	
	// mapping for the service directory page
	mapping["ServiceDirectoryUI.jsp"]="116.htm";
	
	// mapping for service detailed info page
	mapping["ServiceDetailedInfoUI.jsp"]="114.htm";

	// mapping for the order preparation page (order a service)
	mapping["OrderPreparationUI.jsp"]="109.htm";
	
	// mapping for the service order confirmation page
	mapping["OrderConfirmationUI.jsp"]="108.htm";

	// mapping for the order report page
	mapping["OrderReportUI.jsp"]="146.htm";
	
	// mapping for the shopping basket page
	mapping["ShoppingBasketUI.jsp"]="147.htm";
	
	// mapping for service rating page
	mapping["ServiceRatingUI.jsp"]="112.htm";
	
	// mapping for transforming error page
	mapping["TransformingErrorPageUI.jsp"]="2.htm";

	// mapping for contact us page
	mapping["FeedbackUI.jsp"]="124.htm";
	
	// mapping for documents page
	mapping["HelpUI.jsp"]="123.htm";
	
	// mapping for news item list page
	mapping["NewsItemListUI.jsp"]="126.htm";
	
	// mapping for news item content page
	mapping["NewsItemContentUI.jsp"]="125.htm";
	
	// mapping for service provider agreement page
	mapping["ServiceProviderAgreement.jsp"]="158.htm";
	
	// mapping for apply to be service provider confirmation page
	mapping["ApplyToBeServiceProviderUI.jsp"]="157.htm";
	
	// mapping for user feedback page
	mapping["UserFeedbackUI.jsp"]="160.htm";
	
	// mapping for company registration page
	mapping["CompanyRegistrationUI.jsp"]="128.htm";
	
	// mapping for service provider update page
	mapping["ServiceProviderUpdateUI.jsp"]="129.htm";
	
	// mapping for forgot password result page
	mapping["ForgotPasswordResultUI.jsp"]="132.htm";
	
	// mapping for forgot password page
	mapping["ForgotPasswordUI.jsp"]="132.htm";
	
	// mapping for user unregistration page
	mapping["UserUnregistrationUI.jsp"]="127.htm";
	
	// mapping for user unregistration error page
	mapping["UnregisterErrorUI.jsp"]="162.htm";
	
	// mapping for download page
	mapping["DownloadUtil.jsp"]="122.htm";
	
	// mapping for the list of service granting for a register user
	mapping["ListServiceGrantingInfoForRUUI.jsp"]="149.htm";
	
	// mapping for the list of service granting for a service provider
	mapping["ListServiceGrantingInfoForSPUI.jsp"]="176.htm";
	
	// mapping for portal success page (when a service is well created or well
	// updated)
	mapping["Portal_SuccessPageUI.jsp"]="150.htm";
	
	// mapping for disclaimer page
	mapping["Disclaimer.jsp"]="153.htm";
	
	// mapping for the portal error page
	mapping["ErrorPageUI.jsp"]="154.htm";

	// mapping for the privacy policy page
	mapping["PrivacyPolicy.jsp"]="155.htm";
	
	// mapping for the search page
	mapping["SearchUI.jsp"]="156.htm";
	
	// mapping for order registration suggestion page
	mapping["OrderRegistrationSuggestionUI.jsp"]="163.htm";
	
	// mapping for order checkout result page
	mapping["OrderCheckoutResultUI.jsp"]="107.htm";
	
	// mapping for the order detailed information page
	mapping["OrderDetailedInfoUI.jsp"]="105.htm";
	
	// mapping for the order result info page
	mapping["OrderResultInfoUI.jsp"]="103.htm";
	
	// mapping for dds basic request access confirmation
	mapping["RequestAccessUserWarningUI.jsp"]="143.htm";
	
	// mapping for service granting information page
	mapping["ServiceGrantingInfoOfServiceUI.jsp"]="176.htm";
	
	// mapping for the interface selection service registration page
	mapping["ServiceRegistrationWizardInterfaceUI.jsp"]="179.htm";
	
	// mapping for the operation config service registration page
	mapping["ServiceRegistrationWizardOperationUI.jsp"]="180.htm";
	
	// mapping for the AOI config service registration page
	mapping["DisplayAOIConfigUI.jsp"]="181.htm";
	
	// mapping for the common service registration page
	mapping["ServiceRegistrationWizardCommonUI.jsp"]="182.htm";
	
	// mapping for the publication service registration page
	mapping["ServiceRegistrationWizardPublicationUI.jsp"]="183.htm";
	
	// mapping for service update page
	mapping["ServiceUpdateUI.jsp"]="119.htm";
	
	// mapping for service quotation page
	mapping["ServiceQuotationUI.jsp"]="164.htm";
	
	// mapping for the RFQ confirmation page
	mapping["RFQConfirmationUI.jsp"]="165.htm";
	
	// mapping for the RFQ checkout result page
	mapping["RFQCheckoutResultUI.jsp"]="166.htm";

	
	// get the portal page from the path to know where to go in the infocenter
	// first we split the path into a table which contains all elements(without
	// the / symbol) of the path
	var pathElements = new Array();
	pathElements = servletPath.split("/");
	
	// we take the last element in the table corresponding to the jsp name
	var portalPage = pathElements[(pathElements.length)- 1];
	
	// take the infocenter page corresponding to the portal page
	var infoCenterPage;
	infoCenterPage = mapping[portalPage];
	
	// add the link to the infocenter
	var path = document.getElementById("infoCenter");
	if(infoCenterPage != undefined) {
		path.innerHTML = "<a href='"+ contextPath + "/infocenter/?topic=/be.spacebel.sse.doc.user/content/page"+ infoCenterPage + "' target='_blank'>" + linkMessage + "</a>";
	} else {
		path.innerHTML = "<a href='"+ contextPath + "/infocenter/' target='_blank'>" + linkMessage + "</a>";
	}
	
}


/* compare a number = input to a second number introduced as string */
function isShorter(input, compared) {
        var comparedNum = parseInt(compared);
        if(comparedNum > input) {
            return true;
        } else {
            return false;
        }
    }



/* Check if a number is less than another number */
function isLessThanNumber(number, comparedNumber) {
    // Compare two numbers
    if (number < comparedNumber) {
        return true;
    } else {
        return false;
    }
}

/* Check if a number is less than or equal to another number */
function isLessThanOrEqualToNumber(number, comparedNumber) {
    // Compare two numbers
    if (number <= comparedNumber) {
        return true;
    } else {
        return false;
    }
}

/* Check if a number is greater than another number */
function isGreaterThanNumber(number, comparedNumber) {
    // Compare two numbers
    if (number > comparedNumber) {
        return true;
    } else {
        return false;
    }
}

/* Check if a number is greater than or equal to another number */
function isGreaterThanOrEqualToNumber(number, comparedNumber) {
    // Compare two numbers
    if (number >= comparedNumber) {
        return true;
    } else {
        return false;
    }
}

/* Get the current date in format of CCYY-MM-DD */
function getCurrentDate() {
    var currentDate = new Date();
    var date = currentDate.getDate();
    var month = currentDate.getMonth() + 1;

    if (date <= 9) {
        date = "0" + date;
    }

    if (month <= 9) {
        month = "0" + month;
    }

    var currentDateStr = currentDate.getFullYear() + "-" + month + "-" + date;
    return currentDateStr;
}

/*
 * Get the current date and time in format of CCYY-MM-DDThh:mm:ss 'T' is the
 * date/time separator.
 */
function getCurrentDateTime() {
    var currentDate = new Date();
    var date = currentDate.getDate();
    var month = currentDate.getMonth() + 1;
    var hour = currentDate.getHours();
    var minute = currentDate.getMinutes();
    var second = currentDate.getSeconds();

    if (date <= 9) {
        date = "0" + date;
    }

    if (month <= 9) {
        month = "0" + month;
    }

    if (hour <= 9) {
        hour = "0" + hour;
    }

    if (minute <= 9) {
        minute = "0" + minute;
    }

    if (second <= 9) {
        second = "0" + second;
    }

    /* 'T' is the date/time separator */
    var currentDateTimeStr = currentDate.getFullYear() + "-" + month + "-" + date +
                         "T" + hour + ":" + minute + ":" + second;

    return currentDateTimeStr;
}

/* Check if a string is empty */
function checkEmptyString(str) {
    var index;

    if (str.length < 1) {
        return true;
    }

    for (index=0; index < str.length; index++) {
        if (str.charAt(index) != ' ') {
            return false;
        }
    }
    return true;
}

/* Check if a character belongs to a string */
function belongToStr(c, str) {
    for (var i = 0; i < str.length; i++) {
        if (c == str.charAt(i)) {
            return true;
        }
    }
    return false;
}

/* Check if a string is a numerical string */
function isNumericalString(str) {
    var numStr = "0123456789.,";

    // Check if the string is empty
    if (checkEmptyString(str)) {
        return false;
    }

    // Check if all the characters of the string are numerical character
    for (var i = 0; i < str.length; i++){
        var c = str.charAt(i);
        if (!belongToStr(c, numStr)) {
            return false;
        } else {
            if ( ( (i == 0) || (i == str.length - 1) ) &&
                 ( (c == '.') || (c == ',') )  ) {
                return false;
            }
        }
    }

    return true;
}

/*
 * Check if a number contained in a numerical string is less than another
 * integer number
 */
function isLessThanIntegerStr(intStr, comparedIntStr) {
    var intNum = parseInt(intStr);
    var comparedIntNum = parseInt(comparedIntStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(intStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (intNum < comparedIntNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is less than or equal to
 * another integer number
 */
function isLessThanOrEqualToIntegerStr(intStr, comparedIntStr) {
    var intNum = parseInt(intStr);
    var comparedIntNum = parseInt(comparedIntStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(intStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (intNum <= comparedIntNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is greater than another
 * integer number
 */
function isGreaterThanIntegerStr(intStr, comparedIntStr) {
    var intNum = parseInt(intStr);
    var comparedIntNum = parseInt(comparedIntStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(intStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (intNum > comparedIntNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is greater than or equal to
 * another integer number
 */
function isGreaterThanOrEqualToIntegerStr(intStr, comparedIntStr) {
    var intNum = parseInt(intStr);
    var comparedIntNum = parseInt(comparedIntStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(intStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (intNum >= comparedIntNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is less than another float
 * number
 */
function isLessThanFloatStr(floatStr, comparedFloatStr) {
    var floatNum = parseFloat(floatStr);
    var comparedFloatNum = parseFloat(comparedFloatStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(floatStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (floatNum < comparedFloatNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is less than or equal to
 * another float number
 */
function isLessThanOrEqualToFloatStr(floatStr, comparedFloatStr) {
    var floatNum = parseFloat(floatStr);
    var comparedFloatNum = parseFloat(comparedFloatStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(floatStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (floatNum <= comparedFloatNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is greater than another
 * float number
 */
function isGreaterThanFloatStr(floatStr, comparedFloatStr) {
    var floatNum = parseFloat(floatStr);
    var comparedFloatNum = parseFloat(comparedFloatStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(floatStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (floatNum > comparedFloatNum) {
        return true;
    } else {
        return false;
    }
}

/*
 * Check if a number contained in a numerical string is greater than or equal to
 * another float number
 */
function isGreaterThanOrEqualToFloatStr(floatStr, comparedFloatStr) {
    var floatNum = parseFloat(floatStr);
    var comparedFloatNum = parseFloat(comparedFloatStr);

    // Check if the original string is in numerical format
    if (!isNumericalString(floatStr)) {
        return false;
    }

    // Compare two numbers parsed from two strings
    if (floatNum >= comparedFloatNum) {
        return true;
    } else {
        return false;
    }
}

/* Check if a string is greater than another one */
function isGreaterThanOrEqualToString(str, comparedStr) {
    // Compare two strings
    if (str >= comparedStr) {
        return true;
    } else {
        return false;
    }
}
/*
 * check if the number of selected options > to the comparedNumber field is
 * assumed to be html option field in
 */
function checkNumberOfSelectedOptionsGT(field,comparedNumber)
{
  var count = 0;
  for (i=0; i < field.length; i++)
      if (field[i].selected ==true) count++;

  if (count > comparedNumber)
       return true;
  else
       return false;
}

/* Abstract function used to check all mandatory fields of a form */
function checkMandatoryFields(frm) {
    return true;
}
/**
 * Check that a date is valid : isDate(strDay,strMonth,strYear) strDay : string
 * "01" "02".. strMonth : string "01" "02".. strYear : string "1901"... DHTML
 * date validation script. Courtesy of SmartWebby.com
 * (http://www.smartwebby.com/dhtml/)
 */
// Declaring valid date character, minimum year and maximum year

var minYear=1900;
var maxYear=2100;

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   }
   return this
}

function isDate(strDay,strMonth,strYear){


	var daysInMonth = DaysArray(12)

	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)

	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){

		return false
	}

    return true
}
/*
 * set current date assumes that html selection objects are passed as input
 * parameters : year with full values (2004, 2003...), month (01-12), day
 * (01-31) it set the values of these parameters to the current date.
 */
function setCurrentDate(selectYear, selectMonth, selectDay)
{
  var currentDate = new Date();
  selectYear.value  = currentDate.getFullYear();
  var month = currentDate.getMonth() + 1;
  if (month <= 9) {
        month = "0" + month;
  }
  selectMonth.value = month;
  var day = currentDate.getDate();
  if (day <= 9) {
        day = "0" + day;
  }
  selectDay.value   = day;
}

/* Close the news of the day popup window */
function closePopup (itemId)
{
     var obj = document.getElementById(itemId);
     var div = document.getElementById('body');
     div.removeChild(obj);
	document.cookie = "nopopup" + "=" + 1
/* setCookie("nopopup",1); */
}




/* ACL : Common functions to check fields in search page */



function checkPercentage (id, notNull)
{

  var field = document.getElementById (id);
  if(field == null)
  {
    return (false);
  }
  
  var name = field.name;
  
  if(field.value == "")
  {
    if (notNull == true)
    {
      alert(name + " is empty");
      return (false);
    }
    return (true);
  }
  
  if(isNaN(field.value))
  {
    alert(name + " is not a number");
    return (false);
  }
  
  fieldValue = parseFloat(field.value)
  
  if(fieldValue < 0)
  {
    alert(name + " is minus than 0");
    return (false);
  }
  
  if(fieldValue > 100)
  {
    alert(name + " is greater than 100");
    return (false);
  }
  
  return (true);
}


function checkPositiveInteger (id, notNull)
{
  var field = document.getElementById (id);
  if(field.value == null)
  {
    return (false);
  }
  
  var name = field.name;
  
  if(field.value == "")
  {
    if (notNull == true)
    {
      alert(name + " is empty");
      return (false);
    }
    return (true);
  }
  
  if(isNaN(field.value))
  {
    alert(name + " is not a number");
    return (false);
  }
  
  fieldValue = parseInt(field.value)
  
  if(fieldValue < 1)
  {
    alert(name + " is minus than 1");
    return (false);
  }
 
  
  return (true);
}

function checkPositiveReal (id, notNull)
{
  var field = document.getElementById (id);
  if(field.value == null)
  {
    return (false);
  }
  
  var name = field.name;
  
  if(field.value == "")
  {
    if (notNull == true)
    {
      alert(name + " is empty");
      return (false);
    }
    return (true);
  }
  
  if(isNaN(field.value))
  {
    alert(name + " is not a number");
    return (false);
  }
  
  fieldValue = parseFloat(field.value)
  
  if(fieldValue < 1)
  {
    alert(name + " is minus than 1");
    return (false);
  }
 
  
  return (true);
}

function updateCursor(form)
{
  var iteratorSize = document.getElementById('iteratorSize');
  var cursor = document.getElementById('cursor');
    
  if (iteratorSize == null )
  {
    return ;
  }
  if( cursor == null)
  {
    return ;
  }

    cursor.value = parseInt(cursor.value) + parseInt(iteratorSize.value);
}




/* panelFunctions by ACL */


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



function copyStandartsOptions ()
{

  var optionBuffer = document.getElementById("optionsBuffer");
  var classic = document.getElementById("classic");
  
  if (optionBuffer == null || classic == null) {return (false);}
  
  var classicOptions = classic.childNodes;
  
  for (var i = 0; i < classicOptions.length; i++)
  {
    classicOption = classicOptions[i];
    
    if (classicOption.id != "")
    {
      var newId = "option_" + classicOption.id;

      li = document.createElement("li");
      li.id = newId;
      
      classicOption.id = "";
      
      newOption = classicOption.cloneNode(true);
      
      li.appendChild(newOption);
      
      optionBuffer.appendChild(li);

    }
  }
}

function initOptionSelect ()
{

  copyStandartsOptions ();
  
  var optionBuffer = document.getElementById("optionsBuffer");
  
  if (optionBuffer == null) {return (false);}
  
  var options = optionBuffer.childNodes;
  
  for (var i = 0; i < options.length; i++)
  {
    var option = options[i];
    
    if (option.id != null)
    {
      var newId = option.id.split("_")[1];
      
      addOptionSelect(newId);
      
      // check for mandatory elements
      
      var optionP = option.childNodes[0];
      
      
      if (optionP.getAttribute("mandatory") != null && optionP.getAttribute("mandatory") == "true")
      {
        addOption(option.id);
        i--;
      }

    }
  }
}

function removeOptionSelect (optionId)
{
  var optionSelect = getElementByTagNameAndValue ("option", optionId);

  if (optionSelect == null) {return (false);}
  
  removeElement(optionSelect);


}

function addOptionSelect (optionId)
{
  var optionSelect = document.getElementById("optionSelect");
  var option = document.getElementById("option_" + optionId);

  if ( optionSelect == null || option == null ) {return (false);}

  
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
  element.value = "option_" + optionId;
      
  optionSelect.appendChild(element);


}
function getElementByTagNameAndValue(tagName, value)
{
  var elements = document.getElementsByTagName (tagName);
  
  for(var i = 0; i < elements.length; i++)
  {
    element = elements[i];
    if (element.value == value)
    {
      return (element);
    }
  }
  return null;

}


function addOption (mandatoryId) {

  var selectedOption = "";
  
  if(mandatoryId != undefined)
  {
    selectedOption = mandatoryId;
  
  }
  else
  {
    var selected = document.getElementById ("optionSelect");
    
    selectedOption = selected.value;
  }
  if (selectedOption == "") {return (false);}
  
  var panel = document.getElementById("advanced");

  var option = document.getElementById(selectedOption);
  var options = option.childNodes;

  for (var i = 0; i < options.length; i++)
  {
    if (options[i].nodeType == 1 /* == Node.ELEMENT_NODE */ )
    {
      var optionToAdd = options[i];
      break;
    }
  
  }

  optionToAdd.id = selectedOption.split("_")[1];
  
  if(mandatoryId == undefined)
  {
    var remove = document.createElement("span");
    
    remove.appendChild(document.createTextNode("[X]"));
    remove.name = "removeButton";
    remove.className = "removeButton";
    
    remove.onclick = function() {removeOption(this.parentNode.id)};
    
    optionToAdd.insertBefore(remove, optionToAdd.firstChild);  
  } 
  else 
  {
    var remove = document.createElement("span");
    
    remove.appendChild(document.createTextNode("      "));// Warning it is
															// NBSP here
    remove.name = "removeButton";
    remove.className = "removeButton";
    
    remove.onclick = function() {removeOption(this.parentNode.id)};
    
    optionToAdd.insertBefore(remove, optionToAdd.firstChild);  
  }
  
  
  
  panel.appendChild(optionToAdd);
  
  removeElement(option);
  
  removeOptionSelect(selectedOption);
}


function removeOption (optionId)
{
  var option = document.getElementById(optionId);
  var optionsBuffer = document.getElementById("optionsBuffer");
  
  if (option == null || optionsBuffer == null) {return (false);}
  
  var optionContents = option.childNodes;
  
  for (var i = 0; i < optionContents.length; i++)
  {
    var optionContent = optionContents[i];
    
    if ( optionContent.tagName == "SPAN" && optionContent.name == "removeButton")
    {
      removeElement(optionContent);
    }
  }
  
  var li = document.createElement ("li");
  li.id = "option_" + optionId;
  li.appendChild(option);
  
  
  optionsBuffer.appendChild(li);
  
  addOptionSelect(optionId);

}


function removeElement (element)
{
  if (element != null && element.parentNode != null)
  {
    return (element.parentNode.removeChild(element));
  }
  return null;
}

function removeAllChilds (element)
{
  if (element != null)
  {
    while(element.hasChildNodes())
    {
      element.removeChild(element.firstChild);
    }
  }
}




function addUsedParametersField (elementId, value)
{
  var usedParameters = document.getElementById("usedParameters");

  var element = document.getElementById(elementId);

  if(usedParameters == null /* || element == null */)
  {
    return (false);
  }

  var usedElement = document.createElement ("input");
  usedElement.setAttribute("type", "hidden");
  usedElement.setAttribute("id", "used_" + elementId);
  usedElement.setAttribute("name", "used_" + elementId);
  usedElement.setAttribute("value", value);
  
  usedParameters.appendChild(usedElement);
  
  return ("used_" + elementId);
  
}




function initValidation ()
{
  var panel = document.getElementById("tabPanel");
  
  if(panel == null)
  {
    return (false);
  }
  
  var title_classic = document.getElementById("title_classic");
  
  var target;
  
  if (title_classic.className == "selected")
  {
    target = document.getElementById("classic");
  }
  else
  {
    target = document.getElementById("advanced");
  }
  if (target == null)
  {
    return (false);
  }
  
  removeAllChilds(document.getElementById("usedParameters"));


  elements = target.childNodes;

  for (var i = 0; i < elements.length; i++)
  {
    
    var element = elements[i];
    
    if (element.tagName == "P" && element.id != null)
    {
      var childIds = new Array();
      var childs = element.childNodes;

      var type = element.getAttribute("type");
      
      var notNull = element.getAttribute("notNull");
      
      if (notNull == null)
      {
        notNull =  false;
      }

      for (var j = 0; j < childs.length; j++)
      {
        var child = childs[j];
        if (
            (child.tagName == "INPUT" || child.tagName == "SELECT") 
            && child.id != null && child.id != "optionSelect"
            && child.value != null
           )
        {
          if (child.value != "" || notNull == "true")
          {
            childIds.push(addUsedParametersField (child.id, child.value));
          }
          
        }
      }
      
      /* TODO move this code to a specialised function */
      
      if (type == "percentage")
      {
        for (var k = 0; k < childIds.length; k++)
        {
          element.setAttribute("check", "javascript:checkPercentage('" + childIds[k] + "', " + notNull + ");");
        }
      }
      
      if (type == "positiveInteger")
      {
        for (var k = 0; k < childIds.length; k++)
        {
          element.setAttribute("check", "javascript:checkPositiveInteger('" + childIds[k] + "', " + notNull + ");");
        }
      }
      
      if (type == "positiveReal")
      {
        for (var k = 0; k < childIds.length; k++)
        {
          element.setAttribute("check", "javascript:checkPositiveReal('" + childIds[k] + "', " + notNull + ");");
        }
      }
      
      
    }
  }
}
function initSelect (id) {

   var div = document.getElementById (id);

   if (div == null)
   {
     return;
   }



   var childs = div.childNodes ;


   for (i=0; i<childs.length ; i++)
   {
     var child = childs[i];

     if (child.tagName == "SELECT")
     {
       var functStr = "showOnSelect(\"" + id + "\");";

       var funct = function (){eval (functStr)};

       child.onchange =  funct;

     }

     if (child.tagName == "FIELDSET")
     {
       child.style.display = "none";
     }
   }
}


function showOnSelect (idDiv)
{


   var div = document.getElementById (idDiv);

   if (div == null)
   {
     return;
   }

   var childs = div.childNodes ;
   var toShow = ""

   for (i=0; i<childs.length ; i++)
   {
     var child = childs[i];

     if (child.tagName == "SELECT")
     {
       toShow = child.value ;
     }

     if (child.tagName == "FIELDSET")
     {

       if (child.id == toShow)
       {
         child.style.display = "";
       }
       else
       {
         child.style.display = "none";
       }

     }


   }

}
function helpWindow(txt)
{

	var helpPopup = document.getElementById ("helpPopup");
	
	if (helpPopup != null)
	{
		return false;
	}
  
  
	helpPopup = document.createElement("div");
	
	helpPopup.className = 'popup item';
	helpPopup.id = 'helpPopup';
	
	var title = document.createElement("div");
	
	var titleButton = document.createElement("p");
	titleButton.className = 'right';
	titleButton.onclick = closeHelpPopup;
	
	var titleButtonImage = document.createElement("img");
	titleButtonImage.className = 'button';
	titleButtonImage.src = '/portal/images/x.gif';
	titleButtonImage.alt = 'X';
	titleButtonImage.title = 'Close';
	
	titleButton.appendChild(titleButtonImage);
	
	title.appendChild(titleButton);
	
	title.appendChild(document.createTextNode('Help'));
  
  helpPopup.appendChild(title);
  
  content = document.createElement("p");
  content.appendChild(document.createTextNode(txt));
	
	helpPopup.appendChild(content);

  var body = document.getElementsByTagName("body");
  body[0].appendChild(helpPopup);
  
  return false;
}

function closeHelpPopup()
{
	var helpPopup = document.getElementById ("helpPopup");
	
	if (helpPopup != null)
	{
	  helpPopup.parentNode.removeChild(helpPopup) ;
	}

}


function checkOptionsFields()
{
  var selectedItems = document.getElementsByName ("selectedItems");
  // var mass = document.getElementByName ("MASS");
  
  
  if (selectedItems == null || selectedItems.length == 0 )
  {
    return true;
  }
  
 // var massForm = mass[0];
  
  var items = selectedItems;

  for (i = 0; i < items.length; i++)
  {
    var item = items[i].value;
    
    if (item == "")
    {
      continue;
    }

    var div = document.getElementById(item);
    
  addUsedParametersField("selectedItems" , item);
  var fieldsets = div.childNodes ;
  var toGet = "";
 
  for (j=0; j<fieldsets.length ; j++)
  {
    var fieldset = fieldsets[j];
    

    if (fieldset.tagName == "INPUT")
    {
      addUsedParametersField( item + "__" +fieldset.id, fieldset.value);
    }

    if (fieldset.tagName == "SELECT")
    {
      toGet = fieldset.value ;
      if (toGet != "noOption")
      {
      addUsedParametersField( item + "__selected" ,  item + "__" + fieldset.value);
      }
    }
    
    if (fieldset.tagName == "FIELDSET")
    {

      if (fieldset.id == toGet)
      {
        var paragraphs = fieldset.childNodes;
        
        for (k = 0; k < paragraphs.length; k++ )
        {
            paragraph = paragraphs[k];
        
            if (paragraph.tagName == "P")
            {
              
              var inputs = paragraph.childNodes;
             
              for (l = 0; l < inputs.length; l++)
              {
                input = inputs[l];
                
                if (input.tagName == "INPUT" || input.tagName == "SELECT")
                {
                
                  addUsedParametersField( item + "__" +input.id, input.value);
                
                
                }
              
              }
              
              
              
            }
        
        
        
        }
        
        
        
      }
   
    }

 
  }

    
    
    
  }
  

  return true;

}




// ------------------------------------------------------
// Specific temporary functions used to parse the cdata html tring found in the
// ESRIN XML collections files.
//
function replaceAll(string,text,by) {
// Replaces text with by in string
    var strLength = string.length, txtLength = text.length;
    if ((strLength == 0) || (txtLength == 0)) return string;

    var i = string.indexOf(text);
    if ((!i) && (text != string.substring(0,txtLength))) return string;
    if (i == -1) return string;

    var newstr = string.substring(0,i) + by;

    if (i+txtLength < strLength)
        newstr += replaceAll(string.substring(i+txtLength,strLength),text,by);

    return newstr;
}

function parse_txt2html (id)
{

  
  element = document.getElementById(id);
  
    if (element == null)
  {
    return;
  
  }
  
  string = element.innerHTML;
  
  good = replaceAll(string, "&lt;/a&gt;", "</a>");
  good = replaceAll(good, "&lt;br&gt;", "<br/>");
  good = replaceAll(good, "&lt;", "<");
  good = replaceAll(good, "&gt;", "\" target=\"_blank\">");
  good = replaceAll(good ,"href=", "href=\"");


  


  element.innerHTML = good;
}


// function below is used for the multi soap location

// function to have the number of child node
// parentNodeName: name of the node

function getChildNodeNumber(parentNodeName)
{


	var element = document.getElementById(parentNodeName);
	var listChildNodes = element.childNodes;

	var numberOfChild = 0;

	// count the number of child in the list
	for (var i = 0; i < listChildNodes.length; i++)
  	{
  		// if the child node is an element_node add 1 to the number of child
   		if (listChildNodes[i].nodeType == 1)
    	{
      		numberOfChild++;
      	
    	}
      
  	}

	return numberOfChild; 
}


// function to update the element meter field
// parentName: parent element identifier
// number: the value to set
function updateMeterField(parentName, number) 
{

	var elementMeterField = document.getElementById(parentName + "_counter");

	elementMeterField.value = number;
}





// function to add an element in the list (last position).
// parentName: parent element identifier

function addElement(parentName) {
	// prepare the element to add
	var defaultElement = document.getElementById(parentName + "_elementModel");
	var elementToAdd;
	var defaultElementChildNodes = defaultElement.childNodes;

	// get the first element node
	for (var j = 0; j < defaultElementChildNodes.length; j++)
  	{
	  // if the child node is an element_node get it and stop
	   if (defaultElementChildNodes[j].nodeType == 1)
	    {
	      elementToAdd = defaultElementChildNodes[j].cloneNode(true);
	      break;
	    }
	      
  	} 


	// put an id for the element to add
	var numberOfChild = getChildNodeNumber(parentName + "_listElements");
	elementToAdd.id =  parentName + "_" + (numberOfChild) + elementToAdd.id;


	// update the input fields inside the element
	childNodesOfElementToAdd = elementToAdd.childNodes;

	for (var k = 0; k < childNodesOfElementToAdd.length; k++)
  	{
  		// if the child node is an element_node get it and modify it (id and
		// name)
   		if (childNodesOfElementToAdd[k].nodeType == 1)
    	{
    
    		var liField = childNodesOfElementToAdd[k];
    
    		var liFieldChildNodes = liField.childNodes;
    
    		for (var l = 0; l < liFieldChildNodes.length; l++)
  			{
    			
  				// if the child node is an element_node get it and modify it
   				if (liFieldChildNodes[l].nodeType == 1)
    			{
      				var inputField = liFieldChildNodes[l];
      
      				// modify the id
      				inputField.id = elementToAdd.id  +  "_" + inputField.name;
      
      				// modify the name
      				inputField.name = inputField.id;
      			}
     		}
    	}
      
  	}

	var inputElement = document.createElement ("input");
	var attr = document.createAttribute("id");
	attr.nodeValue = elementToAdd.id;
	inputElement.setAttributeNode(attr);
	
	var attr = document.createAttribute("name");
	attr.nodeValue = elementToAdd.id;
	inputElement.setAttributeNode(attr);
	
	var attr = document.createAttribute("value");
	attr.nodeValue = "elements";
	inputElement.setAttributeNode(attr);
	
	var attr = document.createAttribute("type");
	attr.nodeValue = "hidden";
	inputElement.setAttributeNode(attr);
	
	elementToAdd.appendChild(inputElement);
	

	// add the element to the list of soap location
	var listElements = document.getElementById(parentName + "_listElements");
	listElements.appendChild(elementToAdd);


	// update the soapLocation meter field
	numberOfChild++;
	updateMeterField(parentName, numberOfChild);

}


// function to remove the last element of the list.
// parentName: the parent element identifier

function removeLastElement(parentName) {


	var numberOfChild = getChildNodeNumber(parentName + "_listElements");
	
	// if the list is empty do nothing
	if (numberOfChild == 0) 
	{
		return false;
	}
	
	// remove the last element in the list
	var listElements = document.getElementById(parentName + "_listElements");
	
	if (listElements.lastChild.nodeType != 1) {
	// remove the text element (not the real element to remove)
		removeElement(listElements.lastChild);
	}
	
	// remove the element
	removeElement(listElements.lastChild);
	
	// update the element meter
	numberOfChild--;
	updateMeterField(parentName, numberOfChild);
}

// end function used for the multi soap location

