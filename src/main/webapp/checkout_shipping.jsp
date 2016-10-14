<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_shipping.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Στοιχεία Αποστολής");
    lb.put("htmlTitleLG","Delivery Information");
    
    lb.put("recipientTitle","ΣΤΟΙΧΕΙΑ ΑΠΟΣΤΟΛΗΣ");
    lb.put("recipientTitleLG","DELIVERY INFORMATION");
    
    lb.put("note","*Τα πεδία με <b>έντονη γραφή</b> είναι απαραίτητα.");
    lb.put("noteLG","*<b>Bold</b> fields are required.");
    
    lb.put("shippingName","Ονομ/μο:");
    lb.put("shippingNameLG","Full name:");
    lb.put("shippingAddress","Διεύθυνση:");
    lb.put("shippingAddressLG","Address:");
    lb.put("shippingCity","Πόλη:");
    lb.put("shippingCityLG","City:");
    lb.put("shippingZipCode","Τ.Κ.:");
    lb.put("shippingZipCodeLG","ZIP/Postal code:");
    lb.put("shippingArea","Περιοχή:");
    lb.put("shippingAreaLG","Area:");
    lb.put("shippingCountry","Χώρα:");
    lb.put("shippingCountryLG","Country:");
    lb.put("shippingPhone","Τηλέφωνο:");
    lb.put("shippingPhoneLG","Phone number:");
    
    lb.put("district","Χώρα:");
    lb.put("districtLG","Country:");
    lb.put("location","Γεωγρ. διαμέρισμα:");
    lb.put("locationLG","Region:");
    
    lb.put("jsShippingName1","Παρακαλούμε συμπληρώστε το ονοματεπώνυμο.");
    lb.put("jsShippingName1LG","Please enter full name.");
    lb.put("jsShippingAddress1","Παρακαλούμε συμπληρώστε την διεύθυνση.");
    lb.put("jsShippingAddress1LG","Please enter address.");
    lb.put("jsShippingCity1","Παρακαλούμε συμπληρώστε την πόλη.");
    lb.put("jsShippingCity1LG","Please enter city.");
    lb.put("jsShippingCountry1","Παρακαλούμε επιλέξτε την χώρα.");
    lb.put("jsShippingCountry1LG","Please select country.");
    lb.put("jsShippingZipCode1","Παρακαλούμε συμπληρώστε τον ταχυδρομικό κώδικα.");
    lb.put("jsShippingZipCode1LG","Please enter zip/postal code.");
    lb.put("jsShippingPhone1","Παρακαλούμε συμπληρώστε το τηλέφωνο.");
    lb.put("jsShippingPhone1LG","Please enter phone number.");
    
    lb.put("jsDistrict","Παρακαλούμε επιλέξτε χώρα.");
    lb.put("jsDistrictLG","Please select a country.");
    lb.put("jsLocation","Παρακαλούμε επιλέξτε γεωγραφικό διαμέρισμα.");
    lb.put("jsLocationLG","Please select a region.");
    
    lb.put("continueBtn","&gt; Συνέχεια");
    lb.put("continueBtnLG","&gt; Continue");
    lb.put("continueExpl","(θα έχετε την δυνατότητα να ελέγξετε την παραγγελία σας πριν οριστικοποιηθεί)");
    lb.put("continueExplLG","(You can review this order before it is final)");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

if (order.getOrderLines() <= 0) {
    response.sendRedirect("http://" + serverName + "/" + response.encodeRedirectURL("shopping_cart.jsp"));
    return;
}

String shippingName = "", shippingAddress = "", shippingZipCode = "",
       shippingCity = "", shippingPhone = "", shippingArea = "",
       shippingLocationCode = "", shippingDistrictCode = "", shippingCountry = "", shippingCountryCode = "";

if (customer.getShippingName() != null) shippingName = customer.getShippingName();
if (customer.getShippingAddress() != null) shippingAddress = customer.getShippingAddress();
if (customer.getShippingZipCode() != null) shippingZipCode = customer.getShippingZipCode();
if (customer.getShippingCity() != null) shippingCity = customer.getShippingCity();
if (customer.getShippingPhone() != null) shippingPhone = customer.getShippingPhone();

