<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_order_history.jsp"; %>

<%@ include file="/include/customer_auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Ιστορικό Αγορών");
    lb.put("htmlTitleLG","Order's History");
    
    lb.put("orderHistory","Ιστορικό Αγορών");
    lb.put("orderHistoryLG","Order's History");

    lb.put("noOrders","Δεν υπάρχουν αγορές στο λογαριασμό σας.");
    lb.put("noOrdersLG","You have no orders.");
    
    lb.put("orderId","Κωδικός παραγγελίας");
    lb.put("orderIdLG","Order ID");
    
    lb.put("orderDate","Ημ/νία παραγγελίας");
    lb.put("orderDateLG","Order date");
    
    lb.put("status","Κατάσταση");
    lb.put("statusLG","Status");
    
    lb.put("amount","Ποσό χρέωσης (με ΦΠΑ)");
    lb.put("amountLG","Amount (VAT inc.)");
    
    lb.put("Pending","Εκκρεμεί");
    lb.put("PendingLG","Pending");
    lb.put("Pending deposit","Εκκρεμεί κατάθεση");
    lb.put("Pending depositLG","Pending deposit");
    lb.put("Shipped","Απεστάλη");
    lb.put("ShippedLG","Shipped");
    lb.put("Completed","Ολοκληρώθηκε");
    lb.put("CompletedLG","Completed");
    lb.put("Canceled","Ακυρώθηκε");
    lb.put("CanceledLG","Canceled");
    lb.put("pendingPayment","Εκκρεμεί επαλήθευση πληρωμής");
    lb.put("pendingPaymentLG","Pending payment verification");
    
    lb.put("tipMsg","Από εδώ μπορείτε να παρακουλουθήσετε την κατάσταση των παραγγελιών σας αλλά και το ιστορικό των αγορών σας. Για περισσότερες πληροφορίες πατήστε στον κωδικό κάθε παραγγελίας.");
    lb.put("tipMsgLG","From here you can track your order status and view your purchases history. For more information about your orders click on the order ID.");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);

int rows = 0;

BigDecimal zero = new BigDecimal("0");

BigDecimal valueEU = zero, vatValEU = zero, shippingValueEU = zero, shippingVatValueEU = zero, quantity = zero;
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
</head>

<body>

<div id="siteContainer">
<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<%@ include file="/include/customer_myaccount_options.jsp" %>

<div class="sectionHeader"><%= lb.get("orderHistory" + lang) %></h2></div>

<%
rows = helperBean.getTablePK("orders","customerId",customer.getCustomerId(),"orderDate DESC");

if (rows > 0) { %>
    <table width="100%" cellpadding="2" cellspacing="1" border="0">
    
    <thead>
    <tr>
        <td ><b><%= lb.get("orderId" + lang) %></b></td>
        <td ><b><%= lb.get("orderDate" + lang) %></b></td>
        <td ><b><%= lb.get("status" + lang) %></b></td>
        <td align="right"><b><%= lb.get("amount" + lang) %></b></td>
    </tr>
    </thead>
    
<%
    for (int i=0; i<rows; i++) {
        vatValEU = helperBean.getBig("vatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        valueEU = helperBean.getBig("valueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        valueEU = valueEU.add(vatValEU);
        
        shippingValueEU = helperBean.getBig("shippingValueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        shippingVatValueEU = helperBean.getBig("shippingVatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        shippingValueEU = shippingValueEU.add(shippingVatValueEU);
        
        BigDecimal totalValueEU = valueEU.add(shippingValueEU).setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP);
        
        String status = helperBean.getColumn("status");
        if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_PENDING)) status = lb.get("Pending" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_HANDLING)) status = lb.get("Pending" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_PENDING_DEPOSIT)) status = lb.get("Pending deposit" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_SHIPPED)) status = lb.get("Shipped" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_COMPLETED)) status = lb.get("Completed" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_CANCELED)) status = lb.get("Canceled" + lang).toString();
        else if (status.equals(gr.softways.dev.eshop.eways.v2.Order.STATUS_PENDING_PAYMENT)) status = lb.get("pendingPayment" + lang).toString();
%>
        <tr>
            <td align="left"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_order_details.jsp?extLang=" + lang + "&orderId=" + helperBean.getHexColumn("orderId")) %>" style="text-decoration:underline;"><%= helperBean.getColumn("orderId") %></a></td>
            <td class="text"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_order_details.jsp?extLang=" + lang + "&orderId=" + helperBean.getHexColumn("orderId"))%>"><%= SwissKnife.formatDate(helperBean.getTimestamp("orderDate"), "dd/MM/yyyy")%></a></td>
            <td class="text"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_order_details.jsp?extLang=" + lang + "&orderId=" + helperBean.getHexColumn("orderId"))%>"><%= status%></a></td>
            <td class="text" align="right">&euro;<%= SwissKnife.formatNumber(totalValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
        </tr>
<%
        helperBean.nextRow();
    }
%>
    </table>
<% }
else { %>
    <span class="text"><%= lb.get("noOrders" + lang) %></span>
<% } %>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

<% helperBean.closeResources(); %>

</body>
</html>