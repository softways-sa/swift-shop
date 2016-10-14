<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_paygate_viva.jsp"; %>

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
DbRet dbRet = null;

//String createOrderURL = "https://www.vivapayments.com/api/orders", redirectURL = "https://www.vivapayments.com/web/checkout";
String createOrderURL = "http://demo.vivapayments.com/api/orders", redirectURL = "http://demo.vivapayments.com/web/checkout";

String orderID = (String)request.getAttribute(databaseId + ".checkout.orderID");

BigDecimal totalAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalAmount");

String[] values = Configuration.getValues(new String[] {"VIVA-MerchantID","VIVA-APIKey"});

String merchantID = values[0], APIKey = values[1];

gr.softways.dev.eshop.viva.VIVA viva = new gr.softways.dev.eshop.viva.VIVA();
viva.setDebug(false);
viva.setDisableCash(true);
viva.setMerchantID(merchantID);
viva.setAPIKey(APIKey);
viva.setAmount(totalAmount);
viva.setUrl(createOrderURL);
viva.setMerchantTrns(orderID);
viva.setPaymentTimeOut(600);

if ("".equals(lang)) viva.setRequestLang("el-GR");
else viva.setRequestLang("en-US");

dbRet = viva.createOrder();

String orderCode = "";

if (dbRet.getNoError() == 1) {
  orderCode = viva.getOrderCode();
  // update order with orderCode
  Transaction.updateBank(orderID, orderCode, gr.softways.dev.eshop.eways.v2.Order.STATUS_PENDING_PAYMENT);
}
else {
  response.sendRedirect(response.encodeRedirectURL("/problem.jsp"));
  return;
}
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
      <div>
        <div style="margin:100px 0 20px 350px;"><%=lb.get("msg" + lang)%></div>
        <div style="margin:0 0 0 400px;"><img src="/images/loading_big.gif" alt=""/></div>
      </div>
    </div>
    
    <form name="payForm" id="payForm" method="GET" action="<%=redirectURL%>">
    <input type="hidden" name="ref" value="<%=orderCode%>"/>
    </form>

</div> <!-- end: checkoutContainer -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>