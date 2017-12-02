<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  

<%@ page import="org.apache.commons.fileupload.FileUpload, org.apache.commons.fileupload.servlet.ServletFileUpload, org.apache.commons.fileupload.FileItem, org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.io.File"%>

<%@include file="../database.jsp" %> 
<%@include file="validateAdmin.jsp" %>
<%
try
{		
	/* 
		Note: Since HTML request is in one multi-part block.  You cannot use request.getParameter() to retrieve other 
		form parameters.  Instead, fields are processed using FileItem (see below).
		
		Documentation: http://commons.apache.org/proper/commons-fileupload/using.html
	*/
	
	StringBuilder msgBuilder = new StringBuilder("");
	
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (!isMultipart)
	{	out.println("Error. Expecting multi-part HTML file upload.");
		return;
	}
	// Create a factory for disk-based file items
	DiskFileItemFactory factory = new DiskFileItemFactory();
	// Configure a repository (to ensure a secure temp location is used)
	ServletContext servletContext = this.getServletConfig().getServletContext();
	File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
	factory.setRepository(repository);
	// Create a new file upload handler
	ServletFileUpload upload = new ServletFileUpload(factory);
	
    // If file size exceeds 10 MB, a FileUploadException will be thrown
    upload.setSizeMax(10000000);
	boolean saveToDB = true;
    List<FileItem> fileItems = upload.parseRequest(request);
    Iterator<FileItem> itr = fileItems.iterator();
	while (itr.hasNext()) 
	{
		FileItem fi = (FileItem) itr.next();
		// Check if not form field so as to only handle the file inputs
		// else condition handles the submit button input
		if (!fi.isFormField()) 
		{
			String localName = null;
		
			// Write-out to a local file using only the file name.
			// Note: You should put into its own directory and make sure about duplicate file names.
			// The file gets saved by default in the directory where the JSP is located.
			String baseName = stripClientPath(fi.getName());
			
			//Some validation checks
			if(baseName.equals("")){
				request.setAttribute("uploadMsg", "File must have a name");
				request.getRequestDispatcher("imageuploaderForm.jsp").forward(request, response);
				return;
			}
			if(!baseName.contains(".jpg")){
				request.setAttribute("uploadMsg", "File must be of type '.jpg'");
				request.getRequestDispatcher("imageuploaderForm.jsp").forward(request, response);
				return;
			}
			//same name check
			Connection con = getConnection();
			PreparedStatement getImage = con.prepareStatement("SELECT imageId FROM Image WHERE fileName=?");
			getImage.setString(1, baseName);
			ResultSet image = getImage.executeQuery();
			if(image.next()){
				msgBuilder.append("file with name "+baseName+" already exists in db at imageId: "+ image.getString(1) + " ");
				continue;
			}
			
			localName = application.getRealPath("/") + baseName;
			int fileSize = (int) fi.getSize();
			if (!saveToDB) 
			{
				//out.print("<H3>Remote name: " + fi.getName() + " Local name: " + localName + "  Size: " + fileSize + "</H3>");
				File fNew = new File(localName);
				fi.write(fNew);
			} 
			else 
			{
				//  1) Create a PreparedStatement that will do the insert.
				//  2) Pass the PreparedStatement a InputStream for the BLOB.
				//  Our table definition: (uses image type instead of BLOB as done on SQL Server)
				// create table pictures (
				// id int IDENTITY PRIMARY KEY NOT NULL ,
				// fileName VARCHAR(100),
				// fileData image );
				String stmtSQL = "INSERT INTO Image (fileName, imageData) VALUES (?,?);";
				PreparedStatement stmt = con.prepareStatement(stmtSQL);
				stmt.setString(1, baseName);
				stmt.setBinaryStream(2, fi.getInputStream(), fileSize);
				stmt.executeUpdate();
				
				//out.println("<H3>Inserted file: " + localName + " size: " + fileSize + " into database</H3>");
				msgBuilder.append("Inserted File: " + baseName + " Size: " + fileSize + " into database");
				if(itr.hasNext()) msgBuilder.append(", ");
			}
		} 
		else 
		{
			//out.println("<H3>Form parameter field =" + fi.getFieldName() + "</H3>");
		}
	}
	//out.println("<H2>Done processing all files.</H2>");
	
	//Go back to the original form with msg
	request.setAttribute("uploadMsg", msgBuilder.toString());
	request.getRequestDispatcher("imageuploaderForm.jsp").forward(request, response);
} 
catch (Exception e) 
{
	out.println("<H2>Error: " + e + "</H2>");
}
%>

<%!
private String stripClientPath(String s) 
{	// Strips the client path from a filename and returns only the filename itself
	if (s==null)
		return null;
	String filepath = null;
	String filename = null;
	int pos = s.lastIndexOf('\\');		// Search for last \
	if (pos >= 0)
	{
		filepath = s.substring(0,pos);
		filename = s.substring(pos + 1);
	}
	else
		filename = s;
	return filename;
}
%>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Image Upload</title>
</head>
<body>
</body>
</html>