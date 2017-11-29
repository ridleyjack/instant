<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<%@include file="database.jsp" %>
<%@include file="security.jsp" %>
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
if(request.getParameter("password") == null || request.getParameter("password")==""){
	session.setAttribute("loginMessage", "Please enter a password!");
	response.sendRedirect("loginForm.jsp");
	return;
}

String username = request.getParameter("username");
String password = genhash_SHA256(request.getParameter("password"));

try(Connection con = getConnection()){
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
		session.setAttribute("loginMessage", "Login Successful!");
		response.sendRedirect("loginForm.jsp");
	}
	else{ //not found
		session.setAttribute("loginMessage", "Invalid Username or Password!");
		response.sendRedirect("loginForm.jsp");//go back to login form		
	}	
}catch(SQLException ex){out.print(ex);}

%>