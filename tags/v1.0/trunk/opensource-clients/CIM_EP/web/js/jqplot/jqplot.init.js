// Note that there's a bug in jqplot and its extensions
// There were mentions of jQuery instead of $ and it caused issues in events handling (because "jQuery" references Liferay's jQuery 1.2 instead of jQuery 1.4)
// so I changed those references in the .js files and that's why some files are not included in their minified version in facelets.
// JPR 2011

jQueryplot = jQuery;

function plotRegisterEvents() {
//	var plot = jQueryplot('#chartdiv');
//	plot.bind('jqplotDataClick', function(ev, seriesIndex, pointIndex, data) {
//		jQueryplot('#chartinfo').html(
//				'series: ' + seriesIndex + ', point: ' + pointIndex
//						+ ', data: ' + data);
//	});
//	plot.bind('jqplotDataMouseOver',
//			function(ev, seriesIndex, pointIndex, data) {
//				jQueryplot('#chartinfo').html(new Date().getTime());
//			});
//
//	plot.bind('jqplotZoom', function(gridpos, datapos, plot, cursor, a, b) {
//		console.log(gridpos);
//		console.log(datapos);
//		console.log(plot);
//		console.log(cursor);
//		console.log(a);
//	});
}

function plotChart(data) {

	var timePeriod = data.truncate;

	// month
	var formatString = "%b '%y";
	var tickIntervalX = "1 month";
	if (timePeriod == "5") {
		// day
		formatString = "%#d %b '%y";
		tickIntervalX = "1 day";
	} else if (timePeriod == "10") {
		// hour
		formatString = "%R";
		tickIntervalX = "1 hour";
	} else if (timePeriod == "1") {
		// year
		formatString = "'%y";
		tickIntervalX = "1 year";
	}

	var options = {
		axesDefaults : {
			tickRenderer : jQueryplot.jqplot.CanvasAxisTickRenderer,
			tickOptions : {
				fontSize : '12px'
			}
		},
		axes : {
			xaxis : {
				renderer : jQueryplot.jqplot.DateAxisRenderer,
				tickOptions : {
					formatString : formatString
				},
				min : data.minDate,
				max : data.maxDate,
				tickInterval : tickIntervalX
			},
			yaxis : {
				tickOptions : {
					formatString : "%d"
				},
				min : 0,
				max : data.maxValue,
				tickInterval : data.tickInterval
			}
		},
		highlighter : {
			show : true,
			sizeAdjust: 7.5
		},
		seriesDefaults : {
			showMarker : true,
			markerOptions : {
				style : 'filledCircle'
			},
			pointLabels : {
				show : true,
				edgeTolerance: 5
			}
		},
		series : [ {
			neighborThreshold : -1
		} ],
		cursor : {
			dblClickReset : true,
			constrainZoomTo : 'x',
			zoom : true,
			show : true,
			showTooltip : false
		}
	};

	var points = [];
	var i = 0;
	for (key in data.points) {
		var value = data.points[key];
		var point = [ parseInt(key, 10), value ];
		points[i] = point;
		i++;
	}
	jQueryplot.jqplot.preDrawHooks.push(plotRegisterEvents);
	jQueryplot.jqplot('chartdiv', [ points ], options);

}