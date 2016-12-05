<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String shopping_auth_target = "myaccount";

if (whereAmI.equals("/checkout_billing.jsp")) {
  shopping_auth_target = "checkout";
}

String shopping_auth_url = "customer_signin.jsp?target=" + shopping_auth_target;

if (customer.isSignedIn() == false && customer.isGuestCheckout() == false) {
  response.sendRedirect(HTTP_PROTOCOL + serverName + "/" + shopping_auth_url);
  return;
}
%>