<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal, gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","products");

helperBean.initBean(databaseId, request, response, this, session);

String urlSuccess = "/" + appDir + "admin/onsales_update.jsp",
       urlFailure = "/" + appDir + "admin/problem.jsp";

int rows = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script type="text/javascript" language="javascript" src="js/jsfunctions.js"></script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="20" cellpadding="2">
    <tr>
    <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Εκπτώσεις</b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="800" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/OnSales") %>">
            
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Κατηγορία</td>
                <td class="inputFrmFieldTD">
                    <select name="catId" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        int catRows = helperBean.getTable("prdCategory", "catId");

                        for (int i=0; i<catRows; i++) { %>
                            <option value="<%= helperBean.getColumn("catId") %>"><% for (int i0=0; i0<(helperBean.getColumn("catId").length()-2); i0++) out.print("&nbsp;&nbsp;"); %><%= helperBean.getColumn("catName") %></option>
                        <%
                            helperBean.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ποσοστό έκπτωσης (πχ. 20)</td>
                <td class="inputFrmFieldTD"><input type="text" size="5" name="discount" class="inputFrmField" style="text-align:right;" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />%</td>
            </tr>
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <div><b>* Η εφαρμογή έκπτωσης ακυρώνει όλες τις τρέχουσες προσφορές.</b></div>
                    <br/>
                    <input type="button" value="Εφαρμογή έκπτωσης" onclick='if (confirm("Είστε σίγουρος;")) { document.inputForm.action1.value="DISCOUNT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="button" value="Ακύρωση έκπτωσης" onclick='if (confirm("Θα ακυρωθούν όλες οι τρέχουσες προσφορές. Είστε σίγουρος;")) { document.inputForm.action1.value="REVERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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