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
<style>
input[type=number]{
    width: 30px;
} 
</style>
<body>

<h1>Your Shopping Cart</h1>
<h2>Products</h2>
<table>
	<tr>
		<th>Product Id</th><th>Product Name</th><th>Price</th><th colspan="2">Quantity</th><th>Subtotal</th>
	</tr>
    <c:forEach var="row" items="${prodList}">
        <tr>
            <td><c:out value="${row.productId}" /></td>            
            <td><c:out value="${row.pname}" /></td>
            <td><c:out value="${row.price}" /></td>                       
            <td><c:out value="${row.quantity}" /></td>
            <td><form action ="showcart.jsp" method=post>
			<input type="hidden" name="updateId" value="${row.productId}"> 
			<input type="number" min="1" maxlength="2" name="updateQty" value="${row.quantity}">
			<input type="submit" value="change">                      	
           	</form></td>	
            <td><c:out value="${row.subtotal}" /></td>			 
            <td><a href="showcart.jsp?deleteId=${row.productId}">Remove From Cart</a></td>
        </tr>
    </c:forEach>
    <tr><td colspan="6" align="right"><b>Product Total:</b><c:out value="${productTotal}"/></td>    
</table>
<h2>Degrees</h2>
<table>
	<tr>
		<th>Degree Id</th><th>Name</th><th>University</th><th>Discipline</th><th>Honours</th><th>Distinction</th><th>Cost</th>
	</tr>
    <c:forEach var="row" items="${degreeList}">
        <tr>
            <td><c:out value="${row.degreeId}" /></td>            
            <td><c:out value="${row.name}" /></td>
            <td><c:out value="${row.university}" /></td>
            <td><c:out value="${row.discipline}" /></td>
            <td><c:out value="${row.honours}" /></td>
            <td><c:out value="${row.distinction}" /></td>
            <td><c:out value="${row.cost}" /></td>
            <td><a href="showcart.jsp?deleteIdDeg=${row.degreeId}">Remove From Cart</a></td>
        </tr>
    </c:forEach>
    <tr><td colspan="8" align="right"><b>Degree Total:</b><c:out value="${degreeTotal}"/></td> 
</table>
<h2>Order Total:<c:out value="${totalPrice}"/></h2>
<h2><a href="checkout.jsp">Check Out</a></h2>

</body>
</html>