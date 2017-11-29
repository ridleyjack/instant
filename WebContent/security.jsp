<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.nio.charset.StandardCharsets" %> 
<%@ page import="java.security.MessageDigest" %> 
<%@ page import="java.security.NoSuchAlgorithmException" %> 
<%@ page import="java.util.Base64" %> 

<%!
public static String genhash_SHA256(String  str) throws NoSuchAlgorithmException{
	MessageDigest digest = MessageDigest.getInstance("SHA-256");
	byte[] hash = digest.digest( str.getBytes(StandardCharsets.UTF_8));
	String password = Base64.getEncoder().encodeToString(hash);
	return password;		
}
%>