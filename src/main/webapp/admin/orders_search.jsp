<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,java.sql.Timestamp,gr.softways.dev.eshop.eways.v2.Order" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="orders_search_jsp_search" scope="session" class="gr.softways.dev.eshop.orders.v2.AdminSearch" />

<%
request.setAttribute("admin.topmenu","orders");

orders_search_jsp_search.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;

orders_search_jsp_search.setDispRows(dispRows);

dbRet = orders_search_jsp_search.doAction(request);

if (dbRet.getAuthError() == 1) {
    orders_search_jsp_search.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = orders_search_jsp_search.getCurrentRowCount();
totalRowCount = orders_search_jsp_search.getTotalRowCount();
totalPages = orders_search_jsp_search.getTotalPages();
currentPage = orders_search_jsp_search.getCurrentPage();

int start = orders_search_jsp_search.getStart();


String urlSearch = response.encodeURL("orders_search.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"),
       urlExportEXCEL = response.encodeURL("/servlet/admin/orders/Export");

String[] orderStatus = orders_search_jsp_search.getOrderStatus();
String email = orders_search_jsp_search.getEmail(),
       orderId = orders_search_jsp_search.getOrderId(),
       orderDateDayApo = orders_search_jsp_search.getOrderDateDayApo(),
       orderDateMonthApo = orders_search_jsp_search.getOrderDateMonthApo(),
       orderDateYearApo = orders_search_jsp_search.getOrderDateYearApo(),
       orderDateDayEos = orders_search_jsp_search.getOrderDateDayEos(),
       orderDateMonthEos = orders_search_jsp_search.getOrderDateMonthEos(),
       orderDateYearEos = orders_search_jsp_search.getOrderDateYearEos();

String urlQuerySearch = "orders_search.jsp?orderId=" + SwissKnife.hexEscape(orderId)
                      + "&email=" + SwissKnife.hexEscape(email)
                      + "&orderDateDayApo=" + SwissKnife.hexEscape(orderDateDayApo)
                      + "&orderDateMonthApo=" + SwissKnife.hexEscape(orderDateMonthApo)
                      + "&orderDateYearApo=" + SwissKnife.hexEscape(orderDateYearApo)
                      + "&orderDateDayEos=" + SwissKnife.hexEscape(orderDateDayEos)
                      + "&orderDateMonthEos=" + SwissKnife.hexEscape(orderDateMonthEos)
                      + "&orderDateYearEos=" + SwissKnife.hexEscape(orderDateYearEos);
int index = 0;
while (orderStatus != null && index<orderStatus.length) {
    urlQuerySearch += "&orderStatus=" + SwissKnife.hexEscape(orderStatus[index]);
    index++;
}

String orderDateDayApo2 = SwissKnife.getTDateStr(SwissKnife.currentDate(),"DAY"),
       orderDateMonthApo2 = SwissKnife.getTDateStr(SwissKnife.currentDate(),"MONTH"),
       orderDateYearApo2 = SwissKnife.getTDateStr(SwissKnife.currentDate(),"YEAR");

int rows = 0;

String[] months = new String[] {"","Ιαν","Φεβ","Μαρ","Απρ","Μάϊ","Ιουν","Ιουλ","Αυγ","Σεπ","Οκτ","Νοε","Δεκ"};

int currYear = SwissKnife.getTDateInt(SwissKnife.currentDate(), "YEAR");

BigDecimal zero = new BigDecimal("0");

BigDecimal valueEU = zero, vatValEU = zero,
           shippingValueEU = zero, shippingVatValueEU = zero,
           quantity = zero;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    <script language="JavaScript" src="js/date.js"></script>
    
    <script language="JavaScript">
        function submitDaily() {
            resetForm();

            document.searchForm.orderDateDayApo.value = "<%= orderDateDayApo2 %>";
            document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].value = "<%= orderDateMonthApo2 %>";
            document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].value = "<%= orderDateYearApo2 %>";
        }

        function resetForm() {
            for (i = 0; i < document.searchForm.orderStatus.length; i++) {
                document.searchForm.orderStatus[i].checked = false;
            }
            
            document.searchForm.orderId.value = "";

            document.searchForm.email.value = "";
            
            document.searchForm.orderDateDayApo.value = "";
            
            document.searchForm.orderDateMonthApo.selectedIndex = 0;
            if (document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].value != "") {
                document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].value = "";
                document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].text = "ΜΗΝΑΣ";
            }
            document.searchForm.orderDateYearApo.selectedIndex = 0;
            if (document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].value != "") {
                document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].value = "";
                document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].text = "ΕΤΟΣ";
            }

            document.searchForm.orderDateDayEos.value = "";
            
            document.searchForm.orderDateMonthEos.selectedIndex = 0;
            if (document.searchForm.orderDateMonthEos.options[document.searchForm.orderDateMonthEos.selectedIndex].value != "") {
                document.searchForm.orderDateMonthEos.options[document.searchForm.orderDateMonthEos.selectedIndex].value = "";
                document.searchForm.orderDateMonthEos.options[document.searchForm.orderDateMonthEos.selectedIndex].text = "ΜΗΝΑΣ";
            }
            document.searchForm.orderDateYearEos.selectedIndex = 0;
            if (document.searchForm.orderDateYearEos.options[document.searchForm.orderDateYearEos.selectedIndex].value != "") {
                document.searchForm.orderDateYearEos.options[document.searchForm.orderDateYearEos.selectedIndex].value = "";
                document.searchForm.orderDateYearEos.options[document.searchForm.orderDateYearEos.selectedIndex].text = "ΕΤΟΣ";
            }
        }

        var downYear = <%= currYear - yearDnLimit %>;
        var upYear = <%= currYear + yearUpLimit %>;
		
        function showNewDate(d, m, y) {
                var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
                var weekDay = Math.floor(((dayFirst + d -1) % 7));
                if (m >= 1 && m <= 12)	{
                    document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].value = m;
            document.searchForm.orderDateMonthApo.options[document.searchForm.orderDateMonthApo.selectedIndex].text = monthName[m-1];
                }
                document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].value = y;
                document.searchForm.orderDateYearApo.options[document.searchForm.orderDateYearApo.selectedIndex].text = y;
                document.searchForm.orderDateDayApo.value = d;
        }
		
        function showNewDate1(d, m, y) {
            var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
            var weekDay = Math.floor(((dayFirst + d -1) % 7));
            if (m >= 1 && m <= 12)	{
                document.searchForm.orderDateMonthEos.options[document.searchForm.orderDateMonthEos.selectedIndex].value = m;
                document.searchForm.orderDateMonthEos.options[document.searchForm.orderDateMonthEos.selectedIndex].text = monthName[m-1];
            }
            document.searchForm.orderDateYearEos.options[document.searchForm.orderDateYearEos.selectedIndex].value = y;
            document.searchForm.orderDateYearEos.options[document.searchForm.orderDateYearEos.selectedIndex].text = y;
            document.searchForm.orderDateDayEos.value = d;
        }
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <div align="center">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%=urlSearch%>">
              
            <input type="hidden" name="databaseId" value="<%=databaseId%>" />
            <input type="hidden" name="action1" value="" />
            
            <tr>
                <td class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Παραγγελίες</b></td>
                    </tr>
                    </table>
                </td>
                
                <td>
                    <table width="0" border="0" cellspacing="8" cellpadding="0">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="right">Από (περιλαμβάνεται)</td>
                                <td class="searchCalendarTD">
                                
                                    <table width="0" border="0" cellspacing="1" cellpadding="0">
                                    <tr>
                                        <td><input type="text" name="orderDateDayApo" size="2" VALUE="<%= orderDateDayApo %>" MAXLENGTH="2" class="searchFrmInput" onblur="valInt('searchForm', 'orderDateDayApo', 0, 1, 31); this.className='searchFrmInput'" onfocus="this.className='searchFrmInputFocus'" /></td>
                                        <td>
                                            <select name="orderDateMonthApo" class="searchCalendarSelect">
                                                <option value="">ΜΗΝΑΣ</option>
                                                <% 
                                                for (int i=1; i<=12; i++) { %>
                                                    <option value="<%= i %>" <% if (orderDateMonthApo.equals( String.valueOf(i) )) out.print("SELECTED"); %> ><%= months[i] %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="orderDateYearApo" class="searchCalendarSelect">
                                                <option value="">ETOΣ</option>
                                                <%
                                                for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                                    <option value="<%= i %>" <% if (orderDateYearApo.equals ( String.valueOf(i) )) out.print("SELECTED"); %> ><%= i %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                                <td class="searchFrmTD" align="right">Κωδικός</td>
                                <td><input type="text" name="orderId" value="<%= orderId %>" size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD" align="right">Έως (δεν περιλαμβάνεται)</td>
                                <td  class="searchCalendarTD">
                                    <table width="0" border="0" cellspacing="1" cellpadding="0">                                                                
                                    <tr>
                                        <td><input type="text" name="orderDateDayEos" size="2" VALUE="<%= orderDateDayEos %>" MAXLENGTH="2" class="searchFrmInput" onblur="valInt('searchForm', 'orderDateDayEos', 0, 1, 31); this.className='searchFrmInput'" onfocus="this.className='searchFrmInputFocus'" /></td>
                                        <td>
                                            <select name="orderDateMonthEos" class="searchCalendarSelect">
                                                <option value="">ΜΗΝΑΣ</option>
                                                <%
                                                for (int i=1; i<=12; i++) { %>
                                                    <option value="<%= i %>" <% if (orderDateMonthEos.equals( String.valueOf(i) )) out.print("SELECTED"); %> ><%= months[i] %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                        <td>
                                            <select name="orderDateYearEos" class="searchCalendarSelect">
                                                <option value="">ETOΣ</option>
                                                <%
                                                for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                                    <option value="<%= i %>" <% if (orderDateYearEos.equals ( String.valueOf(i) )) out.print("SELECTED"); %> ><%= i %></option>
                                                <% } %>
                                            </select>
                                        </td>
                                    </tr>
                                    </table>
                                </td>
                                <td class="searchFrmTD" align="right">Email</td>
                                <td><input type="text" name="email" value="<%= email %>" size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>                        
                            </tr>
                            <tr>
                                <td class="searchFrmTD" align="right">Κατάσταση</td>
                                <td class="searchFrmInput" colspan="3">
                                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                                    <tr>
                                        <td class="searchFrmTD">Εκκρεμεί</td>
                                        <td class="searchFrmTD">&nbsp;<input type="checkbox" name="orderStatus" value="<%= Order.STATUS_PENDING %>" <% if (orders_search_jsp_search.hasOrderStatus(Order.STATUS_PENDING)) out.print(" checked "); %> size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                        <td class="searchFrmTD">&nbsp;&nbsp;</td>
                                        <td class="searchFrmTD">Απεστάλη</td>
                                        <td class="searchFrmTD">&nbsp;<input type="checkbox" name="orderStatus" value="<%= Order.STATUS_SHIPPED %>" <% if (orders_search_jsp_search.hasOrderStatus(Order.STATUS_SHIPPED)) out.print(" checked "); %> size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                        <td class="searchFrmTD">&nbsp;&nbsp;</td>
                                        <td class="searchFrmTD">Εκκρεμεί επαλήθευση πληρωμής</td>
                                        <td class="searchFrmTD">&nbsp;<input type="checkbox" name="orderStatus" value="<%= Order.STATUS_PENDING_PAYMENT %>" <% if (orders_search_jsp_search.hasOrderStatus(Order.STATUS_PENDING_PAYMENT)) out.print(" checked "); %> size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                    </tr>
                                    <tr>
                                        <td class="searchFrmTD">Διεκπεραιωμένη</td>
                                        <td class="searchFrmTD">&nbsp;<input type="checkbox" name="orderStatus" value="<%= Order.STATUS_COMPLETED %>" <% if (orders_search_jsp_search.hasOrderStatus(Order.STATUS_COMPLETED)) out.print(" checked "); %> size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                        <td class="searchFrmTD">&nbsp;&nbsp;</td>
                                        <td class="searchFrmTD">Ακυρώθηκε</td>
                                        <td class="searchFrmTD">&nbsp;<input type="checkbox" name="orderStatus" value="<%= Order.STATUS_CANCELED %>" <% if (orders_search_jsp_search.hasOrderStatus(Order.STATUS_CANCELED)) out.print(" checked "); %> size="25" class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                        <td class="searchFrmTD" colspan="3">&nbsp;</td>
                                    </tr>
                                    </table>
                                </td>
                            </tr>
                            </table>
                        </td>
                        <td>
                            <table width="0" border="0" cellspacing="2" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD"><input type="button" name="daily" value="παραγγελίες της ημέρας" onclick='document.searchForm.action1.value="SEARCH"; submitDaily(); document.searchForm.submit()' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD"><input type="submit" name="" value="αναζήτηση" onclick='document.searchForm.action="<%=urlSearch%>"; document.searchForm.action1.value="SEARCH"; document.searchForm.submit()' class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD"><input type="button" name="" value="εξαγωγή σε EXCEL" onclick='document.searchForm.action="<%=urlExportEXCEL%>"; document.searchForm.action1.value="EXCEL"; document.searchForm.submit()' class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /></td>
                            </tr>
                            <tr>
                                <td class="searchFrmTD"><input type="button" name="" value="μηδενισμός" onclick="resetForm()" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
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
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Ημ/νία παραγγελίας</td>
                <td class="resultsLabelTD">Βοηθ. κωδικός</td>
                <td class="resultsLabelTD">Κατάσταση</td>
                <td class="resultsLabelTD">Πληρωμή</td>
                <td class="resultsLabelTD">Oνομ/μο</td>
                <td class="resultsLabelTD">Εmail</td>
                <td class="resultsLabelTD">Μερικό Σύνολο</td>
            </tr>
            <%
            int disp = 0;
            
            String status = null, payType = null;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
                quantity = orders_search_jsp_search.getBig("quantity");

                vatValEU = orders_search_jsp_search.getBig("vatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                valueEU = orders_search_jsp_search.getBig("valueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                valueEU = valueEU.add(vatValEU);
    
                shippingValueEU = orders_search_jsp_search.getBig("shippingValueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                shippingVatValueEU = orders_search_jsp_search.getBig("shippingVatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                shippingValueEU = shippingValueEU.add(shippingVatValueEU);
    
                status = orders_search_jsp_search.getColumn("status");
                if (status.equals(Order.STATUS_PENDING)) status = "Εκκρεμεί";
                else if (status.equals(Order.STATUS_SHIPPED)) status = "Απεστάλη";
                else if (status.equals(Order.STATUS_COMPLETED)) status = "Διεκπεραιωμένη";
                else if (status.equals(Order.STATUS_CANCELED)) status = "Ακυρώθηκε";
                else if (status.equals(Order.STATUS_PENDING_PAYMENT)) status = "Εκκρεμεί επαλήθευση πληρωμής";
                
                payType = orders_search_jsp_search.getColumn("ordPayWay");
                if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_CREDIT_CARD)) {
                    payType = "ΠΙΣΤΩΤΙΚΗ ΚΑΡΤΑ";
                }
                else if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_DEPOSIT)) {
                    payType = "ΚΑΤΑΘΕΣΗ";
                }
                else if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_ON_DELIVERY)) {
                    payType = "ΑΝΤΙΚΑΤΑΒΟΛΗ";
                }
                else if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_PAYPAL)) {
                    payType = "PayPal";
                }
                else if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_VIVA)) {
                    payType = "VIVA";
                }
                else if (orders_search_jsp_search.getColumn("ordPayWay").equals(Order.PAY_TYPE_CASH)) {
                    payType = "ΜΕΤΡΗΤΑ";
                }
                else payType = orders_search_jsp_search.getColumn("ordPayWay");
                
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= SwissKnife.formatDate(orders_search_jsp_search.getTimestamp("orderDate"),"dd-MM-yyyy HH:mm") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= orders_search_jsp_search.getInt("ordAA") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("orders_update.jsp?orderId=" + orders_search_jsp_search.getHexColumn("orderId")) %>" class="resultsLink"><%= status %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("orders_update.jsp?orderId=" + orders_search_jsp_search.getHexColumn("orderId")) %>" class="resultsLink"><%= payType %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= orders_search_jsp_search.getColumn("lastname") %>&nbsp;<%= orders_search_jsp_search.getColumn("firstname") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="mailto:<%= orders_search_jsp_search.getColumn("email") %>" class="resultsLink"><%= orders_search_jsp_search.getColumn("email") %></a></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'" align="right">&euro;<%= SwissKnife.formatNumber(valueEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
                </tr>
            <%
                moreDataRows = orders_search_jsp_search.nextRow();
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
            <%
            }
            %>
            <%-- / παρουσίαση προϊόντων --%>
    
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            
            <tr class="resultsFooterTR">
                <td colspan="7"><%@ include file="include/navigationform2.jsp" %></td>
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