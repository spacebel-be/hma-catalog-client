
function ResultItem (element, id) {
      this.hide= function () {
        if (this.view != null) {
          this.view.style.display = "none";
        }
      };
      
      this.show= function () {
        if (this.view != null) {
          this.view.style.display = "";
        };
      
      },
      
      this.checkCriteriaValue = function (criteria, value) {
        if (criteria == null || criteria == "") {
          return false;
        }
        if (value == null || value == "") {
          return false;
        }

        var criteriaValues = this.getCriteriaValues(criteria);

        if (ArrayUtil.indexOf(criteriaValues, value) != -1) {
          return true;
        }
        return false;
    
      };
      
      
      this.getCriteriaValue = function (criteriaName) {
        
        var criteria = this._getCriteriaValueNode(criteriaName);
        
        if (criteria == null) {
          return "";
        } 
        
        var criteriaValueString = DomUtil.getNodeValue(criteria);
        
        return criteriaValueString;
      };
      
      this.getCriteriaValues = function (criteriaName) {
        var results = [];
        var criteriaValueString = this.getCriteriaValue(criteriaName);

        if (criteriaValueString == null || criteriaValueString == "") {
            return null;
        }
        if (this.list == true) {
            var criteriaValueStringList = criteriaValueString.split (",");
            
	        for (var i=0; i<criteriaValueStringList.length; i++) {
	          var currentCriteriaValue = StringUtil.trim(criteriaValueStringList[i]);
	          if (currentCriteriaValue != null && currentCriteriaValue != "") {
	            if (ArrayUtil.indexOf(results, currentCriteriaValue) == -1) {
	              results.push(currentCriteriaValue);
	            }
	          }
	      }
        
        } else {
            results.push(criteriaValueString);
        }
        
        if (results.length == 0) {
          return null;
        }
        return results;
      };
      
      
      
      
      this.getCriteriaType = function (criteriaName) {
        
        var criteria = this._getCriteriaNode(criteriaName);
        if (criteria == null) {
          return null;
        } 
        
        var criteriaType = criteria.getAttribute("type");
        
        return criteriaType;
      };
      
      this._getCriteriaNode = function (criteriaName) {
        if (criteriaName == null || criteriaName == "") {
          return null;
        }
        var criteriaId = "dl_" + this.id + "_" + criteriaName;
        
        var criteria = document.getElementById(criteriaId);
                
        return criteria;
      };
      
      this._getCriteriaValueNode = function (criteriaName) {
        if (criteriaName == null || criteriaName == "") {
          return null;
        }
        var criteriaId = "dd_" + this.id + "_" + criteriaName;
        
        var criteria = document.getElementById(criteriaId);
                
        return criteria;
      };
      
      this._initializeCriteria= function (){
        var td = DomUtil.getChildsByTagName (this.view, "TD");
        
        if (td == null) {
        return null;
      }
      for (var i = 0; i < td.length; i++) {
        var currentTd = td[i];
        var dl = DomUtil.getChildsByTagName (currentTd, "DL");
        if (dl == null) {
          continue;
        }
        
        for (var j = 0; j < dl.length; j++) {
          var currentDl = dl[j];
          var valueLabel = "";

          var dt = DomUtil.getChildsByTagName (currentDl, "DT");
          if (dt == null) {
            continue;
          }
          
          var currentDt = dt[0];
          
          if (currentDt == null) {
            continue;
          }
          
          var noIndex = currentDl.getAttribute("noIndex");
          
          if (noIndex != null && noIndex == "true") {
            continue;
          }
          
          valueLabel = this._formatLabel (DomUtil.getNodeValue(currentDt));
          
          if (valueLabel == "") {
            continue;
          }
          
          var dd = DomUtil.getChildsByTagName (currentDl, "DD");
          if (dd == null) {
            continue;
          }
          var currentDd = dd[0];
        
        if (ArrayUtil.indexOf(this.criteriaList, valueLabel)== -1) {
          this.criteriaList.push(valueLabel);
        }
        
        var list = currentDl.getAttribute("list");
          
        if (list != null && list == "true") {
          this.list = true;
        }
          
        currentDl.id = "dl_" + this.id + "_" + valueLabel;
        currentDt.id = "dt_" + this.id + "_" + valueLabel;
        currentDd.id = "dd_" + this.id + "_" + valueLabel;
        
        this.isEmpty = false;
      }
      
      
      }
        
      } ;
      this._formatLabel= function (label) {
        if (label != null && label != "") {
          return (label.replace(":", ""));
        }
        return null;
      }
    

      if (element == null || element.nodeType != 1) {
        return ;
      }
      
      this.id = id;
      this.view = element;
      this.criteriaList = [];
      
      this.isEmpty = true;
      this.list = false;
      
      this._initializeCriteria();

      

}

