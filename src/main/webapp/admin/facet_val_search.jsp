<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="facetValueAdminSearch" scope="session" class="gr.softways.dev.eshop.facet.FacetValueAdminSearch" />

<%
facetValueAdminSearch.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","products");

DbRet dbRet = null;
int dispPageNumbers = 10;

facetValueAdminSearch.setDispRows(dispRows);
dbRet = facetValueAdminSearch.doAction(request);

if (dbRet.getAuthError() == 1) {
    facetValueAdminSearch.closeResources();
    response.sendRedirect("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode());
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = facetValueAdminSearch.getCurrentRowCount();
totalRowCount = facetValueAdminSearch.getTotalRowCount();
totalPages = facetValueAdminSearch.getTotalPages();
currentPage = facetValueAdminSearch.getCurrentPage();

int start = facetValueAdminSearch.getStart();

String name = facetValueAdminSearch.getName();

String sorted_by_col = facetValueAdminSearch.getSortedByCol(),
       sorted_by_order = facetValueAdminSearch.getSortedByOrder();

String urlSearch = "facet_val_search.jsp",
       urlQuerySearch = "facet_val_search.jsp?name=" + SwissKnife.hexEscape(name),
       urlNew = response.encodeURL("facet_val_update.jsp");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

int rows = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
    function resetForm() {
      document.searchForm.name.value = "";
    }
    </script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
	<td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Φίλτρα</b></td>
        <td><a href="<%=urlNew%>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Νέα εγγραφή" /></a></td>
    </tr>
    </table>
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
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">Ονομασία: <input type="text" name="name" value="<%=name%>" size="25" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">
                                    <input type="submit" name="" value="αναζήτηση" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                                    <input type="button" name="" value="μηδενισμός" onclick="resetForm()" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
            boolean moreDataRows = true;
            
            if (currentRowCount <= 0) moreDataRows = false;
            %>

            <%-- results --%>
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
              <td class="resultsLabelTD">Ονομασία</td>
              <td class="resultsLabelTD">Ομάδα</td>
            </tr>
            <%
            int disp = 0;
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("configuration_update.jsp?action1=EDIT&id=" + facetValueAdminSearch.getInt("id")) %>" class="resultsLink"><%=facetValueAdminSearch.getColumn("name")%></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%=facetValueAdminSearch.getColumn("facet_name")%></td>
                </tr>
            <%
                moreDataRows = facetValueAdminSearch.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                  <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                  <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%=urlSearch%>">
            <tr class="resultsFooterTR">
                <td colspan="2"><%@ include file="include/navigationform2.jsp" %></td>
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