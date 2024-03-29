<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="facet_update" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
facet_update.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","products");
   
String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       id = request.getParameter("id") != null ? request.getParameter("id") : "";

String urlSuccess = "/" + appDir + "admin/facet_search.jsp?action1=UPDATE_SEARCH&goLabel=results",
    urlFailure = "/" + appDir + "admin/problem.jsp",
    urlCancel = "/" + appDir + "admin/facet_search.jsp?goLabel=results";

String name = "", nameLG = "";

int found = 0, display_order = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = facet_update.getTablePK("facet", "id", id);

    if (found < 0) {
      facet_update.closeResources();
      response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
      return;
    }
    else if (found >= 1) {
      name = facet_update.getColumn("name");
      nameLG = facet_update.getColumn("nameLG");

      display_order = facet_update.getInt("display_order");

      facet_update.closeResources();
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
      if (isEmpty(forma.name.value) == true) {
          alert("Παρακαλούμε συμπληρώστε το πεδίο.");
          forma.name.focus();
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
    <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Ομάδα Φίλτρων</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="post" action="/servlet/admin/Facet">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%=urlFailure%>" />
            <input type="hidden" name="urlNoAccess" value="<%=urlNoAccess%>" />
            <input type="hidden" name="databaseId" value="<%=databaseId%>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <input type="hidden" name="id" value="<%=id%>" />
            <tr>
              <td class="inputFrmLabelTD">Ονομασία</td>
              <td class="inputFrmFieldTD">
                <table width="0" border="0" cellspacing="2" cellpadding="0">
                <tr>
                  <td valign="top"><img src="images/flag.gif" /></td>
                  <td class="inputFrmFieldTD"><input type="text" name="name" maxlength="255" size="50" value="<%=name%>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                </tr>
                <tr>
                  <td valign="top"><img src="images/flagLG.gif" /></td>
                  <td class="inputFrmFieldTD"><input type="text" name="nameLG" maxlength="255" size="50" value="<%=nameLG%>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td class="inputFrmLabelTD">Σειρά εμφάνισης</td>
              <td class="inputFrmFieldTD"><input type="text" name="display_order" size="5" value="<%=display_order%>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
           
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
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
            </br></br>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% facet_update.closeResources(); %>
    
</body>
</html>