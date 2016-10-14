<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="exph_searchcmcateg" scope="session" class="gr.softways.dev.swift.cmcategory.Search" />

<%
exph_searchcmcateg.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","content");

DbRet dbRet = null;
int dispPageNumbers = 10;

exph_searchcmcateg.setDispRows(dispRows);
dbRet = exph_searchcmcateg.doAction(request);

if (dbRet.authError == 1) {
    exph_searchcmcateg.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = exph_searchcmcateg.getCurrentRowCount();
totalRowCount = exph_searchcmcateg.getTotalRowCount();
totalPages = exph_searchcmcateg.getTotalPages();
currentPage = exph_searchcmcateg.getCurrentPage();

int start = exph_searchcmcateg.getStart();

String CMCCode = exph_searchcmcateg.getCMCCode(),
       CMCName = exph_searchcmcateg.getCMCName();

String sorted_by_col = exph_searchcmcateg.getSortedByCol(),
       sorted_by_order = exph_searchcmcateg.getSortedByOrder();

String urlSearch = response.encodeURL("cmcategory.jsp"),
       urlQuerySearch = "cmcategory.jsp?CMCCode=" + SwissKnife.hexEscape(CMCCode) + "&CMCName=" + SwissKnife.hexEscape(CMCName)
                               + "&sorted_by_col=" + SwissKnife.hexEscape(sorted_by_col)
                            + "&sorted_by_order=" + SwissKnife.hexEscape(sorted_by_order),
       urlNew = response.encodeURL("processcmcateg.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

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
            document.searchForm.CMCCode.value="";
            document.searchForm.CMCName.value="";
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
                        <td class="menuPathTD" align="middle"><b>Περιεχόμενο&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Ενότητες</b></td>
                        <td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Νέα εγγραφή" /></a></td>			
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
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">Κωδικός:</td>
                                <td class="searchFrmTD">Ονομασία:</td>
                            </tr>			    
                            <tr>
                                <td class="searchFrmTD"><input type="text" name="CMCCode" value="<%= CMCCode %>" size="20"  maxlength="25"  class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                                <td class="searchFrmTD"><input type="text" name="CMCName" value="<%= CMCName %>"  size="20"  maxlength="80"  class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            </tr>
                            </table>
                        </td>
                        <td valign="bottom">
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
                <td class="resultsLabelTD">Κωδικός <% if (exph_searchcmcateg.isSortedBy("CMCCode","ASC") == false) { %><a href="javascript:doSortResults('CMCCode','ASC');"><img src="images/asc.gif" alt="Ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="Ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmcateg.isSortedBy("CMCCode","DESC") == false) { %><a href="javascript:doSortResults('CMCCode','DESC');"><img src="images/desc.gif" alt="Φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="Φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Ονομασία <% if (exph_searchcmcateg.isSortedBy("CMCName","ASC") == false) { %><a href="javascript:doSortResults('CMCName','ASC');"><img src="images/asc.gif" alt="Ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="Ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmcateg.isSortedBy("CMCName","DESC") == false) { %><a href="javascript:doSortResults('CMCName','DESC');"><img src="images/desc.gif" alt="Φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="Φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Εμφάνιση</td>
            </tr>
            <%
            int disp = 0;
            
            String CMCShowFlagMsg = "";
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
                if (exph_searchcmcateg.getColumn("CMCShowFlag").equals("1")) CMCShowFlagMsg = "ΝΑΙ";
                else CMCShowFlagMsg = "ΟΧΙ";
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmcateg.jsp?action1=EDIT&CMCCode=" + exph_searchcmcateg.getHexColumn("CMCCode")) %>" class="resultsLink"><%= exph_searchcmcateg.getColumn("CMCCode") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmcateg.jsp?action1=EDIT&CMCCode=" + exph_searchcmcateg.getHexColumn("CMCCode")) %>" class="resultsLink"><%= exph_searchcmcateg.getColumn("CMCName") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= CMCShowFlagMsg %></td>
                </tr>
            <%
                moreDataRows = exph_searchcmcateg.nextRow();
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
            <%-- end of results --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>