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
<div class=list>
<sql:setDataSource var = "database" driver = "com.mysql.jdbc.Driver"
   url = "jdbc:mysql://cosc304.ok.ubc.ca/db_jjackson"
   user = "jjackson"  password = "86696549"/>

<sql:query var="order" dataSource="${database}">
    Select * From CustomerOrder Where orderId= ?;
    <sql:param value="${orderId}" />
</sql:query>

<sql:query var="shipment" dataSource="${database}">
    Select Shipment.*, Address.city From Shipment, Address Where Address.addressId = Shipment.addressId AND orderId=?;
    <sql:param value="${orderId}" />
</sql:query>


<table>
	<c:forEach var="row" items="${order.rows}">
	<tr>
	<th>Order Id</th><th>Date Placed</th><th>Cost</th><th>Points Earned</th>
	</tr>
	<tr>
	<td><c:out value="${row.orderId}"/></td>
	<td><c:out value="${row.placed}"/></td>
	<td><c:out value="${row.totalCost}"/></td>
	<td><c:out value="${row.pointsEarned}"/></td>
	</tr>
	</c:forEach> 
</table>

      
	<c:forEach var="row" items="${shipment.rows}">
	<table>
	<tr>
	<th>ShipmentId</th><th>ReadyToShip</th><th>AddressId</th><th>Address City</th>
	</tr>  	
		<tr>
			<td><c:out value="${row.shipmentId}"/></td>
			<td><c:out value="${row.readyToShip}"/></td>
			<td><c:out value="${row.addressId}"/></td>
			<td><c:out value="${row.city}"/></td>
		</tr>     
				
		<tr><td colspan="4">		
			<sql:query var="product" dataSource="${database}">
				Select * From OrderedProduct, Product, Warehouse Where Warehouse.warehouseId = OrderedProduct.wareHouseId And OrderedProduct.productId = Product.productId And shipmentId=?;
				<sql:param value="${row.shipmentId}" />
			</sql:query>
							
			<table>	
			<tr>
			<th>ProductId</th><th>Product Name</th><th>Amount</th><th>WarehouseId</th><th>Warehouse City</th>
			</tr>
			
			<c:forEach var="prod" items="${product.rows}">
				<tr>
					<td><c:out value="${prod.productId}"/></td>
					<td><c:out value="${prod.pname}"/></td>
					<td><c:out value="${prod.amount}"/></td>
					<td><c:out value="${prod.warehouseId}"/></td>
					<td><c:out value="${prod.city}"/></td>
				</tr>
			</c:forEach>							      	
			</table>
		</td></tr>	
		
		<tr><td colspan="4">
		<sql:query var="degree" dataSource="${database}">
			Select * From DegreeOrder Where shipmentId=?;
			<sql:param value="${row.shipmentId}" />
		</sql:query>
		
		<table>
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
	</table>		
	</c:forEach>

</div>
</body>
</html>