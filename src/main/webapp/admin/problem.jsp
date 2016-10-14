<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page isErrorPage="true" %>

<%@ page import="gr.softways.dev.util.*,java.io.PrintWriter" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<%
String error = request.getParameter("error");
%>

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
                <td align="center"><span class="text"><b>Παρουσιάστηκε κάποιο πρόβλημα κατά την ενέργεια που επιλέξατε.</b></span>
                <% if (error != null && error.length()>0) { %>
                    <br><br>
                    <span class="text">Μήνυμα λάθους : <%= error %></span>
                <% } %>
                <% if (exception != null) { %>
                    <br><br>
                    <span class="text">Stack Trace : <% exception.printStackTrace(new PrintWriter(out)); %></span>
                <% } %>
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
