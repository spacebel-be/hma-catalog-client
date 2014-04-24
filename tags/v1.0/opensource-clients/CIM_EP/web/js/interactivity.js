/**
 * interactivity.js Copyright (c) 2002 Spacebel S.A. I. Vandammestraat 5-7, 1560
 * Hoeilaart, Belgium All rights reserved.
 * 
 * $History: $Log$ Revision 1.8 2007/10/25 17:04:51 sde add dynamism to the news
 * portlet: contains the last sse news.
 * 
 * Revision 1.7 2006/03/29 10:18:19 sde correct as possible the company and
 * service category pages (SCR 351).
 * 
 * the portlet alternative color is not available on these pages because of a
 * javascript problem (impossible de resize the portlet).
 * 
 * a constraint was discovered: limitation of the text description size for the
 * portlet displayed on the portal home page.
 * 
 * Revision 1.6 2006/03/27 13:48:19 sde correct error for portlet display
 * 
 * Revision 1.5 2006/03/23 15:30:39 sde change function "recadre" in order to
 * take into account new display of company category page and service category
 * page (same display as the portal home page)
 * 
 * Revision 1.4 2006/02/16 10:36:34 sde delete function addBreadCrumb (define in
 * CommonScript.js)
 * 
 * Revision 1.3 2006/02/06 15:37:57 sde correct function addBreadCrumb: rename
 * id breadcrumb into breadCrumb
 * 
 * Revision 1.2 2005/12/12 14:25:55 sde change the home page link from
 * portalHomePage.jsp to index.jsp
 * 
 * Revision 1.1 2005/04/29 03:32:09 dnu JSP source files for MyHomePage added.
 * 
 * End of history.
 */

var nb_column = 2;
var nb_column = 2;
var nbrediv = 6; // important ? modifier si on ajoute des div
var dx = 0, dy = 0, current = null;
var x = 0, y = 0;
var active = 0;

function init() {
	var menuTop;
	var menuTopItems;

	var height = 0;

	menuTop = document.getElementById("menuTop");

	menuTopItems = menuTop.childNodes;

	for ( var i = 0; menuTopItems[i] != undefined; i++) {
		if (menuTopItems[i].offsetHeight != undefined) {
			height = height > menuTopItems[i].offsetHeight ? height
					: menuTopItems[i].offsetHeight;
			// alert (menuTopItems[i].clientHeight);
		}
	}
	menuTop.style.height = height + "px";

	var menuBottom;
	var menuBottomItems;

	height = 0;

	menuBottom = document.getElementById("menuBottom");
	if (menuBottom) {
		menuBottomItems = menuBottom.childNodes;

		for ( var i = 0; menuBottomItems[i] != undefined; i++) {
			if (menuBottomItems[i].offsetHeight != undefined) {
				height = height > menuBottomItems[i].offsetHeight ? height
						: menuBottomItems[i].offsetHeight;
			}
		}
		menuBottom.style.height = height + "px";

		recadre("main");
	}
	recadre("main");
}
var dx = 0, dy = 0, current = null;
var x = 0, y = 0;
var active = 0;

function startDrag(e) {
	if (document.all) {
		var obj = event.srcElement;
	} else {
		var obj = e.target;
	}
	if (obj.tagName == "A") { // not work if click on the anchor link
		return false;
	}
	if (obj.parentNode.nodeName == "body") {

		return;
	}

	while ((obj != null && obj.parentNode != null)
			&& (obj.parentNode.id != "main")) {
		obj = obj.parentNode;

	}

	if ((obj != null) && (obj.parentNode != null)
			&& (obj.parentNode.id != null) && (obj.parentNode.id == "main")) {
		active = obj.id;
		div = obj.parentNode;
		current = obj.style;
		num = obj.id.slice(4, 6);
		// alert(num);

		var clone = obj.cloneNode(true);

		div.insertBefore(clone, obj);

		obj.id = "clone";
		current.position = "absolute";

		if (document.all) {

			var body = document.getElementById("body");
			x = event.x + body.scrollLeft;
			y = event.y + body.scrollTop;

			current.left = x;
			current.top = y;

			dx = event.x - parseInt(current.left);
			dy = event.y - parseInt(current.top);

		} else {
			x = e.pageX;
			y = e.pageY;
			current.left = x + "px";
			current.top = y + "px";

			dx = e.clientX - parseInt(current.left);
			dy = e.clientY - parseInt(current.top);

			document.captureEvents(Event.MOUSEMOVE);
		}
		document.onmousemove = drag;
		return false;
	}

	current = null;
	return false;

}

