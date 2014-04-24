String.prototype.endsWith = function(str) {
	return (this.match(str+"$")==str)
}



function isDecendant(decendant,ancestor){
	if(decendant.parentNode.id != undefined && decendant.parentNode.id.endsWith(ancestor)){
		return true;
	} else if(decendant.parentNode!=document){
		return isDecendant(decendant.parentNode,ancestor);
	} else {
		return false;
	}
}






function buildCollections(parent, selected)
{
    result="";
    var radioButton = document.getElementsByName("searchRadioSelection");
    var collections = document.getElementsByName("collectionId");    
	for (var i=0; i<radioButton.length; i++){
		if(isDecendant(radioButton[i],parent)){
			        if (selected == undefined || radioButton[i].checked == selected) {
        	result = result + collections[i].value +";";
        }
		}

    } 
    return result;
}




function buildProducts(parent, selected)
{
    result="";
    var radioButton = document.getElementsByName("searchRadioSelection");
	for (var i=0; i<radioButton.length; i++){
		if(isDecendant(radioButton[i],parent)){
			        if (selected == undefined || radioButton[i].checked == selected) {
        	result = result + radioButton[i].value +";";
        }
		}

    } 
    return result;
}

function uncheckBoxes()
{
    var radioButton = document.getElementsByName("searchRadioSelection");
	for (var i=0; i<radioButton.length; i++){
        radioButton[i].checked = false;
    } 
    return true;
}

function addToBasketButtonClicked(){
	  var e;

	  var cDiv = document.getElementById('collectionIdsDiv');
	  var childs=cDiv.childNodes;
	  
	  var nbLength=childs.length-1;
	  for (var i=nbLength;i>-1;i--)
	  {
	     cDiv.removeChild(childs[i]);
	  }
		 
      e = document.createElement("input");
      e.setAttribute('type', 'hidden');
      e.setAttribute('value', buildCollections("requestResult",true));
      e.setAttribute('name', 'collectionIds');
      e.setAttribute('id', 'collectionIds');
      cDiv.appendChild(e);
	  return true;
	
}

function addToBasketAjaxComplete(){
	uncheckBoxes("searchRadioSelection");
	return true;
	
}

function removeFromBasketButtonClicked(){
	  var e;

	  var cDiv = document.getElementById('collectionIdsDivBasket');
	  var childs=cDiv.childNodes;
	  
	  var nbLength=childs.length-1;
	  for (var i=nbLength;i>-1;i--)
	  {
	     cDiv.removeChild(childs[i]);
	  }
		 
      e = document.createElement("input");
      e.setAttribute('type', 'hidden');
      e.setAttribute('value', buildCollections("basketForm",false));
      e.setAttribute('name', 'collectionIds');
      e.setAttribute('id', 'collectionIds');
      cDiv.appendChild(e);
      
      
	  var e2;

	  var cDiv2 = document.getElementById('productIdsDivBasket');
	  var childs2=cDiv2.childNodes;
	  
	  nbLength=childs2.length-1;
	  for (i=nbLength;i>-1;i--)
	  {
	     cDiv2.removeChild(childs2[i]);
	  }
		 
      e2 = document.createElement("input");
      e2.setAttribute('type', 'hidden');
      e2.setAttribute('value', buildProducts("basketForm",false));
      e2.setAttribute('name', 'productId');
      e2.setAttribute('id', 'productId');
      cDiv2.appendChild(e2);
      
      
	  return true;
}

function removeFromBasketAjaxComplete(){
	uncheckBoxes("searchRadioSelection");
	return true;
	
}



function checkoutButtonClicked(){
	
	  var e;

	  var cDiv = document.getElementById('collectionIdsDivBasket');
	  var childs=cDiv.childNodes;
	  
	  var nbLength=childs.length-1;
	  for (var i=nbLength;i>-1;i--)
	  {
	     cDiv.removeChild(childs[i]);
	  }
		 
      e = document.createElement("input");
      e.setAttribute('type', 'hidden');
      e.setAttribute('value', buildCollections("basketHtml"));
      e.setAttribute('name', 'collectionIds');
      e.setAttribute('id', 'collectionIds');
      cDiv.appendChild(e);
      
	  var e2;

	  var cDiv2 = document.getElementById('productIdsDivBasket');
	  var childs2=cDiv2.childNodes;
	  
	  nbLength=childs2.length-1;
	  for (i=nbLength;i>-1;i--)
	  {
	     cDiv2.removeChild(childs2[i]);
	  }
		 
      e2 = document.createElement("input");
      e2.setAttribute('type', 'hidden');
      e2.setAttribute('value', buildProducts("basketHtml"));
      e2.setAttribute('name', 'productId');
      e2.setAttribute('id', 'productId');
      cDiv2.appendChild(e2);

      return true;
}

function proceedButtonClicked(){
	
	  var e;

	  var cDiv = document.getElementById('collectionIdsDivCheckout');
	  var childs=cDiv.childNodes;
	  
	  var nbLength=childs.length-1;
	  for (var i=nbLength;i>-1;i--)
	  {
	     cDiv.removeChild(childs[i]);
	  }
		 
    e = document.createElement("input");
    e.setAttribute('type', 'hidden');
    e.setAttribute('value', buildCollections("checkoutForm"));
    e.setAttribute('name', 'collectionIds');
    e.setAttribute('id', 'collectionIds');
    cDiv.appendChild(e);
    
	  var e2;

	  var cDiv2 = document.getElementById('productIdsDivCheckout');
	  var childs2=cDiv2.childNodes;
	  
	  nbLength=childs2.length-1;
	  for (i=nbLength;i>-1;i--)
	  {
	     cDiv2.removeChild(childs2[i]);
	  }
		 
    e2 = document.createElement("input");
    e2.setAttribute('type', 'hidden');
    e2.setAttribute('value', buildProducts("checkoutForm"));
    e2.setAttribute('name', 'productId');
    e2.setAttribute('id', 'productId');
    cDiv2.appendChild(e2);

    return true;
}


