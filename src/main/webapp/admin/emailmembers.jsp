<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="soft_searchEmailMembers" scope="session" class="gr.softways.dev.eshop.emaillists.members.Search" />

<%
soft_searchEmailMembers.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

String urlSearch = response.encodeURL("emailmembers.jsp"),
       urlNew = response.encodeURL("processlistmember.jsp?action1=NEW");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

dbRet = soft_searchEmailMembers.doAction(request);

String EMLMEmail = soft_searchEmailMembers.getEMLMEmail(),
       EMLMLastName = soft_searchEmailMembers.getEMLMLastName();
	   
int rowCount = soft_searchEmailMembers.getRowCount();

if (dbRet.authError == 1) {
    soft_searchEmailMembers.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
}

int pageCount = 0, q = 0, pageNum = 1, 
    groupPages = 0, dispPages = 0, startRow = 0, rows = 0;
	
soft_searchEmailMembers.setDispRows(dispRows);
pageNum = soft_searchEmailMembers.getPageNum();
startRow = soft_searchEmailMembers.getStartRow();
groupPages = soft_searchEmailMembers.getGroupPages();

String[] active = new String[] {"OXI","NAI","ΑΠΕΓΓΡΑΦΗ"};
%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE></TITLE>

    <script language="JavaScript">
        function doReset(form) {
            form.EMLMEmail.value="";
            form.EMLMLastName.value="";
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
                        <td class="menuPathTD" align="middle"><b>Ταχυδρομικές Λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μέλη</b></td>
                    </tr>
                    </table>
                </td>
                <td>
                    <table width="0" border="0" cellspacing="4" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="right">Email</td>
                                <td><input type="text" name="EMLMEmail" value="<%= EMLMEmail %>" size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                <td class="searchFrmTD" align="right">Επίθετο</td>
                                <td><input type="text" name="EMLMLastName" value="<%= EMLMLastName %>" size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>                                
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
                <td class="resultsLabelTD">Email</td>
                <td class="resultsLabelTD">Σύνταξη email</td>
                <td class="resultsLabelTD">Ονομ/μο</td>
                <td class="resultsLabelTD">Ενεργός</td>
            </tr>
            <%
            int disp = 0;
            
            DbRet valEMail = null;
            String validation = null, valColor = null;
        
            // display
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
                valEMail = gr.softways.dev.util.SendMail.validateEMail( soft_searchEmailMembers.getColumn("EMLMEmail") );
                if (valEMail.getNoError() == 1) {
                    validation = "ΣΩΣΤH";
                    valColor = "black";
                }
                else {
                    validation = "ΛΑΝΘΑΣΜΕΝΗ";
                    valColor = "red";
                }
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL( "processlistmember.jsp?action1=EDIT&EMLMCode=" + soft_searchEmailMembers.getHexColumn("EMLMCode")) %>" class="resultsLink"><%= soft_searchEmailMembers.getColumn("EMLMEmail") %></a></td>
                    <td align="right" class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= validation %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;<%= soft_searchEmailMembers.getColumn("EMLMFirstName") %> <%= soft_searchEmailMembers.getColumn("EMLMLastName") %></td>
                    <td align="right" class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= active[Integer.parseInt(soft_searchEmailMembers.getColumn("EMLMActive"))] %></td>
                </tr>
            <%
                    moreDataRows = soft_searchEmailMembers.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
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
                <td colspan="4"><%@ include file="include/navigationform.jsp" %></td>
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