function drag(e) {
	var obj = document.getElementById("clone");
	if (obj) {
		var current = obj.style;
	}

	if (current != null) {
		if (document.all) {
			var body = document.getElementById("body");
			current.top = (parseInt(event.y) - dy) + "px";
			current.left = (parseInt(event.x) - dx - current.width / 2) + "px";

			//
		} else {
			current.top = (parseInt(e.clientY) - dy) + "px";
			current.left = (parseInt(e.clientX) - dx - current.width / 2)
					+ "px";
		}
		x = current.top.substr(0, current.top.length - 2);
		y = current.left.substr(0, current.left.length - 2);
	}

}

function endDrag(e) {

	var div = document.getElementById('main');
	var obj = document.getElementById("clone");
	if (obj == null) { // in case of the A anchor link is click
		return;
	}
	if (document.all) {
		var new_pos = event.srcElement;
	} else {
		var new_pos = e.target;
	}
	if (new_pos == null) {
		return;
	}

	if (new_pos.parentNode.nodeName == "body") {
		obj = document.getElementById("clone");
		if (obj) {
			alert("node: " + obj.nodeName);
			div.removeChild(obj);
		}
		return;
	}

	if (new_pos.parentNode == null) {
		new_pos = null;
	} else {
		while ((new_pos != null && new_pos.parentNode != null)
				&& (new_pos.parentNode.id != "main")) {
			new_pos = new_pos.parentNode;
		}
	}

	var old_pos = document.getElementById(active);

	if ((new_pos != undefined) && (new_pos.id != undefined)) {
		if (old_pos != null) {
			div.replaceChild(old_pos, new_pos);
		}
		div.insertBefore(new_pos, old_pos);
	}

	var obj = document.getElementById("clone");
	if (obj) {
		div.removeChild(obj);
	}

	recadre("main");
}

function callbackClick() {
	var obj = document.getElementById("clone");
	if (obj) {
		div.removeChild(obj);
	}
}

function recadre(id) {

	var height = 0;
	var main;
	var mainItems;
	// variable to set the background color (white) for pages containing
	// portlets
	var globalPageId = document.getElementById("main");
	var globalPageId2 = document.getElementById("main2");

	main = document.getElementById(id);

	if (main == undefined) {
		return;
	}

	mainItems = main.childNodes;

	var k = 0;
	var columnHeight = new Array();

	for ( var i = 0; mainItems[i] != undefined; i++) {
		// alert("boucle "+ mainItems[i].className);
		columnHeight[k] = 0;

		// for the services and company categories
		if (((mainItems[i].className == "celldarkTmp") && (mainItems[i].id != undefined))
				|| ((mainItems[i].className == "cellDarkWithTopSpaceTmp") && (mainItems[i].id != undefined))) {
			// first change the background for the global page (containing the
			// portlets)
			// globalPageId.style.backgroundColor="white";
			globalPageId2.style.paddingLeft = "1px";
			recadre(mainItems[i].id);

		}

		if ((mainItems[i].offsetHeight != undefined)
				&& ((mainItems[i].className == "portletItem")
						|| (mainItems[i].className == "portletItem itemLight") || (mainItems[i].className == "portletItem itemDark"))) {
			// alert("calcul taille"+ mainItems[i].className);
			// first change the background for the global page (containing the
			// portlets)
			globalPageId.style.backgroundColor = "white";

			height = mainItems[i].offsetHeight;
			if (k % 2 == 0) {
				columnHeight[k] = height;
			} else {
				columnHeight[k] = columnHeight[k - 1] > height ? columnHeight[k - 1]
						: height;
				columnHeight[k - 1] = columnHeight[k];
			}

			k++;
		}

		if (mainItems[i].className == "double") {
			height = 0;
			for ( var j = 0; mainItems[i].childNodes[j] != undefined; j++) {
				if (mainItems[i].childNodes[j].offsetHeight != undefined) {
					height = height > mainItems[i].childNodes[j].offsetHeight ? height
							: mainItems[i].childNodes[j].offsetHeight;
					height = 130;
				}
			}
			if (k % 2 == 0) {
				columnHeight[k] = height;
			} else {
				columnHeight[k] = columnHeight[k - 1] > height ? columnHeight[k - 1]
						: height;
				columnHeight[k - 1] = columnHeight[k];
			}
			k++;
		}
	}

	k = 0;
	var color = 0;

	for ( var i = 0; mainItems[i] != undefined; i++) {
		if ((mainItems[i].offsetHeight != undefined)
				&& ((mainItems[i].className == "portletItem")
						|| (mainItems[i].className == "portletItem itemLight")
						|| (mainItems[i].className == "portletItem itemDark") || (mainItems[i].className == "searchDiv itemDark"))) {
			mainItems[i].style.height = columnHeight[k] + "px";

			if (mainItems[i].className != "double") {
				color = colorize(mainItems[i], color);
				k++;
			}
		}

		if (mainItems[i].className == "double") {
			for ( var j = 0; mainItems[i].childNodes[j] != undefined; j++) {
				if (mainItems[i].childNodes[j].clientHeight != undefined) {
					mainItems[i].childNodes[j].style.height = columnHeight[k]
							+ "px";
				}
			}
			k++;
			color++;
		}
	}
}

