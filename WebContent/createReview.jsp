<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %>    
<%@include file="database.jsp" %>

<!-- For JSTL Tags -->
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="header.jsp" %>
<%

String itemId = request.getParameter("id");
if(itemId== null||itemId.equals("")){
	out.println("No such product exists.");
	out.println(request.getParameter("desc"));
	return;
}
if( session.getAttribute("authenticatedUser") == null || session.getAttribute("authenticatedUserId") == null){
	out.print("Please Log In");
	return;
}
Integer result = null;
String rating =  request.getParameter("rating");
String length = request.getParameter("desc");

String username = session.getAttribute("authenticatedUser").toString();
String userId =session.getAttribute("authenticatedUserId").toString();
int reviewId = -1;

if(length == null || rating == null||rating.length()==0||length.length()==0){
	//No arguments
	request.getRequestDispatcher("createReviewForm.jsp?id=${itemId}").forward(request, response);
	return;
}
try{
result = Integer.parseInt(rating);
}catch(Exception e){
	request.getRequestDispatcher("createReviewForm.jsp?id=${itemId}").forward(request, response);
	return;
}
if(result>5||result<1){
	out.println("Invalid rating");
	return;
}
if(length.length()>1000){
	out.println("Description is too long");
	return;
}
try(Connection con =getConnection()){
	//Get count of reviews user has written
	PreparedStatement check = con.prepareStatement("SELECT count(*) as amount FROM Review Where accountId=? and productId=?;");
	check.setString(1, userId);
	check.setString(2, itemId);
	ResultSet amtR = check.executeQuery();
	
	//Get total amount of the product customer has ordered
	PreparedStatement getOrdered = con.prepareStatement("SELECT sum(amount) AS amount FROM Account AS a, CustomerOrder AS co, Shipment AS s, OrderedProduct AS op"+
			" WHERE a.accountId = co.accountId AND s.orderId = co.orderId AND s.shipmentId = op.shipmentId"+
			" AND a.accountId=? AND op.productId=?");
	getOrdered.setString(1, userId);
	getOrdered.setString(2, itemId);
	ResultSet orderedProduct = getOrdered.executeQuery();
	
	int productAmount = 0;
	if(orderedProduct.next()){
		productAmount = orderedProduct.getInt("amount");
	}
	if(productAmount == 0){
		out.println("You can only review products you have ordered");
		return;
	}
	
	Integer amount = null;
	String prodname = null;
	PreparedStatement product = con.prepareStatement("SELECT pname FROM Product WHERE productId=?");
	product.setString(1,itemId);
	ResultSet prod = product.executeQuery();
	if(amtR.next()){
		amount = amtR.getInt("amount");
	}
	while(prod.next()){
		prodname = prod.getString("pname");
	}
	if(amount>=1){
		out.println("You have already made a review for "+prodname);
		return;
	}
	int usId = Integer.parseInt(userId);
	int itId = Integer.parseInt(itemId);
	
	PreparedStatement addReview = con.prepareStatement("INSERT INTO Review (description,rating,accountId,productId) VALUES (?,?,?,?)",Statement.RETURN_GENERATED_KEYS);
	addReview.setString(1, length);
	addReview.setString(2, rating);
	addReview.setInt(3,usId);
	addReview.setInt(4,itId);
	addReview.executeUpdate();	
	
	//Get Id number of last created degree
	ResultSet autogen = addReview.getGeneratedKeys();
	autogen.next();
	reviewId = autogen.getInt(1);
    out.print("Review Created <script type=\"text/javascript\">window.location = \"http://cosc304.ok.ubc.ca/group20/tomcat/productDetail.jsp?id="+itemId+"\";</script> " );
	//request.getRequestDispatcher("createReviewForm.jsp").forward(request, response);
}
catch(SQLException ex){ out.print(ex);}

%>