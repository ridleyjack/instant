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
input[name=cardDay] {    
width: 40px;
}
input[name=cardMonth] {    
width: 40px;
} 
input[name=cardYear] {    
width: 60px;
}      
</style>
</head>

<body>
    <div class=list>
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
	<b>CardHolder Name:</b><input name="cardHolder" type="text" value="${cname}"><br>
	<b>CreditCard Number:</b><input name="cardNumber" type="number" value="1000000000000000" min="99999999999999" max="9999999999999999"><br>
	<b>Card Expiration:</b> 
	DD: <input type="number" name="cardDay" value="1" min="1" max="32" maxlength="2">
	MM: <input type="number" name="cardMonth" value="1" min="1" max="12" maxlength="2">
	YYYY: <input type="number" name="cardYear" value="2020" min="2017" max="9999" maxlength="4"><br><br>
	<input type="submit" value="Make Purchase"/>
</form>



<table align="center">
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