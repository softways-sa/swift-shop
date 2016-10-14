<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_forgot_password.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Ανάκτηση Κωδικού Πρόσβασης");
    lb.put("htmlTitleLG","Retrieve Password");
    
    lb.put("topPath","Ανάκτηση Κωδικού Πρόσβασης");
    lb.put("topPathLG","Retrieve Password");
    
    lb.put("message","Παρακαλούμε συμπληρώστε το email σας και πατήστε \"Ανάκτηση κωδικού\". Θα σας σταλεί το συνθηματικό σας με email άμεσα.");
    lb.put("messageLG","Please enter your email address below and click \"Retrieve password\" button. We\'ll send your password to you right away.");
    lb.put("remindPassword","Ανάκτηση Κωδικού Πρόσβασης");
    lb.put("remindPasswordLG","Retrieve Password");
    lb.put("submit","Ανάκτηση κωδικού");
    lb.put("submitLG","Retrieve password");
    
    lb.put("jsEmail", "Παρακαλούμε ελέγξτε το email σας.");
    lb.put("jsEmailLG", "Please check your email address.");
    
    lb.put("success","Προχωρήστε στην είσοδο πελατών.");
    lb.put("successLG","Sign in.");
    
    lb.put("noSuchEmail", "Δεν βρέθηκε πελάτης με αυτό το email. Παρακαλούμε ελέγξτε το email σας και δοκιμάστε ξανά.");
    lb.put("noSuchEmailLG", "Sorry no such email. Please check your email address and try again.");
    lb.put("passwordSent", "Σύντομα θα λάβετε τον κωδικό πρόσβασής σας με email.");
    lb.put("passwordSentLG", "We have emailed your password.");
}
%>

<%
int s = 0;

if ("no_such_email".equals(request.getAttribute("retrieve_password"))) s = 1;
else if ("retrieve_password_ok".equals(request.getAttribute("retrieve_password"))) s = 2;
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("topPath" + lang) %></title>
    
    <script type="text/javascript">
    function validateForm(forma) {
        // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
        if (forma.email.value == "" || emailCheck(forma.email.value) == false) {
            alert('<%= lb.get("jsEmail" + lang) %>');
            forma.email.focus();
            return false;
        }
        else return true;
    }
    </script>
</head>

<body>

<div id="siteContainer">
<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">
    
<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<div>
<form name="forgotPasswordForm" action="<%= "http://" + serverName + "/" + response.encodeURL("customer.do") %>" method="post" onsubmit="return validateForm(document.forgotPasswordForm); void(0);">

<input type="hidden" name="cmd" value="retrieve_password" />

<div class="sectionHeader"><%= lb.get("remindPassword" + lang) %></div>


<p><%= lb.get("message" + lang) %></p>

<div class="formInput">
    <div class="clearfix"><span>Email:</span> <input name="email" type="text" class="text" /></div>    
</div>

<%
if (s != 0) { %>
    <div style="margin:15px 0 0 160px; color:red; font-weight:bold;">
        <%
        if (s == 1) out.print(lb.get("noSuchEmail" + lang));
        else if (s == 2) { %>
            <div style="font-weight:normal; color:#666666;"><%=lb.get("passwordSent" + lang)%> <a href="<%= HTTP_PROTOCOL + serverName + "/customer_signin.jsp"%>" style="font-weight:bold; text-decoration:underline;"><%=lb.get("success" + lang)%></a></div>
        <%
        }
        %>
    </div>
<% } %>

<div style="margin:15px 0 0 160px;"><input type="submit" value="<%= lb.get("submit" + lang)%>" class="button" /></div>

</form>
</div>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

</body>
</html>