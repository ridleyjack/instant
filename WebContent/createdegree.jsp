<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %> 
<%@ page import="ridleyjack.insta.data.Database" %> 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %> 
<%@ page import="java.text.NumberFormat" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
        
<%
	//Load all Universites and Disciplines, then redirect to form if no arguments.
	try(Connection con = Database.getConnection()){
		PreparedStatement getDisc = con.prepareStatement("SELECT * FROM Discipline");
		PreparedStatement getUni = con.prepareStatement("SELECT * FROM University");
		//Get results of Queries, but change results to jstl result.
		Result disc = ResultSupport.toResult( getDisc.executeQuery() );
		Result uni = ResultSupport.toResult( getUni.executeQuery() );
		
		request.setAttribute("discList", disc);
		request.setAttribute("uniList", uni);
	}
	catch(SQLException ex){ out.print(ex);}
	
	//load arguments.
	String name = request.getParameter("name");
	String university = request.getParameter("university");
	String discipline = request.getParameter("discipline");
	String hon = request.getParameter("honours");
	String dist = request.getParameter("distinction");
	
	//do we have arguments?
	if(name == null || university == null|| discipline == null){
		//No arguments
		request.getRequestDispatcher("createdegreeForm.jsp").forward(request, response);
		return;
	}
	//We have arguments
	boolean honours = false;
	boolean distinction = false;
	
	if(hon != null && hon.equals("yes")) honours = true; 
	if(dist != null && dist.equals("yes")) distinction = true; 
		
	//Todo: Debugging code swap these
	//String username = session.getAttribute("authenticatedUser").toString();
	String username = "guest";

	//Add the template for the created Degree to the database.
	int degreeId = -1;
	try(Connection con = Database.getConnection()){
		int userId = -1;
		//get usersId
		PreparedStatement grabId = con.prepareStatement("Select accountId From Account Where loginName=?");
		grabId.setString(1, username);
		ResultSet idSet = grabId.executeQuery();
		//should add error checking here but, length should always be one
		if( idSet.next() ) userId = idSet.getInt("accountId");
		
		//Add degree to Database
		PreparedStatement addDegree = con.prepareStatement("Insert Into DegreeOrder"+
				"(nameField, dateField, withHonours, withDistinction, uniName, dicName, createdby)"+
				" Values(?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
		addDegree.setString(1, name);
		addDegree.setDate(2, Date.valueOf("2017-04-30")); //TODO: let user choose date
		addDegree.setBoolean(3, honours);
		addDegree.setBoolean(4, distinction);
		addDegree.setString(5, university);
		addDegree.setString(6, discipline);
		addDegree.setInt(7, userId);
		addDegree.executeUpdate();	
		
		//Get Id number of last created degree
		ResultSet autogen = addDegree.getGeneratedKeys();
		autogen.next();
		degreeId = autogen.getInt(1);	
		
		//Add degree to database, then add it to the cart. 	
		@SuppressWarnings({"unchecked"})
		HashMap<String, ArrayList<String>> degreeList = (HashMap<String, ArrayList<String>>) session.getAttribute("degreeList");

		if (degreeList == null){
			degreeList = new HashMap<String, ArrayList<String>>();
		}

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		//Add all the information to the cart.
		ArrayList<String> degree = new ArrayList<>();
		degree.add(String.valueOf(degreeId));
		degree.add(name);
		degree.add(university);
		degree.add(discipline);
		degree.add(honours==true ? "yes" : "no");
		degree.add(distinction==true ? "yes" : "no");
		degree.add("20000.00"); //degree price is hardcoded

		degreeList.put(String.valueOf(degreeId), degree);		
		session.setAttribute("degreeList", degreeList);		
		response.sendRedirect("showcart.jsp");
	}
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