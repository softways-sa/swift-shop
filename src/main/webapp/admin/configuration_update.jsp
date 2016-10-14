<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="configuration_update" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
configuration_update.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","admin");
   
String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       CO_Code = request.getParameter("CO_Code") != null ? request.getParameter("CO_Code") : "";

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/configuration_search.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/configuration_search.jsp?goLabel=results"),
       urlSuccessInsAgain = response.encodeURL("http://" + serverName + "/" + appDir + "admin/configuration_update.jsp");

String CO_Key = "", CO_Title = "", CO_Description = "", 
       CO_Value = "", CO_ValueLG ="", CO_ValueLG1 = "", CO_ValueLG2 = "",
       CO_Params = "", CO_ParamsLG = "", CO_ParamsLG1 = "", CO_ParamsLG2 = "";

int CO_Editable = 0;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = configuration_update.getTablePK("Configuration", "CO_Visible = 1 AND CO_Code", CO_Code);

    if (found < 0) {
        configuration_update.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        CO_Key = configuration_update.getColumn("CO_Key");
        CO_Title = configuration_update.getColumn("CO_Title");
        CO_Description = configuration_update.getColumn("CO_Description");
      
        CO_Value = configuration_update.getColumn("CO_Value");
        CO_ValueLG = configuration_update.getColumn("CO_ValueLG");
        CO_ValueLG1 = configuration_update.getColumn("CO_ValueLG1");
        CO_ValueLG2 = configuration_update.getColumn("CO_ValueLG2");
        
        CO_Params = configuration_update.getColumn("CO_Params");
        CO_ParamsLG = configuration_update.getColumn("CO_ParamsLG");
        CO_ParamsLG1 = configuration_update.getColumn("CO_ParamsLG1");
        CO_ParamsLG2 = configuration_update.getColumn("CO_ParamsLG2");
        
        CO_Editable = configuration_update.getInt("CO_Editable");
            
        configuration_update.closeResources();
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
      return true;
    }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
                    <table width="0" border="0" cellspacing="2" cellpadding="20">
                    <tr>
                    <td class="menuPathTD" align="middle"><b>Σύστημα&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Παράμετροι</b></td>
                    </tr>
                    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="post" action="<%= response.encodeURL("/servlet/admin/Configuration") %>">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <input type="hidden" name="CO_Code" value="<%= CO_Code %>" />
            <tr>
                <td class="inputFrmLabelTD">Κλειδί</td>
                <td class="inputFrmFieldTD"><input type="text" name="CO_Key" size="50" maxlength="80" value="<%= CO_Key %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>
                <td class="inputFrmFieldTD"><input type="text" name="CO_Title" size="80" maxlength="80" value="<%= CO_Title %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή</td>
                <td class="inputFrmFieldTD"><input type="text" name="CO_Value" size="100" maxlength="250" value="<%= CO_Value %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Μεταβλητές</td>
                <td class="inputFrmFieldTD"><input type="text" name="CO_Params" size="100" maxlength="250" value="<%= CO_Params %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Περιγραφή</td>
                <td class="inputFrmFieldTD"><input type="text" name="CO_Description" size="100" maxlength="250" value="<%= CO_Description %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <%
                    if (action.equals("EDIT") && CO_Editable == 1) { %>
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
            </br></br>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% configuration_update.closeResources(); %>
    
</body>
</html>