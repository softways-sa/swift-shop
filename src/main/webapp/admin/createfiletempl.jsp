<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.JSPBean" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<% 
JSPBean present = new JSPBean();
present.initBean(databaseId, request, response, this, session);

String tableHeader = "Στοιχεία εισαγωγής-εξαγωγής";

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/createfiletempl.jsp"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlFileTemplate = response.encodeURL("/servlet/admin/FTImportExport");

int rows = 0;
%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>

    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
       <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            <tr height="40">
            
                <td width="30%" class="menuPathTD" align="middle">
                
                
                
                <table width="0" border="0" cellspacing="2" cellpadding="2">                
                <tr>
                <td class="menuPathTD" align="middle"><b>Σύστημα&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Εισαγωγή-εξαγωγή δεδομένων</b></td>
                </tr>
                </table>
                
                
                
                </td>
                <td width="70%" align = "middle">&nbsp;</td>
            </tr>
            </table>        
        </td>      
        <%@ include file="include/right.jsp" %>        
    </tr>
    <tr>
        <%@ include file="include/left.jsp" %>  
        <td valign="top">
		
        
        
            <form name="inputForm" action="<%= urlFileTemplate %>" method="POST">
            <input type="Hidden" name="databaseId" value="<%= databaseId %>">
            <input type="Hidden" name="inPath" value="<%= TEMPLATE_DIR_IN %>">
            <input type="Hidden" name="outPath" value="<%= TEMPLATE_DIR_OUT %>">
            <input type="Hidden" name="urlSuccess" value="<%= urlSuccess %>">
            <input type="Hidden" name="urlFailure" value="<%= urlFailure %>">
            <input type="Hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmHeader" colspan="2" align="center"><%= tableHeader %></td>
            </tr>	
            <TR>
                <TD class="inputFrmLabelTD">Γραμμογράφηση</TD>
                <TD class="inputFrmFieldTD">
                    <SELECT NAME="FTemCode" style="HEIGHT: 25px; WIDTH: 200px" width="200" height="25" class="inputFrmField">
                    <%
                    rows = present.getTable("fileTemplate","FTemName");
                    
                    for (int l=0; l<rows; l++) {
                    %>
                        <OPTION VALUE="<%= present.getColumn("FTemCode") %>"><%= present.getColumn("FTemName") %></OPTION>
                    <%
                        present.nextRow();
                    } %>
                    </SELECT>
                </TD>
            </TR>
            <TR>
                <TD class="inputFrmLabelTD">Τύπος Αρχείου</TD>
                <TD class="inputFrmFieldTD">
                    <SELECT NAME="className" style="HEIGHT: 25px; WIDTH: 200px" width="200" height="25" class="inputFrmField">
                        <OPTION VALUE="gr.softways.dev.eshop.filetemplate.TXTFileTemplate">TXT</OPTION>
                        <OPTION VALUE="gr.softways.dev.eshop.filetemplate.EXCELFileTemplate">EXCEL</OPTION>
                    </SELECT>
                </TD>
            </TR>
            <TR>
                <TD class="inputFrmLabelTD">Λειτουργία</TD>
                <TD class="inputFrmFieldTD">
                    <SELECT NAME="action1" style="HEIGHT: 25px; WIDTH: 200px" width="200" height="25" class="inputFrmField">
                        <OPTION VALUE="<%= TEMPLATE_OP_INNew %>">ΝΕΑ ΕΙΣΑΓΩΓΗ</OPTION>
                        <OPTION VALUE="<%= TEMPLATE_OP_IN %>">ΜΕΤΑΒΟΛΗ</OPTION>
                        <OPTION VALUE="<%= TEMPLATE_OP_OUT %>">ΕΞΑΓΩΓΗ</OPTION>
                    </SELECT>
                </TD>
            </TR>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <input type="Button" name="" value="Δημιουργία αρχείου" onClick='if (confirm("Είστε σίγουρος;") == true) {document.inputForm.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'">
                </td>
            </tr>
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center" class="inputFrmLabelTD"><I>Δεξί click</I> & <I>Αποθήκευση ως</I> για download του αρχείου δεδομένων.<br><br>
                <% 
                present.goToRow(0);
                for (int i = 0; i < rows; i++){
                %>
                    <a href="<%= response.encodeURL("http://" + serverName + "/" + appDir + "admin/template_data/out/" + present.getColumn("FTemFilename")) %>" class="link"><%= present.getColumn("FTemName") %></a>&nbsp;<br>
                <% 
                    present.nextRow();
                }
                present.closeResources();
                %>
                </td>
            </tr>            
            
            
            </table>
            </form>
        </td>
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    <%@ include file="include/bottom.jsp" %>
</body>
</html>