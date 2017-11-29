<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %>    
<%@ page import="ridleyjack.insta.data.Database" %> 

<!-- For JSTL Tags -->
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String userId = session.getAttribute("authenticatedUserId").toString();
Integer id = null;
try{
	id = Integer.parseInt(userId);
}catch(Exception e){
	out.print("Login for Account Info");
	return;
}
try(Connection con = Database.getConnection()){
	PreparedStatement orders = con.prepareStatement("SELECT CO.*,S.*,cname FROM CustomerOrder CO, Shipment S, Account WHERE CO.orderId = S.orderId AND CO.accountId=Account.accountId AND Account.accountId=?");
	orders.setInt(1, id);
	ResultSet rst = orders.executeQuery();
	Result ords = ResultSupport.toResult(rst);
	request.setAttribute("orders", ords);
	request.getRequestDispatcher("accountForm.jsp").forward(request, response);
	
}catch(SQLException e){
	out.print(e);
	
}

%>