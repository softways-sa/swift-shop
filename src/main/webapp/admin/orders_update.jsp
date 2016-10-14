<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,java.sql.Timestamp,gr.softways.dev.eshop.eways.v2.Order" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.orders.v2.Present" />

<%
request.setAttribute("admin.topmenu","orders");

helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

String orderId = request.getParameter("orderId") == null ? "" : request.getParameter("orderId");

String  urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/orders_search.jsp?goLabel=results"),
        urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/orders_search.jsp?action1=UPDATE_SEARCH&goLabel=results"),
        urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp");
        
dbRet = helperBean.getOrder(orderId, "catId, transId, TAVCode");

if (dbRet.getNoError() == 0 || dbRet.getRetInt() <= 0) {
    helperBean.closeResources();
    response.sendRedirect( response.encodeRedirectURL("problem.jsp") );
    return;
}

int rows = dbRet.getRetInt();

String orderStatus = helperBean.getColumn("status");

BigDecimal zero = new BigDecimal(0);

BigDecimal valueEU = zero, vatValEU = zero, netValueEU = zero,
           quantity = zero, sumQuantity = zero,
           sumValueEU = zero, sumVatValEU = zero,netSumValueEU = zero,
           shippingValueEU = zero, shippingVatValueEU = zero, netShippingValueEU = zero,
           totalValEU = zero, netTotalValEU = zero, totalVatValEU = zero;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            <tr height="40">
                <td width="30%" class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Παραγγελία</b></td>
                    </tr>
                    </table>
                </td>
                <td width="70%" align = "middle">&nbsp;</td>
            </tr>
            </table>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/Order") %>">
            
            <input type="hidden" name="action1" value="">
            <input type="hidden" name="databaseId" value="<%= databaseId %>">
            <input type="hidden" name="urlSuccess" value="">
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
            
            <input type="hidden" name="orderId" value="<%= orderId %>">
            
            <tr>
                <td class="inputFrmLabelTD">Hμ/νία</td>
                <td class="inputFrmFieldTD"><span class="text"><%= SwissKnife.formatDate(helperBean.getTimestamp("orderDate"),"dd-MM-yyyy HH:mm") %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Kωδικός</td>
                <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("orderId") %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Βοηθ. κωδικός</td>
                <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getInt("ordAA") %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προέλευση</td>
                <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("occupation") %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τρόπος πληρωμής</td>
                <%
                String payType = null;
                if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_CREDIT_CARD)) {
                    payType = "ΠΙΣΤΩΤΙΚΗ ΚΑΡΤΑ";
                }
                else if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_DEPOSIT)) {
                    payType = "ΚΑΤΑΘΕΣΗ";
                }
                else if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_ON_DELIVERY)) {
                    payType = "ΑΝΤΙΚΑΤΑΒΟΛΗ";
                }
                else if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_PAYPAL)) {
                    payType = "PayPal";
                }
                else if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_VIVA)) {
                    payType = "VIVA";
                }
                else if (helperBean.getColumn("ordPayWay").equals(Order.PAY_TYPE_CASH)) {
                    payType = "ΜΕΤΡΗΤΑ";
                }
                else payType = helperBean.getColumn("ordPayWay");
                %>
                <td class="inputFrmFieldTD"><span class="text"><%= payType %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Bank Ref</td>
                <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("ordBankTran") %></span></td>
            </tr>
            <tr>
                <td valign="top" width="50%">
                    <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                    <tr>
                        <td class="inputFrmHeader" colspan="2" align="center">Στοιχεία Χρέωσης</td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Oνομ/μο</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("firstname") %>&nbsp;<%= helperBean.getColumn("lastname") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Δ/νση</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("billingAddress") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Τ.Κ. - Πόλη</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("billingZipCode") %> <%= helperBean.getColumn("billingCity") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Χώρα</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("billingCountry") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Email</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("email") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Τηλέφωνο</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("billingPhone") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Εταιρία</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("companyName") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Α.Φ.Μ.</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("afm") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Δ.Ο.Υ.</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("doy") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Δραστηριότητα</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("profession") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Παρατηρήσεις</td>
                        <td class="inputFrmFieldTD"><%= SwissKnife.formatHTML(helperBean.getColumn("ordPrefNotes")) %></td>
                    </tr>
                    </table>
                </td>
                <td valign="top" width="50%">
                    <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                    <tr>
                        <td class="inputFrmHeader" colspan="2" align="center">Στοιχεία Αποστολής</td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Oνομ/μο</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("shippingName") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Δ/νση</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("shippingAddress") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Τ.Κ. - Πόλη</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("shippingZipCode") %> <%= helperBean.getColumn("shippingCity") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Χώρα</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("shippingCountry") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Τηλ. επικοινωνίας</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("shippingPhone") %></span></td>
                    </tr>
                    <tr>
                        <td class="inputFrmLabelTD">Τρόπος</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("ord_ShipMethodTitle") %></span></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" colspan="2">Κατάσταση
                    <select name="orderStatus" style="HEIGHT: 25px; WIDTH: 150px" width="150" height="25" class="select">
                        <option value="<%= Order.STATUS_PENDING_PAYMENT %>" <% if (orderStatus.equals(Order.STATUS_PENDING_PAYMENT)) out.print("SELECTED"); %>>Εκκρεμεί επαλήθευση πληρωμής</option>
                        <option value="<%= Order.STATUS_PENDING %>" <% if (orderStatus.equals(Order.STATUS_PENDING)) out.print("SELECTED"); %>>Εκκρεμεί</option>
                        <option value="<%= Order.STATUS_SHIPPED %>" <% if (orderStatus.equals(Order.STATUS_SHIPPED)) out.print("SELECTED"); %>>Απεστάλη</option>
                        <option value="<%= Order.STATUS_COMPLETED %>" <% if (orderStatus.equals(Order.STATUS_COMPLETED)) out.print("SELECTED"); %>>Διεκπεραιωμένη</option>
                        <option value="<%= Order.STATUS_CANCELED %>" <% if (orderStatus.equals(Order.STATUS_CANCELED)) out.print("SELECTED"); %>>Ακυρώθηκε</option>
                    </select>
                    <input type="button" value="αποθήκευση" onclick='document.inputForm.urlSuccess.value="<%= urlSuccess %>";document.inputForm.action1.value="UPDATE";document.inputForm.submit();' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="button" value="διαγραφή" onclick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit();} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="button" value="επιστροφή" onclick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" colspan="2">Πληροφορίες<br/><textarea name="ordHistDetails" cols="80" rows="5" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= helperBean.getColumn("ordHistDetails") %></textarea></td>
            </tr>
            
            </form>
            
            </table>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmHeader" colspan="8" align="center">Στοιχεία παραγγελίας</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmLabelTD">Περιγραφή</td>
                <td class="inputFrmLabelTD">Ποσότητα</td>
                <td class="inputFrmLabelTD">Ποσό</td>
            </tr>
            <%
            int transIdNext = 0;
            int transIdPrevious = -1;
           
            
            sumQuantity = helperBean.getBig("quantity").setScale(0, BigDecimal.ROUND_HALF_UP);

            netSumValueEU  = helperBean.getBig("valueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
            sumVatValEU = helperBean.getBig("vatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
            sumValueEU = netSumValueEU.add(sumVatValEU);
        
            netShippingValueEU = helperBean.getBig("shippingValueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
            shippingVatValueEU = helperBean.getBig("shippingVatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
            shippingValueEU = netShippingValueEU.add(shippingVatValueEU);
        
            totalValEU = sumValueEU.add(shippingValueEU);
            netTotalValEU = netSumValueEU.add(netShippingValueEU);
            totalVatValEU = sumVatValEU.add(shippingVatValueEU);
            
            for (int i=0; i<rows; i++) {
                transIdNext = helperBean.getInt("transId");
                
                if (transIdNext != transIdPrevious) {
                    transIdPrevious = transIdNext;
                    quantity = helperBean.getBig("quantity1");
                    quantity = quantity.setScale(0, BigDecimal.ROUND_HALF_UP);
                    
                    netValueEU = helperBean.getBig("valueEU1").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                    vatValEU = helperBean.getBig("vatValEU1").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
                    valueEU = netValueEU.add(vatValEU);
                %>
                    <tr>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("prdId") %></span></td>
                        <td class="inputFrmFieldTD">
                            <span class="text"><%= helperBean.getColumn("name") %><% if (helperBean.getColumn("transPO_Name") != null && helperBean.getColumn("transPO_Name").length()>0) {%> - <%= helperBean.getColumn("transPO_Name") %><% } %><% if ("1".equals(helperBean.getColumn("transPRD_GiftWrap"))) {%> + συσκευασία δώρου<%}%></span>
                        </td>
                        <td class="inputFrmFieldTD" align="right"><span class="text"><%= SwissKnife.formatNumber(quantity,localeLanguage,localeCountry,0,0) %></span></td>
                        <td class="inputFrmFieldTD" align="right"><span class="text">&euro;<%= SwissKnife.formatNumber(valueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></span></td>
                    </tr>
                <%
                    if (!helperBean.getColumn("TAVCode").equals("")) { %>
                        <tr>
                            <td class="inputFrmFieldTD">&nbsp;</td>
                            <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("TAVAtrName") %>-<%= helperBean.getColumn("TAVValue") %></span></td>
                            <td class="inputFrmFieldTD" align="right"><span class="text">&nbsp;</td>
                            <td class="inputFrmFieldTD" align="right"><span class="text">&nbsp;</td>
                        </tr>
                <%
                    }
                }
                else { %>
                    <tr>
                        <td class="inputFrmFieldTD">&nbsp;</td>
                        <td class="inputFrmFieldTD"><span class="text"><%= helperBean.getColumn("TAVAtrName") %>-<%= helperBean.getColumn("TAVValue") %></span></td>
                        <td class="inputFrmFieldTD" align="right"><span class="text">&nbsp;</td>
                        <td class="inputFrmFieldTD" align="right"><span class="text">&nbsp;</td>
                    </tr>
                <%
                }
                
                helperBean.nextRow();
            } %>
            <tr>
                <td class="inputFrmLabelTD" colspan="3" align="right">Μερικό Σύνολο</td>
                <td class="inputFrmFieldTD" align="right"><span class="text">&euro;<%= SwissKnife.formatNumber(sumValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" colspan="3" align="right">Έξοδα Αποστολής</td>
                <td class="inputFrmFieldTD" align="right"><span class="text">&euro;<%= SwissKnife.formatNumber(shippingValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></span></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" colspan="3" align="right">ΣΥΝΟΛΟ</td>
                <td class="inputFrmFieldTD" align="right"><span class="text">&euro;<%= SwissKnife.formatNumber(totalValEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></span></td>
            </tr>
            </table>
            
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% helperBean.closeResources(); %>

</body>
</html>