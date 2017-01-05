<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_signin.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Είσοδος");
    lb.put("htmlTitleLG","Sign In");
    
    lb.put("top_path","Είσοδος");
    lb.put("top_pathLG","Sign In");
    
    lb.put("rcustomers","ΠΕΛΑΤΕΣ");
    lb.put("rcustomersLG","CUSTOMERS");
    
    lb.put("newCustomers","ΝΕΟΙ ΠΕΛΑΤΕΣ");
    lb.put("newCustomersLG","NEW CUSTOMERS");
    
    lb.put("password","Κωδικός πρόσβασης");
    lb.put("passwordLG","Password");
    
    lb.put("btnNewCustomer","Συνέχεια");
    lb.put("btnNewCustomerLG","Continue");
    
    lb.put("btSignIn","Είσοδος");
    lb.put("btSignInLG","Sign In");
    
    lb.put("btSubmit","Εγγραφή");
    lb.put("btSubmitLG","Register");
    
    lb.put("forgotPassword","Ξεχάσατε τον κωδικό πρόσβασής σας;");
    lb.put("forgotPasswordLG","Forgot your password?");
    
    lb.put("newCustText","<b>Εάν αυτή είναι η πρώτη σας αγορά από το ηλεκτρονικό μας κατάστημα</b> και δεν έχετε κωδικό πρόσβασης, παρακαλούμε πατήστε \"Εγγραφή\". <p>Στην περίπτωση που δεν επιθυμείτε να κάνετε εγγραφή πατήστε \"Αγορά ως Επισκέπτης\".</p>");
    lb.put("newCustTextLG","<b>If this is your first purchase from our shop,</b> please click \"Register\". If you don't wish to register please click \"Guest Checkout\".");
    
    lb.put("returningCustText","<b>Εάν έχετε πραγματοποιήσει αγορά στο παρελθόν από το ηλεκτρονικό μας κατάστημα,</b> παρακαλούμε συμπληρώστε τα παρακάτω στοιχεία.");
    lb.put("returningCustTextLG","<b>If you have purchased from our shop,</b> please sign in below.");
    
    lb.put("invalid_login","Λάθος email ή κωδικός.");
    lb.put("invalid_loginLG","Incorrect e-mail or password.");
    
    lb.put("btnGuestCheckout","Αγορά ως Επισκέπτης");
    lb.put("btnGuestCheckoutLG","Guest Checkout");
}
%>

<%
String target = request.getParameter("target") == null ? "" : request.getParameter("target");

boolean customer_signin_jsp_invalid_login = false;

if (request.getAttribute("signin") != null && request.getAttribute("signin").equals("invalid_login")) customer_signin_jsp_invalid_login = true;
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

  <div class="row">
    
    <div class="col-sm-6" id="newCustomerWrapper">
      <div class="sectionHeader"><%= lb.get("newCustomers" + lang)%></div>

      <p><%= lb.get("newCustText" + lang)%></p>

      <div class="clearfix">
        <div class="fl mr"><input type="button" onclick="location.href='<%= HTTP_PROTOCOL + serverName + "/" + "customer_create_account.jsp?target=" + target %>'" value="<%=lb.get("btSubmit" + lang)%>" class="button" /></div>
        <div class="fl"><input type="button" onclick="location.href='<%=HTTP_PROTOCOL + serverName + "/" + "customer.do?cmd=guest_checkout"%>'" value="<%=lb.get("btnGuestCheckout" + lang)%>" class="button" /></div>
      </div>
    </div>
    
    <div class="col-sm-6" id="existingCustomerWrapper">
      <div class="sectionHeader"><%= lb.get("rcustomers" + lang) %></div>

      <div>
          <form name="signinForm" action="<%= HTTP_PROTOCOL + serverName + "/" + "customer.do" %>" method="POST">

          <input type="hidden" name="cmd" value="signin" />
          <input type="hidden" name="target" value="<%= target %>" />

          <p><%= lb.get("returningCustText" + lang)%></p>

          <div class="formInput">
          <div class="clearfix"><span>Email:</span> <input name="username" type="text" value="" class="text"/></div>
          <div class="clearfix"><span><%= lb.get("password" + lang)%>:</span> <input name="password" type="password" class="text"/></div>
          </div>

          <div id="signinForgPasswdWrapper">

          <%
          if (customer_signin_jsp_invalid_login == true) { %>
              <h3 style="color:#D21920; margin-top:15px;"><%= lb.get("invalid_login" + lang) %></h3>
          <% } %>

          <div style="margin-top:15px;"><a href="<%= "http://" + serverName + "/" + "customer_forgot_password.jsp"%>" style="text-decoration:underline;"><%= lb.get("forgotPassword" + lang)%></a></div>

          <div style="margin-top:15px;"><input type="submit" value="<%= lb.get("btSignIn" + lang)%>" class="button" /></div>
          </div>

          </form>
      </div>
    </div>

  </div>
        
</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>