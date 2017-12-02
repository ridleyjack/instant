<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Image Upload</title>
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
<c:choose>
<c:when test="${isAdmin==1 }">
<h1>Enter file to upload to server:</h1>

<c:out value="${uploadMsg}"/> <!-- usually shows nothing -->

<form name="uploadForm" action="imageuploader.jsp" method="post" enctype="multipart/form-data">
<b>File:</b><input type="file" name="file" size="100"/>
<input type="submit" name="Submit" value="Upload File"/>
<p>Images must be less than 65535 bytes. Images should be 100x100 px</p>
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