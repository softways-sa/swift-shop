<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,java.sql.Timestamp" %>

<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.SQLHelper2" />

<%
request.setAttribute("admin.topmenu","products");

helperBean.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       PO_Code = request.getParameter("PO_Code") != null ? request.getParameter("PO_Code") : "",
       PO_prdId = request.getParameter("PO_prdId") != null ? request.getParameter("PO_prdId") : "";

String PO_Name = "", PO_NameLG = "", PO_NameLG1 = "", PO_NameLG2 = "", PO_Enabled = "1";

BigDecimal _zero = new BigDecimal("0");

BigDecimal PO_RetailPrcEU = _zero, PO_WholesalePrcEU = _zero, PO_RetailOfferPrcEU = _zero, PO_WholesaleOfferPrcEU = _zero;
     
int PO_Order = 0;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = helperBean.getSQL("SELECT * FROM ProductOptions WHERE PO_Code = '" + SwissKnife.sqlEncode(PO_Code) + "' AND PO_prdId = '" + SwissKnife.sqlEncode(PO_prdId) + "'").getRetInt();
    
    if (found < 0) {
        helperBean.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        PO_Name = helperBean.getColumn("PO_Name");
        PO_NameLG = helperBean.getColumn("PO_NameLG");
        PO_NameLG1 = helperBean.getColumn("PO_NameLG1");
        PO_NameLG2 = helperBean.getColumn("PO_NameLG2");
        
        PO_Enabled = helperBean.getColumn("PO_Enabled");
        
        PO_RetailPrcEU = helperBean.getBig("PO_RetailPrcEU");
        if (PO_RetailPrcEU == null) PO_RetailPrcEU = _zero;
        
        PO_WholesalePrcEU = helperBean.getBig("PO_WholesalePrcEU");
        if (PO_WholesalePrcEU == null) PO_WholesalePrcEU = _zero;
        
        PO_RetailOfferPrcEU = helperBean.getBig("PO_RetailOfferPrcEU");
        if (PO_RetailOfferPrcEU == null) PO_RetailOfferPrcEU = _zero;
        
        PO_WholesaleOfferPrcEU = helperBean.getBig("PO_WholesaleOfferPrcEU");
        if (PO_WholesaleOfferPrcEU == null) PO_WholesaleOfferPrcEU = _zero;
        
        PO_Order = helperBean.getInt("PO_Order");
        
        helperBean.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

String urlSuccess = "/" + appDir + "admin/product_update.jsp?action1=EDIT&prdId=" + SwissKnife.hexEscape(PO_prdId) + "&goLabel=ProductOptions&tab=tab8",
       urlCancel = "/" + appDir + "admin/product_update.jsp?action1=EDIT&prdId=" + SwissKnife.hexEscape(PO_prdId) + "&goLabel=ProductOptions&tab=tab8",
       urlFailure = "/" + appDir + "admin/problem.jsp";

String pageTitle = "Αποθήκη&nbsp;<span class=\"menuPathTD\" id=\"white\">|</span>&nbsp;Προϊόν&nbsp;<span class=\"menuPathTD\" id=\"white\">|</span>&nbsp;Επιλογή";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function validateForm(forma) {
            // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
            if (isEmpty(forma.PO_Name.value) == true) {
                alert("Παρακαλούμε συμπληρώστε την επιλογή.");
                forma.PO_Name.focus();
                return false;
            }
            else return true;
        }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="menuPathTD">
            <table width="0" border="0" cellspacing="2" cellpadding="20">
            <tr>
            <td class="menuPathTD"><b><%= pageTitle %></b></td>
            </tr>
            </table>
        </td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/ProductOptions") %>">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>" />
            <input type="hidden" name="localeCountry" value="<%= localeCountry %>" />
            
            <input type="hidden" name="PO_prdId" value="<%= PO_prdId %>" />
            <input type="hidden" name="PO_Code" value="<%= PO_Code %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Α/Α</td>
                <td class="inputFrmFieldTD"><input type="text" name="PO_Order" size="5" value="<%= PO_Order %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επιλογή</td>
                <td class="inputFrmFieldTD">
                  <table width="0" border="0" cellspacing="2" cellpadding="0">
                  <tr>
                      <td valign="top"><img src="images/flag.gif" /></td>
                      <td class="inputFrmFieldTD"><input type="text" name="PO_Name" maxlength="160" size="80" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                  </tr>
                  <tr>
                      <td valign="top"><img src="images/flagLG.gif" /></td>
                      <td class="inputFrmFieldTD"><input type="text" name="PO_NameLG" maxlength="160" size="80" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                  </tr>
                  </table>
                </td>
            </tr>
            <script language="JavaScript">
                document.inputForm.PO_Name.value = "<%= PO_Name.replaceAll("[\"]","\\\\\"").replaceAll("[']","\\\\\'") %>";
                document.inputForm.PO_NameLG.value = "<%= PO_NameLG.replaceAll("[\"]","\\\\\"").replaceAll("[']","\\\\\'") %>";
                document.inputForm.PO_NameLG1.value = "<%= PO_NameLG1.replaceAll("[\"]","\\\\\"").replaceAll("[']","\\\\\'") %>";
            </script>
            <tr>
                <td class="inputFrmLabelTD">Τιμή λιανικής &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="PO_RetailPrcEU" value="<%= SwissKnife.formatNumber(PO_RetailPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή χονδρικής &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="PO_WholesalePrcEU" value="<%= SwissKnife.formatNumber(PO_WholesalePrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή λιανικής σε προσφορά &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="PO_RetailOfferPrcEU" value="<%= SwissKnife.formatNumber(PO_RetailOfferPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή χονδρικής σε προσφορά &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="PO_WholesaleOfferPrcEU" value="<%= SwissKnife.formatNumber(PO_WholesaleOfferPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Διαθέσιμο</td>
                <td class="inputFrmFieldTD"><input type="checkbox" name="PO_Enabled" value="1" <% if (PO_Enabled.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); } }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit()} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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