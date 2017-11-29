<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  
<%@ page import="ridleyjack.insta.data.Database" %> 

<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
<%
try ( Connection con = Database.getConnection();) 
{
	//Indicate that we are sending a JPG picture
	response.setContentType("image/jpeg");  	
	//Get the image id
	String id = request.getParameter("id");
	if (id == null||id.equals("0")){
		int BUFFER_SIZE = 10000;
		byte[] data = new byte[BUFFER_SIZE];
		InputStream stream = getServletContext().getResourceAsStream("/Images/missing.jpg"); 
		OutputStream ostream = response.getOutputStream();
		int count;
		while ( (count = stream.read(data, 0, BUFFER_SIZE)) != -1)
			ostream.write(data, 0, count);

		ostream.flush();
		stream.close();	
		return;
	}

	int idVal = -1;
	try{
		idVal = Integer.parseInt(id);
	}
	catch(Exception e)
	{	
		int BUFFER_SIZE = 10000;
		byte[] data = new byte[BUFFER_SIZE];
		InputStream stream = getServletContext().getResourceAsStream("/Images/missing.jpg"); 
		OutputStream ostream = response.getOutputStream();
		int count;
		while ( (count = stream.read(data, 0, BUFFER_SIZE)) != -1)
			ostream.write(data, 0, count);

		ostream.flush();
		stream.close();	
		return; 
	}
	
	PreparedStatement stmt = con.prepareStatement("SELECT imageData FROM Image WHERE imageId=?");
	stmt.setInt(1, idVal);
	ResultSet rst = stmt.executeQuery();		

	int BUFFER_SIZE = 100000;
	byte[] data = new byte[BUFFER_SIZE];

	if (rst.next())
	{
		// Copy stream of bytes from database to output stream for JSP/Servlet
		InputStream istream = rst.getBinaryStream(1);
		OutputStream ostream = response.getOutputStream();

		int count;
		while ( (count = istream.read(data, 0, BUFFER_SIZE)) != -1)
			ostream.write(data, 0, count);

		ostream.flush();
		istream.close();					
	}
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
%>