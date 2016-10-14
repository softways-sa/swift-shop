<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="processausr" scope="page" class="gr.softways.dev.eshop.adminusers.Present" />

<%
processausr.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","admin");
   
String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       ausrCode = request.getParameter("ausrCode") != null ? request.getParameter("ausrCode") : "";

String  urlCancel = "http://" + serverName + "/admin/" + response.encodeURL("adminusers.jsp?goLabel=results"),
        urlSuccessInsAgain = "http://" + serverName + "/admin/" +  response.encodeURL("processadminusers.jsp"),
        urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/adminusers.jsp?action1=UPDATE_SEARCH&goLabel=results"),
        urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
        urlReturn = response.encodeURL("http://" + serverName + "/" + appDir + "admin/adminusers.jsp?goLabel=results" );
        
String ausrLastname = "", ausrFirstname = "",
       ausrUsername = "", ausrUserGroupId = "",
       ausrPassword = "", ausrLogCode = "";

int rows = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";

    rows = processausr.locateAdminUser(ausrCode);

    if (rows < 0) {
        response.sendRedirect(response.encodeURL("noaccess.jsp?authCode=" + rows));
        processausr.closeResources();
        return;
    }
    else if (rows >= 1) {
        ausrFirstname = processausr.getColumn("ausrFirstname");
        ausrLastname = processausr.getColumn("ausrLastname");
        ausrUsername = processausr.getColumn("usrName");
        ausrUserGroupId = processausr.getColumn("usrAccessLevel");
        ausrPassword = processausr.getColumn("usrPasswd");
        ausrLogCode = processausr.getColumn("ausrLogCode");
    }
    processausr.closeResources(); 
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
            if (forma.ausrCode.value == "") {
                alert("Παρακαλούμε εισάγετε τον κωδικό");
                forma.ausrCode.focus();
                return false;
            }
            else if (forma.ausrUsername.value == "") {
                alert("Παρακαλούμε εισάγετε το username");
                forma.ausrUsername.focus();
                return false;
            }
            else if (forma.ausrUserGroupId.options[forma.ausrUserGroupId.selectedIndex].value == "") {
                alert("Παρακαλούμε εισάγετε την ομάδα χρηστών ");
                forma.ausrUserGroupId.focus();
                return false;
            }
            return true;
        }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="20" cellpadding="2">
    <tr>
    <td class="menuPathTD" align="middle"><b>Σύστημα&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Χρήστες συστήματος</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/AdminUsers") %>">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            <input type="hidden" name="ausrLogCode" value="<%= ausrLogCode %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmFieldTD"><input type="Text" name="ausrCode" maxlength="25" value="<%= ausrCode %>" <% if (action.equals("EDIT")) out.print("onfocus=\"blur();\""); else out.print("onfocus=\"this.className='inputFrmFieldFocus'\""); %> class="inputFrmField" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επίθετο</td>
                <td class="inputFrmFieldTD"><input type="Text" name="ausrLastname" maxlength="50" value="<%= ausrLastname %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Όνομα</td>
                <td class="inputFrmFieldTD"><input type="Text" name="ausrFirstname" maxlength="50" value="<%= ausrFirstname %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Username</td>
                <td class="inputFrmFieldTD"><input type="Text" name="ausrUsername" maxlength="15" value="<%= ausrUsername %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ομάδα Χρηστών</td>
                <td class="inputFrmFieldTD">
                    <select name="ausrUserGroupId" class="inputFrmField">
                        <option value=""></option>
                        <%
                        rows = processausr.getTable("userGroups","");
                        
                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= processausr.getColumn("userGroupId") %>" <% if ( ausrUserGroupId.equals( processausr.getColumn("userGroupId") ) ) out.print("SELECTED"); %>><%= processausr.getColumn("userGroupName") %></option>
                        <%
                            processausr.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Password</td>
                <td class="inputFrmFieldTD"><input type="Password" name="ausrPassword" maxlength="20" value="<%= ausrPassword %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"></td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
            </br></br>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% processausr.closeResources(); %>
    
</body>
</html>