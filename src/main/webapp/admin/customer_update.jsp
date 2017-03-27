<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,java.sql.Timestamp,gr.softways.dev.eshop.emaillists.newsletter.Newsletter" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.customer.Present" />

<%
request.setAttribute("admin.topmenu","orders");

helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

// customer table
String firstname = "", lastname = "",
       occupation = "", email = "",
       title = "", sex = "", phone = "", fax = "", dateLastUsed = "",
       dateCreated= "", lastIPUsed = "", contactUsDescr = "",
       lockedAccnt = "", custText = "";

String receiveEmail = "0";

Timestamp birthDate = null;

BigDecimal zero = new BigDecimal("0"),
           discountPct = zero, purchaseValEU = zero;

int hotdealBuysCnt = 0, buysCnt = 0, customerType = 0;

// shipBillInfo billing table
String SBCodeBilling = "", SBNameBilling = "",
       SBAddressBilling = "", SBAreaCodeBilling = "",
       SBCityBilling = "", SBRegionBilling = "",
       SBCountryCodeBilling = "", SBZipCodeBilling = "",
       SBAfmBilling = "", SBDoyBilling = "",
       SBProfessionBilling = "",
       SBCreditTypeBilling = "", SBCreditNumBilling = "",
       SBCreditOwnerBilling = "", SBPhoneBilling = "", SBFaxBilling = "";
Timestamp SBCreditExpDayBilling = null;

// users table
String logCode = "", usrPasswd = "";
int usrAccessLevel = -1;

String action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       customerId = request.getParameter("customerId") == null ? "" : request.getParameter("customerId");

String urlCancel = "",
    urlSuccess = "",
    urlSuccessInsAgain = "/admin/customer_update.jsp",
    urlFailure = "/" + appDir + "admin/problem.jsp";

