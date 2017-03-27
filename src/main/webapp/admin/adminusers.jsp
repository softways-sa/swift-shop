<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.DbRet" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_srcusers" scope="session" class="gr.softways.dev.eshop.adminusers.Search" />

<%
app_srcusers.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","admin");

DbRet dbRet = null;

dbRet = app_srcusers.doAction(request);

if (dbRet.authError == 1) {
    app_srcusers.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
}

String urlSearch = "/" + appDir + "admin/adminusers.jsp",
       urlNewUser = "/" + appDir + "admin/processadminusers.jsp?action1=INSERT",
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

String ausrCode = app_srcusers.getAusrCode(),
       ausrLastname = app_srcusers.getAusrLastname();  

int rowCount = app_srcusers.getRowCount();

int pageCount = 0, q = 0, pageNum = 1, groupPages = 0,
    dispPages = 0, startRow = 0, rows = 0;

app_srcusers.setDispRows(dispRows);
pageNum = app_srcusers.getPageNum();
startRow = app_srcusers.getStartRow();
groupPages = app_srcusers.getGroupPages();


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function resetForm() {
            document.searchForm.ausrLastname.value="";
            document.searchForm.ausrCode.value="";
        } 
    </script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="20" cellpadding="2">
    <tr>
    <td class="menuPathTD" align="middle"><b>Σύστημα&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Χρήστες συστήματος</b></td>
    <td><a href="<%= urlNewUser%>" class="text" id="white"><img src="images/addnew.png"  border ="0" alt="Προσθήκη νέας εγγραφής" /></a></td>    
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            <input type="hidden" name="action1" value="SEARCH" />
            <input type="hidden" name="goLabel" value="results" />
            
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">Κωδικός <input type="Text" name="ausrCode" value="<%= ausrCode %>"  size="20"  class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                                <td class="searchFrmTD">Επώνυμο <input type="Text" name="ausrLastname" value="<%= ausrLastname %>"   size="20"  class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">
                                    <input type="submit" name="" value="αναζήτηση" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/> 
                                    <input type="button" name="" value="μηδενισμός" onclick='resetForm()' class="loginFrmBtn"   onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/>
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            
            </form>
            
            </table>

            <%
            // see if there are rows to display
            boolean moreDataRows = true;
            
            if (rowCount > 0) {
                // determine the number of pages
                if (rowCount > dispRows) {
                    pageCount = (rowCount / dispRows);
                    if ( (rowCount % dispRows) > 0 ) { pageCount++; }
                }
                else { pageCount = 1; }
            }
            else { moreDataRows = false; }
            %>

            <%-- παρουσίαση --%>
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός</td>
                <td class="resultsLabelTD">Ονοματεπώνυμο</td>
                <td class="resultsLabelTD">Username</td>
            </tr>
            <%
            int disp = 0;
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL( "processadminusers.jsp?action1=EDIT&ausrCode=" + app_srcusers.getColumn("ausrCode") ) %>" class="resultsLink"><%= app_srcusers.getColumn("ausrCode") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%=  app_srcusers.getColumn("ausrLastname") + " " + app_srcusers.getColumn("ausrFirstname")%></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= app_srcusers.getColumn("usrName") %></td>
                </tr>
            <%
                moreDataRows = app_srcusers.nextRow();
            }
            for (; disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="3"><%@ include file="include/navigationform.jsp" %></td>
            </tr>
            </form>
            
            </table>
            <%-- / παρουσίαση --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>