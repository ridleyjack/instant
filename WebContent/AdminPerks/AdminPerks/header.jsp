<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<% 
//Check if the user is logged in
if (session.getAttribute("authenticatedUser") != null){
	request.setAttribute("username", session.getAttribute("authenticatedUser"));
	request.setAttribute("admin",session.getAttribute("isAdmin"));
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
body {
	background-image:url("/Images/Graduation.jpeg");
	background-repeat:no-repeat;
	background-align:center;
	background-color:#000066
}

#navigation{								
    border-collapse: collapse;
    width: 100%;
    text-align:center;
    text-color:#ffffff;
    background-color:#020230
}

#logoSlogan{
	border-collapse: collapse;
	width:100%;
}

#navigation, #navigation th, #navigation td {
    border: 1px solid #020230;
}
hr{
margin-top: 30px;
margin-bottom: 30px;
}
</style>

<c:choose>
<c:when test= "${isAdmin==1 }">
 <p>Admin Page: <a href="admin.jsp"> private</a></p>
</c:when>
</c:choose>
<c:choose>
<c:when test= "${isAdmin==0||isAdmin==null }">

</c:when>
</c:choose>
<body>
<c:choose>
    <c:when test="${username == Null }">
        <p style="text-align:right; color:#ffffff">Not Logged In: <a href="../loginForm.jsp">Log In</a></p>
    </c:when>
    <c:otherwise>
        <p style="text-align:right">Logged In: <b><c:out value="${username}"/></b>
        <a href="../logout.jsp">Log Out</a></p>
    </c:otherwise>      
</c:choose>

<form>
	<table id="logoSlogan">
	<tr>
	<td><a href="index.jsp"><img src="<c:url value="/Images/LogoWebsite.png"/>" width="573" height="222" /></a></td>
	<td><h1 style="text-align:right; vertical-align:bottom; font-family:Verdana; color:#ffffff">The Fastest Way To Graduate!</h1></td>
	</tr>
	</table>
</form>

<form>
	<table id="navigation">
	<tr>
	<td><a href="../index.jsp"><img src="<c:url value="/Images/HomeButton.jpg"/>" width="86" height="40" /></a></td>
	<td><a href="../createdegree.jsp"><img src="<c:url value="/Images/MakeaDegreeButton.jpg"/>" width="194" height="40" /></a></td>
	<td><a href="../listprod.jsp"><img src="<c:url value="/Images/ProductsButton.jpg"/>" width="123" height="40" /></a></td>
	<td><a href="../showcart.jsp"><img src="<c:url value="/Images/CartButton.jpg"/>" width="73" height="40" /></a></td>
	<td><a href="../account.jsp"><img src="<c:url value="/Images/AccountButton.jpg"/>" width="117" height="40" /></a></td>
	</tr>
	</table>
</form>
<hr>
</body>
</html>