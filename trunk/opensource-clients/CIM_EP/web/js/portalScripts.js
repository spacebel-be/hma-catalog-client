function escapeSelector( str) {
 if( str)
     return str.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g,'\\$1');
 else
     return str;
}


function booleanAnd(a, b){
	return a && b;
}

function booleanOr(a, b){
	return a || b;
}

function isLessThanNumber(number, comparedNumber) {
    if (number < comparedNumber) {
        return true;
    } else {
        return false;
    }
}

function isLessThanNumberOrEqual(number, comparedNumber) {
    if (number <= comparedNumber) {
        return true;
    } else {
        return false;
    }
}

function isGreaterThanNumber(number, comparedNumber) {
    if (number > comparedNumber) {
        return true;
    } else {
        return false;
    }
}

function isGreaterThanNumberOrEqual(number, comparedNumber) {
    if (number >= comparedNumber) {
        return true;
    } else {
        return false;
    }
}



var portalScripts = (function() {
   // Private members

  function getParameter(url, name) {
    name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
    var regexS = "[\\?&]"+name+"=([^&#]*)";
    var regex = new RegExp( regexS );
    var results = regex.exec( url );
    if( results == null )
      return "";
    else
      return results[1];
  }

   // Public members
   return {
      "getFromSSEDocument": function(elementName) {
         try {
            return top.document[elementName];
         } catch (e) {;}
         
         for (var i = 0; i < top.frames.length; i++) {
          try {
            return top.frames[i].document[elementName];
          } catch (e) {;}
         }
         
         return null;
      },
      
      "getFromSSEWindow": function(elementName) {
         try {
            return top.window[elementName];
         } catch (e) {;}
         
         for (var i = 0; i < top.frames.length; i++) {
          try {
            return top.frames[i].window[elementName];
          } catch (e) {;}
         }
         
         return null;
      },
      
      "getParameterFromURL": function(name) {
        return (getParameter(window.location.href, name));
      },
      
      "getParameterFromReferrer": function(name) {
        return (getParameter(document.referrer, name));
      },
      
      "replaceAll": function (string,text,by) {
        // Replaces text with by in string
        var strLength = string.length, txtLength = text.length;
        if ((strLength == 0) || (txtLength == 0)) return string;

        var i = string.indexOf(text);
        if ((!i) && (text != string.substring(0,txtLength))) return string;
        if (i == -1) return string;

        var newstr = string.substring(0,i) + by;

        if (i+txtLength < strLength)
            newstr += this.replaceAll(string.substring(i+txtLength,strLength),text,by);

        return newstr;
      }
   };
})();

var StringUtils = (function() {
   // Private members


   // Public members
   return {
    
      "replaceAll": function (string,text,by) {
        // Replaces text with by in string
        var strLength = string.length, txtLength = text.length;
        if ((strLength == 0) || (txtLength == 0)) return string;

        var i = string.indexOf(text);
        if ((!i) && (text != string.substring(0,txtLength))) return string;
        if (i == -1) return string;

        var newstr = string.substring(0,i) + by;

        if (i+txtLength < strLength)
            newstr += this.replaceAll(string.substring(i+txtLength,strLength),text,by);

        return newstr;
      },
      "unescapeXML": function (string) {
        var newstr = string;
        
        newstr = this.replaceAll(newstr, "&gt;", ">");
        newstr = this.replaceAll(newstr, "&lt;", "<");
        return newstr;
      }
      
      
   };
})();