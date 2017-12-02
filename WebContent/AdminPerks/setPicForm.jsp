<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 
<%@ page import="java.sql.*" %> 

<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %> 
  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@include file="/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div class=list>
<c:choose>
<c:when test="${isAdmin==1 }">
<h1>Set a Product Image</h1>

<form action="setPic.jsp" method="post">
<p>Product Name: <input type = "text" name= "pname"></p>
<p>Image Name: <input type = "text" name= "imageName"></p>
 <p> <input type="submit" value="image"></p>
  </form>
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