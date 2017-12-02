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
try(Connection con = getConnection()){
	PreparedStatement orders = con.prepareStatement("SELECT CO.*,S.*,cname FROM CustomerOrder CO, Shipment S, Account WHERE CO.orderId = S.orderId AND CO.accountId=Account.accountId");
	ResultSet rst = orders.executeQuery();
	Result ord = ResultSupport.toResult(rst);
	request.setAttribute("orders", ord);
	request.getRequestDispatcher("listOrdersForm.jsp").forward(request, response);
	
}catch(SQLException ex){ out.print(ex);}


%>