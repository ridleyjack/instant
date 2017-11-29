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
<div class=list>
<%


// Print prior error login message if present (from sample code)
if (session.getAttribute("loginMessage") != null){
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
	session.removeAttribute("loginMessage");
}
%>
<form id="loginForm" method="post" action="login.jsp">
	<p>User name:<br>
	<input type="text" name="username"></p>
	<p>Password:<br>
	<input type="password" name="password"><br></p>
	<input type="submit" value="login">
</form>
<form id="createAcc" action="createAccountForm.jsp">
	<input type="submit" value="Create Account">
</form>
</div>
</body>
</html>