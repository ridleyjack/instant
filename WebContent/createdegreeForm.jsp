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
<div class=list>
<form action="createdegree.jsp" method="post">
	<p>Name To Appear On Degree:<br>
	<input type="text" name="name" size="30"></p>
	<p>University:
	<select name="university">		
		<c:forEach var="row" items="${uniList.rows}">
		<option value="${row.name}">${row.name}</option>
		</c:forEach>
	</select></p>
	<p>Discipline:
	<select name="discipline">		
		<c:forEach var="row" items="${discList.rows}">
		<option value="${row.name}">${row.name}</option>
		</c:forEach>
	</select></p>
 <p> With Honors:
  <input type="radio" name="honours" value="yes"> Yes
  <input type="radio" name="honours" value="no" checked="checked"> No</p>
  <p>With Distinction:
  <input type="radio" name="distinction" value="yes"> Yes
  <input type="radio" name="distinction" value="no" checked="checked"> No</p>
	
  <p><input type="submit" value="Create Degree"></p>
</form>
</div>
</body>
</html>