function Results (element) {
      this.searchByCriteriaValue= function (criteria, value) {
      
      if (criteria == null || criteria == "") {
        return null;
      }
      if (value == null || value == "") {
        return null;
      }

      if (this.items == null) {
        return null;
      }

      var results = [];
      
      for (var i=0; i<this.items.length; i++) {
        var currentItem = this.items[i];

        if (currentItem.checkCriteriaValue(criteria, value) == true) {
          results.push (currentItem);
          
        }
      }
      if (results.length == 0) {
        return null;
      }
      return results;
    
    };
      
      this.showAll= function () {
      if (this.items == null || this.items.length == 0) {
        return ;
      }
      
      for (var i=0; i<this.items.length; i++) {
        var currentItem = this.items[i];
        currentItem.show();
      }
    
    };
      
      this.hideAll= function () {
      if (this.items == null || this.items.length == 0) {
        return ;
      }
      
      for (var i=0; i<this.items.length; i++) {
        var currentItem = this.items[i];
        currentItem.hide();
      }
    
    };
      
      
      this.hideEmpty= function () {
      if (this.items == null || this.items.length == 0) {
        return ;
      }
      
      for (var i=0; i<this.items.length; i++) {
        var currentItem = this.items[i];
        
        if (currentItem.isEmpty == true) {
            currentItem.hide();
        }
      }
    
    };
      
      this.hideByCriteriaValue= function (criteria, value, showOthers) {
      if (criteria == null || criteria == "") {
        return null;
      }
      if (value == null || value == "") {
        return null;
      }
      
      if (showOthers == true) {
        this.showAll();
      }
      
      
      var results = this.searchByCriteriaValue(criteria, value);
      
      if (results == null) {
        return;
      }
      
      for (var i=0; i<results.length; i++) {
        var currentItem = results[i];
        
        currentItem.hide();
        
      }
    
    };
      
      this.showByCriteriaValue= function (criteria, value, hideOthers) {
      if (criteria == null || criteria == "") {
        return null;
      }
      if (value == null || value == "") {
        return null;
      }
      
      if (hideOthers == true) {
        this.hideAll();
      }
      
      
      var results = this.searchByCriteriaValue(criteria, value);
      
      if (results == null) {
        return;
      }
      
      for (var i=0; i<results.length; i++) {
        var currentItem = results[i];
        
        currentItem.show();
        
      }
    
    };
    
    this.getValuesByCriteria = function (criteria) {
      if (criteria == null || criteria == "") {
        return null;
      }
    
       if (this.items == null || this.items.length == 0) {
        return ;
      }
      var results = [];
      
      
      for (var i=0; i<this.items.length; i++) {
        var currentItem = this.items[i];
        
        var currentItemValues = currentItem.getCriteriaValues(criteria);
        
        results = ArrayUtil.mergeArray(results, currentItemValues);
      }
      if (results.length == 0) {
        return null;
      }
      results.sort()
      return results;
    };
    
      
      this._initializeItems=function  () {

      var tbody = DomUtil.getChildsByTagName (this.view, "TBODY");
      
      if (tbody == null) {
        return null;
      }
      
      var tr = DomUtil.getChildsByTagName (tbody[0], "TR");
      
      if (tr == null) {
        return null;
      }
      
      for (var i = 0; i < tr.length; i++) {
        var currentTr = tr[i];
        var model =  new ResultItem (currentTr, i);
        
      currentTr.model = model;
      
      this.items.push(model);
      }
      };
      
      this.generateFilterBar =function  (criteria, id) {
      
        if (criteria == null || criteria == "") {
          return null;
        }
        
        if (this.items == null || this.items.length == 0) {
          return ;
        }
        var filterValues = this.getValuesByCriteria(criteria);
        
        if (filterValues == null || filterValues.length == 0) {
          return ;
        }

        var filterBox = new SelectBox ();
        
        if (id != null && criteria != "") {
          filterBox.setId(id);
        }
        
        var callback = function() {
          if (this.value == "All") {
            results.showAll();
          } else {
            results.showByCriteriaValue(criteria, this.value, true);
          }
          ResultFrame.resize();
        };
        
        filterBox.setCallback(callback);
        
        
        filterBox.addOption("All", "All");
        
        for (var i=0; i<filterValues.length; i++) {
          var filterValue = filterValues[i];
          filterBox.addOption(filterValue, filterValue);
        }
        
        var filters = document.getElementById("filters");
        
        if (filters != null) {
          filters.appendChild(filterBox.rootElement);
        }

      };
      
    this.generateFilterCriteriaBar =function  () {
      var criteriaList = [];
      
      if (this.items == null || this.items.length == 0) {
        return ;
      }
      
      for (var i=0;i < this.items.length;  i++) {
        var currentItem = this.items[i];
        criteriaList = ArrayUtil.mergeArray(criteriaList, currentItem.criteriaList);
      }
      
      if (criteriaList.length == 0) {
        return ;
      }
      this.generateFilterCriteriaBarFromList(criteriaList);
      
    }
    
    this.generateFilterCriteriaBarFromList =function  (criteriaList) {
      if (criteriaList == null || criteriaList.length == 0) {
        return null;
      }
      
        var filterCriteriaBox = new SelectBox ();
        
        filterCriteriaBox.setLabel ("Filter by:");
       
        var callback = function() {
        
          if (this.value == " ") {
            results._removeChildBar(this.id + "__child");
          } else {
            results._removeChildBar(this.id + "__child");
            results.generateFilterBar(this.value, this.id + "__child");
          }
          results.showAll();
          ResultFrame.resize();
        };
        filterCriteriaBox.setCallback (callback);
        
        filterCriteriaBox.setId("filter__select");
        
        filterCriteriaBox.addOption (" ", " ");
        
        for (var i=0; i<criteriaList.length; i++) {
          var criteria = criteriaList[i];
        
          filterCriteriaBox.addOption (criteria, criteria);
        }
        
      var filterBar = document.getElementById("filters");
      
      if (filterBar != null) {
        filterBar.appendChild(filterCriteriaBox.rootElement);
      }
      

    }
    
    this._removeChildBar  =function (id) {
      if (id == null || id == "") {
        return;
      }
      
      var childBar = document.getElementById(id);
      
      if (childBar != null) {
        childBar.parentNode.removeChild(childBar) 
      }
    
    }
      
    this.compareItems =function (a,b) {
      if (sortOrder == null || sortOrder == 0) {
        sortOrder = 1;
      }
    
      if (a == null) {
        return -1;
      }
      if (b == null) {
        return 1;
      }
      
      var valueA = a.getCriteriaValue(sortCriteria);
      var valueB = b.getCriteriaValue(sortCriteria);
      
      var typeA = a.getCriteriaType(sortCriteria);
      var typeB = b.getCriteriaType(sortCriteria);
      
      if (typeA != typeB) {
        typeA = null;
      }
      return (SortUtil.compareByType (typeA, valueA, valueB) * sortOrder);
    }
    
    this.sortByCriteria =function  (criteria) {
      if (criteria == null || criteria == "") {
        return null;
      }
      
      if (this.items == null || this.items.length == 0) {
        return ;
      }

      sortCriteria = criteria;
      
      var sortOrderBox = document.getElementById ("sortOrderBox");
      
      if (sortOrderBox != null) {
        sortOrder = sortOrderBox.model.selectElement.value;
      } else {
        sortOrder = 1;
      }
      
      this.hideEmpty();
      this.items = this.items.sort(this.compareItems);
      
      this.refreshView();
      
      sortCriteria = null;
      sortOrder = 1;
    }
    
    this.generateSortBarFromList = function  (criteriaList) {
      if (criteriaList == null || criteriaList.length == 0) {
        return null;
      }
      
        var sortBox = new SelectBox ();
        
        sortBox.setLabel ("Sort by:");
        
        sortBox.setId ("sortBox");
        var callback = function() {
          var sortBox = document.getElementById("sortBox");
            
          if (sortBox == null) {
            return;
          }
          
          var sortBoxSelectValue = sortBox.model.selectElement.value;
        
          if (sortBoxSelectValue == null || sortBoxSelectValue == " ") {
          } else {
            results.sortByCriteria(sortBoxSelectValue);
          }
        };
        sortBox.setCallback (callback);
        
        sortBox.addOption (" ", " ");
        
        for (var i=0; i<criteriaList.length; i++) {
          var criteria = criteriaList[i];
        
          sortBox.addOption (criteria, criteria);
        }
        
      var sortBar = document.getElementById("sortBar");
      
      if (sortBar != null) {
        sortBar.appendChild(sortBox.rootElement);
      }
      
      var sortBarOrderBox = new SelectBox ();
      
      sortBarOrderBox.setId("sortOrderBox");
      
      sortBarOrderBox.setCallback (callback);
      
      sortBarOrderBox.addOption ("Ascending", 1);
      sortBarOrderBox.addOption ("Descending", -1);
        
      if (sortBar != null) {
        sortBar.appendChild(sortBarOrderBox.rootElement);
      }
    }
    
    this.generateSortBar =function  () {
      var criteriaList = [];
      
      if (this.items == null || this.items.length == 0) {
        return ;
      }
      
      for (var i=0;i < this.items.length;  i++) {
        var currentItem = this.items[i];
        criteriaList = ArrayUtil.mergeArray(criteriaList, currentItem.criteriaList);
      }
      
      if (criteriaList.length == 0) {
        return ;
      }
      this.generateSortBarFromList(criteriaList);
      
    }
    
    
    
    this.refreshView =function  () {
      if (this.items == null || this.items.length == 0) {
        return ;
      }

      var resultTableBody = DomUtil.getChildsByTagName (this.view, "TBODY");
      if (resultTableBody == null) {
        return;
      }
      
      var resultTableBodyElement = resultTableBody[0];
      if (resultTableBodyElement == null) {
        return;
      }
      
      for (var i = 0; i < this.items.length; i++) {
        var currentItem = this.items[i];
        var currentItemElement = currentItem.view;

        resultTableBodyElement.removeChild(currentItemElement) 
        resultTableBodyElement.appendChild(currentItemElement);
      }
    }
    
  if (element == null || element.nodeType != 1) {
    return null;
  }
  this.view = element;
  element.model = this;

  this.items = [];
  this._initializeItems ();
}

