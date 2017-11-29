<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@include file="header.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Checkout</title>

<style>
input[type=number]{
    width: 160px;
} 
</style>
</head>

<body>
<form name="checkout" method="post" action="order.jsp">
	<h1>Checkout</h1>
	<h3>User Information</h3>
	<b>UserId: <c:out value="${userId}"/></b><br>
	<b>Username: <c:out value="${username}"/></b><br>
	<h3>Purchase Information</h3>
	<b>PurchaseCost: <c:out value="${purchaseCost}"/></b><br>
	<b>Tax (PST+GST): <c:out value="${purchaseTax}"/></b><br>
	<b>Shipping: <c:out value="${purchaseShipping}"/></b><br>
	<b>Total Cost: <c:out value="${purchaseTotal}"/></b><br>
	<h3>Shipping Address</h3>
	<b>Street: <c:out value="${street}"/></b><br>
	<b>City: <c:out value="${city}"/></b><br>
	<b>Postal Code: <c:out value="${postal}"/></b><br>
	<h3>Billing Information</h3>
	<b>CardHolder Name:</b><input type="text" value="${cname}"><br>
	<b>CreditCard Number:</b><input type="number" value="" min="13" max="19"><br>
	<input type="submit" value="Make Purchase"/>
</form>


<div class=list>
<table>
	<tr>
		<th>Id</th><th>Name</th><th>Amount In Order</th><th>Message</th>
	</tr>
    <c:forEach var="row" items="${productsInOrder}">
        <tr>
            <td><c:out value="${row.productId}" /></td>
            <td><c:out value="${row.name}" /></td>
            <td><c:out value="${row.amount}" /></td>
            <td><c:out value="${row.message}" /></td>
        </tr>
    </c:forEach>
</table>
</div>

</body>
</html>