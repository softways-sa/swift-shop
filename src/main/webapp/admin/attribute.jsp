<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>
                 
<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="bean_searchattribute" scope="session" class="gr.softways.dev.eshop.attribute.Search" />

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
bean_searchattribute.initBean(databaseId, request, response, this, session);
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;
bean_searchattribute.setDispRows(dispRows);
dbRet = bean_searchattribute.doAction(request);

if (dbRet.getAuthError() == 1) {
    bean_searchattribute.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = bean_searchattribute.getCurrentRowCount();
totalRowCount = bean_searchattribute.getTotalRowCount();
totalPages = bean_searchattribute.getTotalPages();
currentPage = bean_searchattribute.getCurrentPage();

int start = bean_searchattribute.getStart();

String atrName = bean_searchattribute.getAtrName();

String sorted_by_col = bean_searchattribute.getSortedByCol(),
       sorted_by_order = bean_searchattribute.getSortedByOrder();

String urlSearch = response.encodeURL("attribute.jsp"),
       urlNew = response.encodeURL("processattribute.jsp"),
       urlQuerySearch = "attribute.jsp?atrName=" + SwissKnife.hexEscape(atrName)
                        + "&sorted_by_col=" + SwissKnife.hexEscape(sorted_by_col)
                        + "&sorted_by_order=" + SwissKnife.hexEscape(sorted_by_order),

                        
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

int rows = 0;

%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function resetForm() {
            document.searchForm.atrName.value = "";
        }
        
        function doSortResults(sortedByCol, sortedByOrder) {
            document.searchForm.action1.value = "SORT";
    
            document.searchForm.sorted_by_col.value = sortedByCol;
            document.searchForm.sorted_by_order.value = sortedByOrder;
            
            document.searchForm.submit();
        }

	
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <div align="center">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            <input type="hidden" name="action1" value="SEARCH" />
            
            <input type="hidden" name="sorted_by_col" value="<%= sorted_by_col %>" />
            <input type="hidden" name="sorted_by_order" value="<%= sorted_by_order %>" />            
    
            <tr>
                <td class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Ιδιότητα&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Διαχείριση</b></td>
                    </tr>
                    </table>
                </td>
                
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="right">Ονομασία</td>
                                <td><input type="text" name="atrName" value="<%= atrName %>" size="50"  maxlength="100" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD"><input type="submit" name="" value="αναζήτηση" class="searchFrmBtn"  onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'"/></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD"><input type="button" name="" value="μηδενισμός" onclick="resetForm()" class="searchFrmBtn"  onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'"/></td>
                            </tr>
                            </table>
                        </td>
                        <td align="right"><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Προσθήκη νέας εγγραφής" /></a></td>
                    </tr>
                    </table>
                </td>
            </tr>
            
            </form>
            
            </table>

            <%
            // see if there are rows to display
            boolean moreDataRows = true;
            if (currentRowCount <= 0) moreDataRows = false;
            %>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός<% if (bean_searchattribute.isSortedBy("atrCode","ASC") == false) { %><a href="javascript:doSortResults('atrCode','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (bean_searchattribute.isSortedBy("atrCode","DESC") == false) { %><a href="javascript:doSortResults('atrCode','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>            
                <td class="resultsLabelTD">Ονομασία <% if (bean_searchattribute.isSortedBy("atrName","ASC") == false) { %><a href="javascript:doSortResults('atrName','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (bean_searchattribute.isSortedBy("atrName","DESC") == false) { %><a href="javascript:doSortResults('atrName','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
            </tr>
            <%
            // display
            int disp = 0;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processattribute.jsp?action1=EDIT&atrCode=" + bean_searchattribute.getHexColumn("atrCode")) %>" class="resultsLink"><%= bean_searchattribute.getColumn("atrCode") %></a></td>                
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processattribute.jsp?action1=EDIT&atrCode=" + bean_searchattribute.getHexColumn("atrCode")) %>" class="resultsLink"><%= bean_searchattribute.getColumn("atrName") %></a></td>
                </tr>
            <%
                moreDataRows = bean_searchattribute.nextRow();
            }
            for (; disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>                
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <%
            }
            %>
            <%-- / παρουσίαση ιδιοτήτων --%>
    
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="2"><%@ include file="include/navigationform2.jsp" %></td>
            </tr>
            </form>
            <%-- / previus - next --%>
            
            </table>
            
            </div>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% helperBean.closeResources(); %>
    
</body>
</html>
