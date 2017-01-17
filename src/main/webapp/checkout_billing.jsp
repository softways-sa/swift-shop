<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_billing.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Προσωπικά Στοιχεία");
  lb.put("htmlTitleLG","Personal Information");
  lb.put("billingName","Επωνυμία εταιρίας:");
  lb.put("billingNameLG","Company name:");
  lb.put("billingProfession","Δραστηριότητα:");
  lb.put("billingProfessionLG","Company activity:");
  lb.put("billingAfm","Α.Φ.Μ.:");
  lb.put("billingAfmLG","VAT No:");
  lb.put("billingDoy","Δ.Ο.Υ.:");
  lb.put("billingDoyLG","Tax Office Code:");
  lb.put("customer","ΠΡΟΣΩΠΙΚΑ ΣΤΟΙΧΕΙΑ");
  lb.put("customerLG","PERSONAL INFORMATION");
  lb.put("invoiceTitle","Έκδοση τιμολογίου");
  lb.put("invoiceTitleLG","Invoice");
  lb.put("address","Διεύθυνση:");
  lb.put("addressLG","Address:");
  lb.put("city","Πόλη:");
  lb.put("cityLG","City:");
  lb.put("zipcode","Τ.Κ.:");
  lb.put("zipcodeLG","ZIP/Postal code:");
  lb.put("country","Χώρα:");
  lb.put("countryLG","Country:");
  lb.put("phoneNumber","Τηλέφωνο:");
  lb.put("phoneNumberLG","Phone number:");
  lb.put("note","*Τα πεδία με <b>έντονη γραφή</b> είναι απαραίτητα.");
  lb.put("noteLG","*<b>Bold</b> fields are required.");
  lb.put("shipCheckText","Είναι τα παραπάνω στοιχεία χρέωσης ίδια με τα στοιχεία αποστολής;");
  lb.put("shipCheckTextLG","Is this billing address also the shipping location?");
  lb.put("yes","Ναι");
  lb.put("yesLG","Yes");
  lb.put("no","Όχι");
  lb.put("noLG","No");
  lb.put("email","Email:");
  lb.put("emailLG","Email:");
  lb.put("lastname","Επώνυμο:");
  lb.put("lastnameLG","Last name:");
  lb.put("firstname","Όνομα:");
  lb.put("firstnameLG","First name:");
  lb.put("invoiceMsg","Αν επιθυμείτε την έκδοση τιμολογίου πρέπει να συμπληρώσετε και τα παρακάτω στοιχεία.");
  lb.put("invoiceMsgLG","If you would like to receive an invoice please fill in the following fields.");
  lb.put("ordPrefNotes","Εδώ μπορείτε να συμπληρώσετε επιπλέον προτιμήσεις/παρατηρήσεις που έχετε.");
  lb.put("ordPrefNotesLG","If you have any preferences/notes please enter them here.");
  lb.put("ordPrefNotesTitle","Παρατηρήσεις");
  lb.put("ordPrefNotesTitleLG","Notes");
  lb.put("fillBillingAddress","Παρακαλούμε συμπληρώστε την διεύθυνση.");
  lb.put("fillBillingAddressLG","Please fill in address.");
  lb.put("fillBillingCity","Παρακαλούμε συμπληρώστε την πόλη.");
  lb.put("fillBillingCityLG","Please fill in city.");
  lb.put("fillBillingZipCode","Παρακαλούμε συμπληρώστε τον ταχυδρομικό κώδικα.");
  lb.put("fillBillingZipCodeLG","Please fill in ZIP/Postal code.");
  lb.put("fillLastname","Παρακαλούμε συμπληρώστε τo επώνυμο.");
  lb.put("fillLastnameLG","Please fill in last name.");
  lb.put("fillFirstname","Παρακαλούμε συμπληρώστε τo όνομα.");
  lb.put("fillFirstnameLG","Please fill in first name.");
  lb.put("fillBillingPhone","Παρακαλούμε συμπληρώστε τo τηλέφωνο.");
  lb.put("fillBillingPhoneLG","Please fill in phone number.");
  lb.put("fillBillingCountry","Παρακαλούμε επιλέξτε μία χώρα");
  lb.put("fillBillingCountryLG","Please select a country");
  lb.put("continueBtn","Συνέχεια");
  lb.put("continueBtnLG","Continue");
  lb.put("continueExpl","(θα έχετε την δυνατότητα να ελέγξετε την παραγγελία σας πριν οριστικοποιηθεί)");
  lb.put("continueExplLG","(You can review this order before it is final)");
  lb.put("jsEnterEmail","Παρακαλούμε ελέγξτε το email σας.");
  lb.put("jsEnterEmailLG","Please check your email address.");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);

