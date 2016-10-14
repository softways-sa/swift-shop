<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
helperBean.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");
   
String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/batchimpemailmembers.jsp"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp");

int rows = helperBean.getTable("emailListTab", "EMLTName");

if (rows < 0) {
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + rows) );
    return;
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
            if (isEmpty(forma.EMLRListCode.options[forma.EMLRListCode.selectedIndex].value) == true) {
                alert("Παρακαλούμε πληκτρολογήστε τον κωδικό.");
                forma.EMLRListCode.focus();
                return false;
            }
            else if (isEmpty(forma.emailMembers.value)) {
                alert("Δεν έχετε εισάγει χρήστες.");
                forma.emailMembers.focus();
                return false;
            }
            else return true;
        }
        
        function doReset(forma) {
            forma.EMLRListCode.selectedIndex = 0;
            forma.emailMembers.value = "";
        }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    <td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μαζική εισαγωγή μελών</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/MailListMember") %>">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="catParentFlag" value="0" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            <tr>
                <td class="inputFrmLabelTD">Λίστα</td>
                <td class="inputFrmFieldTD">
                    <select name="EMLRListCode" class="inputFrmField">
                    <%
                    for (int i=0; i<rows; i++) { %>
                        <option value="<%= helperBean.getColumn("EMLTCode") %>"><%= helperBean.getColumn("EMLTName") %></option>
                    <%
                        helperBean.nextRow();
                    } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">E-mail (ένα ανα γραμμή)</td>
                <td class="inputFrmFieldTD"><textarea name="emailMembers" cols="40" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"></textarea></td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT_BATCH"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="button" value="Μηδενισμός" onClick="doReset(document.inputForm)" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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