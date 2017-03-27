<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal, gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","shipping");

helperBean.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       SHCMCode = request.getParameter("SHCMCode") != null ? request.getParameter("SHCMCode") : "";

String urlSuccess = "/" + appDir + "admin/ship_method_search.jsp?action1=UPDATE_SEARCH&goLabel=results",
       urlFailure = "/" + appDir + "admin/problem.jsp",
       urlCancel = "/" + appDir + "admin/ship_method_search.jsp?goLabel=results",
       urlSuccessInsAgain = "/" + appDir + "admin/ship_method_update.jsp";

String SHCMTitle = "", SHCMTitleLG = "";

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = helperBean.getTablePK("ShipCostMethod", "SHCMCode", SHCMCode);

    if (found < 0) {
        helperBean.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        SHCMTitle = helperBean.getColumn("SHCMTitle");
        SHCMTitleLG = helperBean.getColumn("SHCMTitleLG");
        
        helperBean.closeResources();
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
            if (isEmpty(forma.SHCMTitle.value) == true) { 
                alert("Παρακαλούμε πληκτρολογήστε τον τίτλο.");
                forma.SHCMTitle.focus();
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
      <td class="menuPathTD" align="middle"><b>Μεταφορικά&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Τρόπος</b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/ShipMethod") %>">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="SHCMCode" value="<%= SHCMCode %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>
                <td class="inputFrmFieldTD">
                  <table width="0" border="0" cellspacing="2" cellpadding="0">
                  <tr>
                      <td valign="top"><img src="images/flag.gif" /></td>
                      <td class="inputFrmFieldTD"><input type="text" name="SHCMTitle" maxlength="160" size="50" value="<%= SHCMTitle %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                  </tr>
                  <tr>
                      <td valign="top"><img src="images/flagLG.gif" /></td>
                      <td class="inputFrmFieldTD"><input type="text" name="SHCMTitleLG" maxlength="160" size="50" value="<%= SHCMTitleLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                  </tr>
                  </table>
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
    
    <% helperBean.closeResources(); %>
    
</body>
</html>