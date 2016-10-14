<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="agapitos_searchEmailMembers" scope="session" class="gr.softways.dev.eshop.emaillists.members.Search" />

<%
agapitos_searchEmailMembers.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");

DbRet dbRet = null;

dbRet = agapitos_searchEmailMembers.doAction(request);

if (dbRet.getAuthError() == 1) {
    agapitos_searchEmailMembers.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

String urlSearch = response.encodeURL("searchemailmembers.jsp"),
       urlNew = response.encodeURL("processemailmember.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

String EMLMEmail = agapitos_searchEmailMembers.getEMLMEmail(),
       EMLMLastName = agapitos_searchEmailMembers.getEMLMLastName();

int rowCount = agapitos_searchEmailMembers.getRowCount();

int pageCount = 0, q = 0, pageNum = 1, groupPages = 0,
    dispPages = 0, startRow = 0, rows = 0;

agapitos_searchEmailMembers.setDispRows(dispRows);
pageNum = agapitos_searchEmailMembers.getPageNum();
startRow = agapitos_searchEmailMembers.getStartRow();
groupPages = agapitos_searchEmailMembers.getGroupPages();

String[] active = new String[] {"OXI","NAI","ΑΠΕΓΓΡΑΦΗ"};
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function resetForm() {
            document.searchForm.EMLMEmail.value = "";
            document.searchForm.EMLMLastName.value = "";
        }
    </script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
	<td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μέλη</b></td>
	<td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border="0" alt="Προσθήκη νέας εγγραφής" /></a></td>
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
        
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">Email <input type="text" name="EMLMEmail" value="<%= EMLMEmail %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />&nbsp;&nbsp;Επίθετο <input type="text" name="EMLMLastName" value="<%= EMLMLastName %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
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
            // see if there are rows to display
            boolean moreDataRows = true;
            
            if (rowCount > 0) {
                // determine the number of pages
                if (rowCount > dispRows) {
                    pageCount = (rowCount / dispRows);
                    if ( (rowCount % dispRows) > 0 ) { pageCount++; }
                }
                else { pageCount = 1; }
            }
            else { moreDataRows = false; }
            %>

            <%-- παρουσίαση --%>
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">E-mail</td>
                <td class="resultsLabelTD">Σύνταξη email</td>
                <td class="resultsLabelTD">Ονομ/μο</td>
                <td class="resultsLabelTD">Ενεργός</td>
            </tr>
            <%
            int disp = 0;
            
            DbRet valEMail = null;
            String validation = null, valColor = null;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            
                valEMail = gr.softways.dev.util.SendMail.validateEMail( agapitos_searchEmailMembers.getColumn("EMLMEmail") );
                if (valEMail.getNoError() == 1) {
                    validation = "ΣΩΣΤH";
                }
                else {
                    validation = "ΛΑΝΘΑΣΜΕΝΗ";
                }
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processemailmember.jsp?action1=EDIT&EMLMCode=" + agapitos_searchEmailMembers.getHexColumn("EMLMCode")) %>" class="resultsLink"><%= agapitos_searchEmailMembers.getColumn("EMLMEmail") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processemailmember.jsp?action1=EDIT&EMLMCode=" + agapitos_searchEmailMembers.getHexColumn("EMLMCode")) %>" class="resultsLink"><%= validation %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= agapitos_searchEmailMembers.getColumn("EMLMFirstName") %> <%= agapitos_searchEmailMembers.getColumn("EMLMLastName") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= active[Integer.parseInt(agapitos_searchEmailMembers.getColumn("EMLMActive"))] %></td>
                </tr>
            <%
                moreDataRows = agapitos_searchEmailMembers.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="4"><%@ include file="include/navigationform.jsp" %></td>
            </tr>
            </form>
            
            </table>
            <%-- / παρουσίαση --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>