<%@ page import="java.sql.*" %>
<%@ page import="ridleyjack.insta.data.Database" %>
<%@ page import="ridleyjack.insta.util.Security" %>

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
// Account type: -1=none 0=customer 1,2=admins
int type = Integer.parseInt(request.getParameter("type"));

//hash the password
String password = Security.genhash_SHA256(request.getParameter("password"));

//TODO: validate input here

//Create the account
try(Connection c = Database.getConnection();){
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
	}
	
	//Should redirect to somewhere eventually
	out.print("Account Created Successfully!");
}
catch(SQLException ex) {out.print(ex);}

%>