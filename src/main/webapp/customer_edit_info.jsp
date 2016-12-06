<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_edit_info.jsp"; %>

<%@ include file="/include/customer_auth.jsp" %>

<%@ page import="gr.softways.dev.eshop.emaillists.newsletter.Newsletter" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.customer.Present" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Μεταβολή Στοιχείων");
    lb.put("htmlTitleLG","Update Information");
    
    lb.put("subTitle","Μεταβολή Στοιχείων");
    lb.put("subTitleLG","Update Information");
    
    lb.put("invoiceTitle","Έκδοση τιμολογίου");
    lb.put("invoiceTitleLG","Invoice");
    
    lb.put("text","*Τα πεδία με <b>έντονη γραφή</b> είναι απαραίτητα.");
    lb.put("textLG","*<b>Bold</b> fields are required.");
    
    lb.put("noteForOffers","Λήψη ενημερωτικών email");
    lb.put("noteForOffersLG","Receive newsletters");
    
    lb.put("SBNameBilling","Επωνυμία εταιρίας:");
    lb.put("SBNameBillingLG","Company name:");
    lb.put("SBProfessionBilling","Δραστηριότητα:");
    lb.put("SBProfessionBillingLG","Company activity:");
    lb.put("SBAfmBilling","Α.Φ.Μ.:");
    lb.put("SBAfmBillingLG","VAT:");
    lb.put("SBDoyBilling","Δ.Ο.Υ.:");
    lb.put("SBDoyBillingLG","TAX OFFICE CODE:");
    
    lb.put("billingAddress","Διεύθυνση:");
    lb.put("billingAddressLG","Address:");

    lb.put("billingCity","Πόλη:");
    lb.put("billingCityLG","City:");

    lb.put("billingZipCode","ΤΚ:");
    lb.put("billingZipCodeLG","Postal Code:");
    
    lb.put("SBCountryCodeBilling","Χώρα:");
    lb.put("SBCountryCodeBillingLG","Country:");
    
    lb.put("billingPhone","Τηλέφωνο:");
    lb.put("billingPhoneLG","Phone number:");

    lb.put("email","Email:");
    lb.put("emailLG","Email:");

    lb.put("lastname","Επίθετο:");
    lb.put("lastnameLG","Last name:");
    lb.put("firstname","Όνομα:");
    lb.put("firstnameLG","First name:");
    
    lb.put("fillBillingAddress","Παρακαλούμε συμπληρώστε τη διεύθυνση.");
    lb.put("fillBillingAddressLG","Please fill in address.");

    lb.put("fillBillingCity","Παρακαλούμε συμπληρώστε την πόλη.");
    lb.put("fillBillingCityLG","Please fill in city.");
    
    lb.put("fillSBZipCodeBilling","Παρακαλούμε συμπληρώστε τον ταχυδρομικό κώδικα.");
    lb.put("fillSBZipCodeBillingLG","Please fill in zip code.");

    lb.put("fillBillingCountry","Παρακαλούμε επιλέξτε την χωρά σας.");
    lb.put("fillBillingCountryLG","Please select your country.");
    
    lb.put("fillSBPhoneBilling","Παρακαλούμε συμπληρώστε τo τηλέφωνο.");
    lb.put("fillSBPhoneBillingLG","Please fill in phone number.");
    
    lb.put("fillLastname","Παρακαλούμε συμπληρώστε τo επίθετο.");
    lb.put("fillLastnameLG","Please fill in last name.");

    lb.put("fillFirstname","Παρακαλούμε συμπληρώστε τo όνομα.");
    lb.put("fillFirstnameLG","Please fill in first name.");
    
    lb.put("fillEmail","Παρακαλούμε ελέξτε το email σας.");
    lb.put("fillEmailLG","Please check your email address.");
    
    lb.put("invoiceMsg","Αν επιθυμείτε την έκδοση τιμολογίου πρέπει να συμπληρώσετε και τα παρακάτω στοιχεία.");
    lb.put("invoiceMsgLG","If you would like to receive an invoice please fill in the following fields.");
    
    lb.put("update","Μεταβολή στοιχείων");
    lb.put("updateLG","Update");
    
    lb.put("cancel","Άκυρο");
    lb.put("cancelLG","Cancel");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);

int rows = 0;

helperBean.getCustomer(customer.getCustomerId(), null);

String lastname = "", firstname = "",
       email = "", SBAddressBilling  = "", SBCountryCodeBilling = "",
       SBCityBilling = "", SBZipCodeBilling = "", SBPhoneBilling = "", SBFaxBilling = "",
       SBCodeBilling = "", SBRegionBilling = "";

String SBNameBilling = "", SBAfmBilling = "",
       SBDoyBilling = "", SBProfessionBilling = "";
       
lastname = helperBean.getColumn("lastname");
firstname = helperBean.getColumn("firstname");
email = helperBean.getColumn("email");

SBAddressBilling = helperBean.getColumn("SBAddress");
SBCountryCodeBilling = helperBean.getColumn("SBCountryCode");
SBCityBilling = helperBean.getColumn("SBCity");
SBZipCodeBilling = helperBean.getColumn("SBZipCode");
SBPhoneBilling = helperBean.getColumn("SBPhone");

SBNameBilling = helperBean.getColumn("SBName");
SBAfmBilling = helperBean.getColumn("SBAfm");
SBDoyBilling = helperBean.getColumn("SBDoy");
SBProfessionBilling = helperBean.getColumn("SBProfession");

String receiveEmail = "0";

DbRet dbRet = Newsletter.checkListStatus(email, "NEWSLETTER");

