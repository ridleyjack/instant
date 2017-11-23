<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 
<%@ page import="java.sql.*" %> 
<%@ page import="ridleyjack.insta.data.Database" %> 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %> 
  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h1>Product: <c:out value="${name}"/> $<c:out value="${price}"/></h1> 
<h3>Description: <c:out value="${desc}"/></h3>
<h3>It is worth: <c:out value="${points}"/> points</h3>


<table>
	<tr>
		<th>User Id</th><th>Reviews</th><th>Rating</th>
	</tr>
    <c:forEach var="row" items="${reviews.rows}">
        <tr>
        <td><c:out value="${row.accountId}" /></td>
            <td><c:out value="${row.description}" /></td>
            <td><c:out value="${row.rating}" /></td>
        </tr>
    </c:forEach>
</table>
</body>
</html>