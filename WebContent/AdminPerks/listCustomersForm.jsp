<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
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
<body>
<div class=list>
<c:choose>
<c:when test="${isAdmin==1 }">
<table>
	<tr>
		<th>Name</th><th>Login Name</th><th>Account Id</th><th>Admin Level</th><th>Prize Points</th><th>Email</th><th>Last Login</th><th>Creation Date</th><th>Deactivated</th>
	</tr>
    <c:forEach var="row" items="${customers.rows}">
        <tr>
            <td><c:out value="${row.cname}" /></td>
            <td><c:out value="${row.loginName}" /></td>
            <td><c:out value="${row.accountId}" /></td>
            <td><c:out value="${row.adminLevel}" /></td>
            <td><c:out value="${row.prizePoints}" /></td>
            <td><c:out value="${row.email}" /></td>
            <td><c:out value="${row.lastLogin}" /></td>
            <td><c:out value="${row.creationDate}" /></td>
             <td><c:out value="${row.isDeactivated}" /></td>
        </tr>
    </c:forEach>
</table>
</c:when>
</c:choose>
<c:choose>
<c:when test="${isAdmin==0||isAdmin==null }">
<h1>You do not have access to this page.</h1>
</c:when>
</c:choose>
</div>
</body>
</html>