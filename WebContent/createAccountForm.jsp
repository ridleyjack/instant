<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@include file="header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<style>
form{
text-align: center;
}
</style>

<title>Create Account</title>

<script>
function validateForm() {
    if (document.forms["myForm"]["username"].value == "") {
        alert("Username field required");
        return false;
    }
    if (document.forms["myForm"]["name"].value == "") {
        alert("Name field required");
        return false;
    }
    var p1 = document.forms["myForm"]["password"].value;
    if ( p1== "") {
        alert("Password field required");
        return false;
    }
    var p2 = document.forms["myForm"]["password2"].value
    if ( p1!=p2) {
        alert("Passwords must match");
        return false;
    }
    if (document.forms["myForm"]["email"].value == "") {
        alert("Email field required");
        return false;
    }
}
</script>
</head>
<body>

<%
// Print prior error login message if present (from sample code)
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<!-- This form creates customer accounts -->
<form name=myForm onsubmit="return validateForm()" action="createAccount.jsp">
	<h3>Account Information</h3>
	User Name:<br>
	<input type="text" name="username" ><br>
	Password:<br>
	<input type="text" name="password" ><br>
	Confirm Password:<br>
	<input type="text" name="password2" ><br>
	Full Name:<br>
	<input type="text" name="name" ><br>
	Email:<br>
	<input type="text" name="email" ><br>
	<h3>Primary Address</h3>
	Street:<br>
	<input type="text" name="street" ><br>
	City:<br>
	<input type="text" name="city" ><br>
	Postal Code:<br>
	<input type="text" name="postalcode" ><br><br>		
	<input type="hidden" name="type" value="0"> <!-- 0=customer -->	
	<input type="submit" value="Create Account"><br>
</form>

</body>
</html>