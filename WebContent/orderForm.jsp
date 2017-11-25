<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %> 

<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Orders</title>
</head>
<body>

<sql:query var="shipment" dataSource="jdbc/db_settings">
    Select Shipment.*, Address.city From Shipment, Address Where Address.addressId = Shipment.addressId AND orderId=${param.orderId};
</sql:query>
    
<table border="1">
	<tr>
	<th>ShipmentId</th><th>ReadyToShip</th><th>AddressId</th><th>Address City</th>
	</tr>        
	<c:forEach var="row" items="${shipment.rows}">
		<tr>
			<td><c:out value="${row.shipmentId}"/></td>
			<td><c:out value="${rpw.readyToShip}"/></td>
			<td><c:out value="${row.addressId}"/></td>
			<td><c:out value="${row.city}"/></td>
		</tr>     
				
		<tr><td colspan="6">		
		<sql:query var="product" dataSource="jdbc/db_settings">
			Select * From OrderedProduct, Product, Warehouse Where Warehouse.warehouseId = OrderedProduct.wareHouseId And OrderedProduct.productId = Product.productId And shipmentId=${row.shipmentId};
		</sql:query>
						
		<table border="1">	
		<tr>
		<th>ProductId</th><th>Product Name</th><th>Amount</th><th>WarehouseId</th><th>Warehouse City</th>
		</tr>
		
		<c:forEach var="prod" items="${product.rows}">
			<tr>
				<td><c:out value="${prod.productId}"/></td>
				<td><c:out value="${prod.pname}"/></td>
				<td><c:out value="${prod.amount}"/></td>
				<td><c:out value="${prod.warehousId}"/></td>
				<td><c:out value="${prod.city}"/></td>
			</tr>
		</c:forEach>							      	
		</table>	
		
		<sql:query var="degree" dataSource="jdbc/db_settings">
			Select * From DegreeOrder Where shipmentId=${row.shipmentId};
		</sql:query>
		
		<table border="1">
			<tr>
				<th>DegreeId</th><th>Name Field</th><th>University</th><th>Discipline</th>
			</tr>
			<c:forEach var="deg" items="${degree.rows}">
				<td><c:out value="${deg.degreeId}"/></td>
				<td><c:out value="${deg.nameField}"/></td>
				<td><c:out value="${deg.uniName}"/></td>
				<td><c:out value="${deg.dicName}"/></td>
			</c:forEach>
		</table>
					   	
		</td></tr>
	</c:forEach>
</table>

</body>
</html>