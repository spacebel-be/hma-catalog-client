/*
 * FileUtility.java
 *
 * Copyright (c) 2002 Spacebel S.A.
 * I. Vandammestraat 5-7, 1560 Hoeilaart, Belgium
 * All rights reserved.
 * Created on Aug 10, 2004 by tnn
 *
 * History:
$Log$
Revision 1.3  2008/01/30 12:39:32  jhn
uddi registration
- retrieve WSDL file from newly generated WSDL url

Revision 1.2  2004/10/18 16:04:54  tnn
implement copy file and directory functions

Revision 1.1  2004/09/08 09:31:00  tnn
implementing exception control functions

 * End of history.
 *
 */
package spb.mass.business.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLConnection;

public class FileUtility {
	
	private static String convertName(String input) {
		
		return input.replace(' ', '_').replace('-', '_');
	}
    
    public static String generateServiceFileName(String companyName, String serviceName, String fileType) {
    	
		return convertName(companyName) + "_" + convertName(serviceName) + "." + fileType;
	}

	/**
	 * read file content and assign to a string
	 */
	public static String readFileContent(String filename) throws FileNotFoundException, IOException {

		FileReader fr = new FileReader(new File(filename));
		StringWriter sw = new StringWriter();
		int c;
		while ((c = fr.read()) != -1)
			sw.write(c);
		return sw.toString();
	}
	public static String readFileContent(File file) throws FileNotFoundException, IOException {

		FileReader fr = new FileReader(file);
		StringWriter sw = new StringWriter();
		int c;
		while ((c = fr.read()) != -1)
			sw.write(c);
		return sw.toString();
	}
	/**
	 * Copies src file to dst file.
	 * If the dst file does not exist, it is created
	 * @param src
	 * @param dst
	 * @throws IOException
	 */

	public void copyFile(File src, File dst) throws IOException {
		InputStream in = new FileInputStream(src);
		OutputStream out = new FileOutputStream(dst);


		byte[] buf = new byte[1024];
		int len;
		while ((len = in.read(buf)) > 0) {
			out.write(buf, 0, len);
		}
		in.close();
		out.close();
	}
	/**
	 * Copies all files under srcDir to dstDir.
	 * If dstDir does not exist, it will be created.
	 * @param srcDir
	 * @param dstDir
	 * @throws IOException
	 */

	public void copyDirectory(File srcDir, File dstDir) throws IOException {

		if (srcDir.isDirectory()) {
			if (!dstDir.exists()) {
				if(!dstDir.mkdirs())  throw new IOException("cannot create directory: " + dstDir.getAbsolutePath());
			}

			String[] children = srcDir.list();
			for (int i=0; i<children.length; i++) {
				copyDirectory(new File(srcDir, children[i]),
						new File(dstDir, children[i]));
			}
		} else {

			copyFile(srcDir, dstDir);
		}
	}
	/**
	 * delete a directory
	 * @param dir
	 * @return
	 */
	public boolean deleteDir(File dir) {
		if (dir.isDirectory()) {
			String[] children = dir.list();
			for (int i=0; i<children.length; i++) {
				boolean success = deleteDir(new File(dir, children[i]));
				if (!success) {
					return false;
				}
			}
		}

		// The directory is now empty so delete it
		return dir.delete();
	}
	public static void main(String[] args) {
		File sDir = new File(".\\bpel");


		try {
			FileUtility util = new FileUtility();
			if(util.deleteDir(sDir)) System.out.println("delete dir " + sDir.getAbsolutePath() + " successfully");

		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}	

	public static void urlToFile(String urlName, File fileName) 
		throws FileNotFoundException, IOException {
		URL url = new URL(urlName);
        URLConnection urlc = url.openConnection();

        BufferedInputStream bis = new BufferedInputStream( urlc.getInputStream());
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(fileName));

        int i;
        while ((i = bis.read()) != -1)
        {
           bos.write( i );
        }
        
        bis.close();
        bos.close();
	}
	
	public static void stringToFile(String content, String filename) throws FileNotFoundException, IOException 
	{
		BufferedWriter writer = null;
        writer = new BufferedWriter(new FileWriter(filename));
        writer.write( content);
        writer.flush();
        writer.close();
	}
}