var ResultFrame = (function() {
   // Private members


   // Public members
  return {
    "resize": function (array) {
      var resultDiv = document.getElementById("result"); 
      
      if (resultDiv != null) {
        var massForm = portalScripts.getFromSSEDocument("MASS");
        if (massForm != null) {
          var frameOperationResult = massForm.ownerDocument.getElementsByName("frameOperationResult");
          if (frameOperationResult != null) { 
            var contentSize = resultDiv.scrollHeight;
            contentSize = contentSize + 50;
            frameOperationResult[0].height = contentSize;
            frameOperationResult[0].overflowX = "hidden";
            frameOperationResult[0].overflowY = "hidden"; 
          }
        }
      }
    }
  }
})();

var PresentPopup = (function() {
   // Private members


   // Public members
  return {
    "resize": function (array) {
      var table = document.getElementById ("resultTable");
      if (table != null) { 
        var width = ((table.clientWidth + 150 ) < screen.width) ? table.clientWidth + 150 : screen.width; 
        var height = ((table.clientHeight + 150) < screen.height) ? table.clientHeight + 150 : screen.height;

        window.resizeTo (width, height);

        var x = (screen.width - width) / 2; 
        var y = (screen.height - height) / 2;

        window.moveTo (x, y); 
      }
    }
  }
})();


var sortCriteria = null;

var sortOrder = 1;
