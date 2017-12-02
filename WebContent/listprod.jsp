<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  

<%@include file="database.jsp" %>

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
String nameLike = request.getParameter("productName");

//load products from database
try(Connection con = getConnection()){

	//Lets build a SQL statment based on arguments (NO USER INPUT IN HERE)
	StringBuilder sqlBuilder = new StringBuilder("Select p.*, c.catName From Product AS p, ProductCategory AS c Where p.categoryId=c.categoryId");
	
	String categoryArg = null;
	if(category != null && !category.equals("all")){
		sqlBuilder.append(" AND c.categoryId=?");
		categoryArg = category; 
	}	
	String nameLikeArg = null;
	if(nameLike != null && nameLike != ""){
		sqlBuilder.append(" AND p.pname Like ?");
		nameLikeArg = "%"+nameLike+"%";
	}
	
	//Lets prepare that statement
	PreparedStatement getProducts = con.prepareStatement( sqlBuilder.toString() );
	
	//Lets give it some arguments (order of these is important becuase of argId)
	int argId = 1;
	if(categoryArg != null){
		getProducts.setString(argId, categoryArg);
		argId++;
	}
	if(nameLikeArg != null){
		getProducts.setString(argId, nameLikeArg);
		argId++;	
	}		
	
	ResultSet rslt = getProducts.executeQuery();
	
	//Convert sql result to jstl result so we can use c:out etc..
	Result prods = ResultSupport.toResult(rslt);
	//Store result in request
	request.setAttribute("products", prods);
	
	//Load up Categories for the listprodForm's dropdown list
	PreparedStatement grabCategories = con.prepareStatement("SELECT categoryId, catName FROM ProductCategory");
	ResultSet categories = grabCategories.executeQuery();
	//JSTL uses different form of result
	Result categoriesResult = ResultSupport.toResult(categories);
	request.setAttribute("categories", categoriesResult);
	
	//Go to the listprodForm
	request.getRequestDispatcher("listprodForm.jsp").forward(request, response);
	
}
catch(SQLException ex){ out.print(ex);}

%>