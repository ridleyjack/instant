<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<style>
form {
text-align: center;
padding-top: 10px;
}
</style>

<title>login</title>
</head>

<body>

<%
// Print prior error login message if present (from sample code)
if (session.getAttribute("loginMessage") != null){
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
	session.removeAttribute("loginMessage");
}
%>

<form id="loginForm" method="post" action="login.jsp">
	User name:<br>
	<input type="text" name="username"><br>
	Password:<br>
	<input type="password" name="password"><br><br>
	<input type="submit" value="login">
</form>
<form id="createAcc" action="createAccountForm.jsp">
	<input type="submit" value="Create Account">
</form>

</body>
</html>