if (customer.getShippingCountry() != null) shippingCountry = customer.getShippingCountry();
if (customer.getShippingCountryCode() != null) shippingCountryCode = customer.getShippingCountryCode();

if (customer.getShippingArea() != null) shippingArea = customer.getShippingArea();

int rows = 0;
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
    
    <script type="text/javascript">
    function validateForm(form) {
        if (isEmpty(form.shippingName.value)) {
            alert("<%= lb.get("jsShippingName1" + lang) %>");
            form.shippingName.focus();
            return false;
        }
        else if (isEmpty(form.shippingAddress.value)) {
            alert("<%= lb.get("jsShippingAddress1" + lang) %>");
            form.shippingAddress.focus();
            return false;
        }
        else if (isEmpty(form.shippingZipCode.value)) {
            alert("<%= lb.get("jsShippingZipCode1" + lang) %>");
            form.shippingZipCode.focus();
            return false;
        }
        else if (isEmpty(form.shippingCity.value)) {
            alert("<%= lb.get("jsShippingCity1" + lang) %>");
            form.shippingCity.focus();
            return false;
        }
        else if (form.shippingCountryCode.options[form.shippingCountryCode.selectedIndex].value == "") {
            alert("<%= lb.get("jsShippingCountry1" + lang) %>");
            form.shippingCountryCode.focus();
            return false;
        }
        else if (isEmpty(form.shippingPhone.value)) {
            alert("<%= lb.get("jsShippingPhone1" + lang) %>");
            form.shippingPhone.focus();
            return false;
        }
        else return true;
    }

    function confirmContinue() {
        if (validateForm(document.shippingForm) == true) {
            document.shippingForm.submit();
        }
    }
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<%@ include file="/include/checkout_steps.jsp" %>

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<div class="sectionHeader"><%= lb.get("recipientTitle" + lang) %></div>

<form name="shippingForm" method="post" action="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("customer.do") %>">

<input type="hidden" name="cmd" value="set_shipping_address" />

<div class="formInput">

<div class="clearfix"><span><%= lb.get("shippingName" + lang) %></span> <input type="text" name="shippingName" class="text" value="<%= shippingName %>" maxlength="75" /></div>
<div class="clearfix"><span><%= lb.get("shippingAddress" + lang)%></span> <input type="text" name="shippingAddress" class="text" value="<%= shippingAddress %>" maxlength="100" /></div>
<div class="clearfix"><span><%= lb.get("shippingZipCode" + lang) %></span> <input type="text" name="shippingZipCode" class="text" value="<%= shippingZipCode %>" maxlength="20" /></div>
<div class="clearfix"><span><%= lb.get("shippingCity" + lang) %></span> <input type="text" name="shippingCity" class="text" value="<%= shippingCity %>" maxlength="50" /></div>
<div class="clearfix"><span><%= lb.get("shippingCountry" + lang)%></span> 
    <select name="shippingCountryCode" class="text">
        <option value="">---</option>
        <%
        rows = helperBean.getTable("country","countryName" + lang);

        for (int i=0; i<rows; i++) { %>
            <option value="<%= helperBean.getColumn("countryCode") %>" <% if (shippingCountryCode.equals(helperBean.getColumn("countryCode"))) out.print("SELECTED"); %>><%= helperBean.getColumn("countryName" + lang) %></option>
        <%
            helperBean.nextRow();
        } %>
    </select>
</div>
<div class="clearfix"><span><%= lb.get("shippingPhone" + lang) %></span> <input type="text" name="shippingPhone" class="text" value="<%= shippingPhone %>" maxlength="30" /></div>

</div>

</form>

<div style="float:left; margin:20px 0 0 160px;">
<div style="float:left; margin-right:10px;"><a href="javascript:confirmContinue();void(0);"><span class="button"><%= lb.get("continueBtn" + lang)%></span></a></div>
<div style="float:left; line-height:35px; vertical-alignment:middle;"><span class="shop-tips"><%= lb.get("continueExpl" + lang)%></span></div>
</div>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

<% helperBean.closeResources(); %>

</body>
</html>