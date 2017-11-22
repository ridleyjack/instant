<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<% 
//Check if the user is logged in
if (session.getAttribute("authenticatedUser") != null){
	request.setAttribute("username", session.getAttribute("authenticatedUser"));
}
else{
	request.setAttribute("username", null);
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<style>
#navigation{
    border-collapse: collapse;
    width: 100%;
    text-align:center
}

#navigation, #navigation th, #navigation td {
    border: 1px solid black;
}
hr{
margin-top: 30px;
margin-bottom: 30px;
}
</style>

<body>
<c:choose>
    <c:when test="${username == Null }">
        <p>Not Logged In: <a href="loginForm.jsp">Log In</a></p>
    </c:when>
    <c:otherwise>
        <p>Logged In: <b><c:out value="${username}"/></b>
        <a href="logout.jsp">Log Out</a></p>
    </c:otherwise>      
</c:choose>

<h1 style="text-align:center;">Instant Degree</h1>

<form>
	<table id="navigation">
	<tr>
	<td><a href="index.jsp">Home</a></td>
	<td><a href="createdegree.jsp">Make a Degree</a></td>
	<td><a href="listprod.jsp">Products</a></td>
	<td><a href="showcart.jsp">Cart</a></td>
	<td><a href="account.jsp">Account</a></td>
	</tr>
	</table>
</form>
<hr>
</body>
</html>