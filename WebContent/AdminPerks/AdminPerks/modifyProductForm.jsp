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
<c:choose>
<c:when test="${isAdmin==1 }">
<h1>Update a Product</h1>

<form action="modifyProduct.jsp" method="post">
Product Name: <input type = "text" name= "oldpname">
New Product Name: <input type = "text" name= "newpname">
Description: <input type = "text" name= "description">
Price: <input type = "text" name= "price">
Points: <input type = "text" name= "pointValue">
Category Name: <input type = "text" name= "category">
Image Name(leave blank for default): <input type = "text" name= "imageName">
  <input type="submit" value="Update Product">
  </form>
<h1>Or...</h1><br>
<h1>Delete a Product</h1>

<form action="modifyProduct.jsp" method="post">
Product Name: <input type = "text" name= "delpname">
  <input type="submit" value="Delete Product">
  
</form>
</c:when>
</c:choose>

<c:choose>
<c:when test="${isAdmin==0||isAdmin==null }">
<h1>You do not have access to this page.</h1>
</c:when>
</c:choose>
</body>
</html>