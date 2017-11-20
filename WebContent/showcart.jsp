<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
//based on ramons lab7 starter code

// Get the current list of products
String deleteId = request.getParameter("deleteId");
String deleteIdDeg = request.getParameter("deleteIdDeg");
String updateId = request.getParameter("updateId");
String updateQty = request.getParameter("updateQty");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

//If null create new shopping cart
if (productList == null)
{	
	productList = new HashMap<String, ArrayList<Object>>();
}

//Degree Cart
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> degreeList = (HashMap<String, ArrayList<Object>>) session.getAttribute("degreeList");

//If null create new shopping cart
if (degreeList == null)
{	
	degreeList = new HashMap<String, ArrayList<Object>>();
}
//delete degree if paramater isn't null
if(deleteIdDeg !=null){
	if (degreeList.containsKey(deleteIdDeg)) degreeList.remove(deleteIdDeg);
	response.sendRedirect("showcart.jsp"); //start again to clear url
	return;
}

//Update or delete if paramaters arn't null
if (deleteId != null){
	if (productList.containsKey(deleteId)) productList.remove(deleteId);
	response.sendRedirect("showcart.jsp"); //start again to clear url
	return;
}
if (updateId != null && updateQty != null){
	if (!productList.containsKey(updateId)) out.print("UpdateQTYErr: Product with id:" + updateId + " not found in cart");
	else {
		ArrayList<Object> product = (ArrayList<Object>) productList.get(updateId);
		product.set(3, updateQty);		
	}
	response.sendRedirect("showcart.jsp"); //start again to clear url
	return;
}

//Add all the products in the shopping cart to an arraylist of hashmaps

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
ArrayList< HashMap<String, Object> > mappedProduct = new ArrayList<>();

double productTotal = 0;
int count = 1;

//Iterate through all the products.. Create little hashmaps representing the products.. add them to our Arraylist of products
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

	//The jstl foreach loop needs 
	HashMap<String, Object> productMap = new HashMap<>();
	productMap.put("productId", id);
	productMap.put("pname", pname);
	productMap.put("price", currFormat.format(price));
	productMap.put("quantity", quantity);
	productMap.put("subtotal", currFormat.format( price*quantity) );
	mappedProduct.add(productMap);

	productTotal = productTotal + price*quantity;
	count++;		
}


ArrayList< HashMap<String, Object> > mappedDegree = new ArrayList<>();
iterator = degreeList.entrySet().iterator();

//Iterate through all the degrees.. Create little hashmaps representing the degrees.. add them to our Arraylist of degrees
double degreeTotal = 0;
while(iterator.hasNext()){
	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
	ArrayList<Object> degree = (ArrayList<Object>) entry.getValue();
	
	HashMap<String, Object> degreeMap = new HashMap<>();
	degreeMap.put("degreeId", degree.get(0));
	degreeMap.put("name", degree.get(1));
	degreeMap.put("university", degree.get(2));
	degreeMap.put("discipline", degree.get(3));
	degreeMap.put("honours", degree.get(4));
	degreeMap.put("distinction", degree.get(5));
	degreeMap.put("cost", degree.get(6) ); //degree price is hardcoded
	
	mappedDegree.add(degreeMap);
	degreeTotal += Double.valueOf(degree.get(6).toString());
}

request.setAttribute("degreeList", mappedDegree);
request.setAttribute("prodList", mappedProduct);
request.setAttribute("productTotal", productTotal);
request.setAttribute("degreeTotal", degreeTotal);
request.setAttribute("totalPrice", currFormat.format(degreeTotal + productTotal));
request.getRequestDispatcher("showcartForm.jsp").forward(request, response);
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