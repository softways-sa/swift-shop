<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>
                 
<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="exph_searchcmrow" scope="session" class="gr.softways.dev.swift.cmrow.Search" />

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
exph_searchcmrow.initBean(databaseId, request, response, this, session);
helperBean.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","content");

DbRet dbRet = null;

int dispPageNumbers = 10;
exph_searchcmrow.setDispRows(dispRows);
dbRet = exph_searchcmrow.doAction(request);

if (dbRet.getAuthError() == 1) {
    exph_searchcmrow.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = exph_searchcmrow.getCurrentRowCount();
totalRowCount = exph_searchcmrow.getTotalRowCount();
totalPages = exph_searchcmrow.getTotalPages();
currentPage = exph_searchcmrow.getCurrentPage();

int start = exph_searchcmrow.getStart();

String CMRDateCreatedDay = exph_searchcmrow.getCMRDateCreatedDay(),
        CMRDateCreatedMonth = exph_searchcmrow.getCMRDateCreatedMonth(),
        CMRDateCreatedYear = exph_searchcmrow.getCMRDateCreatedYear(),
        CMRDateUpdatedDay = exph_searchcmrow.getCMRDateUpdatedDay(),
        CMRDateUpdatedMonth = exph_searchcmrow.getCMRDateUpdatedMonth(),
        CMRDateUpdatedYear = exph_searchcmrow.getCMRDateUpdatedYear(),        
        CMRTitle = exph_searchcmrow.getCMRTitle(),
        CMCCode = exph_searchcmrow.getCMCCode();        

String sorted_by_col = exph_searchcmrow.getSortedByCol(),
       sorted_by_order = exph_searchcmrow.getSortedByOrder();

String urlSearch = response.encodeURL("cmrow.jsp"),
       urlNew = response.encodeURL("processcmrow.jsp"),
       urlQuerySearch = "cmrow.jsp?CMRTitle=" + SwissKnife.hexEscape(CMRTitle)
                        + "&CMRDateCreatedDay=" + SwissKnife.hexEscape(CMRDateCreatedDay)        
                        + "&CMRDateCreatedMonth=" + SwissKnife.hexEscape(CMRDateCreatedMonth)        
                        + "&CMRDateCreatedYear=" + SwissKnife.hexEscape(CMRDateCreatedYear)        
                        + "&CMRDateUpdatedDay=" + SwissKnife.hexEscape(CMRDateUpdatedDay)        
                        + "&CMRDateUpdatedMonth=" + SwissKnife.hexEscape(CMRDateUpdatedMonth)        
                        + "&CMRDateUpdatedYear=" + SwissKnife.hexEscape(CMRDateUpdatedYear)
                        + "&CMCCode=" + SwissKnife.hexEscape(CMCCode)                        
                        + "&sorted_by_col=" + SwissKnife.hexEscape(sorted_by_col)
                        + "&sorted_by_order=" + SwissKnife.hexEscape(sorted_by_order),

                        
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

int rows = 0;

String[] months = new String[] {"","Ιαν","Φεβ","Μαρ","Απρ","Μάϊ","Ιουν","Ιουλ","Αυγ","Σεπ","Οκτ","Νοε","Δεκ"};

int currYear = SwissKnife.getTDateInt(SwissKnife.currentDate(), "YEAR");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    <script language="JavaScript" src="js/date.js"></script>
    
    <script language="JavaScript">
    function resetForm() {
        document.searchForm.CMRTitle.value = "";

        document.searchForm.CMRDateCreatedDay.value = "";
        document.searchForm.CMRDateCreatedMonth.selectedIndex = 0;
        document.searchForm.CMRDateCreatedYear.selectedIndex = 0;

        document.searchForm.CMRDateUpdatedDay.value = "";
        document.searchForm.CMRDateUpdatedMonth.selectedIndex = 0;
        document.searchForm.CMRDateUpdatedYear.selectedIndex = 0;          

        document.searchForm.CMCCode.selectedIndex = 0;                        

    }

    function doSortResults(sortedByCol, sortedByOrder) {
        document.searchForm.action1.value = "SORT";

        document.searchForm.sorted_by_col.value = sortedByCol;
        document.searchForm.sorted_by_order.value = sortedByOrder;

        document.searchForm.submit();
    }

    var downYear = <%= currYear - yearDnLimit %>;
    var upYear = <%= currYear + yearUpLimit %>;
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>

    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
	<td class="menuPathTD" align="middle"><b>Περιεχόμενο&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Σελίδες</b></td>
	<td class="menuPathTD" align="middle"><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Προσθήκη νέας εγγραφής" /></a></td>
    </tr>
    </table>

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
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="right">Καταχώρηση από</td>
                                <td class="searchCalendarTD">
                                    <table width="0" border="0" cellspacing="1" cellpadding="0">
                                    <tr>
                                        <td><input type="text" name="CMRDateCreatedDay" size="2" value="<%= CMRDateCreatedDay %>" maxlength="2" class="inputFrmField" onblur="valInt('searchForm', 'CMRDateCreatedDay', 0, 1, 31); this.className='inputFrmField'" onfocus="this.className='inputFrmFieldFocus'" /></td>
                                        <td>
                                            <select name="CMRDateCreatedMonth" class="inputFrmField">
                                                <option value="">ΜΗΝΑΣ</option>
                                                <% 
                                                for (int i=1; i<=12; i++) { %>
                                                    <option value="<%= i %>" <% if (CMRDateCreatedMonth.equals( String.valueOf(i) )) out.print("SELECTED"); %>><%= months[i] %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="CMRDateCreatedYear" class="inputFrmField">
                                                <option value="">ETOΣ</option>
                                                <%
                                                for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                                    <option value="<%= i %>" <% if (CMRDateCreatedYear.equals( String.valueOf(i) )) out.print("SELECTED"); %>><%= i %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                                <td class="searchFrmTD" align="right">Τίτλος</td>
                                <td><input type="text" name="CMRTitle" value="<%= CMRTitle %>" size="30"  maxlength="160" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD" align="right">Ενημέρωση από</td>
                                <td class="searchCalendarTD">
                                    <table width="0" border="0" cellspacing="1" cellpadding="0">
                                    <tr>
                                        <td><input type="text" name="CMRDateUpdatedDay" size="2" value="<%= CMRDateUpdatedDay %>" maxlength="2" class="inputFrmField" onblur="valInt('searchForm', 'CMRDateUpdatedDay', 0, 1, 31); this.className='inputFrmField'" onfocus="this.className='inputFrmFieldFocus'" /></td>
                                        <td>
                                            <select name="CMRDateUpdatedMonth" class="inputFrmField">
                                                <option value="">ΜΗΝΑΣ</option>
                                                <% 
                                                for (int i=1; i<=12; i++) { %>
                                                    <option value="<%= i %>" <% if (CMRDateUpdatedMonth.equals( String.valueOf(i) )) out.print("SELECTED"); %>><%= months[i] %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="CMRDateUpdatedYear" class="inputFrmField">
                                                <option value="">ETOΣ</option>
                                                <%
                                                for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                                    <option value="<%= i %>" <% if (CMRDateUpdatedYear.equals( String.valueOf(i) )) out.print("SELECTED"); %>><%= i %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                                <td class="searchFrmTD" align="right">Ενότητα</td>
                                <td colspan="3">
                                    <select name="CMCCode" class="inputFrmField" >
                                        <option value="">---</option>
                                        <%
                                        int CMCRows = helperBean.getTable("CMCategory", "CMCCode");
                    
                                        for (int i=0; i<CMCRows; i++) { %>
                                            <option value="<%= helperBean.getColumn("CMCCode") %>" <% if (helperBean.getColumn("CMCCode").equals(CMCCode)) { %>SELECTED <% } %>><% for (int i0=0; i0<(helperBean.getColumn("CMCCode").length()-2); i0++) out.print("&nbsp;&nbsp;"); %><%= helperBean.getColumn("CMCName") %></option>
                                        <%
                                            helperBean.nextRow();
                                        } %>
                                    </select>
                                </td>                            
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD"><input type="submit" name="" value="αναζήτηση" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
                                <td class="searchFrmTD"><input type="button" name="" value="μηδενισμός" onclick="resetForm()" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
                            </tr>
                            </table>
                        </td>
                        <td align="right"></td>
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
            
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός <% if (exph_searchcmrow.isSortedBy("CMRCode","ASC") == false) { %><a href="javascript:doSortResults('CMRCode','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmrow.isSortedBy("CMRCode","DESC") == false) { %><a href="javascript:doSortResults('CMRCode','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>            
                <td class="resultsLabelTD">Καταχώρηση <% if (exph_searchcmrow.isSortedBy("CMRDateCreated","ASC") == false) { %><a href="javascript:doSortResults('CMRDateCreated','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmrow.isSortedBy("CMRDateCreated","DESC") == false) { %><a href="javascript:doSortResults('CMRDateCreated','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Ενημέρωση <% if (exph_searchcmrow.isSortedBy("CMRDateUpdated","ASC") == false) { %><a href="javascript:doSortResults('CMRDateUpdated','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmrow.isSortedBy("CMRDateUpdated","DESC") == false) { %><a href="javascript:doSortResults('CMRDateUpdated','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">Τίτλος <% if (exph_searchcmrow.isSortedBy("CMRTitle","ASC") == false) { %><a href="javascript:doSortResults('CMRTitle','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (exph_searchcmrow.isSortedBy("CMRTitle","DESC") == false) { %><a href="javascript:doSortResults('CMRTitle','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
            </tr>
            <%
            // display
            int disp = 0;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + exph_searchcmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= exph_searchcmrow.getColumn("CMRCode") %></a></td>                
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + exph_searchcmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= SwissKnife.formatDate(exph_searchcmrow.getTimestamp("CMRDateCreated"),"dd-MM-yyyy") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + exph_searchcmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= SwissKnife.formatDate(exph_searchcmrow.getTimestamp("CMRDateUpdated"),"dd-MM-yyyy") %></a></td>                    
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + exph_searchcmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= exph_searchcmrow.getColumn("CMRTitle") %></a></td>
                </tr>
            <%
                moreDataRows = exph_searchcmrow.nextRow();
            }
            for (; disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>                
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <%
            }
            %>
            <%-- / παρουσίαση άρθρων --%>
    
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="4"><%@ include file="include/navigationform2.jsp" %></td>
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