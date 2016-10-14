<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="bean_relAttribute" scope="session" class="gr.softways.dev.eshop.attribute.AdminRelAttSearch" />


<%
bean_relAttribute.initBean(databaseId, request, response, this, session);
DbRet dbRet = null;
int dispPageNumbers = 10;
bean_relAttribute.setDispRows(dispRows);
dbRet = bean_relAttribute.doAction(request);

if (dbRet.getAuthError() == 1) {
    bean_relAttribute.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}


int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = bean_relAttribute.getCurrentRowCount();
totalRowCount = bean_relAttribute.getTotalRowCount();
totalPages = bean_relAttribute.getTotalPages();
currentPage = bean_relAttribute.getCurrentPage();

int start = bean_relAttribute.getStart();

String SLAT_master_atrCode = request.getParameter("SLAT_master_atrCode"),
       atrName = request.getParameter("atrName");

if (SLAT_master_atrCode != null && SLAT_master_atrCode.length()>0) {
    bean_relAttribute.setSLAT_master_atrCode(SLAT_master_atrCode);
}
if (atrName != null && atrName.length()>0) {
    bean_relAttribute.setatrName(atrName);
}

SLAT_master_atrCode = bean_relAttribute.getSLAT_master_atrCode();
atrName = bean_relAttribute.getatrName();

if (SLAT_master_atrCode == null || SLAT_master_atrCode.equals("")) {
    bean_relAttribute.closeResources();
    response.sendRedirect( response.encodeURL("problem.jsp") );
    return;
}


String sorted_by_col = bean_relAttribute.getSortedByCol(),
       sorted_by_order = bean_relAttribute.getSortedByOrder();

String searchatrName = bean_relAttribute.getSearchatrName();


String urlSearch = response.encodeURL("relateattribute.jsp"),
       urlReturn = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processattribute.jsp?action1=EDIT&goLabel=relAttribute&atrCode=" + SLAT_master_atrCode),
       urlrelAttribute = response.encodeURL("/servlet/admin/RelateAttribute"),
       urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/relateattribute.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       urlQuerySearch = "relateattribute.jsp?searchatrName=" + SwissKnife.hexEscape(searchatrName)
                        + "&sorted_by_col=" + SwissKnife.hexEscape(sorted_by_col)
                        + "&sorted_by_order=" + SwissKnife.hexEscape(sorted_by_order),        
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");
int rows = 0;

%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE>eΔιαχείριση</TITLE>

    <script type="text/javascript" language="javascript" src="js/jsfunctions.js" charset="UTF-8"></script>
    <script language="JavaScript" src="js/date.js"></script>    
    
    <script language="JavaScript">
        function resetForm() {
            document.searchForm.searchatrName.value = "";
        }
        
        function doSortResults(sortedByCol, sortedByOrder) {
            document.searchForm.action1.value = "SORT";
    
            document.searchForm.sorted_by_col.value = sortedByCol;
            document.searchForm.sorted_by_order.value = sortedByOrder;
            
            document.searchForm.submit();
        }
    </script>
</HEAD>

<body <%= bodyString %>>

<%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            <input type="hidden" name="goLabel" value="results">
            <input type="hidden" name="action1" value="SEARCH">
            <input type="hidden" name="sorted_by_col" value="<%= sorted_by_col %>" />
            <input type="hidden" name="sorted_by_order" value="<%= sorted_by_order %>" />                        
            
            <tr>
                <td class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Ιδιότητα:&nbsp;<%= atrName %><span class="menuPathTD" id="white">|</span>&nbsp;Συσχέτιση με άλλη ιδιότητα</b></td>
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
                                <td><input type="text" name="atrName" value="<%= searchatrName %>" size="50"  maxlength="100" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
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
                            <tr>
                                <td class="searchFrmTD"><input type="button" name="" value="επιστροφή" onClick='location.href="<%= urlReturn %>"' class="searchFrmBtn"   onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'"/></td>
                            </tr>                            
                            </table>
                        </td>
                        <td align="right">&nbsp;</td>
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
            <form name="relAtrForm" method="POST" action="<%= urlrelAttribute %>" />
            <input type="hidden" name="action1" value="RELATE" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            <input type="hidden" name="urlSuccess" value="<%= urlSuccess %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="SLAT_master_atrCode" value="<%= SLAT_master_atrCode %>" />
            <input type="hidden" name="SLAT_slave_atrCode" value="" />            
            
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός <% if (bean_relAttribute.isSortedBy("atrCode","ASC") == false) { %><a href="javascript:doSortResults('atrCode','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (bean_relAttribute.isSortedBy("atrCode","DESC") == false) { %><a href="javascript:doSortResults('atrCode','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>            
                <td class="resultsLabelTD">Ονομασία <% if (bean_relAttribute.isSortedBy("atrName","ASC") == false) { %><a href="javascript:doSortResults('atrName','ASC');"><img src="images/asc.gif" alt="αύξουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/asc_off.gif" alt="αύξουσα ταξινόμηση" align="top" border="0"><% } %>&nbsp;<% if (bean_relAttribute.isSortedBy("atrName","DESC") == false) { %><a href="javascript:doSortResults('atrName','DESC');"><img src="images/desc.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /></a><% } else { %><img src="images/desc_off.gif" alt="φθίνουσα ταξινόμηση" align="top" border="0" /><% } %></td>
                <td class="resultsLabelTD">&nbsp;</td>                
            </tr>
            <%
            // display
            int disp = 0;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= bean_relAttribute.getColumn("atrCode") %></td>                
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= bean_relAttribute.getColumn("atrName") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="button" name="relcmr" value="συσχέτιση" onclick='document.relAtrForm.SLAT_slave_atrCode.value="<%= bean_relAttribute.getColumn("atrCode") %>"; document.relAtrForm.submit(); void(0)' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>                    
                </tr>
            <%
                moreDataRows = bean_relAttribute.nextRow();
            }
            for (; disp < dispRows; disp++) {
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
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
                <td colspan="3"><%@ include file="include/navigationform2.jsp" %></td>
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
    
</body>
</html>