String tableHeader = "";
if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    dbRet = helperBean.getCustomer(customerId, "");

    if (dbRet.getNoError() == 0 || dbRet.getRetInt() <= 0) {
        helperBean.closeResources();
        response.sendRedirect( response.encodeRedirectURL("problem.jsp") );
        return;
    }
    else {
        firstname = helperBean.getColumn("firstname");
        lastname = helperBean.getColumn("lastname");
        occupation = helperBean.getColumn("occupation");
        email = helperBean.getColumn("email");
        phone = helperBean.getColumn("phone");
        fax = helperBean.getColumn("fax");
        title = helperBean.getColumn("title");
        sex = helperBean.getColumn("sex");
        birthDate = helperBean.getTimestamp("birthDate");
        discountPct = helperBean.getBig("discountPct");
        purchaseValEU = helperBean.getBig("purchaseValEU");
        hotdealBuysCnt = helperBean.getInt("hotdealBuysCnt");
        dateLastUsed = SwissKnife.formatDate(helperBean.getTimestamp("dateLastUsed"), "dd/MM/yyyy HH:mm");
        dateCreated = SwissKnife.formatDate(helperBean.getTimestamp("dateCreated"), "dd/MM/yyyy HH:mm");
        lastIPUsed = helperBean.getColumn("lastIPUsed");
        buysCnt = helperBean.getInt("buysCnt");
        customerType = helperBean.getInt("customerType");

        contactUsDescr = helperBean.getColumn("contactUsDescr");

        dbRet = Newsletter.checkListStatus(email, "NEWSLETTER");

        if (dbRet.getRetStr().length() > 0) receiveEmail = "1";
        
        lockedAccnt = helperBean.getColumn("lockedAccnt");

        logCode = helperBean.getColumn("logCode");
        usrAccessLevel = helperBean.getInt("usrAccessLevel");

        SBCodeBilling = helperBean.getColumn("SBCode");
        SBNameBilling = helperBean.getColumn("SBName");
        SBAddressBilling = helperBean.getColumn("SBAddress");
        SBAreaCodeBilling = helperBean.getColumn("SBAreaCode");
        SBCityBilling = helperBean.getColumn("SBCity");
        SBRegionBilling = helperBean.getColumn("SBRegion");
        SBCountryCodeBilling = helperBean.getColumn("SBCountryCode");
        SBZipCodeBilling = helperBean.getColumn("SBZipCode");
        SBAfmBilling = helperBean.getColumn("SBAfm");
        SBDoyBilling = helperBean.getColumn("SBDoy");
        SBProfessionBilling = helperBean.getColumn("SBProfession");
        SBCreditTypeBilling = helperBean.getColumn("SBCreditNum");
        SBCreditNumBilling = helperBean.getColumn("SBCreditNum");
        SBCreditOwnerBilling = helperBean.getColumn("SBCreditOwner");
        SBCreditExpDayBilling = helperBean.getTimestamp("SBCreditExpDay");
        SBPhoneBilling = helperBean.getColumn("SBPhone");
        SBFaxBilling = helperBean.getColumn("SBFax");

        custText = helperBean.getColumn("custText");

        helperBean.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

helperBean.closeResources();

urlSuccess = "/admin/customer_search.jsp?action1=UPDATE_SEARCH&goLabel=results";
urlCancel = "/admin/customer_search.jsp?goLabel=results";

int rows = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>

    <script language="JavaScript" src="js/jsfunctions.js"></script>

    <script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>

    <script language="JavaScript">
    function validateForm(forma) {
        if (forma.customerType.options[forma.customerType.selectedIndex].value == "") {
            alert("Παρακαλούμε επιλέξτε τύπο πελάτη.");
            forma.customerType.focus();
            return false;
        }
        else if (isEmpty(forma.firstname.value) == true) {
            alert("Παρακαλούμε συμπληρώστε το όνομα.");
            forma.firstname.focus();
            return false;
        }
        else if (isEmpty(forma.lastname.value) == true) {
            alert("Παρακαλούμε συμπληρώστε το επίθετο.");
            forma.lastname.focus();
            return false;
        }
        else if (forma.SBCountryCodeBilling.options[forma.SBCountryCodeBilling.selectedIndex].value == "") {
            alert("Παρακαλούμε επιλέξτε την χώρα.");
            forma.SBCountryCodeBilling.focus();
            return false;
        }
        else if (forma.usrAccessLevel.options[forma.usrAccessLevel.selectedIndex].value == "") {
            alert("Παρακαλούμε επιλέξτε την ομάδα χρηστών.");
            forma.usrAccessLevel.focus();
            return false;
        }
        else if (isEmpty(forma.email.value) == true) {
            alert("Παρακαλούμε συμπληρώστε το e-mail.");
            forma.email.focus();
            return false;
        }
        <% if (!action.equals("EDIT")) { %>
            else if (isEmpty(forma.usrPasswd.value) == true) {
                alert("Παρακαλούμε συμπληρώστε το password.");
                forma.usrPasswd.focus();
                return false;
            }
        <% } %>
        else if (forma.usrPasswd.value != forma.usrPasswdVer.value) {
            alert("Η επαλήθευση του password απέτυχε.");
            forma.usrPasswd.focus();
            return false;
        }
        else return true;
    }

    tinyMCE.init({
        elements : "custText",
        verify_html : false,
        theme : "advanced",
        mode : "exact",
        entity_encoding : "raw",
        plugins : "table,template,advlink,paste,advhr,media",
        content_css : "/css/core.css",
        theme_advanced_buttons1 : "bold, italic, underline, |, justifyleft, justifycenter, justifyright, justifyfull, separator, anchor, formatselect, fontselect, fontsizeselect, forecolor, backcolor",
        theme_advanced_buttons2 : "removeformat, advhr,  |, sub, sup, |, bullist, numlist, |,media,  separator, pasteword, table, row_props, cell_props, delete_col, delete_row, col_after, col_before, row_after, row_before, split_cells, merge_cells, image, link, unlink, visualaid, template, code",
        theme_advanced_buttons3 : "",
        extended_valid_elements : "a[name|href|target|title|onclick|rel],hr[class|width|size|noshade]"
    });
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Πελάτες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Πελάτης</b></td>
    </tr>
    </table>

    <table width="100%" cellspacing="0" cellpadding="0" border="0">

    <tr>
        <%@ include file="include/left.jsp" %>

        <td valign="top">

            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">

            <form name="inputForm" method="post" action="<%= response.encodeURL("/servlet/admin/Customer") %>">

            <input type="hidden" name="action1" value="">
            <input type="hidden" name="databaseId" value="<%= databaseId %>">
            <input type="hidden" name="urlSuccess" value="">
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">

            <input type="hidden" name="customerId" value="<%= customerId %>" />
            <input type="hidden" name="logCode" value="<%= logCode %>" />
            <input type="hidden" name="SBCodeBilling" value="<%= SBCodeBilling %>" />

            <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>">
            <input type="hidden" name="localeCountry" value="<%= localeCountry %>">

            <tr>
                <td class="inputFrmLabelTD">Πελάτης</td>
                <td class="inputFrmFieldTD">
                    <select name="customerType" class="inputFrmField">
                      <option value="">---</option>
                      <option value="<%= gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL %>" <% if (customerType == gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL) out.print("SELECTED"); %>>ΛΙΑΝΙΚΗΣ</option>
                      <option value="<%= gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE %>" <% if (customerType == gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE) out.print("SELECTED"); %>>ΧΟΝΔΡΙΚΗΣ</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Έκπτωση (σε δεκαδική μορφή πχ. 0,15 για 15%)</td>
                <td class="inputFrmFieldTD"><input type="text" name="discountPct" maxlength="6" size="6" value="<%= SwissKnife.formatNumber(discountPct,localeLanguage,localeCountry,2,2) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Όνομα</td>
                <td class="inputFrmFieldTD"><input type="text" name="firstname" maxlength="30" size="30" value="<%= firstname %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επίθετο</td>
                <td class="inputFrmFieldTD"><input type="text" name="lastname" maxlength="30" size="30" value="<%= lastname %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επωνυμία εταιρίας</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBNameBilling" maxlength="75" size="30" value="<%= SBNameBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Α.Φ.Μ.</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBAfmBilling" maxlength="15" size="15" value="<%= SBAfmBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Δ.Ο.Υ.</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBDoyBilling" maxlength="40" size="30" value="<%= SBDoyBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Δραστηριότητα</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBProfessionBilling" maxlength="100" size="30" value="<%= SBProfessionBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Διεύθυνση</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBAddressBilling" maxlength="100" size="30" value="<%= SBAddressBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Πόλη</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBCityBilling" maxlength="50" size="30" value="<%= SBCityBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τ.Κ.</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBZipCodeBilling" maxlength="50" size="6" value="<%= SBZipCodeBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Χώρα</td>
                <td class="inputFrmFieldTD">
                    <select name="SBCountryCodeBilling" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = helperBean.getTable("country","countryName");

                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= helperBean.getColumn("countryCode") %>" <% if (SBCountryCodeBilling.equals(helperBean.getColumn("countryCode"))) out.print("SELECTED"); %>><%= helperBean.getColumn("countryName") %></option>
                        <%
                            helperBean.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τηλέφωνο</td>
                <td class="inputFrmFieldTD"><input type="text" name="SBPhoneBilling" maxlength="30" size="20" value="<%= SBPhoneBilling %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Λήψη newsletter</td>
                <td class="inputFrmFieldTD"><% if (receiveEmail.equals("1")) out.print("ΝΑΙ"); else out.print("ΟΧΙ"); %></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κλειδωμένος λογαριασμός</td>
                <td class="inputFrmFieldTD"><input type="checkbox" name="lockedAccnt" value="1" <% if (lockedAccnt.equals("1")) out.print("CHECKED"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κείμενο</td>
                <td class="inputFrmFieldTD"><textarea name="custText" id="custText" cols="100" rows="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= custText %></textarea></td>
            </tr>
            <tr>
                <td class="inputFrmHeader" colspan="2" align="center">Στοιχεία ταυτοποίησης</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ομάδα Χρηστών</td>
                <td class="inputFrmFieldTD">
                    <select name="usrAccessLevel" class="inputFrmField">
                        <%
                        rows = helperBean.getTable("userGroups","");

                        for (int i=0; i<rows; i++) {
                            if (!helperBean.getColumn("userGroupGrantLogin").equals("1")) { %>
                                <option value="<%= helperBean.getInt("userGroupId") %>" <% if (usrAccessLevel == helperBean.getInt("userGroupId")) out.print("SELECTED"); %>><%= helperBean.getColumn("userGroupName") %></option>
                        <%
                            }
                            helperBean.nextRow();
                        }
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">E-mail</td>
                <td class="inputFrmFieldTD"><input type="text" name="email" maxlength="75" size="30" value="<%= email %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κωδικός πρόσβασης</td>
                <td class="inputFrmFieldTD"><input type="password" name="usrPasswd" maxlength="8" size="8" value="<%= usrPasswd %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επαλήθευση κωδικού πρόσβασης</td>
                <td class="inputFrmFieldTD"><input type="password" name="usrPasswdVer" maxlength="8" size="8" value="<%= usrPasswd %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <%
            if (action.equals("EDIT")) { %>
                <tr>
                    <td class="inputFrmLabelTD">Εγγραφή</td>
                    <td class="inputFrmFieldTD"><span class="text"><%= dateCreated %></span></td>
                </tr>
                <tr>
                    <td class="inputFrmLabelTD">Τελευταία είσοδος</td>
                    <td class="inputFrmFieldTD"><span class="text"><%= dateLastUsed %></span></td>
                </tr>
                <tr>
                    <td class="inputFrmLabelTD">Τελευταία διεύθυνση Η/Υ</td>
                    <td class="inputFrmFieldTD"><span class="text"><%= lastIPUsed %></span></td>
                </tr>
                <tr>
                    <td class="inputFrmLabelTD">Αριθμός Εισόδων</td>
                    <td class="inputFrmFieldTD"><span class="text"><%= hotdealBuysCnt %></span></td>
                </tr>
            <% } %>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="hidden" value="0" name="buttonPressed" />
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit()} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; document.inputForm.submit() }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <% } %>
                    <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>

            </form>

            </table>
        </td>

        <%@ include file="include/right.jsp" %>

    </tr>
    </table>

    <%@ include file="include/bottom.jsp" %>

    <% helperBean.closeResources(); %>

</body>
</html>
