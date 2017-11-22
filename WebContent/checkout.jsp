<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %> 
<%@ page import="ridleyjack.insta.data.Database" %> 

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
	out.print("Please Log In");
	return;
}

String username = session.getAttribute("authenticatedUser").toString();
String userId = session.getAttribute("authenticatedUserId").toString();

//grab our product and degree carts
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> degreeList = (HashMap<String, ArrayList<Object>>) session.getAttribute("degreeList");
if (productList == null)
	productList = new HashMap<String, ArrayList<Object>>();
if (degreeList == null)
	degreeList = new HashMap<String, ArrayList<Object>>();

try(Connection con = Database.getConnection()){
	
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
	
	//Count up all the products in our cart
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
		
		double price = 0;
		int quantity = 0;
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
		productTotal = productTotal + price*quantity;	
		productCount++;
	}
	
	
	ArrayList< HashMap<String, Object> > mappedDegree = new ArrayList<>();
	iterator = degreeList.entrySet().iterator();
	
	//Iterate through all the degrees.. Create little hashmaps representing the degrees.. add them to our Arraylist of degrees
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
	
	//User information
	request.setAttribute("userId", userId);
	request.setAttribute("username", username);
	request.setAttribute("cname", cname); //default cardholder name
	//Address information
	request.setAttribute("street", street);
	request.setAttribute("city", city);
	request.setAttribute("postal", postal);
	//Cost information
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
<title>Insert title here</title>
</head>
<body>

</body>
</html>