package spb.mass.navigation.utils;

import javax.faces.context.FacesContext;

/**
 * Provides utility functions to lookup managed beans.
 * 
 * @author jpr
 * 
 */
public class ManagedBeanUtil {

	/**
	 * Returns the name of the class with a lower case first letter.
	 * 
	 * @param klass
	 * @return
	 */
	public static String toScopeName(Class<?> klass) {
		String className = klass.getSimpleName();
		return className.substring(0, 1).toLowerCase() + className.substring(1);
	}

	@SuppressWarnings("unchecked")
	public static <T> T lookup(Class<T> klass) {
		return (T) lookup(toScopeName(klass));
	}

	/**
	 * Looks the managed bean up in the current context
	 * 
	 * @param <T>
	 * @param className
	 * @return
	 */
	public static Object lookup(String className) {
		FacesContext fc = FacesContext.getCurrentInstance();
		Object object = fc.getApplication().getELResolver()
				.getValue(fc.getELContext(), null, className);
		return object;
	}
}