function colorize(style, color) {

	if (color % 4 == 0) {
		style.className = "portletItem itemLight";
	} else if (color % 4 == 1) {
		style.className = "portletItem itemDark";
	} else if (color % 4 == 2) {
		style.className = "portletItem itemDark";
	} else if (color % 4 == 3) {
		style.className = "portletItem itemLight";
	}

	color++;
	return (color);
}

function closePortletItem(id, contextPath) {
	var URL;
	if (contextPath != undefined) {
		URL = contextPath + "/portal/user/closePortletItem.do?id=" + id;
	} else {
		URL = "/portal/user/closePortletItem.do?id=" + id;
	}
	window.location.href = URL;
}

function closePopup(itemId) {
	var obj = document.getElementById(itemId);

	var div = document.getElementById('body');
	div.removeChild(obj);
	setCookie("nopopup", 1);
}

function saveConfig(type) {
	window.location.href = "/portal/index.jsp?";
	/*
	 * var URL;
	 * 
	 * URL = "/portal/index.jsp?";
	 * 
	 * var main;
	 * 
	 * var mainItems;
	 * 
	 * main = document.getElementById("main");
	 * 
	 * mainItems = main.childNodes;
	 * 
	 * for (var i = 0; mainItems[i] != undefined; i++) { if((mainItems[i].id !=
	 * undefined)&&(mainItems[i].className!="spacer")&&(mainItems[i].className!="popup")) {
	 * 
	 * URL = URL + "items[]=" + mainItems[i].id+"&"; } }
	 * 
	 * 
	 * if(type == "ADD") { select = document.getElementById("selectedItem");
	 * 
	 * selection = select.value; if(selection != "empty") { URL = URL +
	 * "newItem="+selection; } } if(type == "DaD") { URL = URL + "DaD=1"; }
	 * 
	 * window.location.href = URL;
	 */
}

function addPortletItem(itemId, contextPath, itemType) {
	var URL;
	if (contextPath != undefined) {
		URL = contextPath + "/portal/user/addPortletItem.do?itemId=" + itemId
				+ "&itemType=" + itemType;
	} else {
		URL = "/portal/user/addPortletItem.do?itemId=" + itemId + "&itemType="
				+ itemType;
	}
	window.location.href = URL;
}

function enableDaD() {
	select = document.getElementById("DaD");

	if (select.checked) {
		document.onmousedown = startDrag;
		document.onmouseup = endDrag;
		document.onclick = callbackClick;
		document.body.style.cursor = "move";
	} else {
		document.onmousedown = (null);
		document.onmouseup = (null);
		document.onclick = (null);
		document.body.style.cursor = "default";
		saveConfig("DaD");
	}

}

function setCookie(name, value, expires, path, domain, secure) {
	var curCookie = name + "=" + escape(value)
			+ ((expires) ? "; expires=" + expires.toGMTString() : "")
			+ ((path) ? "; path=" + path : "")
			+ ((domain) ? "; domain=" + domain : "")
			+ ((secure) ? "; secure" : "");
	document.cookie = curCookie;
}

function minimiseItem(id) {

	var main;

	var mainItems;

	main = document.getElementById(id);

	if (main == undefined) {
		return;
	}

	mainItems = main.childNodes;

	for ( var i = 0; mainItems[i] != undefined; i++) {

		if ((mainItems[i].offsetHeight != undefined)
				&& ((mainItems[i].className == "portletItem")
						|| (mainItems[i].className == "portletItem itemLight") || (mainItems[i].className == "portletItem itemDark"))) {

			if (mainItems[i].style.visibility == "hidden") {
				mainItems[i].style.visibility = "visible";
				mainItems[i].style.height = "";
				mainItems[i].style.display = "";
			} else {
				mainItems[i].style.visibility = "hidden";
				mainItems[i].style.display = "none";
				// mainItems[i].style.overflow = "hidden";

				// mainItems[i].style.height="1px";
			}

		}

	}
	recadre("main");

}
