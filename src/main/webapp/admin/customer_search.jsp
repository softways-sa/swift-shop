<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,java.sql.Timestamp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="customer_search_jsp_search" scope="session" class="gr.softways.dev.eshop.customer.v2.AdminSearch" />

<%
request.setAttribute("admin.topmenu","orders");

customer_search_jsp_search.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;

customer_search_jsp_search.setSortedByCol("dateCreated");
customer_search_jsp_search.setSortedByOrder("DESC");
customer_search_jsp_search.setDispRows(dispRows);

dbRet = customer_search_jsp_search.doAction(request);

if (dbRet.getAuthError() == 1) {
    customer_search_jsp_search.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = customer_search_jsp_search.getCurrentRowCount();
totalRowCount = customer_search_jsp_search.getTotalRowCount();
totalPages = customer_search_jsp_search.getTotalPages();
currentPage = customer_search_jsp_search.getCurrentPage();

int start = customer_search_jsp_search.getStart();

String lastname = customer_search_jsp_search.getLastname(),
       email = customer_search_jsp_search.getEmail();
       
String urlSearch = response.encodeURL("customer_search.jsp"),
       urlQuerySearch = "customer_search.jsp?lastname=" + SwissKnife.hexEscape(lastname)
                      + "&email=" + SwissKnife.hexEscape(email),
       urlNew = response.encodeURL("customer_update.jsp"),
       urlExport = response.encodeURL("/servlet/admin/customer/Export"),
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
            document.searchForm.lastname.value = "";
            document.searchForm.email.value = "";
        }
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Πελάτες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Πελάτες</b></td>
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
            
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">Επίθετο <input type="text" name="lastname" value="<%= lastname %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                                <td class="searchFrmTD">Email <input type="text" name="email" value="<%= email %>" size="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD">
                                    <input type="submit" name="" value="αναζήτηση" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/> 
                                    <input type="button" name="" value="μηδενισμός" onclick='resetForm()' class="loginFrmBtn"   onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/>
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
            
            <%-- παρουσίαση { --%>
            <a name="results"></a>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="10" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Ημ/νία εγγραφής</td>
                <td class="resultsLabelTD">Τελευταία είσοδος &amp; δ/νση Η/Υ</td>
                <td class="resultsLabelTD">Ονομ/μο</td>
                <td class="resultsLabelTD">Δ/νση</td>
                <td class="resultsLabelTD">Πόλη</td>
                <td class="resultsLabelTD">Τηλέφωνο</td>
                <td class="resultsLabelTD">Εmail</td>
            </tr>
            <%
            // display
            int disp = 0;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%=SwissKnife.formatDate(customer_search_jsp_search.getTimestamp("dateCreated"), "dd/MM/yyyy HH:mm")%></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><% if (customer_search_jsp_search.getTimestamp("dateLastUsed1") != null) out.print(SwissKnife.formatDate(customer_search_jsp_search.getTimestamp("dateLastUsed1"), "dd/MM/yyyy HH:mm")); else out.print("-"); %> | <%= customer_search_jsp_search.getColumn("lastIpUsed") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("customer_update.jsp?action1=EDIT&customerId=" + customer_search_jsp_search.getHexColumn("customerId")) %>" class="resultsLink"><%= customer_search_jsp_search.getColumn("lastname") %>&nbsp;<%= customer_search_jsp_search.getColumn("firstname") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= customer_search_jsp_search.getColumn("SBAddress") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= customer_search_jsp_search.getColumn("SBCity") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= customer_search_jsp_search.getColumn("SBPhone") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="mailto:<%= customer_search_jsp_search.getColumn("email") %>" class="resultsLink"><%= customer_search_jsp_search.getColumn("email") %></a></td>
                </tr>
            <%
                moreDataRows = customer_search_jsp_search.nextRow();
            }
            
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            
            <%-- previus - next buttons { --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            <tr class="resultsFooterTR">
                <td colspan="7"><%@ include file="include/navigationform2.jsp" %></td>
            </tr>
            </form>
            <%-- } previus - next --%>
            
            <%-- } παρουσίαση --%>
            
            </table>
            
            </div>
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