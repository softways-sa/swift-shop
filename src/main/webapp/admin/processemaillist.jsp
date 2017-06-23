<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.emaillists.lists.Present" />

<%
helperBean.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");
   
String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       EMLTCode = request.getParameter("EMLTCode") != null ? request.getParameter("EMLTCode") : "";

String urlSuccess = "/" + appDir + "admin/searchemaillists.jsp?action1=UPDATE_SEARCH&goLabel=results",
       urlFailure = "/" + appDir + "admin/problem.jsp",
       urlCancel = "/" + appDir + "admin/searchemaillists.jsp?goLabel=results",
       urlSuccessInsAgain = "/" + appDir + "admin/processemaillist.jsp";

String EMLTName = "", EMLTDescr = "", EMLTTo = "", EMLTField1 = "", EMLTField2 = "";

int EMLTActive = -1;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = helperBean.locateEmailList(EMLTCode);

    if (found < 0) {
        helperBean.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        
        return;
    }
    else if (found >= 1) {
        EMLTName = helperBean.getColumn("EMLTName");
        EMLTDescr = helperBean.getColumn("EMLTDescr");
        EMLTTo = helperBean.getColumn("EMLTTo");
        EMLTActive = Integer.parseInt( helperBean.getColumn("EMLTActive") );
        EMLTField1 = helperBean.getColumn("EMLTField1");
        EMLTField2 = helperBean.getColumn("EMLTField2");
        
        helperBean.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}
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
            if (isEmpty(forma.EMLTName.value) == true) {
                alert("Το όνομα λίστας είναι απαραίτητο πεδίο.");
                forma.EMLTName.focus();
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
    <td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Καταχώρηση - Μεταβολή</b></td>
    </tr>
    </table>
 
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="/servlet/admin/MailList">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%=urlFailure%>" />
            <input type="hidden" name="urlNoAccess" value="<%=urlNoAccess%>" />
            <input type="hidden" name="databaseId" value="<%=databaseId%>" />
            
            <input type="hidden" name="EMLTCode" value="<%=EMLTCode%>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLTField1" size="40" maxlength="100" value="<%= EMLTField1 %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLTName" size="40" maxlength="100" value="<%= EMLTName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Περιγραφή</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLTDescr" size="40" maxlength="150" value="<%= EMLTDescr %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <%--<tr>
                <td class="inputFrmLabelTD">Εμφάνιση Παραλήπτη (πχ. news@softways.gr)</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLTTo" size="40" maxlength="150" value="<%= EMLTTo %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>--%>
            <tr>
                <td class="inputFrmLabelTD">Εξ' ορισμού επιλεγμένη</td>
                <td class="inputFrmFieldTD">
                    <select name="EMLTActive" class="inputFrmField">
                        <OPTION VALUE="0" <% if (EMLTActive == 0) out.print("SELECTED"); %>>ΟΧΙ</OPTION>
                        <OPTION VALUE="1" <% if (EMLTActive == 1) out.print("SELECTED"); %>>ΝΑΙ</OPTION>
                    </select>
                </td>
            </tr>
            <%--<tr>
                <td class="inputFrmLabelTD">Πεδίο 2</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLTField2" size="40" maxlength="100" value="<%= EMLTField2 %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>--%>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); } }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Εξαγωγή" onClick='document.inputForm.urlSuccess.value="<%=urlSuccess%>"; document.inputForm.action1.value="EXCEL"; document.inputForm.submit();' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
    
</body>
</html>