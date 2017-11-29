<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*" %>    
<%@include file="database.jsp" %>

<!-- For JSTL Tags -->
<%@ page import="javax.servlet.jsp.jstl.sql.Result" %>  
<%@ page import="javax.servlet.jsp.jstl.sql.ResultSupport" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%

if(session.getAttribute("authenticatedUserId") == null){
	session.setAttribute("loginMessage", "Please Log In For Account Info");
	response.sendRedirect("loginForm.jsp");
	return;
}

String userId = session.getAttribute("authenticatedUserId").toString();
Integer id = null;

try{
	id = Integer.parseInt(userId);
}catch(Exception e){
	session.setAttribute("loginMessage", "Please reLogin In For Account Info, Could not read account Id");
	response.sendRedirect("loginForm.jsp");
	return;
}
try(Connection con = getConnection()){
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