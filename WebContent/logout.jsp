<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
//were we logged in?
if(session.getAttribute("authenticatedUser") == null){
	session.setAttribute("loginMessage", "You Need To Have Been Logged In To Log Out!");
	response.sendRedirect("loginForm.jsp");
	return; //do nothing
}
//we were

session.setAttribute("authenticatedUser", null);
session.setAttribute("authenticatedUser", null);
session.setAttribute("isAdmin",null);
session.setAttribute("loginMessage", "Successfully Logged Out!");
//TODO: Save Cart To Database here
response.sendRedirect("loginForm.jsp");


%>
</body>
</html>