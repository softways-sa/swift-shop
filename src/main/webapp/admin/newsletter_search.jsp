<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="nwl_search" scope="session" class="gr.softways.dev.eshop.emaillists.newsletter.Search" />

<%
nwl_search.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");

DbRet dbRet = null;
int dispPageNumbers = 10;

nwl_search.setDispRows(dispRows);
dbRet = nwl_search.doAction(request);

if (dbRet.getAuthError() == 1) {
    nwl_search.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = nwl_search.getCurrentRowCount();
totalRowCount = nwl_search.getTotalRowCount();
totalPages = nwl_search.getTotalPages();
currentPage = nwl_search.getCurrentPage();

int start = nwl_search.getStart();

String sorted_by_col = nwl_search.getSortedByCol(),
       sorted_by_order = nwl_search.getSortedByOrder();

String urlSearch = response.encodeURL("newsletter_search.jsp"),
       urlQuerySearch = "newsletter_search.jsp?1=1",
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String urlSuccess = "/" + appDir + "admin/newsletter_search.jsp?action1=SEARCH&goLabel=results",
    urlFailure = "/" + appDir + "admin/problem.jsp";

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

int rows = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
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
            
            <form name="searchForm" method="post" action="<%= urlSearch %>">
            
            <input type="hidden" name="action1" value="SEARCH" />
            <input type="hidden" name="goLabel" value="results" />
            <input type="hidden" name="sorted_by_col" value="<%= sorted_by_col %>" />
            <input type="hidden" name="sorted_by_order" value="<%= sorted_by_order %>" />
        
            <tr>
                <td class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Αποστολή email</b></td>
                    </tr>
                    </table>
                </td>
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">&nbsp;</td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">
                                    <input type="button" name="" value="επιστροφή σε σύνθεση μηνύματος" class="searchFrmBtn" onclick="document.location.href= 'sendemail.jsp';" onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'" />
                                    
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    </table>
                </td>
                <td align="right">
                    <table width="0" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    </table>
                </td>
            </tr>
            
            </form>
            
            </table>
            
            <%
            boolean moreDataRows = true;
            
            if (currentRowCount <= 0) moreDataRows = false;
            %>

            <%-- results --%>
            <form name="updateForm" method="post" action="/admin/deletenewsletter.do">
            
            <input type="hidden" name="urlSuccess" value="<%= urlSuccess %>" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            
            <input type="hidden" name="NWLR_Code" value="" />
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Ημ/νία</td>
                <td class="resultsLabelTD">Τίτλος</td>
                <td class="resultsLabelTD">Θέμα</td>
                <td class="resultsLabelTD">&nbsp;</td>
            </tr>
            <%
            int disp = 0;
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("sendemail.jsp?NWLR_Code=" + nwl_search.getHexColumn("NWLR_Code")) %>" class="resultsLink"><%= SwissKnife.formatDate(nwl_search.getTimestamp("NWLR_Date"),"dd-MM-yyyy HH:mm") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("sendemail.jsp?NWLR_Code=" + nwl_search.getHexColumn("NWLR_Code")) %>" class="resultsLink"><%= nwl_search.getColumn("NWLR_Title") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= nwl_search.getColumn("NWLR_Subject") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="button" onclick='document.updateForm.NWLR_Code.value="<%=nwl_search.getColumn("NWLR_Code")%>";document.updateForm.submit();' value="Διαγραφή"/></td>
                </tr>
            <%
                moreDataRows = nwl_search.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            </form>
            </table>
            
            <%-- previus - next buttons --%>
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="4"><%@ include file="include/navigationform2.jsp" %></td>
            </tr>
            </form>
            
            </table>
            <%-- end of results --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>