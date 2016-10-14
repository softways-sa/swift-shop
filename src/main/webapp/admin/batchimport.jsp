<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<%
request.setAttribute("admin.topmenu","products");

String urlReturn = response.encodeURL("http://" + serverName + "/" + appDir + "admin/batchimport.jsp"),
       urlBatchManager = response.encodeURL("/servlet/admin/ProductBatchManager");
       
String status = request.getParameter("status") == null ? "" : request.getParameter("status"),
       textMsg = request.getParameter("textMsg") == null ? "" : request.getParameter("textMsg");
       
String statusLabel = "";

if (status.equals("")) {
    statusLabel = "Άγνωστη";
}
else if (status.equals("0")) {
    statusLabel = "Αδράνεια";
}
else if (status.equals("1")) {
    statusLabel = "Σε εξέλιξη ΕΝΗΜΕΡΩΣΗ ΠΡΟΪΟΝΤΩΝ";
}
%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>ΜΑΖΙΚΗ ΕΝΗΜΕΡΩΣΗ</title>

    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="javascript">
    function validateForm(){
        if (document.upFileForm.file.value == ""){
            alert("Παρακαλούμε εισάγετε το όνομα του αρχείου.");
            document.upFileForm.file.focus();
            return false;
        }
        else if (document.upFileForm.action1.options[document.upFileForm.action1.selectedIndex].value == "") {
            alert('Παρακαλούμε επιλέξτε ενέργεια.');
            document.upFileForm.action1.focus();
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
      <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μαζική ενημέρωση</b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="upFileForm" action="<%= urlBatchManager %>" enctype="multipart/form-data" method="POST">

            <input type="hidden" name="buttonPressed" value="0">
            <input type="hidden" name="databaseId" value="<%= databaseId %>">
            <input type="hidden" name="urlReturn" value="<%= urlReturn %>">
            
            <tr>
                <td colspan="2" class="inputFrmHeader" align="center">ΑΠΟΣΤΟΛΗ ΑΡΧΕΙΟΥ &amp; ΕΝΗΜΕΡΩΣΗ</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Αρχείο EXCEL</td>
                <td class="inputFrmFieldTD"><input type="file" name="file" size="80" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD"><span class="normalBold">Ενέργεια</span></td>
                <td class="inputFrmFieldTD">
                    <select name="action1" class="inputFrmField">
                        <option value="BATCH_UPDATE_PRODUCT">ΕΝΗΜΕΡΩΣΗ ΠΡΟΪΟΝΤΩΝ</option>
                    </select>
                </td>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <input type="button" value="Αποστολή" onClick='if (validateForm() == true && confirm("Είστε σίγουρος;") == true) { if (checkButton(document.upFileForm.buttonPressed) == true) { document.upFileForm.submit(); } else return false}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="reset" value="Καθαρισμός πεδίων" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            
            </form>
            
            </table>
            
            <br/>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="queryStatusForm" action="<%= urlBatchManager %>" enctype="multipart/form-data" method="POST">
            
            <input type="hidden" name="action1" value="QUERY_STATUS" />
            <input type="hidden" name="urlReturn" value="<%=urlReturn%>" />
            <input type="hidden" name="databaseId" value="<%=databaseId%>" />
            
            <tr>
                <td class="inputFrmLabelTD">ΚΑΤΑΣΤΑΣΗ</td>
                <td class="inputFrmFieldTD"><%=statusLabel%></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">ΜΥΝΗΜΑ</td>
                <td class="inputFrmFieldTD"><%=textMsg%></td>
            </tr>
            <tr>
                <td class="inputFrmFooter" colspan="2" align="center"><input type="submit" value="Λήψη κατάστασης" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /></td>
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