if (order.getOrderLines() <= 0) {
    response.sendRedirect("http://" + serverName + "/" + response.encodeRedirectURL("shopping_cart.jsp"));
    return;
}

String lastname = "", firstname = "",
       email = "", billingAddress = "", billingCountryCode = "",
       billingCity = "", billingZipCode = "", billingPhone = "";

String billingName = "", billingAfm = "", billingDoy = "", billingProfession = "";

String ordPrefNotes = "";

if (customer. getLastname() != null) lastname = customer.getLastname();
if (customer.getFirstname() != null) firstname = customer.getFirstname();
if (customer.getEmail() != null) email = customer.getEmail();

if (customer.getBillingAddress() != null) billingAddress = customer.getBillingAddress();
if (customer.getBillingCountryCode() != null) billingCountryCode = customer.getBillingCountryCode();
if (customer.getBillingCity() != null) billingCity = customer.getBillingCity();
if (customer.getBillingZipCode() != null) billingZipCode = customer.getBillingZipCode();
if (customer.getBillingPhone() != null) billingPhone = customer.getBillingPhone();

if (customer.getBillingName() != null) billingName = customer.getBillingName();
if (customer.getBillingAfm() != null) billingAfm = customer.getBillingAfm();
if (customer.getBillingDoy() != null) billingDoy = customer.getBillingDoy();
if (customer.getBillingProfession() != null) billingProfession = customer.getBillingProfession();

if (customer.getOrdPrefNotes() != null) ordPrefNotes = customer.getOrdPrefNotes();

int rows = 0;
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%=lb.get("htmlTitle" + lang)%></title>
    
    <script type="text/javascript">
    function validateForm(form) {
        if (form.firstname.value == "") {
            alert("<%= lb.get("fillFirstname" + lang) %>");
            form.firstname.focus();
            return false;
        }
        else if (form.lastname.value == "") {
            alert("<%= lb.get("fillLastname" + lang) %>");
            form.lastname.focus();
            return false;
        }
        else if (form.billingAddress.value == "") {
            alert("<%= lb.get("fillBillingAddress" + lang) %>");
            form.billingAddress.focus();
            return false;
        }
        else if (form.billingCity.value == "") {
            alert("<%= lb.get("fillBillingCity" + lang) %>");
            form.billingCity.focus();
            return false;
        }
        else if (form.billingZipCode.value == "") {
            alert("<%= lb.get("fillBillingZipCode" + lang) %>");
            form.billingZipCode.focus();
            return false;
        }
        else if (form.billingCountryCode.options[form.billingCountryCode.selectedIndex].value == "") {
            alert("<%= lb.get("fillBillingCountry" + lang) %>");
            form.billingCountryCode.focus();
            return false;
        }
        else if (form.billingPhone.value == "") {
            alert("<%= lb.get("fillBillingPhone" + lang) %>");
            form.billingPhone.focus();
            return false;
        }
        <%if (customer.isGuestCheckout()) {%>
          else if (isEmpty(form.email.value) == true || emailCheck(form.email.value) == false) {
            alert("<%= lb.get("jsEnterEmail" + lang) %>");
            form.email.focus();
            return false;
          }
        <%}%>
        else return true;
    }
    
    function confirmContinue() {
        if (validateForm(document.billingForm) == true) {
            document.billingForm.submit();
        }
    }
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

<%@ include file="/include/checkout_steps.jsp" %>

