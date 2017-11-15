<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  
<%@ page import="ridleyjack.insta.data.Database" %> 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>

<%
String category =  request.getParameter("category");


//load products from database
try(Connection con = Database.getConnection()){
	PreparedStatement getProducts = null;
	
	if(category==null || category.equals("all")){
		//select all products
		getProducts = con.prepareStatement("Select p.*, c.catName From Product as p, ProductCategory as c Where p.categoryId = c.categoryId");
	}	
	else{
		//select only products in some categories
		getProducts = con.prepareStatement("Select p.*, c.catName From Product as p, ProductCategory as c Where p.categoryId = c.categoryId and c.categoryId=?");
		getProducts.setString(1, category); //category id = ?
	}
	
	ResultSet rslt = getProducts.executeQuery();
	
	//Convert sql result to jstl result so we can use c:out etc..
	Result prods = ResultSupport.toResult(rslt);
	//Store result in request
	request.setAttribute("products", prods);
	//Go to the listprodForm
	request.getRequestDispatcher("listprodForm.jsp").forward(request, response);
	
	/*
	if(! (request.getParameter("viewid")== null) ){
	//redirect with data to caller of the jsp if viewid was set
	request.getRequestDispatcher(request.getParameter("viewid")).forward(request, response);
	}
	*/
}
catch(SQLException ex){ out.print(ex);}

%>