<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="ridleyjack.insta.data.Database" %>
<%@ page import="ridleyjack.insta.util.Security" %>
<%@include file="header.jsp" %>
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
String username = request.getParameter("username");
String password = Security.genhash_SHA256(request.getParameter("password"));

session = request.getSession();

try(Connection con = Database.getConnection()){
	//Try and find username + password in database
	String sql = "Select password, accountId, adminLevel From Account Where loginName=? and password=?";
	PreparedStatement stmt = con.prepareStatement(sql);
	stmt.setString(1, username);
	stmt.setString(2,password);
	ResultSet rslt = stmt.executeQuery();
	
	//Look at result set
	if(rslt.next()){ //found
		session.setAttribute("authenticatedUser", username);
		session.setAttribute("authenticatedUserId", rslt.getString("accountId"));
		session.setAttribute("isAdmin", rslt.getInt("adminLevel"));
		session.removeAttribute("loginMessage");
		out.print("Login Successful!");
	}
	else{ //not found
		session.setAttribute("loginMessage", "Invalid Username or Password!");
		response.sendRedirect("loginForm.jsp");//go back to login form		
	}
	
}

%>