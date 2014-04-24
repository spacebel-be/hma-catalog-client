package spb.mass.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShowMetadata extends HttpServlet {		
	private static final long serialVersionUID = -2632072549851504837L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {		
		String xmlString = req.getParameter("xmlString");		
		StringBuffer xmlBuffer = new StringBuffer();
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		if(xmlString != null){
			xmlBuffer.append(xmlString);
		}		
		resp.setContentType("text/xml");		
		resp.getWriter().write(xmlBuffer.toString());	
	}
}
