<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="org.apache.commons.codec.binary.Base64" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_paygate_cardlink.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Ανακατεύθυνση");
  lb.put("htmlTitleLG","Redirect");
  lb.put("msg","Μεταφορά σε ασφαλές περιβάλλον για πληρωμή...");
  lb.put("msgLG","You are being redirected to payment web site...");
}
%>

<%
String orderID = (String)request.getAttribute(databaseId + ".checkout.orderID"),
    customerEmail = (String)request.getAttribute(databaseId + ".checkout.customerEmail"),
    ordPayWay = (String)request.getAttribute(databaseId + ".checkout.ordPayWay"),
    installments = (String)request.getAttribute(databaseId + ".checkout.installments");

if ("0".equals(installments)) installments = "";

String installmentsOffset = installments.length() > 0 ? "0" : "";

BigDecimal totalAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalAmount");

String checkout_lang = (String)request.getAttribute(databaseId + ".checkout.lang");
if ("".equals(checkout_lang)) checkout_lang = "el";
else checkout_lang = "en";

String orderDesc = "cart checkout";
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
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

<div id="contentContainer" class="container">

  <div style="margin-top: 60px;">
    <div style="margin-bottom: 20px;" class="text-center"><%=lb.get("msg" + lang)%></div>
    <div><img src="/images/loading_big.gif" alt="" class="center-block"/></div>
  </div>

  <%
  if (gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_CREDIT_CARD.equals(ordPayWay)) {
    String[] values = Configuration.getValues(new String[] {"ProxyPayURL", "ProxyPayMerchantID", "ProxyPayConfirmPass"});

    String ProxyPayURL = values[0],
        ProxyPayMerchantID = values[1],
        ProxyPayConfirmPass = values[2];

    String confirmUrl = URI_SCHEME + serverName + "/cardlink_confirm.do",
        cancelUrl = URI_SCHEME + serverName + "/cardlink_confirm.do";

    String data = ProxyPayMerchantID + checkout_lang + orderID + orderDesc +
        totalAmount.setScale(2, BigDecimal.ROUND_HALF_UP) + "EUR" +
        customerEmail + installmentsOffset + installments + confirmUrl + cancelUrl + ProxyPayConfirmPass;

    java.security.MessageDigest mdigest = java.security.MessageDigest.getInstance("SHA-1");
    byte [] digestResult = mdigest.digest(data.getBytes("UTF-8"));
    String digest = new String(Base64.encodeBase64(digestResult));
  %>
    <form name="payForm" id="payForm" method="POST" action="<%=ProxyPayURL%>" accept-charset="UTF-8">
      <input type="hidden" name="mid" value="<%=ProxyPayMerchantID%>">
      <input type="hidden" name="lang" value="<%=checkout_lang%>">
      <input type="hidden" name="orderid" value="<%=orderID%>">
      <input type="hidden" name="orderDesc" value="<%=orderDesc%>">
      <input type="hidden" name="orderAmount" value="<%=totalAmount.setScale(2, BigDecimal.ROUND_HALF_UP)%>">
      <input type="hidden" name="currency" value="EUR">
      <input type="hidden" name="payerEmail" value="<%=customerEmail%>">
      <input type="hidden" name="extInstallmentoffset" value="<%=installmentsOffset%>">
      <input type="hidden" name="extInstallmentperiod" value="<%=installments%>">
      <input type="hidden" name="confirmUrl" value="<%=confirmUrl%>">
      <input type="hidden" name="cancelUrl" value="<%=cancelUrl%>">
      <input type="hidden" name="digest" value="<%=digest%>">
    </form>
  <%
  } %>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!--/site -->

</body>
</html>