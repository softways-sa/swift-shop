<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal, gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="updateShipPricelist" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","shipping");

updateShipPricelist.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       SHCECode = request.getParameter("SHCECode") != null ? request.getParameter("SHCECode") : "";

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/ship_pricelist_search.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/ship_pricelist_search.jsp?goLabel=results"),
       urlSuccessInsAgain = response.encodeURL("http://" + serverName + "/" + appDir + "admin/ship_pricelist_update.jsp");

String SHCE_SHCRCode = "", SHCE_countryCode = "", SHCE_SHCMCode = "", SHCE_VAT_ID = "";

BigDecimal SHCEPrice = new BigDecimal("0"), SHCEVATPct = new BigDecimal("0");

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = updateShipPricelist.getTablePK("ShipCostEntry", "SHCECode", SHCECode);

    if (found < 0) {
        updateShipPricelist.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        SHCE_SHCRCode = updateShipPricelist.getColumn("SHCE_SHCRCode");
        SHCE_countryCode = updateShipPricelist.getColumn("SHCE_countryCode");
        SHCE_SHCMCode = updateShipPricelist.getColumn("SHCE_SHCMCode");
            
        SHCEPrice = updateShipPricelist.getBig("SHCEPrice");
        SHCEVATPct = updateShipPricelist.getBig("SHCEVATPct");
        
        SHCE_VAT_ID = updateShipPricelist.getColumn("SHCE_VAT_ID");
        
        updateShipPricelist.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

int rows = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script type="text/javascript" language="javascript" src="js/jsfunctions.js"></script>
    
    <script type="text/javascript" language="javascript">
        function validateForm(forma) {
            // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
            if (forma.SHCE_SHCRCode.options[forma.SHCE_SHCRCode.selectedIndex].value == "") {
                alert("Παρακαλούμε επιλέξτε εύρος τιμών.");
                forma.SHCE_SHCRCode.focus();
                return false;
            }
            else if (forma.SHCE_SHCMCode.options[forma.SHCE_SHCMCode.selectedIndex].value == "") {
                alert("Παρακαλούμε επιλέξτε τρόπο.");
                forma.SHCE_SHCMCode.focus();
                return false;
            }
            else if (forma.SHCE_VAT_ID.options[forma.SHCE_VAT_ID.selectedIndex].value == "") {
                alert("Παρακαλούμε επιλέξτε Φ.Π.Α.");
                forma.SHCE_VAT_ID.focus();
                return false;
            }
            else if (isEmpty(forma.SHCEPrice.value) == true) { 
                alert("Παρακαλούμε πληκτρολογήστε την τιμή.");
                forma.SHCEPrice.focus();
                return false;
            }
            else if (isDecimal(forma.SHCEPrice.value) == false
                        || hasFractionDigits(forma.SHCEPrice.value,
                                             <%= curr1CheckFractionDigits %>,
                                             "<%= localeCountry %>") == false) { 
                alert("Η τιμή πρέπει να έχει <%= curr1CheckFractionDigits %> δεκαδικά ψηφία.");
                forma.SHCEPrice.focus();
                return false;
            }
            else return true;
        }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Μεταφορικά&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Τιμοκατάλογος</b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/ShipPricelist") %>">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="SHCECode" value="<%= SHCECode %>" />
            
            <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>">
            <input type="hidden" name="localeCountry" value="<%= localeCountry %>">
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Χώρα</td>
                <td class="inputFrmFieldTD">
                    <select name="SHCE_countryCode" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = updateShipPricelist.getTable("country", "countryName");
                        
                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= updateShipPricelist.getColumn("countryCode") %>" <% if (updateShipPricelist.getColumn("countryCode").equals(SHCE_countryCode)) out.print("SELECTED"); %>><%= updateShipPricelist.getColumn("countryName") %></option>
                        <%
                            updateShipPricelist.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Εύρος Τιμών</td>
                <td class="inputFrmFieldTD">
                    <select name="SHCE_SHCRCode" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = updateShipPricelist.getTable("ShipCostRange", "SHCRStart");
                        
                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= updateShipPricelist.getColumn("SHCRCode") %>" <% if (updateShipPricelist.getColumn("SHCRCode").equals(SHCE_SHCRCode)) out.print("SELECTED"); %>><%= updateShipPricelist.getColumn("SHCRTitle") %></option>
                        <%
                            updateShipPricelist.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τρόπος</td>
                <td class="inputFrmFieldTD">
                    <select name="SHCE_SHCMCode" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = updateShipPricelist.getTable("ShipCostMethod", "SHCMTitle");
                        
                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= updateShipPricelist.getColumn("SHCMCode") %>" <% if (updateShipPricelist.getColumn("SHCMCode").equals(SHCE_SHCMCode)) out.print("SELECTED"); %>><%= updateShipPricelist.getColumn("SHCMTitle") %></option>
                        <%
                            updateShipPricelist.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή (χωρίς ΦΠΑ) &euro;</td>
                <td class="inputFrmFieldTD"><input type="text" size="12" name="SHCEPrice" value="<%= SwissKnife.formatNumber(SHCEPrice.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Φ.Π.Α.</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <select name="SHCE_VAT_ID" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = updateShipPricelist.getTable("VAT","VAT_Pct");

                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= updateShipPricelist.getColumn("VAT_ID") %>" <% if (SHCE_VAT_ID.equals(updateShipPricelist.getColumn("VAT_ID"))) out.print("SELECTED"); %>><%= updateShipPricelist.getColumn("VAT_Title") %></option>
                        <%
                            updateShipPricelist.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm) && checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση / Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm) && checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm) && checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση / Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm) && checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
    
    <% updateShipPricelist.closeResources(); %>
    
</body>
</html>