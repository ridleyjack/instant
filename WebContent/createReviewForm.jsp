

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 
<%@ page import="java.sql.*" %> 
<%@include file="database.jsp" %>
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
<h1>Create a Review</h1>
<%
String prodid = request.getParameter("id");
request.setAttribute("id",prodid);
%>
<form action="createReview.jsp?id=${id }" method="post">
    Description (1000 Characters max): <textarea rows="6" name= "desc"></textarea>
Rating (1-5): <input type = "text" name= "rating">
  <input type="submit" value="Create Review">
  <input type="hidden" id="prodid" name = "prod" value ="${prodid }"> 
  

</form>
</body>
</html>