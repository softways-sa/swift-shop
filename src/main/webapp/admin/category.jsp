<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_searchcateg" scope="session" class="gr.softways.dev.eshop.category.v2.Search" />

<%
request.setAttribute("admin.topmenu","products");

app_searchcateg.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;

app_searchcateg.setDispRows(dispRows);

dbRet = app_searchcateg.doAction(request);

if (dbRet.getAuthError() == 1) {
    app_searchcateg.closeResources();
    
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = app_searchcateg.getCurrentRowCount();
totalRowCount = app_searchcateg.getTotalRowCount();
totalPages = app_searchcateg.getTotalPages();
currentPage = app_searchcateg.getCurrentPage();

int start = app_searchcateg.getStart();

String catId = app_searchcateg.getCatId(),
       catName = app_searchcateg.getCatName();

String sorted_by_col = app_searchcateg.getSortedByCol(),
       sorted_by_order = app_searchcateg.getSortedByOrder();

String urlSearch = response.encodeURL("category.jsp"),
       urlQuerySearch = "category.jsp?catId=" + SwissKnife.hexEscape(catId)
                      + "&name=" + SwissKnife.hexEscape(catName)
                      + "&sorted_by_col=" + SwissKnife.hexEscape(sorted_by_col)
                      + "&sorted_by_order=" + SwissKnife.hexEscape(sorted_by_order),
       urlNew = response.encodeURL("processcateg.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function resetForm() {
            document.searchForm.catId.value="";
            document.searchForm.catName.value="";
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
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle">
          <table width="0" border="0" cellspacing="2" cellpadding="2">
          <tr>
              <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Κατηγορίες προϊόντων</b></td>
          </tr>
          </table>
      </td>
      <td align="right">
          <table width="0" border="0" cellspacing="0" cellpadding="0">
          <tr>
              <td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Προσθήκη νέας εγγραφής" /></a></td>
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
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            <input type="hidden" name="action1" value="SEARCH" />
            <input type="hidden" name="goLabel" value="results" />
            <input type="hidden" name="sorted_by_col" value="<%= sorted_by_col %>" />
            <input type="hidden" name="sorted_by_order" value="<%= sorted_by_order %>" />
        
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="0" cellpadding="10">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="left">Κωδικός:</td>
                                <td class="searchFrmTD" align="left">Ονομασία:</td>
                                <td class="searchFrmTD" align="left"></td>				
                            </tr>			    
                            <tr>
                                <td class="searchFrmTD"><input type="text" name="catId" value="<%= catId %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                                <td class="searchFrmTD"><input type="text" name="catName" value="<%= catName %>"  size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
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
            // see if there are rows to display
            boolean moreDataRows = true;
            
            if (currentRowCount <= 0) moreDataRows = false;
            %>

            <%-- παρουσίαση --%>
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός <% if (app_searchcateg.isSortedBy("catId","ASC") == false) { %><a href="javascript:doSortResults('catId','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (app_searchcateg.isSortedBy("catId","DESC") == false) { %><a href="javascript:doSortResults('catId','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Ονομασία <% if (app_searchcateg.isSortedBy("catName","ASC") == false) { %><a href="javascript:doSortResults('catName','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (app_searchcateg.isSortedBy("catName","DESC") == false) { %><a href="javascript:doSortResults('catName','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Εμφάνιση</td>
            </tr>
            <%
            int disp = 0;
            
            String catShowFlagMsg = "";
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
                if (app_searchcateg.getColumn("catShowFlag").equals("1")) catShowFlagMsg = "ΝΑΙ";
                else catShowFlagMsg = "ΟΧΙ";
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcateg.jsp?action1=EDIT&catId=" + app_searchcateg.getHexColumn("catId")) %>" class="resultsLink"><%= app_searchcateg.getColumn("catId") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcateg.jsp?action1=EDIT&catId=" + app_searchcateg.getHexColumn("catId")) %>" class="resultsLink"><%= app_searchcateg.getColumn("catName") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= catShowFlagMsg %></td>
                </tr>
            <%
                moreDataRows = app_searchcateg.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            
            <tr class="resultsFooterTR">
                <td colspan="3"><%@ include file="include/navigationform2.jsp" %></td>
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
    
</body>
</html>