<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="ridleyjack.insta.data.Database" %> 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@ page import="java.util.Scanner" %> 
<%@ page import="java.io.File" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>
<%
String admin = session.getAttribute("isAdmin").toString();
Integer isadmin = null;
try{isadmin = Integer.parseInt(admin);
	
}catch(Exception e){return;}
if(isadmin==1){
System.out.println("Connecting to database.");

String url="jdbc:mysql://cosc304.ok.ubc.ca/db_zbentsen";
String usr="zbentsen";
String pass="45705150";
Connection con = DriverManager.getConnection(url,usr,pass);
System.out.println("Connected");
String fileName = "data/finalproject.ddl";

try
{
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        System.out.println(command);        // Uncomment if want to see commands executed
        try
        {
        	stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
        	System.out.println(e);
        }
    }	 
    scanner.close();
}
catch (Exception e)
{
    System.out.println(e);
}   }
else{
	out.print("You do not have access to this.");
}
%>