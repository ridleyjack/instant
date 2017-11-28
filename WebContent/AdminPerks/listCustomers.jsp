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
try(Connection con = Database.getConnection()){
	PreparedStatement list = con.prepareStatement("SELECT A.*,C.* FROM Account A, Customer C WHERE A.accountId=C.accountId");
	ResultSet rst = list.executeQuery();
	Result cust = ResultSupport.toResult(rst);
	request.setAttribute("customers", cust);
	request.getRequestDispatcher("listCustomersForm.jsp").forward(request, response);
	
}catch(SQLException ex){ out.print(ex);}


%>