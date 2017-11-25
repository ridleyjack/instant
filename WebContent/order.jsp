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
String userId = null;

try(Connection con = Database.getConnection()){	
	//check if user is signed in
	if (session.getAttribute("authenticatedUserId") == null || session.getAttribute("authenticatedUser") == null){
		request.setAttribute("loginMessage", "Please Log In First");
		request.getRequestDispatcher("loginForm.jsp").forward(request, response);
		return;
	}
	userId = session.getAttribute("authenticatedUserId").toString();
	
	//Product cart
	@SuppressWarnings({"unchecked"})
	ArrayList<HashMap<String, String>> products= (ArrayList<HashMap<String, String>>) session.getAttribute("productsInOrder");
	if (products == null)
	{	
		products = new ArrayList<HashMap<String, String>>();
	}

	//Degree Cart
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> degreeList = (HashMap<String, ArrayList<Object>>) session.getAttribute("degreeList");
	if (degreeList == null)
	{	
		degreeList = new HashMap<String, ArrayList<Object>>();
	}	
	if(degreeList.size() == 0 && products.size() == 0){
		out.print("You can't create an Order with an empty cart!");
		return;
	}
	
	//Create the Order 
	PreparedStatement createOrder = con.prepareStatement("INSERT INTO CustomerOrder(placed, totalCost, pointsEarned, accountId) Values(?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
	createOrder.setDate(1, new Date(System.currentTimeMillis()));
	createOrder.setInt(2, 0);
	createOrder.setInt(3, 0);
	createOrder.setInt(4, Integer.valueOf(userId));
	createOrder.executeUpdate();
	
	ResultSet orderAutoId = createOrder.getGeneratedKeys();
	
	if(!orderAutoId.next()){
		out.println("Problem creating order");
		return;
	}
	int orderId = orderAutoId.getInt(1);	
	
	//Gets the Id of the customers address
	PreparedStatement getAddress = con.prepareStatement("SELECT addressId FROM Address WHERE accountId=?");
	getAddress.setString(1, userId);
	ResultSet addressRslt= getAddress.executeQuery();
	
	if(!addressRslt.next()){
		out.println("Problem loading Address");
		return;
	}
	int addressId = addressRslt.getInt(1);
	
	//Finds if we already have a shipment from specific warehouse in this order
	PreparedStatement getShipments = con.prepareStatement("SELECT DISTINCT s.ShipmentId as id From Shipment AS s, OrderedProduct AS ps, Warehouse AS w Where s.shipmentId = ps.ShipmentId and ps.warehouseId = w.warehouseId and s.orderId=? and w.warehouseId=?");
	//Get all the warehouses that store a specific product
	PreparedStatement getStores = con.prepareStatement("SELECT w.warehouseId AS wId, sp.amount AS amt FROM Warehouse AS w, StoresProduct AS sp WHERE w.warehouseId = sp.warehouseId AND sp.productId=?"); 
	//Changes the amount of product stored in a warehouse
	PreparedStatement updateStock = con.prepareStatement("UPDATE StoresProduct AS sp SET amount=? WHERE sp.productId=? AND sp.warehouseId=? ");	
	//Creates a new shipment
	PreparedStatement createShip = con.prepareStatement("INSERT INTO Shipment(orderId, addressId) Values(?,?)", Statement.RETURN_GENERATED_KEYS);
	//Create A ProductSelection
	PreparedStatement createPrepShip = con.prepareStatement("INSERT INTO OrderedProduct(productId, warehouseId, shipmentId, amount) Values(?,?,?,?)");
		
	//Add All The Products 
	Iterator<HashMap<String,String>> iterator = products.iterator();
	while( iterator.hasNext() ){
		
		HashMap<String, String> prod = iterator.next();
		String prodId = prod.get("productId");
		int amount = Integer.parseInt( prod.get("amount") );

		getStores.setString(1, prodId);
		ResultSet stores = getStores.executeQuery();
		while (stores.next() && amount > 0){
			
			String wareId = stores.getString("wId");
			int stored = stores.getInt("amt");
			if(stored == 0) continue;//can't do anything with an empty warehouse
			
			//Take some product
			int amountTaken = 0;
			if(stored >= amount) {//We have enough product in this warehouse 
				amountTaken = amount;
				amount=0; //don't need anymore
			}
			else{ //if stored < amount // we can only fufill part of order from this warehouse
				amountTaken = stored;
				amount = amount - amountTaken;
			}
			
			//Update the warehouses stock
			updateStock.setInt(1, stored-amountTaken);
			updateStock.setString(2, prodId);
			updateStock.setString(3, wareId);
			updateStock.executeUpdate();
			
			//Get the shipmentId of any shipments leaving this warehouse for this order
			getShipments.setInt(1, orderId);
			getShipments.setString(2, wareId);
			ResultSet shipment = getShipments.executeQuery();
			
			//Get the shipmentId of existing or newly created shipment
			int shipmentId;			
			if(shipment.next()){ // we already have a shipment get the Id
				shipmentId = shipment.getInt("id");
			}
			else { // create a shipment and get the id
				createShip.setInt(1, orderId);
				createShip.setInt(2, addressId);
				createShip.executeUpdate();
				ResultSet autoKey = createShip.getGeneratedKeys();
				autoKey.next();
				shipmentId = autoKey.getInt(1);
			}
			
			//Add the product to the shipment
			createPrepShip.setString(1, prodId);
			createPrepShip.setString(2, wareId);			
			createPrepShip.setInt(3, shipmentId);
			createPrepShip.setInt(4, amountTaken);
			createPrepShip.executeUpdate();			
		}
	}
	//Clear the list of products to add to the order
	session.setAttribute("productsInOrder", null);
	
	//Used to add the degrees to a shipment
	PreparedStatement addDegree = con.prepareStatement("UPDATE DegreeOrder SET shipmentId=? Where degreeId=?");
	
	//Add all the degrees to the order in their own shipment
	Iterator<Map.Entry<String, ArrayList<Object>>> iteratorDeg = degreeList.entrySet().iterator();
	
	//Create shipment for degrees if we have at least one
	int shipmentId = 0;
	if (iteratorDeg.hasNext()){
		createShip.setInt(1, orderId);
		createShip.setInt(2, addressId);
		createShip.executeUpdate();
		ResultSet autoKey = createShip.getGeneratedKeys();
		autoKey.next();
		shipmentId = autoKey.getInt(1);
	}
	
	//Iterate through all the degrees adding them to the shipment
	while (iteratorDeg.hasNext()){
		Map.Entry<String, ArrayList<Object>> entry = iteratorDeg.next();
		ArrayList<Object> degree = (ArrayList<Object>) entry.getValue();
		if(degree.size() == 0 || degree.get(0)==null){
			out.println("Nonexistant or invalid degree in degreeCart");
			continue;
		}
		String degreeId = degree.get(0).toString();
		addDegree.setInt(1, shipmentId);
		addDegree.setString(2, degreeId);
		addDegree.execute();
	}
	//Reset The Degree Cart
	session.setAttribute("degreeList", null);
	
	response.sendRedirect("orderForm.jsp?orderId=" + orderId);
}
catch(SQLException ex) {out.print(ex); }

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Order</title>
</head>
<body>
</body>
</html>