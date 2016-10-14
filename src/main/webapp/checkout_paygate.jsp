<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_paygate.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","");
    lb.put("htmlTitleLG","");
    
    lb.put("msg","Μεταφορά σε ασφαλές περιβάλλον για πληρωμή...");
    lb.put("msgLG","You are being redirected to payment web site...");
}
%>

<%
String orderID = (String)request.getAttribute(databaseId + ".checkout.orderID"),
    customerEmail = (String)request.getAttribute(databaseId + ".checkout.customerEmail"),
    ordPayWay = (String)request.getAttribute(databaseId + ".checkout.ordPayWay");

BigDecimal totalAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalAmount");

//lang = (String)request.getAttribute(databaseId + ".checkout.lang");
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
    
    <script type="text/javascript">
    $(function() {
      $('#payForm').submit();
    });
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="checkoutContainer">

    <div style="height:300px;">
        <div >
            <div style="margin:100px 0 20px 350px;"><%= lb.get("msg" + lang)%></div>
            <div style="margin:0 0 0 400px;"><img src="/images/loading_big.gif" alt=""/></div>
        </div>
    </div>
    
    <%
    if (gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_CREDIT_CARD.equals(ordPayWay)) {
        String[] values = Configuration.getValues(new String[] {"ProxyPayURL","ProxyPayMerchantID"});

        String ProxyPayURL = values[0],
            ProxyPayMerchantID = values[1];
    %>
        <form name="payForm" id="payForm" method="POST" action="<%=ProxyPayURL%>">
        <input type="hidden" name="APACScommand" value="NewPayment">
        <input type="hidden" name="merchantID" value="<%=ProxyPayMerchantID%>">
        <input type="hidden" name="amount" value="<%=totalAmount.setScale(2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100")).setScale(0, BigDecimal.ROUND_HALF_UP)%>">
        <input type="hidden" name="merchantRef" value="<%=orderID%>">
        <input type="hidden" name="currency" value="0978"> <!--0978 equals Euro-->
        <input type="hidden" name="lang" value="EN">
        <input type="hidden" name="customerEmail" value="<%=customerEmail%>">
        <input type="hidden" name="merchantDesc" value="">
        <input type="hidden" name="Var1" value="">
        <input type="hidden" name="Var2" value="">
        <input type="hidden" name="Var3" value="">
        <input type="hidden" name="Var4" value="">
        <input type="hidden" name="Var5" value="">
        <input type="hidden" name="Var6" value="">
        <input type="hidden" name="Var7" value="">
        <input type="hidden" name="Var8" value="">
        <input type="hidden" name="Var9" value="">
        <input type="hidden" name="Offset" value="0">
        <input type="hidden" name="Period" value="0">
        </form>
    <%
    } %>

</div> <!-- end: checkoutContainer -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>