<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="facetAdminSearch" scope="session" class="gr.softways.dev.eshop.facet.FacetAdminSearch" />

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","products");

facetAdminSearch.initBean(databaseId, request, response, this, session);
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;

facetAdminSearch.setDispRows(dispRows);

dbRet = facetAdminSearch.doAction(request);

if (dbRet.getAuthError() == 1) {
    facetAdminSearch.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = facetAdminSearch.getCurrentRowCount();
totalRowCount = facetAdminSearch.getTotalRowCount();
totalPages = facetAdminSearch.getTotalPages();
currentPage = facetAdminSearch.getCurrentPage();

int start = facetAdminSearch.getStart();

String urlSearch = "facet_search.jsp",
       urlQuerySearch = "facet_search.jsp?s=1",
       urlNew = response.encodeURL("facet_update.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

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
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Ομάδες Φίλτρων</b></td>
      <td align="right" valign="middle">
        <table width="0" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border ="0" alt="Προσθήκη νέας εγγραφής"></a></td>
          <td>&nbsp;</td>
        </tr>
        </table>
      </td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="post" action="<%=urlSearch%>">
            
            <input type="hidden" name="action1" value="SEARCH" />
            <input type="hidden" name="goLabel" value="results" />
        
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">
                                    <input type="submit" name="" value="αναζήτηση" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                                    
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

            <%-- παρουσίαση --%>
            <a name="results"></a>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Ονομασία</td>
                <td class="resultsLabelTD">Σειρά</td>
            </tr>
            <%
            int disp = 0;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                  <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%="facet_update.jsp?action1=EDIT&id=" + facetAdminSearch.getInt("id")%>" class="resultsLink"><%=facetAdminSearch.getColumn("name")%></a></td>
                  <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%=facetAdminSearch.getInt("display_order")%></td>
                </tr>
            <%
                moreDataRows = facetAdminSearch.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="12"><%@ include file="include/navigationform2.jsp" %></td>
            </tr>
            </form>
            
            </table>
            <%-- / παρουσίαση --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% 
    if (goLabel.length()>0) { %>
        <script type="text/javascript" language="javascript">
            document.location.hash = "<%= goLabel %>";
        </script>
    <% } %>
    
    <% helperBean.closeResources(); %>
    
</body>
</html>