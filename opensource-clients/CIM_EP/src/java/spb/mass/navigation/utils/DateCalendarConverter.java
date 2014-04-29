package spb.mass.navigation.utils;

import java.util.Date;
import java.util.TimeZone;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.DateTimeConverter;

import org.apache.log4j.Logger;

/**
 * Use this converter to store dates as strings and not as Date objects.
 * 
 * @author jpr
 * 
 */
public class DateCalendarConverter extends DateTimeConverter {	

	public DateCalendarConverter() {
		super();
		setTimeZone(TimeZone.getDefault());
	}

	public DateCalendarConverter(String pattern, TimeZone timeZone) {
		super();
		setTimeZone(timeZone);
		setPattern(pattern);
	}

	@Override
	public Object getAsObject(FacesContext context, UIComponent component,
			String value) {
		return value;
	}

	@Override
	public String getAsString(FacesContext context, UIComponent component,
			Object value) {

		String result = null;

		if (value == null || "".equals(value)) {
			result = super.getAsString(context, component, new Date());			
		} else if (value instanceof Date) {
			result = super.getAsString(context, component, value);			
		} else if (value instanceof String) {
			result = (String) value;			
		}
		return result;
	}

}
