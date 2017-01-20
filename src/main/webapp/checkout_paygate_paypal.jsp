<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_paygate.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Ανακατεύθυνση");
  lb.put("htmlTitleLG","Redirect");
  lb.put("msg","Μεταφορά στο paypal...");
  lb.put("msgLG","You are being redirected to paypal...");
}
%>

<%
String orderID = (String)request.getAttribute(databaseId + ".checkout.orderID"),
    customerEmail = (String)request.getAttribute(databaseId + ".checkout.customerEmail"),
    ordPayWay = (String)request.getAttribute(databaseId + ".checkout.ordPayWay");

BigDecimal totalAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalAmount"),
    totalOrderAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalOrderAmount"),
    totalShippingAmount = (BigDecimal)request.getAttribute(databaseId + ".checkout.totalShippingAmount");

Product product = null;
PrdPrice prdPrice = null;

ProductOptionsValue productOptionsValue = null;
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <title><%= lb.get("htmlTitle" + lang) %></title>

  <script>
  $(document).ready(function() {
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
  if (gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_PAYPAL.equals(ordPayWay)) {
      String[] values = Configuration.getValues(new String[] {"PayPalURL","PayPalBusinessEmail"});

      String PayPalURL = values[0],
          PayPalBusinessEmail = values[1];
  %>
      <form name="payForm" id="payForm" method="POST" action="<%=PayPalURL%>">

      <input type="hidden" name="upload" value="1" />
      <input type="hidden" name="cmd" value="_cart" />
      <input type="hidden" name="charset" value="UTF-8" />
      <input type="hidden" name="currency_code" value="EUR" />

      <input type="hidden" name="cbt" value="Return to shop" />

      <%-- 1 – do not prompt for an address  --%>
      <input type="hidden" name="no_shipping" value="1" />

      <input type="hidden" name="first_name" value="<%=customer.getFirstname()%>" />
      <input type="hidden" name="last_name" value="<%=customer.getLastname()%>" />
      <input type="hidden" name="address1" value="<%=customer.getBillingAddress()%>" />
      <input type="hidden" name="city" value="<%=customer.getBillingCity()%>" />
      <input type="hidden" name="zip" value="<%=customer.getBillingZipCode()%>" />
      <input type="hidden" name="email" value="<%=customerEmail%>" />

      <%if (SwissKnife.fileExists(wwwrootFilePath + "/images/logo_for_paypal.png")) {%><input type="hidden" name="image_url" value="<%="http://" + serverName + "/images/logo_for_paypal.png"%>" /><%}%>

      <input type="hidden" name="invoice" value="<%=orderID%>" />

      <input type="hidden" name="business" value="<%=PayPalBusinessEmail%>" />

      <input type="hidden" name="no_note" value="1" />

      <%-- 1 – the buyer’s browser is redirected to the return URL by using the GET method, but no payment variables are included  --%>
      <input type="hidden" name="rm" value="1" />

      <input type="hidden" name="return" value="<%="http://" + serverName + "/paypal_ok.jsp"%>" />
      <input type="hidden" name="cancel_return" value="<%="http://" + serverName + "/shopping_cart.jsp"%>" />
      <input type="hidden" name="notify_url" value="<%="http://" + serverName + "/paypal_confirm.do"%>" />

      <input type="hidden" name="handling_cart" value="<%=totalShippingAmount.setScale(2, BigDecimal.ROUND_HALF_UP)%>" />
      <input type="hidden" name="tax_cart" value="<%=order.getOrderPrice().getVATCurr1().setScale(2, BigDecimal.ROUND_HALF_UP)%>" />
      <%
      int orderLines = order.getOrderLines();

      for (int i=0; i<orderLines; i++) {
          product = order.getProductAt(i);
          prdPrice = product.getPrdPrice();
          productOptionsValue = product.getProductOptionsValue();
      %>
          <input type="hidden" name="item_name_<%=i+1%>" value="<%=product.getPrdName()%><%if (productOptionsValue != null) out.print(" - " + productOptionsValue.getValue("PO_Name" + lang));%>" />
          <input type="hidden" name="amount_<%=i+1%>" value="<%=prdPrice.getUnitNetCurr1().setScale(2, BigDecimal.ROUND_HALF_UP)%>" />
          <input type="hidden" name="quantity_<%=i+1%>" value="<%=product.getQuantity()%>" />
      <%
      } %>

      </form>
  <%
  } %>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- /site -->

</body>
</html>