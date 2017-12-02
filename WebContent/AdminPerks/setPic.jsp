<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.ArrayList" %>  
 
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  

<%@include file="validateAdmin.jsp" %>
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
String pname = request.getParameter("pname");
String imageName = request.getParameter("imageName");

int imageId = -1;
int prod = -1;

if(pname.equals("")){
	out.print("Enter a Product Name");
	return;
}
if(imageName.equals("")){
	out.print("Enter an image Name");
	return;
}
try(Connection con = getConnection()){

	
	try{PreparedStatement prodId = con.prepareStatement("SELECT productId FROM Product WHERE pname = ?");
	prodId.setString(1, pname);
	ResultSet rst = prodId.executeQuery();
	while(rst.next()){
		prod = rst.getInt("productId");
	}

	}catch(SQLException e){out.print("No such product Found");
	return;}
	
	
try{PreparedStatement image = con.prepareStatement("SELECT imageId FROM Image WHERE fileName = ?");
image.setString(1, imageName);


ResultSet rst = image.executeQuery();
while(rst.next()){
	imageId = rst.getInt("imageId");
}
}catch(SQLException e){out.print("No such image Found");
return;}
if(imageId!=-1||prod!=-1){
PreparedStatement change = con.prepareStatement("Update Product Set imageId = ? Where productId = ?");
change.setInt(1, imageId);
change.setInt(2, prod);
change.executeUpdate();
out.print("Image Updated");
}else{
   out.print("no such product or image found");
   }

}catch(SQLException e){
	out.print(e);
}

%>