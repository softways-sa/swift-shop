<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="soft_searchEmailLists" scope="session" class="gr.softways.dev.eshop.emaillists.lists.Search" />

<%
soft_searchEmailLists.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

String urlSearch = response.encodeURL("emaillists.jsp"),
       urlNew = response.encodeURL("processemaillist.jsp?action1=NEW");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

dbRet = soft_searchEmailLists.doAction(request);

String emailListName = soft_searchEmailLists.getEmailListName();
	   
int rowCount = soft_searchEmailLists.getRowCount();

if (dbRet.authError == 1) {
    soft_searchEmailLists.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
}

int pageCount = 0, q = 0, pageNum = 1, 
    groupPages = 0, dispPages = 0, startRow = 0, rows = 0;
	
soft_searchEmailLists.setDispRows(dispRows);
pageNum = soft_searchEmailLists.getPageNum();
startRow = soft_searchEmailLists.getStartRow();
groupPages = soft_searchEmailLists.getGroupPages();
%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE></TITLE>

    <script language="JavaScript">
        function doReset(form) {
            form.emailListName.value="";
	}
    </script>

    <script type="text/javascript" language="javascript" src="js/jsfunctions.js" charset="UTF-8"></script>
</HEAD>

<body <%= bodyString %>>

<%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            
            <input type="hidden" name="action1" value="SEARCH" />
            
            <tr>
                <td class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Ταχυδρομικές Λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Εγγραφές</b></td>
                    </tr>
                    </table>
                </td>
                <td>
                    <table width="0" border="0" cellspacing="4" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="right">Όνομα λίστας</td>
                                <td><input type="text" name="emailListName" value="<%= emailListName %>" size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>                                
                            </tr>
                            </table>
                        </td>
                    </tr>
                    </table>
                </td>
                <td valign="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="searchFrmTD"><input type="submit" name="" value="αναζήτηση" class="searchFrmBtn"  onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'"/></td>
                    </tr>
                    <tr>
                        <td class="searchFrmTD"><input type="button" name="" value="μηδενισμός" onclick="doReset(document.searchForm)" class="searchFrmBtn"   onmouseover="this.className='searchFrmBtnOver'" onmouseout="this.className='searchFrmBtn'"/></td>
                    </tr>
                    </table>
                </td>
                <td align="right" valign="middle">
                    <table width="0" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border ="0" alt="Προσθήκη νέας εγγραφής"></a></td>
                        <td>&nbsp;</td>
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
                else pageCount = 1;
            }
            else moreDataRows = false;
            %>
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Όνομα</td>
                <td class="resultsLabelTD">Περιγραφή</td>
                <td class="resultsLabelTD">Εμφάνιση Παραλήπτη</td>
            </tr>
            <%
            int disp = 0;
            
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            %>
                    <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL( "processemaillist.jsp?action1=EDIT&emailListCode=" + soft_searchEmailLists.getHexColumn("EMLTCode")) %>" class="resultsLink"><%= soft_searchEmailLists.getColumn("EMLTName") %></a></td>
                        <td align="right" class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= soft_searchEmailLists.getColumn("EMLTDescr") %></td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= soft_searchEmailLists.getColumn("EMLTTo") %></td>
                    </tr>
            <%
                    moreDataRows = soft_searchEmailLists.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <%
            } %>
            <%-- / παρουσίαση --%>
        
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            
            <tr class="resultsFooterTR">
                <td colspan="3"><%@ include file="include/navigationform.jsp" %></td>
            </tr>
            
            </form>
            <%-- / previus - next --%>
            
            </table>
            
        </td>
    
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>
