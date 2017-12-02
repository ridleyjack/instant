<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
   
   <%@ include file="/header.jsp" %>
   <%@ include file="validateAdmin.jsp" %>
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
<body>
<div class=admin>
<c:choose>
<c:when test="${isAdmin==1 }">
<h1>Admin Page!</h1>
<table><tr>
<th><a href=listCustomers.jsp>List all customers.</a></th>
<th><a href=listOrders.jsp>List all orders.</a></th>
<th><a href=imageuploaderForm.jsp>Upload a photo.</a></th>
</tr><tr>
<th><a href=addProductForm.jsp>Add a Product.</a></th>
<th><a href=modifyProductForm.jsp>Modify or Delete a Product.</a></th>
<th><a href=setPicForm.jsp>Set a Products Photo.</a></th>
</tr></table>

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