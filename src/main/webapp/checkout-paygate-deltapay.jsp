<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout-paygate-deltapay.jsp"; %>

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

String Guid1 = "";

String orderID = (String)request.getAttribute(databaseId + ".checkout.orderID"),
    customerEmail = (String)request.getAttribute(databaseId + ".checkout.customerEmail");
    
BigDecimal totalAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalAmount");

String[] values = Configuration.getValues(new String[] {"DeltaPayMerchantCode"});

String MerchantCode = values[0];

gr.softways.dev.eshop.deltapay.DeltaPay deltaPay = new gr.softways.dev.eshop.deltapay.DeltaPay();
deltaPay.setDebug(false);
deltaPay.setURL("https://www.deltapay.gr/getguid.asp");
deltaPay.setDatabaseID(databaseId);
deltaPay.setEncoding("UTF8");
deltaPay.setMerchantCode(MerchantCode);
deltaPay.setAmount(totalAmount);
deltaPay.setCardHolderEmail(customerEmail);
deltaPay.setVar1(orderID);
dbRet = deltaPay.getGuid();

if (dbRet.getNoError() == 1) {
  Guid1 = deltaPay.getGuid1();
}
else {
  response.sendRedirect(response.encodeRedirectURL("problem.jsp"));
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
    
    <form name="payForm" id="payForm" method="POST" action="https://www.deltapay.gr/entry.asp">
    <input type="hidden" name="Guid1" value="<%=Guid1%>"/>
    </form>

</div> <!-- end: checkoutContainer -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>