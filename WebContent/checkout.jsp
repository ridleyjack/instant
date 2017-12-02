<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %> 
<%@include file="database.jsp" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>    
<%
//settings
final double taxRate = 0.12;
final double shipCost_Per_Item = 6.50;

if( session.getAttribute("authenticatedUser") == null || session.getAttribute("authenticatedUserId") == null){
	session.setAttribute("loginMessage", "Please Log In Before Checking Out!");
	response.sendRedirect("loginForm.jsp");
	return;
}

String username = session.getAttribute("authenticatedUser").toString();
String userId = session.getAttribute("authenticatedUserId").toString();

//grab product Cart
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
//grab degree Cart
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> degreeList = (HashMap<String, ArrayList<Object>>) session.getAttribute("degreeList");
if (productList == null)
	productList = new HashMap<String, ArrayList<Object>>();
if (degreeList == null)
	degreeList = new HashMap<String, ArrayList<Object>>();

try(Connection con = getConnection()){
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	ArrayList< HashMap<String, Object> > mappedProduct = new ArrayList<>();
	
	//load users name from database
	String cname = "name not found";
	PreparedStatement getName = con.prepareStatement("Select cname From Account Where accountId=?");
	getName.setString(1, userId);
	ResultSet cnameRslt = getName.executeQuery();
	if(cnameRslt.next()){
		cname = cnameRslt.getString("cname");
	}
	
	//load users address from database (only use first one for now)
	PreparedStatement getAddr = con.prepareStatement("Select street, city, postalCode From Address Where accountId=?");
	getAddr.setString(1, userId);
	ResultSet addressRslt = getAddr.executeQuery();
	String street = "Invalid Address";
	String city = "Invalid Address";
	String postal = "Invalid Address";
	if(addressRslt.next()){
		street = addressRslt.getString("street");
		city = addressRslt.getString("city");
		postal = addressRslt.getString("postalCode");
	}
	
	
	double productTotal = 0;
	int productCount = 0;
	int pointTotal = 0;
	
	//This array list will store all the products we are going to order and the amount.
	//The product information will be kept in a hashmap contaning product id, amount to order, message notifing user amount being ordered
	ArrayList<HashMap<String, String>> productsInOrder = new ArrayList<>();
	
	//Count up all the products in our cart
	//Check how much of each product we have in stock.  
	while (iterator.hasNext()) {
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();		
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
						
		//Grab product information
		String id = product.get(0).toString();
		String pname = product.get(1).toString();
		String priceStr = product.get(2).toString();
		String quantityStr = product.get(3).toString();
		String pointStr = product.get(4).toString();
		
		//try and get a price and quantity from product information
		double price = 0;
		int quantity = 0;
		int point = 0;
		try
		{
			price = Double.parseDouble( priceStr );
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+id+" price: "+priceStr);
		}
		try
		{
			quantity = Integer.parseInt( quantityStr );
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+id+" quantity: "+quantityStr);
		}
		try
		{
			point = Integer.parseInt( pointStr );
		}
		catch (Exception e)
		{
			out.println("Invalid points for product: "+id+" quantity: "+quantityStr);
		}
		
		HashMap<String, String > productOrder = new HashMap<>();
		
		//Check how much of the product is available
		PreparedStatement getAmount = con.prepareStatement("SELECT p.productId, SUM(sp.amount) AS amount FROM Product AS p LEFT JOIN StoresProduct AS sp ON sp.productId = p.productId WHERE p.productId=? GROUP BY sp.productId");
		getAmount.setString(1, id);
		ResultSet amount = getAmount.executeQuery();
		
		if(!amount.next()){
			out.println("An Error Ocurred Finding Amount Of Product Given Product ID:"+id);	
			continue;
		}
		
		int stock = amount.getInt("amount"); //Returns 0 if sql value is null which is what we want.
		
		productOrder.put("productId", id);
		productOrder.put("name", pname);
		
		if(stock == 0){
			productOrder.put("amount", "0");
			productOrder.put("message", "Out Of Stock!");	
			quantity = 0;
		}
		else if(quantity > stock){
			productOrder.put("amount", Integer.toString(stock));
			productOrder.put("message", "Low On Stock, Order Reduced to " + stock +"!");
			quantity = stock;
		}
		else { //if quantity < stock
			productOrder.put("amount", Integer.toString(quantity));
			productOrder.put("message", "In Stock!");
		}
		
		productsInOrder.add(productOrder);
		
		productTotal = productTotal + price*quantity;	
		pointTotal = pointTotal + point*quantity;
		productCount += quantity;		
	}//end iterate through products
	
	
	ArrayList< HashMap<String, Object> > mappedDegree = new ArrayList<>();
	iterator = degreeList.entrySet().iterator();
	
	//Iterate through all the degrees to calculate cost.
	double degreeTotal = 0;
	double degreeCount = 0;
	while(iterator.hasNext()){
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> degree = (ArrayList<Object>) entry.getValue();
		double price = 0;
		try{
			price = Double.valueOf(degree.get(6).toString());	
		}
		catch(Exception e){
			out.println("Degree Prices are Invalid");
		}
	
		degreeTotal += price;
		degreeCount++;
	}
	
	double purchaseCost = degreeTotal + productTotal;
	double purchaseTax = purchaseCost*taxRate;
	double purchaseShipping = (degreeCount+productCount)*shipCost_Per_Item;
	double purchaseTotal = purchaseCost + purchaseTax + purchaseShipping;
	
	if(purchaseTotal >= 10000000 ){
		out.print("Sorry your order is too expensive, orders must be less than 9999999.99. Please consider two differernt orders.");
		return;
	}
	
	
	//Is the order empty
	String emptyOrder = "false";
	if(degreeCount == 0 && productCount == 0){
		emptyOrder = "true";
	}	
	
	session.setAttribute("emptyOrder", emptyOrder);
	//Shipment Information
	session.setAttribute("productsInOrder", productsInOrder);
	session.setAttribute("orderTotalCost", purchaseTotal);
	session.setAttribute("orderTotalPoint", pointTotal);		
	//User information
	request.setAttribute("userId", userId);
	request.setAttribute("username", username);
	request.setAttribute("cname", cname); //default cardholder name
	//Address Information
	request.setAttribute("street", street);
	request.setAttribute("city", city);
	request.setAttribute("postal", postal);
	//Cost Information
	request.setAttribute("purchaseCost", currFormat.format(purchaseCost));
	request.setAttribute("purchaseTax", currFormat.format(purchaseTax));
	request.setAttribute("purchaseShipping", currFormat.format(purchaseShipping));
	request.setAttribute("purchaseTotal", currFormat.format(purchaseTotal));
	request.getRequestDispatcher("checkoutForm.jsp").forward(request, response);
}
catch(SQLException e){out.print(e);}

%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Checkout</title>
</head>
<body>

</body>
</html>