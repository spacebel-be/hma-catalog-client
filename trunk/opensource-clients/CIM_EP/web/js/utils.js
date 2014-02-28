var DomUtil = (function() {
   // Private members


   // Public members
   return {
    
      "getChildsByTagName": function (element, tagName) {

      if (element == null || element.nodeType != 1) {
        return null;
      }
    
      if (tagName == null || tagName == "") {
        return null;
      }
      
      var children = [];
      
        var elementChildren = element.childNodes;

        for (var i = 0; i < elementChildren.length; i++) {
          var elementChild = elementChildren[i];
    
          if (elementChild.nodeType == 1 && elementChild.tagName == tagName) {
          children.push (elementChild);
          } 
        
        }
        
      if (children.length == 0) {
        return null;
      }
      
      return children;
    
    },
    
    "getNodeValue" : function (element) {
      if (element == null || element.nodeType != 1) {
        return "";
      }
      var value = element.firstChild.nodeValue
      
      return StringUtil.trim(value);
    
    
    }
      
      
   };
})();


var StringUtil = (function() {
   // Private members


   // Public members
  return {
    
    "rtrim": function (string) {

      if (string == null || string == "") {
        return "";
      }
        var i=string.length -1;
        while(i > 0 && string.charAt(i) == ' ') {  
          i= i - 1;  
        }
        return string.substring(0, i+1);
    }, 
    
    "ltrim": function (string) {

      if (string == null || string == "") {
        return "";
      }
        var i=0;
        while(i < string.length && string.charAt(i) == ' ') {  
          i= i + 1;  
        }
        return string.substring(i);
    }, 
    
    "trim": function (string) {

      if (string == null || string == "") {
        return "";
      }
      string = this.rtrim(string);
      string = this.ltrim(string);

      return string;
    }
      
   };
})();


var ArrayUtil = (function() {
   // Private members


   // Public members
  return {
      "isArray": function (array) {
        if (array == null) {
          return false;
        }
      
//         if (array.constructor.toString().indexOf("Array") == -1)
         if (!(array.length))
            return false;
         else
            return true;
      },
      "indexOf": function (array, value) {
      if (array == null || !ArrayUtil.isArray(array) || array.length == 0) {
        return -1;
      }
      
      if (value == null || value == "") {
        return -1;
      }
      
      for (var i=0; i<array.length; i++) {
        if (array [i] == value) {
          return i;
        }
      }
      

      return -1;
      
    },
    "mergeArray": function (array1, array2) {

      var result = [];
    
      if (array1 == null || !ArrayUtil.isArray(array1) || array1.length == 0 ) {
        return array2;
      }
      
      if (array2 == null || !ArrayUtil.isArray(array2) || array2.length == 0 ) {
        return array1;
      }
      
      for (var i=0; i<array1.length; i++) {
        var currentItem = array1[i];
        result.push(currentItem);
      }
      
      for (var i=0; i<array2.length; i++) {
        var currentItem = array2[i];
        if(ArrayUtil.indexOf(result, currentItem) == -1) {
          result.push(currentItem);
        }
      }
      return result;
      
    }
    
      
   };
})();

var IntegerUtil = (function() {
   // Private members


   // Public members
  return {
    "parseInteger": function (a) {
        if (a == null) {
            return null;
        }
        
        var valueA = StringUtil.trim(a);
        
        valueA = valueA.split("\n")[0];
        
        valueA = valueA.replace(/\.(.)*$/g, "");
        valueA = valueA.replace(/,(.)*$/g, "");
        valueA = valueA.replace(/[^\d]/g, "");
        valueA = valueA.replace(/^[0]*/, "");
        
        if (valueA == "") {
            return 0;
        }
        
        return (parseInt(valueA, 10));
    }
    
      
   };
})();

var SortUtil = (function() {
   // Private members


   // Public members
  return {
    "compareInteger": function (a, b) {
        if (a == null) {
            return -1;
        }
        
        if (b == null) {
            return 1;
        }
        
        var valueA =  IntegerUtil.parseInteger(a);
        var valueB = IntegerUtil.parseInteger(b);
        
        return (valueA - valueB);
    },
    "compareString": function (a, b) {
        if (a == null) {
            return -1;
        }
        
        if (b == null) {
            return 1;
        }
        
      if (a == b) {
        return 0;
      }
      if (a == "") {
        return -1;
      }
      if (b == "") {
        return -1;
      }
      if (a < b) {
        return -1;
      }
      return 1;
    },
    "compareByType": function (type, a, b) {
        if (type != null) {
	        if (type == "integer") {
	            return SortUtil.compareInteger(a,b);
	        }
        }
        
        return SortUtil.compareString(a,b);

    }
    
      
   };
})();



function SelectBox () {
  this.setLabel = function (label) {
    if (!this.isValid()){
      return;
    }
  
    if (label == null || label == ""){
      return;
    }
    
    var labelElement = document.createElement("label");
    labelElement.appendChild(document.createTextNode(label));
    this.rootElement.insertBefore (labelElement, this.selectElement);
  }

  this.setId = function (id) {
    if (!this.isValid()){
      return;
    }
  
    if (id == null || id == ""){
      return;
    }
    
    this.rootElement.id = id;
  }
  
  
  this.setCallback = function (callbackFunction) {
    if (!this.isValid()){
      return;
    }
    // TODO find a way to check callback funct
    if (callbackFunction == null){
      return;
    }
    
    this.selectElement.onchange = callbackFunction;
  }

  this.addOption = function (label, value) {
    if (!this.isValid()){
      return;
    }
    
    if (label == null || label == ""){
      return;
    }
    
    var option = document.createElement ("option");
    if (value != null && value != "") {
      option.value = value;
    }
    option.appendChild(document.createTextNode(label));

    this.selectElement.appendChild(option);
  }

  this.isValid = function () {
    if (this.rootElement == null || this.selectElement == null){
      return false;
    }
    
    return true;
  }

  this.rootElement = document.createElement ("span");
  
  this.rootElement.model = this;
  this.selectElement = document.createElement ("select");
  this.rootElement.appendChild(this.selectElement);
  
  
}



