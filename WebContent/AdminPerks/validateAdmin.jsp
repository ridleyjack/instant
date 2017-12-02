
<%
if (session.getAttribute("authenticatedUserId") == null || session.getAttribute("authenticatedUserId").equals("") ||
 session.getAttribute("isAdmin") == null || session.getAttribute("isAdmin").equals("1")) {
	out.println("You do not have the proper authorization to perform this action!");
	return;
}
%>