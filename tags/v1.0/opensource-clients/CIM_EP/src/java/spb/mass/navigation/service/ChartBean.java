package spb.mass.navigation.service;

import java.util.Calendar;
import java.util.Date;
import java.util.TreeMap;

import javax.faces.event.ActionEvent;

import org.ajax4jsf.model.KeepAlive;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;

import spb.mass.navigation.messages.FacesMessageUtil;
import spb.mass.navigation.service.search.model.SearchResultItem;
import spb.mass.navigation.service.search.model.SearchResultProperty;
import spb.mass.navigation.service.search.model.SearchResultSet;
import spb.mass.navigation.utils.DateUtil;

@KeepAlive
public class ChartBean {
	private ServiceBean searchResultBean;
	private Logger log = Logger.getLogger(getClass());

	private PointsModel points;

	public void buildChart(ActionEvent ae) {
		log.debug("Starting building chart ...");
		String startDateProperty = NavigationUtils.getRequestParameter("startDate");
		String endDateProperty = NavigationUtils.getRequestParameter("endDate");
		String datePattern = NavigationUtils.getRequestParameter("datePattern");
		SearchResultSet resultSet = searchResultBean.getResultSet();

		String[] patterns = new String[DateUtil.DATEPATTERNS.length + 1];
		System.arraycopy(DateUtil.DATEPATTERNS, 0, patterns, 0,
				DateUtil.DATEPATTERNS.length);
		patterns[DateUtil.DATEPATTERNS.length] = datePattern;

		PointsModel points = new PointsModel();
		try {
			// find min, find max, and decide what unit to use for truncate
			Date minDate = new Date();
			Date maxDate = new Date(0);

			for (SearchResultItem item : resultSet.getItems()) {
				SearchResultProperty startDate = item.getProperties().get(
						startDateProperty);
				SearchResultProperty endDate = item.getProperties().get(
						endDateProperty);
				if (startDate != null && startDate.getValue() != null) {
					Date start = DateUtils.parseDate(startDate.getValue(),
							patterns);
					if (start.before(minDate)) {
						minDate = start;
					}
					if (start.after(maxDate)) {
						maxDate = start;
					}
				}
				// if (endDate != null && endDate.getValue() != null) {
				// Date end = sdf.parse(endDate.getValue());
				// if (end.after(maxDate)) {
				// maxDate = end;
				// }
				// }
			}
			log.debug("minData: " + minDate);
			log.debug("maxData: " + maxDate);

			int truncate = Calendar.YEAR;
			if (DateUtil.isSameYear(minDate, maxDate)) {
				truncate = Calendar.MONTH;
			} else if (DateUtils.isSameDay(minDate, maxDate)) {
				truncate = Calendar.HOUR;
			} else if (DateUtil.isSameMonth(minDate, maxDate)) {
				truncate = Calendar.DATE;
			}
			points.setTruncate(truncate);

			// iterate over the properties and count, building the chart
			for (SearchResultItem item : resultSet.getItems()) {
				SearchResultProperty startDate = item.getProperties().get(
						startDateProperty);
				SearchResultProperty endDate = item.getProperties().get(
						endDateProperty);
				if (startDate != null && startDate.getValue() != null) {

					Date start = DateUtils.parseDate(startDate.getValue(),
							patterns);
					// Date end = sdf.parse(endDate.getValue());

					Long key = DateUtils.truncate(start, truncate).getTime();
					Integer value = points.getPoints().get(key);
					if (value == null) {
						value = 0;
					}

					points.getPoints().put(key, value + 1);
				}
			}

		} catch (Exception e) {
			FacesMessageUtil.addErrorMessage(e);
		}

		this.points = points;
	}

	public class PointsModel {
		// key: time, value: count
		private TreeMap<Long, Integer> points = new TreeMap<Long, Integer>();;
		private int truncate;

		public long getMinDate() {
			long longDate = 0;
			if (!points.isEmpty()) {
				longDate = points.firstKey();
			}
			Date date = new Date(longDate);
			return DateUtils.add(date, truncate, -1).getTime();
		}

		public long getMaxDate() {
			long longDate = new Date().getTime();
			if (!points.isEmpty()) {
				longDate = points.lastKey();
			}
			Date date = new Date(longDate);
			return DateUtils.add(date, truncate, 1).getTime();
		}

		public int getMaxValue() {
			int maxValue = 0;
			for (Integer i : points.values()) {
				maxValue = Math.max(maxValue, i);
			}
			return maxValue;
		}

		public int getTickInterval() {
			int maxValue = getMaxValue();
			int tick = (int) Math.ceil((double) maxValue / 3d);
			if (tick < 1) {
				// making sure tickInterval is not 0 even though it should never
				// happen, it crashes jqplot.
				tick = 1;
			}
			return tick;
		}

		/* GETTERS AND SETTERS */

		public TreeMap<Long, Integer> getPoints() {
			return points;
		}

		public void setPoints(TreeMap<Long, Integer> points) {
			this.points = points;
		}

		public int getTruncate() {
			return truncate;
		}

		public void setTruncate(int truncate) {
			this.truncate = truncate;
		}

	}

	/* GETTERS AND SETTERS */
	public ServiceBean getSearchResultBean() {
		return searchResultBean;
	}

	public void setSearchResultBean(ServiceBean searchResultBean) {
		this.searchResultBean = searchResultBean;
	}

	public PointsModel getPoints() {
		return points;
	}

	public void setPoints(PointsModel points) {
		this.points = points;
	}

}
