<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %>    
<%@include file="database.jsp" %>

<!-- For JSTL Tags -->
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String productId = request.getParameter("id");
if(productId == null){
	out.print("Non existant product id");
	return;
	//response.sendRedirect("addcart.jsp");
}
try(Connection con = getConnection()){
	
	PreparedStatement getProduct = con.prepareStatement("SELECT P.*, Sum(SP.amount) as amount FROM Product P LEFT JOIN  StoresProduct SP ON P.productId = SP.productId WHERE P.productId = ? GROUP BY SP.productId");
	getProduct.setString(1, productId);
	ResultSet product = getProduct.executeQuery();
	String name = null;
	String desc = null;
	String price = null;
	Integer points = null;
	Integer img = null;
	String amount = null;
	if(product.next()){
	name = product.getString("pname");
	desc = product.getString("description");
	price = product.getString("price");
	points = product.getInt("pointValue");
	img = product.getInt("imageId");
	amount = product.getString("amount");
	if(amount == null) amount = "0";
	}
	request.setAttribute("name", name);
	request.setAttribute("desc", desc);
	request.setAttribute("price", price);
	request.setAttribute("points", points);
	request.setAttribute("img", img);
	request.setAttribute("amount",amount);
	request.setAttribute("productId",productId);
	
	PreparedStatement reviews = con.prepareStatement("SELECT description,rating,loginName FROM Review,Account WHERE Review.accountId= Account.accountId AND productId = ?");
	reviews.setString(1, productId);
	ResultSet rst = reviews.executeQuery();
	Result Reviews = ResultSupport.toResult(rst);
	request.setAttribute("reviews", Reviews);
	request.getRequestDispatcher("productDetailForm.jsp").forward(request, response);
	

	/*
	if(! (request.getParameter("viewid")== null) ){
	//redirect with data to caller of the jsp if viewid was set
	request.getRequestDispatcher(request.getParameter("viewid")).forward(request, response);
	}
	*/
}
catch(SQLException ex){ out.print(ex);}
//Look at list prod <href links
%>

