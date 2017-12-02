<%@ page import="java.sql.*" %>

<%@include file="database.jsp" %>
<%@include file="security.jsp" %>
<%@include file="header.jsp" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Creation Result</title>

</head>

<body>

</body>
</html>

<%
String username = request.getParameter("username");
String name = request.getParameter("name");
String email = request.getParameter("email");

String street = request.getParameter("street");
String city = request.getParameter("city");
String postalCode = request.getParameter("postalcode");

//Validation
if(street.length()<1 || city.length()<1||postalCode.length()!=6){
	out.print("Missing/Invalid Fields In Address, Note: PostalCode Must be 6 characters.");
	return;
}

// Account type: -1=none 0=customer 1,2=admins
int type = Integer.parseInt(request.getParameter("type"));

if( request.getParameter("password") == null || request.getParameter("password").length() == 0){
	out.print("password must be at least one character long"); //low standards
	return;
}

//hash the password
String password = genhash_SHA256(request.getParameter("password"));

//TODO: validate input here

//Create the account
try(Connection c = getConnection()){
	int id = -1;
	//Create general Account
	PreparedStatement stmt = c.prepareStatement("Insert Into Account(loginName, password, creationDate, lastLogin, cname, email, isDeactivated, adminLevel)"
			+" Values(?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS );
	stmt.setString(1, username); 
	stmt.setString(2, password);
	stmt.setDate(3, new Date(System.currentTimeMillis())); //Creation Date
	stmt.setDate(4, new Date(System.currentTimeMillis())); // Last Login Date
	stmt.setString(5, name);
	stmt.setString(6, email);
	stmt.setBoolean(7, false); //isDeactivated?
	stmt.setInt(8, type);//admin level
	stmt.executeUpdate();
	
	//if above statement worked we have ids
	ResultSet ids = stmt.getGeneratedKeys();
	ids.next();
	id = ids.getInt(1);
	
	//Create customer Account
	if(type==0){
		PreparedStatement stmtCust = c.prepareStatement("Insert Into Customer(accountId, prizePoints, isWarned, isBanned)"
				+" Values(?, ?, ?, ?)");
		stmtCust.setInt(1, id);
		stmtCust.setInt(2, 0);
		stmtCust.setBoolean(3, false);
		stmtCust.setBoolean(4, false);
		stmtCust.executeUpdate();
		
		//Create and Address 
		PreparedStatement addAddress = c.prepareStatement("Insert Into Address(street, city, postalCode, accountId) Values(?, ?, ?, ?)");
		addAddress.setString(1, street);
		addAddress.setString(2, city);
		addAddress.setString(3, postalCode);
		addAddress.setInt(4, id);
		addAddress.executeUpdate();
	}

	session.setAttribute("loginMessage", "Account Created Successfully! Please Log In");
	response.sendRedirect("loginForm.jsp");
	
}
catch(SQLException ex) {out.print(ex);}

%>