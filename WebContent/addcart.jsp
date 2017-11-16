<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Cart</title>
</head>
    
<%
//Based on Ramons lab7 starter code
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
	//TODO:Load from database
}

//Add new product selected
//Get product information
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
Integer quantity = new Integer(1);

//Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

//Update quantity if add same item to order again
if (productList.containsKey(id))
{	product = (ArrayList<Object>) productList.get(id);
	int curAmount = ((Integer) product.get(3)).intValue();
	product.set(3, new Integer(curAmount+1));
}
else
	productList.put(id,product);

session.setAttribute("productList", productList);
response.sendRedirect("showcart.jsp");

%>




<body>
</body>
</html>