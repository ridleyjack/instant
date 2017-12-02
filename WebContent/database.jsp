<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.naming.Context" %> 
<%@ page import="javax.naming.InitialContext" %>  
<%@ page import="javax.naming.NamingException" %> 
<%@ page import="javax.sql.DataSource" %> 



<%!
public Connection getConnection() throws SQLException{
	DataSource dataSource = null;
	try
	{	// Load driver class
		Class.forName("com.mysql.jdbc.Driver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		System.out.println("ClassNotFoundException: " +e);
	}
	//Thread pool not working on cosc304 machine
	/*
	try {		
		// Get DataSource
		Context initContext  = new InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		dataSource = (DataSource)envContext.lookup("jdbc/db_settings");
	} catch (NamingException e) {
		e.printStackTrace();
	}

		*/
		//return dataSource.getConnection();
		
	String url="jdbc:mysql://cosc304.ok.ubc.ca/db_jjackson";
	String usr="jjackson";
	String pass="86696549";
	return DriverManager.getConnection(url,usr,pass);
}
%>

