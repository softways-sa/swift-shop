<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
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
                        <td class="menuPathTD" align="middle"><b>Πρόβλημα</b></td>
                    </tr>
                    </table>
                </td>
                <td width="70%" align = "middle">&nbsp;</td>
            </tr>
            </table>
            
            <table width="60%" border="0" cellspacing="1" cellpadding="5" class="tablecolor">
            <tr class="trcolor1">
                <td align="center"><span class="text"><b>Δεν έχετε τα απαραίτητα δικαιώματα για την ενέργεια που επιλέξατε.</b></span>
                </td>
            </tr>
            </table>
        
        </td>
        
        <%@ include file="include/right.jsp" %>
        
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>
