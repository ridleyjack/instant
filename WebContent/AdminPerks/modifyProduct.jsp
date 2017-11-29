<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  
 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
  <%@include file="../database.jsp" %>
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

String oldpname = request.getParameter("oldpname");
String newpname = request.getParameter("newpname");
String description = request.getParameter("description");
String price = request.getParameter("price");
String pointValue = request.getParameter("pointValue");
String category = request.getParameter("category");
String imageName = request.getParameter("imageName");
String delete = request.getParameter("delpname");

if(delete==oldpname){
	out.print("No product choosen");
	return;
}

Double Price = null;
Integer points = null;
Integer imageId = -1;
int productId = -1;
Integer categoryId = null;
int prod = -1;



if(oldpname!=null){
	
if(oldpname.equals("")||oldpname.length()>255){
	out.print("Name too long or field is blank");
	return;
}
if(category.equals("")||category.length()>255){
	out.print("Name too long or field is blank");
	return;
}

if(newpname.equals("")||newpname.length()>255){
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
if(imageName.equals("")){
	imageId = null;
}
try{ points = Integer.parseInt(pointValue);
}catch(Exception e){
	out.print("Enter Valid Price");
	return;
}

}else if(delete!=null){
	if(delete.equals("")||delete.length()>255){
		out.print("Name too long or field is blank");
		return;
	}
}

try(Connection con = getConnection()){

if(oldpname!=null){
try{PreparedStatement cat = con.prepareStatement("SELECT categoryId FROM ProductCategory WHERE catName = ?");
cat.setString(1, category);
ResultSet rst = cat.executeQuery();
while(rst.next()){
	categoryId = rst.getInt("categoryId");
}
}catch(Exception e){out.print("No such category Found");
return;}
if(!imageName.equals("")){
try{PreparedStatement image = con.prepareStatement("SELECT imageId FROM Image WHERE fileName = ?");
image.setString(1, imageName);
ResultSet rst = image.executeQuery();
while(rst.next()){
	imageId = rst.getInt("imageId");
}

}catch(Exception e){out.print("No such image Found");
return;}
}
try{PreparedStatement prodId = con.prepareStatement("SELECT productId FROM Product WHERE pname = ?");
prodId.setString(1, oldpname);
ResultSet rst = prodId.executeQuery();
while(rst.next()){
	prod = rst.getInt("productId");
}

}catch(Exception e){out.print("No such product Found");
return;}
if(!imageName.equals("")){
PreparedStatement update = con.prepareStatement("UPDATE Product SET pname=?,description=?,price=?,pointValue=?,categoryId=?,imageId=? WHERE productId = ?");
update.setString(1,newpname);
update.setString(2,description);
update.setDouble(3,Price);
update.setInt(4,points);
update.setInt(5,categoryId);
update.setInt(6,imageId);
update.setInt(7, prod);
update.executeUpdate();
out.print("Product Updated");
}else{
	PreparedStatement update = con.prepareStatement("UPDATE Product SET pname=?,description=?,price=?,pointValue=?,categoryId=? WHERE productId = ?");
	update.setString(1,newpname);
	update.setString(2,description);
	update.setDouble(3,Price);
	update.setInt(4,points);
	update.setInt(5,categoryId);
	update.setInt(6, prod);
	update.executeUpdate();
	out.print("Product Updated");
}
}else if(delete!=null){
	try{PreparedStatement prodId = con.prepareStatement("SELECT productId FROM Product WHERE pname = ?");
	prodId.setString(1, delete);
	ResultSet rst = prodId.executeQuery();
	while(rst.next()){
		prod = rst.getInt("productId");
	}

	}catch(Exception e){out.print("No such product Found");
	return;}
	
	PreparedStatement delprod = con.prepareStatement("DELETE FROM Product WHERE productId = ?");
	delprod.setInt(1, prod);
	delprod.executeUpdate();
	out.print("Product Deleted");
}


}catch(SQLException ex){ out.print(ex);}
%>