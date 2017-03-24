<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_create_account.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Νέοι Πελάτες");
  lb.put("htmlTitleLG","New Customers");
  lb.put("newCustomers","ΝΕΟΙ ΠΕΛΑΤΕΣ");
  lb.put("newCustomersLG","NEW CUSTOMERS");
  lb.put("note","*Τα πεδία με <b>έντονη γραφή</b> είναι απαραίτητα.");
  lb.put("noteLG","*<b>Bold</b> fields are required.");
  lb.put("password","Κωδικός πρόσβασης");
  lb.put("passwordLG","Password");
  lb.put("firstname","Όνομα");
  lb.put("firstnameLG","First name");
  lb.put("lastname","Επίθετο");
  lb.put("lastnameLG","Last name");
  lb.put("createPassword","Δημιουργήστε κωδικό πρόσβασης");
  lb.put("createPasswordLG","Create password");
  lb.put("vPassword","Επαλήθευση κωδικού");
  lb.put("vPasswordLG","Confirm password");
  lb.put("btSubmit","&gt; Δημιουργία λογαριασμού");
  lb.put("btSubmitLG","&gt; Create account");
  lb.put("noteForOffers","Λήψη ενημερωτικών email");
  lb.put("noteForOffersLG","Receive newsletters");
  lb.put("newCustText","<b>Παρακαλούμε συμπληρώστε τα παρακάτω στοιχεία για να δημιουργήσετε τον online λογαριασμό σας.</b>");
  lb.put("newCustTextLG","<b>Please fill out the fields below to create your online account.</b>");
  lb.put("jsEnterFirstname","Παρακαλούμε πληκτρολογήστε το όνομά σας.");
  lb.put("jsEnterFirstnameLG","Please enter your first name.");
  lb.put("jsEnterLastname","Παρακαλούμε πληκτρολογήστε το επίθετο σας.");
  lb.put("jsEnterLastnameLG","Please enter your last name.");
  lb.put("jsBillingCity","Παρακαλούμε πληκτρολογήστε την πόλη σας.");
  lb.put("jsBillingCityLG","Please enter your city.");
  lb.put("jsBillingCountry","Παρακαλούμε επιλέξτε την χωρά σας.");
  lb.put("jsBillingCountryLG","Please select your country.");
  lb.put("jsEnterEmail","Παρακαλούμε ελέγξτε το email σας.");
  lb.put("jsEnterEmailLG","Please check your email address.");
  lb.put("jsEnterPassword","Παρακαλούμε δημιουργήστε τον κωδικό πρόσβασής σας.");
  lb.put("jsEnterPasswordLG","Please create your password.");
  lb.put("jsPasswordNotMatch","Η επαλήθευση του κωδικού πρόσβασής σας απέτυχε.");
  lb.put("jsPasswordNotMatchLG","Your password does not match.");
}
%>

<%
String target = request.getParameter("target") == null ? "" : request.getParameter("target");
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
    
    <script type="text/javascript">
    function validateForm(form) {
        if (isEmpty(form.firstname.value) == true) {
            alert("<%= lb.get("jsEnterFirstname" + lang) %>");
            form.firstname.focus();
            return false;
        }
        else if (isEmpty(form.lastname.value) == true) {
            alert("<%= lb.get("jsEnterLastname" + lang) %>");
            form.lastname.focus();
            return false;
        }
        else if (isEmpty(form.email.value) == true || emailCheck(form.email.value) == false) {
            alert("<%= lb.get("jsEnterEmail" + lang) %>");
            form.email.focus();
            return false;
        }
        else if (isEmpty(form.password.value) == true) {
            alert("<%= lb.get("jsEnterPassword" + lang) %>");
            form.password.focus();
            return false;
        }
        else if (form.password.value != form.vpassword.value) {
            alert("<%= lb.get("jsPasswordNotMatch" + lang) %>");
            form.password.focus();
            return false;
        }
        else return true;
    }

    function confirmContinue() {
        if (validateForm(document.registerForm) == true) {
            document.registerForm.submit();
        }
    }
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

  <div class="row">
    <div class="col-sm-12">
      <div class="sectionHeader"><%= lb.get("newCustomers" + lang)%></div>

      <form name="registerForm" action="/customer.do" method="post">

      <input type="hidden" name="cmd" value="create_account" />
      <input type="hidden" name="target" value="<%= target %>" />
      <input type="hidden" name="custLang" value="<%=lang%>" />

      <p><%= lb.get("newCustText" + lang) %></p>

      <div class="formInput">
      <div class="clearfix"><span><%= lb.get("firstname" + lang) %>:</span>  <input name="firstname" type="text" value="" maxlength="30" class="text"/></div>
      <div class="clearfix"><span><%= lb.get("lastname" + lang) %>:</span> <input name="lastname" type="text" value="" maxlength="30" class="text"/></div>
      <div class="clearfix"><span>Email:</span> <input name="email" type="text" value="" maxlength="75" class="text"/></div>
      <div class="clearfix"><span><%= lb.get("createPassword" + lang) %>:</span> <input name="password" type="password" maxlength="75" class="text"/></div>
      <div class="clearfix"><span><%= lb.get("vPassword" + lang) %>:</span> <input name="vpassword" type="password" maxlength="75" class="text"/></div>
      <div class="clearfix"><span><%= lb.get("noteForOffers" + lang) %>:</span> <input name="receiveEmail" type="checkbox" value="1" checked/></div>
      </div>

      <div style="margin:15px 0 0 160px;"><input type="button" onclick="javascript:confirmContinue();void(0);" value="<%= lb.get("btSubmit" + lang) %>" class="button" /></div>

      </form>
    </div>
  </div>

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>