<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="processcmcateg" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
processcmcateg.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","content");
   
String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       CMCCode = request.getParameter("CMCCode") != null ? request.getParameter("CMCCode") : "";

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/cmcategory.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/cmcategory.jsp?goLabel=results"),
       urlSuccessInsAgain = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processcmcateg.jsp");

String CMCName = "", CMCNameLG = "",
       CMCParentFlag = "", CMCShowFlag = "1", CMCText = "", CMCTextLG = "", CMCURL = "", CMCURLLG = "";
int CMCRank = 0;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = processcmcateg.getTablePK("CMCategory", "CMCCode", CMCCode);

    if (found < 0) {
        processcmcateg.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        CMCName = processcmcateg.getColumn("CMCName");
        CMCNameLG = processcmcateg.getColumn("CMCNameLG");
        CMCParentFlag = processcmcateg.getColumn("CMCParentFlag");
        CMCShowFlag = processcmcateg.getColumn("CMCShowFlag");
        CMCRank = processcmcateg.getInt("CMCRank");
        CMCText = processcmcateg.getColumn("CMCText");
        CMCTextLG = processcmcateg.getColumn("CMCTextLG");
        CMCURL = processcmcateg.getColumn("CMCURL");
        CMCURLLG = processcmcateg.getColumn("CMCURLLG");
        
        processcmcateg.closeResources();
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
    <%--<script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>--%>
    
    <script language="JavaScript">
        function validateForm(forma) {
            // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
            if (isEmpty(forma.CMCCode.value)) {
                alert("Παρακαλούμε πληκτρολογήστε τον κωδικό.");
                forma.CMCCode.focus();
                return false;
            }
            else if (isEmpty(forma.CMCName.value)) {
                alert("Παρακαλούμε πληκτρολογήστε την ονομασία.");
                forma.CMCName.focus();
                return false;
            }
            else if (isInteger(forma.CMCRank.value) == false) {
                alert("Το πεδίο είναι αριθμητικό.");
                forma.CMCRank.focus();
                return false;
            }
            else return true;
        }
        
        <%--tinyMCE.init({
            elements : "CMCText,CMCTextLG",
            verify_html : false,
            relative_urls : false,
            theme : "advanced",
            mode : "exact",
            entity_encoding : "raw",
            plugins : "table,template,advlink,paste,advhr,media,advimage",
            content_css : "/css/core.css",
            theme_advanced_buttons1 : "bold, italic, underline, |, justifyleft, justifycenter, justifyright, justifyfull, separator, anchor, formatselect, fontselect, fontsizeselect, forecolor, backcolor",
            theme_advanced_buttons2 : "removeformat, advhr,  |, sub, sup, |, bullist, numlist, |,media,  separator, pasteword, table, row_props, cell_props, delete_col, delete_row, col_after, col_before, row_after, row_before, split_cells, merge_cells, image, link, unlink, visualaid, template, code",
            theme_advanced_buttons3 : "",
            extended_valid_elements : "a[id|onclick|rel|rev|charset|hreflang|tabindex|accesskey|type|name|href|target|title|class|onfocus|onblur],hr[class|width|size|noshade]"
        });--%>
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>

    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    <td class="menuPathTD" align="middle"><b>Περιεχόμενο&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Ενότητα</b></td>
    </tr>
    </table>
  
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
          
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/CMCategory") %>">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />

            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmFieldTD"><input type="text" name="CMCCode" maxlength="25" value="<%= CMCCode %>" <% if (action.equals("EDIT")) out.print("onfocus=\"blur();\""); else out.print("onfocus=\"this.className='inputFrmFieldFocus'\""); %> class="inputFrmField" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMCName" size="40" maxlength="70" value="<%= CMCName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMCNameLG" size="40" maxlength="70" value="<%= CMCNameLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <%--<tr>
                <td class="inputFrmLabelTD">Κείμενο</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><textarea name="CMCText" id="CMCText" cols="100" rows="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMCText %></textarea></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><textarea name="CMCTextLG" id="CMCTextLG" cols="100" rows="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMCTextLG %></textarea></td>
                    </tr>
                    </table>
                </td>
            </tr>--%>
            
            <tr>
                <td class="inputFrmLabelTD">Περιέχει υποενότητες</td>
                <td class="inputFrmFieldTD">
                    <select name="CMCParentFlag" class="inputFrmField">
                        <option value="1" <% if (CMCParentFlag.equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                        <option value="0" <% if (CMCParentFlag.equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Βαρύτητα εμφάνισης <br/>(υψηλή τιμή-υψηλή θέση εμφάνισης)</td>
                <td class="inputFrmFieldTD"><input type="text" name="CMCRank" size="5" value="<%= CMCRank %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Εμφανίζεται</td>
                <td class="inputFrmFieldTD"><input type="checkbox" name="CMCShowFlag" value="1" <% if (CMCShowFlag.equals("1")) out.print("CHECKED"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Σελίδα Σύνδεσης</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMCURL" size="80" maxlength="150" value="<%= CMCURL %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMCURLLG" size="80" maxlength="150" value="<%= CMCURLLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); } }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
    
    <% processcmcateg.closeResources(); %>
    
</body>
</html>