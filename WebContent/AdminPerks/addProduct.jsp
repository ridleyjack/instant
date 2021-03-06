<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  

<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@include file="../database.jsp" %>

<%@include file="validateAdmin.jsp" %>
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



String pname = request.getParameter("pname");
String description = request.getParameter("description");
String price = request.getParameter("price");
String pointValue = request.getParameter("pointValue");
String category = request.getParameter("category");
String imageName = request.getParameter("imageName");

Double Price = null;
Integer points = null;
int imageId = -1;
int productId = -1;
Integer categoryId = null;
boolean check1=false;
boolean check2=false;


if(pname.equals("")||pname.length()>255){
	out.print("Name too long or field is blank");
	return;
}
if(description.length()>255){
	out.print("Description too long");
	return;
}
try{ Price = Double.parseDouble(price);
}catch(Exception e){
	out.print("Enter Valid Price");
	return;
}
try{points = Integer.parseInt(pointValue);}
catch(Exception e){out.print("Enter a Valid Point Value");return;}


try(Connection con = getConnection()){

try{PreparedStatement cat = con.prepareStatement("SELECT categoryId FROM ProductCategory WHERE catName = ?");
cat.setString(1, category);
ResultSet rst = cat.executeQuery();

while(rst.next()){
	categoryId = rst.getInt("categoryId");
    check1=true;
}
}catch(Exception e){out.print("No such category Found");
return;}
if(!imageName.equals("")){
try{PreparedStatement image = con.prepareStatement("SELECT imageId FROM Image WHERE fileName = ?");
image.setString(1, imageName);


ResultSet rst = image.executeQuery();
while(rst.next()){
	imageId = rst.getInt("imageId");
    check2=true;
}
}catch(Exception e){out.print("No such image Found");
return;}
}
if(check1==true&&check2==true){
if(!imageName.equals("")){
PreparedStatement stmt = con.prepareStatement("INSERT INTO Product(pname,description,price,pointValue,categoryId,imageId) VALUES (?,?,?,?,?,?)",Statement.RETURN_GENERATED_KEYS);
stmt.setString(1,pname);
stmt.setString(2, description);
stmt.setDouble(3,Price);
stmt.setInt(4, points);
stmt.setInt(5, categoryId);
stmt.setInt(6,imageId);
stmt.executeUpdate();
session.setAttribute("ProductAdded", "Product added Successfully!");
ResultSet autogen = stmt.getGeneratedKeys();
autogen.next();
productId = autogen.getInt(1);	
response.sendRedirect("addProductForm.jsp");
}
    }else if(check1==true&&check2==false){
	if(imageName.equals("")){
    PreparedStatement stmt = con.prepareStatement("INSERT INTO Product(pname,description,price,pointValue,categoryId,imageId) VALUES (?,?,?,?,?,null)",Statement.RETURN_GENERATED_KEYS);
	stmt.setString(1,pname);
	stmt.setString(2, description);
	stmt.setDouble(3,Price);
	stmt.setInt(4, points);
	stmt.setInt(5, categoryId);
	stmt.executeUpdate();
	session.setAttribute("ProductAdded", "Product added Successfully!");
	ResultSet autogen = stmt.getGeneratedKeys();
	autogen.next();
	productId = autogen.getInt(1);
	out.print("Product Added");
	response.sendRedirect("addProductForm.jsp");
}}else{
    out.print("invalid category or image");
    return;
    }


}catch(SQLException ex){ out.print(ex);}


%>