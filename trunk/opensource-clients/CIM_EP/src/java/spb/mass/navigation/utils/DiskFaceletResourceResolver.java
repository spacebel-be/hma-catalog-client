package spb.mass.navigation.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;

import org.apache.log4j.Logger;

import com.sun.facelets.impl.DefaultResourceResolver;

/**
 * This class allows facelets to be included and referenced in other facelets
 * even if they are not in the directory of the application. The Resolver is
 * registered with the facelets.RESOURCE_RESOLVER init parameter in the web.xml
 * file.
 * 
 * @author jpr
 * 
 */
public class DiskFaceletResourceResolver extends DefaultResourceResolver {
	private final Logger log = Logger.getLogger(getClass());

	@Override
	public URL resolveUrl(String path) {
		URL url = null;
		try {
			url = super.resolveUrl(path);
			if (url == null) {
				File file = new File(path);
				if (file.exists()) {
					/**
					 * By passing a handler instead of the path to the file, we
					 * are able to manage the modification time. See
					 * getLastModified() below.
					 */
					url = new URL("internal", null, 0, path, getHandler(file));

				} else {
					throw new MalformedURLException("File doesn't exist: "
							+ path);
				}
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		return url;
	}

	private static URLStreamHandler getHandler(final File file) {

		return new URLStreamHandler() {
			@Override
			protected URLConnection openConnection(URL url) throws IOException {
				return new URLConnection(url) {
					@Override
					public void connect() throws IOException {
						// nothing to do here
					}

					@Override
					public InputStream getInputStream() throws IOException {
						return new FileInputStream(file);
					}

					@Override
					public long getLastModified() {
						return file.lastModified();
					}

				};
			}

		};

	}

}
