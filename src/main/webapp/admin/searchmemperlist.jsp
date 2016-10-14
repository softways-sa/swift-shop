<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="agapitos_searchPerList" scope="session" class="gr.softways.dev.eshop.emaillists.members.SearchPerList" />

<%
agapitos_searchPerList.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");

JSPBean supp = new JSPBean();
supp.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

dbRet = agapitos_searchPerList.doAction(request);

if (dbRet.authError == 1) {
    agapitos_searchPerList.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

String urlSearch = response.encodeURL("searchmemperlist.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

String EMLMEmail = agapitos_searchPerList.getEMLMEmail(),
       EMLTCode = agapitos_searchPerList.getEMLTCode();

int rowCount = agapitos_searchPerList.getRowCount();

int pageCount = 0, q = 0, pageNum = 1, groupPages = 0,
    dispPages = 0, startRow = 0, rows = 0;

agapitos_searchPerList.setDispRows(dispRows);
pageNum = agapitos_searchPerList.getPageNum();
startRow = agapitos_searchPerList.getStartRow();
groupPages = agapitos_searchPerList.getGroupPages();

String[] active = new String[] {"OXI","NAI","ΑΠΕΓΓΡΑΦΗ"};
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
    function resetForm() {
        document.searchForm.EMLMEmail.value = "";
        document.searchForm.EMLTCode.selectedIndex = 0;
    }
    </script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
	<td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μέλη ανα λίστα</b></td>
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
                                <td class="searchFrmTD" align="right">Λίστα</td>
                                <td>
                                    <select name="EMLTCode" class="inputFrmField">
                                    <%
                                    int rowsC = supp.getTable("emailListTab", "EMLTName");
                    
                                    for (int i = 0; i < rowsC; i++) { %>
                                        <option value="<%= supp.getColumn("EMLTCode") %>" <% if (supp.getColumn("EMLTCode").equals(EMLTCode)) out.print("SELECTED"); %>><%= supp.getColumn("EMLTName") %></option>
                                    <%
                                        supp.nextRow();
                                    }
                                    supp.closeResources();
                                    %>
                                    </select>
                                </td>
                                <td class="searchFrmTD" align="right">E-mail</td>
                                <td><input type="text" name="EMLMEmail" value="<%= EMLMEmail %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
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
                <td class="resultsLabelTD">Σύνταξη e-mail</td>
                <td class="resultsLabelTD">Ονομ/μο</td>
                <td class="resultsLabelTD">Ενεργός</td>
            </tr>
            <%
            int disp = 0;
            
            DbRet valEMail = null;
            String validation = null, valColor = null;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
            
                valEMail = gr.softways.dev.util.SendMail.validateEMail( agapitos_searchPerList.getColumn("EMLMEmail") );
                if (valEMail.getNoError() == 1) {
                    validation = "ΣΩΣΤH";
                }
                else {
                    validation = "ΛΑΝΘΑΣΜΕΝΗ";
                }
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processemailmember.jsp?urlCallReturn=searchmemperlist.jsp&action1=EDIT&EMLMCode=" + agapitos_searchPerList.getHexColumn("EMLMCode")) %>" class="resultsLink"><%= agapitos_searchPerList.getColumn("EMLMEmail") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= validation %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= agapitos_searchPerList.getColumn("EMLMFirstName") %> <%= agapitos_searchPerList.getColumn("EMLMLastName") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= active[Integer.parseInt(agapitos_searchPerList.getColumn("EMLMActive"))] %></td>
                </tr>
            <%
                moreDataRows = agapitos_searchPerList.nextRow();
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