<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<h1>Your Shopping Cart</h1>
<table>
	<tr>
		<th>Product Id</th><th>Product Name</th><th>Price</th><th>Quantity</th><th>Subtotal</th>
	</tr>
    <c:forEach var="row" items="${listMap}">
        <tr>
            <td><c:out value="${row.productId}" /></td>            
            <td><c:out value="${row.pname}" /></td>
            <td><c:out value="${row.price}" /></td>
            <td><c:out value="${row.quantity}" /></td>
            <td><c:out value="${row.subtotal}" /></td>
            <td><a href="showcart.jsp?deleteId=${row.productId}">Remove From Cart</a></td>
        </tr>
    </c:forEach>
    <tr><td colspan="5" align="right"><b>Order Total:</b><c:out value="${totalPrice}"/></td>
    
</table>

<h2><a href="checkout.jsp">Check Out</a></h2>

</body>
</html>