<div class="row">
  <div class="col-xs-12">

    <div class="sectionHeader"><%= lb.get("customer" + lang)%></div>

    <form name="billingForm" method="post" action="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("customer.do") %>">

    <input type="hidden" name="cmd" value="set_billing_address" />
    <%if (!customer.isGuestCheckout()) {%><input type="hidden" name="email" value="<%=email%>" /><%}%>

    <div class="formInput">

    <div class="clearfix"><span><%= lb.get("firstname" + lang) %></span> <input type="text" name="firstname" value="<%= firstname %>" class="text" maxlength="30" /></div>
    <div class="clearfix"><span><%= lb.get("lastname" + lang) %></span> <input type="text" name="lastname" value="<%= lastname %>" class="text" maxlength="30" /></div>
    <div class="clearfix"><span><%= lb.get("address" + lang)%></span> <input type="text" name="billingAddress" value="<%= billingAddress %>" class="text" maxlength="100" /></div>
    <div class="clearfix"><span><%= lb.get("city" + lang) %></span> <input type="text" name="billingCity" value="<%= billingCity %>" class="text" maxlength="50" /></div>
    <div class="clearfix"><span><%= lb.get("zipcode" + lang) %></span> <input type="text" name="billingZipCode" value="<%= billingZipCode %>" class="text" maxlength="10" /></div>
    <div class="clearfix"><span><%= lb.get("country" + lang)%></span> 
      <select name="billingCountryCode" class="text">
        <option value="">---</option>
        <%
        rows = helperBean.getTable("country","countryName"+lang);

        for (int i=0; i<rows; i++) {%>
          <option value="<%= helperBean.getColumn("countryCode") %>" <% if (billingCountryCode.equals(helperBean.getColumn("countryCode"))) out.print("SELECTED"); %>><%= helperBean.getColumn("countryName" + lang) %></option>
        <%
          helperBean.nextRow();
        }%>
      </select>
    </div>
    <div class="clearfix"><span><%= lb.get("phoneNumber" + lang) %></span> <input type="text" name="billingPhone" value="<%= billingPhone %>" class="text" maxlength="30" /></div>
    <%if (customer.isGuestCheckout()) {%><div class="clearfix"><span><%= lb.get("email" + lang) %></span> <input type="text" name="email" value="<%=email%>" class="text" maxlength="50" /></div><%}%>
    </div>

    <div class="clearfix" style="margin-top:20px; font-weight:bold;"><span><%= lb.get("shipCheckText" + lang) %></span>&nbsp;&nbsp;&nbsp;&nbsp;<b><%= lb.get("yes" + lang) %></b> <input type="radio" name="useBilling" value="1" checked="checked" />&nbsp;&nbsp;&nbsp;&nbsp;<b><%= lb.get("no" + lang) %></b> <input type="radio" name="useBilling" value="0" /></div>

    <div class="sectionHeader" style="margin:25px 0 10px;"><%= lb.get("invoiceTitle" + lang)%> <span class="hidden-xs" style="font-weight:normal; font-size:11px; margin-left:40px;"><%= lb.get("invoiceMsg" + lang)%></span></div>

    <div class="formInput">
    <div class="clearfix"><span><%= lb.get("billingName" + lang).toString() %></span> <input type="text" name="billingName" value="<%= billingName %>" class="text" maxlength="75" /></div>
    <div class="clearfix"><span><%= lb.get("billingAfm" + lang).toString() %></span> <input type="text" name="billingAfm" value="<%= billingAfm %>" class="text" maxlength="15" /></div>
    <div class="clearfix"><span><%= lb.get("billingDoy" + lang).toString() %></span> <input type="text" name="billingDoy" value="<%= billingDoy %>" class="text" maxlength="40" /></div>
    <div class="clearfix"><span><%= lb.get("billingProfession" + lang).toString() %></span> <input type="text" name="billingProfession" value="<%= billingProfession %>" class="text" maxlength="100" /></div>
    </div>

    <div class="sectionHeader" style="margin:25px 0 10px;"><%= lb.get("ordPrefNotesTitle" + lang)%> <span class="hidden-xs" style="font-weight:normal; font-size:11px; margin-left:40px;"><%= lb.get("ordPrefNotes" + lang).toString() %></span></div>

    <textarea name="ordPrefNotes" cols="40" rows="5" class="text"><%= ordPrefNotes %></textarea>

    </form>

    <div style="float:left; margin-top:20px;">
      <div style="float:left; margin-right:10px;"><a href="javascript:confirmContinue();void(0);"><span class="button"><%= lb.get("continueBtn" + lang)%></span></a></div>
      <div style="float:left; line-height:35px; vertical-alignment:middle;"><span class="shop-tips"><%= lb.get("continueExpl" + lang)%></span></div>
    </div>

  </div>
</div>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

<% helperBean.closeResources(); %>

</body>
</html>