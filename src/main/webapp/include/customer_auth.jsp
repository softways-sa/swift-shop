<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String shopping_auth_url = "customer_signin.jsp";

if (customer.isSignedIn() == false) {
  response.sendRedirect("/" + shopping_auth_url);
  return;
}
%>