if (dbRet.getRetStr().length() > 0) receiveEmail = "1";
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
    
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
        else if (form.SBAddressBilling.value == "") {
            alert("<%= lb.get("fillBillingAddress" + lang) %>");
            form.SBAddressBilling.focus();
            return false;
        }
        else if (form.SBCityBilling.value == "") {
            alert("<%= lb.get("fillBillingCity" + lang) %>");
            form.SBCityBilling.focus();
            return false;
        }
        else if (isEmpty(form.SBZipCodeBilling.value) == true) {
            alert("<%= lb.get("fillSBZipCodeBilling" + lang) %>");
            form.SBZipCodeBilling.focus();
            return false;
        }
        else if (form.SBCountryCodeBilling.options[form.SBCountryCodeBilling.selectedIndex].value == "") {
            alert("<%= lb.get("fillBillingCountry" + lang) %>");
            form.SBCountryCodeBilling.focus();
            return false;
        }
        else if (isEmpty(form.SBPhoneBilling.value) == true) {
            alert("<%= lb.get("fillSBPhoneBilling" + lang) %>");
            form.SBPhoneBilling.focus();
            return false;
        }
        else if (isEmpty(form.email.value) == true || emailCheck(form.email.value) == false) {
            alert("<%= lb.get("Email" + lang) %>");
            form.email.focus();
            return false;
        }
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

<div id="siteContainer">
<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<%@ include file="/include/customer_myaccount_options.jsp" %>

<div class="sectionHeader"><%= lb.get("subTitle" + lang) %></div>

<form name="billingForm" action="<%= "http://" + serverName + "/" + response.encodeURL("customer.do") %>" method="post">

<input type="hidden" name="cmd" value="edit_info" />

<div class="formInput">
<div class="clearfix"><span><%= lb.get("firstname" + lang) %></span> <input type="text" name="firstname" value="<%= firstname %>" class="text" maxlength="30" /></div>
<div class="clearfix"><span><%= lb.get("lastname" + lang) %></span> <input type="text" name="lastname" value="<%= lastname %>" class="text" maxlength="30" /></div>
<div class="clearfix"><span><%= lb.get("billingAddress" + lang) %></span> <input type="text" name="SBAddressBilling" value="<%= SBAddressBilling %>" class="text" maxlength="100" /></div>
<div class="clearfix"><span><%= lb.get("billingCity" + lang) %></span> <input type="text" name="SBCityBilling" value="<%= SBCityBilling %>" class="text" maxlength="50" /></div>
<div class="clearfix"><span><%= lb.get("billingZipCode" + lang) %></span> <input type="text" name="SBZipCodeBilling" value="<%= SBZipCodeBilling %>" class="text" maxlength="10" /></div>
<div class="clearfix"><span><%= lb.get("SBCountryCodeBilling" + lang) %></span> 
    <select name="SBCountryCodeBilling">
        <option value="">---</option>
        <%
        rows = helperBean.getTable("country","countryName"+lang);

        for (int i=0; i<rows; i++) { %>
            <option value="<%= helperBean.getColumn("countryCode") %>" <% if (SBCountryCodeBilling.equals(helperBean.getColumn("countryCode"))) out.print("selected"); %>><%= helperBean.getColumn("countryName" + lang) %></option>
        <%
            helperBean.nextRow();
        } %>
    </select></div>
<div class="clearfix"><span><%= lb.get("billingPhone" + lang)%></span> <input type="text" name="SBPhoneBilling" value="<%= SBPhoneBilling %>" class="text" maxlength="30" /></div>
<div class="clearfix"><span><%= lb.get("email" + lang) %></span> <input type="text" name="email" value="<%= email %>" class="text" maxlength="75" /></div>
<div class="clearfix"><span><%= lb.get("noteForOffers" + lang) %></span> <input type="checkbox" name="receiveEmail" value="1" <% if ("1".equals(receiveEmail)) out.print("checked"); %> /></div>
</div>

<div class="sectionHeader" style="margin:25px 0 10px;"><%= lb.get("invoiceTitle" + lang)%> <span style="font-weight:normal; font-size:11px; margin-left:40px;"><%= lb.get("invoiceMsg" + lang)%></span></div>
        
<div class="formInput">
<div class="clearfix"><span><%= lb.get("SBNameBilling" + lang)%></span> <input type="text" name="SBNameBilling" value="<%= SBNameBilling %>" class="text" maxlength="75" /></div>
<div class="clearfix"><span><%= lb.get("SBAfmBilling" + lang) %></span> <input type="text" name="SBAfmBilling" value="<%= SBAfmBilling %>" class="text" maxlength="15" /></div>
<div class="clearfix"><span><%= lb.get("SBDoyBilling" + lang) %></span> <input type="text" name="SBDoyBilling" value="<%= SBDoyBilling %>" class="text" maxlength="40" /></div>
<div class="clearfix"><span><%= lb.get("SBProfessionBilling" + lang) %></span> <input type="text" name="SBProfessionBilling" value="<%= SBProfessionBilling %>" class="text" maxlength="100" /></div>
</div>

<div style="float:left; margin:15px 0 0 160px;">
<div style="float:left; margin-right:20px;"><a href="javascript:confirmContinue();void(0);"><span class="button"><%= lb.get("update" + lang)%></span></a></div>
<div style="float:left;"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_myaccount.jsp")%>"><span class="button"><%= lb.get("cancel" + lang)%></span></a></div>
</div>

</form>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

<% helperBean.closeResources(); %>

</body>
</html>