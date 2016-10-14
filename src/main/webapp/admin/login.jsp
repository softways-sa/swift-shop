<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="include/config.jsp" %>

<%
String urlValidate = "/servlet/admin/Login",
    urlSuccess = "/admin/index.jsp",
    urlFailure = "/admin/login.jsp";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>Σύστημα διαχείρισης</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
</head>

<body onload="document.loginForm.empUsername.focus();">
    <br/><br/>
    
    <div align="center">
    
    
    <img src="images/logo_intro.png" border="0" alt="" title="" />
    <br/><br/><br/><br/>
    
    <form action="<%= urlValidate %>" method="post" name="loginForm">
    <input type="hidden" NAME="databaseId" VALUE="<%= databaseId %>">
    <input type="hidden" NAME="urlSuccess" VALUE="<%= urlSuccess %>">
    <input type="hidden" NAME="urlFailure" VALUE="<%= urlFailure %>">
    
    <table width="0" border="0" cellspacing="0" cellpadding="16" class="loginTBL">
    <tr>
        <td colspan="2" class="loginFrmHeader" align="left">Αναγνώριση Χρήστη</td>
    </tr>
    <tr class="loginTR">
        <td class="loginFrmLabelTD">Όνομα:</td>
        <td class="loginFrmFieldTD"><input type="text" name="empUsername" size="35" maxlength="15" class="loginFrmField" /></td>
	</tr>
    <tr class="loginTR">
        <td class="loginFrmLabelTD">Κωδικός:</td>
        <td class="loginFrmFieldTD"><input type="password" name="empPassword" size="35" maxlength="20" class="loginFrmField" /></td>
	 </tr>
     <tr class="loginFooterTR">
        <td colspan="2" align="center">
            <input type="submit" value="Είσοδος" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/>
        </td>
     </tr>
    </table>
    </form>
    
    <br/>
    <table width="40%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="text"><b>ΠΡΟΕΙΔΟΠΟΙHΣΗ</b>: Μη εξουσιοδοτημένη χρήση απαγορεύεται αυστηρώς και μπορεί να επιφέρει ποινική δίωξη. Η χρήση του κόμβου εποπτεύεται συνεχώς.</td>
    </tr>
    </table>
    
    
    </div>
    
    <br/>

</body>
</html>