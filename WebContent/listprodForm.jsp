<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %> 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %> 
  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@include file="header.jsp" %>
<%@include file="database.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<body>
    <div class=list>
<%
//grab categories from database
try(Connection con = getConnection()){
	ResultSet cat = con.createStatement().executeQuery("Select categoryId, catName From ProductCategory");
	Result cats = ResultSupport.toResult(cat);
	request.setAttribute("categories", cats);	
}
catch(SQLException ex){ out.print(ex);}

%>

<form action="listprod.jsp" method=get>
	Category:	
	<select name="category">
		<option value="all">All</option>
		<c:forEach var="row" items="${categories.rows}">
		<option value="${row.categoryId}">${row.catname}</option>
		</c:forEach>
	</select>
	Name:
	<input type="text" name="productName" size="50"><br>
	<input type="submit" value="Show Products">
</form> 

<table>
	<tr>
		<th>Image</th><th>Name</th><th>Category</th><th>Description</th><th>Price</th><th>Points</th>
	</tr>
    <c:forEach var="row" items="${products.rows}">
        <tr>
        	<td><iframe src="<c:url value="/imageview.jsp?id=${row.imageId}" />" width="100" height="100" scrolling="no" frameborder="0"></iframe></td>
            <td><c:out value="${row.pname}" /></td>
            <td><c:out value="${row.catName}" /></td>
            <td><c:out value="${row.description}" /></td>
            <td><c:out value="${row.price}" /></td>
            <td><c:out value="${row.pointvalue}" /></td>
            <td><a href=addcart.jsp?id=${row.productId}>Add To Cart</a></td>
            <td><a href=productDetail.jsp?id=${row.productId}>Product Details</a></td>
        </tr>
    </c:forEach>
</table>
    </div>
</body>
</html>
