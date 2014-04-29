package spb.mass.navigation.service.search;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.faces.component.UIComponentBase;
import javax.faces.component.html.HtmlGraphicImage;
import javax.faces.context.FacesContext;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import spb.mass.navigation.messages.FacesMessageUtil;
import spb.mass.navigation.utils.HtmlLinkComponent;

/**
 * Outputs the logo of the company corresponding to the collectionId, if found.
 * 
 * @author jpr
 * 
 */
public class CompanyLogoComponent extends UIComponentBase {	

	@Override
	public void encodeBegin(FacesContext context) throws IOException {
		super.encodeBegin(context);

		Map<String, ImageAndWebsite> properties = new LinkedHashMap<String, ImageAndWebsite>();
		// read properties in order
		List<String> lines = IOUtils.readLines(getClass().getClassLoader()
				.getResourceAsStream("companies_logo.properties"));
		for (String line : lines) {
			if (StringUtils.isNotBlank(line) && !line.startsWith("#")) {
				line = StringEscapeUtils.unescapeJava(line);
				String[] keyVal = line.split("=");
				String key = keyVal[0];
				String val = keyVal[1];

				ImageAndWebsite imageAndWebsite = new ImageAndWebsite();
				String[] values = val.split(",");
				imageAndWebsite.setImage(values[0].trim());
				if (values.length > 1) {
					imageAndWebsite.setWebsite(values[1].trim());
				}
				properties.put(key.trim(), imageAndWebsite);
			}
		}

		String collectionId = (String) getAttributes().get("collectionId");
		String styleClass = (String) getAttributes().get("styleClass");
		String finalClass = "company-logo";
		if (StringUtils.isNotBlank(styleClass)) {
			finalClass += " " + styleClass;
		}

		ImageAndWebsite imageAndWebsite = null;

		for (String key : properties.keySet()) {
			if (StringUtils.startsWithIgnoreCase(collectionId, key)) {
				imageAndWebsite = properties.get(key);
				break;
			}
		}

		if (imageAndWebsite != null) {
			HtmlLinkComponent link = new HtmlLinkComponent(
					imageAndWebsite.getWebsite(), null, "_blank");
			HtmlGraphicImage image = new HtmlGraphicImage();
			image.setStyleClass(finalClass);
			image.setValue("/images/companies/" + imageAndWebsite.getImage());
			image.setTitle(FacesMessageUtil
					.getLocalizedString("searchresults.label.visitcompanywebsite"));

			link.getChildren().add(image);
			image.setParent(link);
			link.encodeAll(context);
		}
	}

	private class ImageAndWebsite {
		private String image;
		private String website;

		public String getImage() {
			return image;
		}

		public void setImage(String image) {
			this.image = image;
		}

		public String getWebsite() {
			return website;
		}

		public void setWebsite(String website) {
			this.website = website;
		}

	}

	@Override
	public String getFamily() {
		return getClass().getName();
	}
}
