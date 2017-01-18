<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_confirm.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Επιβεβαίωση της αγοράς");
  lb.put("htmlTitleLG","Confirm your order");
  lb.put("confirmOrder","Επιβεβαίωση αγοράς");
  lb.put("confirmOrderLG","Confirm your order");
  lb.put("confirmOrderExpl","Πατήστε το κουμπί \"Αγορά\" για να επιβεβαιώσετε την αγορά σας.");
  lb.put("confirmOrderExplLG","Click \"Place your order\" button to confirm your order.");
  lb.put("placeYourOrder","ΕΠΙΒΕΒΑΙΩΣΗ ΑΓΟΡΑΣ");
  lb.put("placeYourOrderLG","REVIEW & PLACE YOUR ORDER");
  lb.put("items","ΠΡΟΪΟΝΤΑ");
  lb.put("itemsLG","ITEMS");
  lb.put("paymentInfo","ΤΡΟΠΟΣ ΑΠΟΣΤΟΛΗΣ & ΠΛΗΡΩΜΗΣ");
  lb.put("paymentInfoLG","SHIPPING & PAYMENT METHOD");
  lb.put("cvv2Cvc2","κωδικός επαλήθευσης");
  lb.put("cvv2Cvc2LG","cvv2/cvc2");
  lb.put("creditCardNumber","αριθμός κάρτας");
  lb.put("creditCardNumberLG","number");
  lb.put("customerInfo","Στοιχεία πελάτη");
  lb.put("customerInfoLG","Customer");
  lb.put("shippingInfo","Στοιχεία αποστολής");
  lb.put("shippingInfoLG","Delivery information");
  lb.put("change","Μεταβολή");
  lb.put("changeLG","Change");
  lb.put("invoiceInfo","Στοιχεία τιμολογίου");
  lb.put("invoiceInfoLG","Invoice information");
  lb.put("qty","ΠΟΣΟΤΗΤΑ");
  lb.put("qtyLG","QTY");
  lb.put("price","ΤΙΜΗ");
  lb.put("priceLG","PRICE");
  lb.put("totals","ΣΥΝΟΛΟ");
  lb.put("totalsLG","TOTAL");
  lb.put("subtotal", "Μερικό σύνολο");
  lb.put("subtotalLG", "Subtotal");
  lb.put("shipCost","Έξοδα αποστολής");
  lb.put("shipCostLG","Shipping");
  lb.put("total","Σύνολο");
  lb.put("totalLG","Total");
  lb.put("totalHeader","ΣΥΝΟΛΟ");
  lb.put("totalHeaderLG","TOTAL");
  lb.put("expiresMonth","μήνας λήξης");
  lb.put("expiresMonthLG","expires month");
  lb.put("expiresYear","έτος λήξης");
  lb.put("expiresYearLG","expires year");
  lb.put("selectCard","Eπιλέξτε κάρτα");
  lb.put("selectCardLG","Select card");
  lb.put("selectMonth","Eπιλέξτε μήνα");
  lb.put("selectMonthLG","Select month");
  lb.put("selectYear","Eπιλέξτε έτος");
  lb.put("selectYearLG","Select year");
  lb.put("jsSelectPayMethod","Παρακαλούμε επιλέξτε τρόπο πληρωμής.");
  lb.put("jsSelectPayMethodLG","Please select payment method.");
  lb.put("jsMixedProblem","Δεν έχετε επιλέξει ως τρόπο πληρωμής πιστωτική κάρτα αλλά έχετε συμπληρώσει στοιχεία πιστωτικής κάρτας.");
  lb.put("jsMixedProblemLG","You haven't selected to pay by credit card but you have entered credit card details.");
  lb.put("noCreditSelected","Παρακαλούμε επιλέξτε πιστωτική κάρτα.");
  lb.put("noCreditSelectedLG","Please select your credit card.");
  lb.put("checkCreditNo","Παρακαλούμε ελέξτε τον αριθμό της πιστωτικής σας κάρτας.");
  lb.put("checkCreditNoLG","Please check your credit card number.");
  lb.put("checkCvvCvc","Παρακαλούμε ελέξτε τον κωδικό επαλήθευσης (τα 3 τελευταία ψηφία στο πίσω μέρος της κάρτας σας).");
  lb.put("checkCvvCvcLG","Please check your CVV2/CVC2 (the last 3 digits printed on the back of your credit card).");
  lb.put("noMonthSelected","Παρακαλούμε επιλέξτε μήνα λήξης.");
  lb.put("noMonthSelectedLG","Please select month.");
  lb.put("noYearSelected","Παρακαλούμε επιλέξτε έτος λήξης.");
  lb.put("noYearSelectedLG","Please select year.");
  lb.put("paymentMethod","ΤΡΟΠΟΣ ΠΛΗΡΩΜΗΣ");
  lb.put("paymentMethodLG","PAYMENT METHOD");
  lb.put("deposit","κατάθεση σε τράπεζα");
  lb.put("depositLG","bank deposit");
  lb.put("onDelivery","αντικαταβολή");
  lb.put("onDeliveryLG","on delivery");
  lb.put("creditCard","πιστωτική κάρτα");
  lb.put("creditCardLG","credit card");
  lb.put("paypal","paypal");
  lb.put("paypalLG","paypal");
  lb.put("viva","πιστωτική κάρτα (VIVA υπηρεσίες πληρωμών)");
  lb.put("vivaLG","credit card (VIVA payments services)");
  lb.put("giftWrap","+ συσκευασία δώρου");
  lb.put("giftWrapLG","+ gift wrap");
  lb.put("giftWrapLG1","+ gift wrap");
  lb.put("jsSelectShipping","Παρακαλούμε επιλέξτε τρόπο αποστολής.");
  lb.put("jsSelectShippingLG","Please select shipping method.");
  lb.put("shipMethod","ΤΡΟΠΟΣ ΑΠΟΣΤΟΛΗΣ");
  lb.put("shipMethodLG","SHIPPING METHOD");
  lb.put("termsofuse","Διάβασα και αποδέχομαι τους όρους χρήσης");
  lb.put("termsofuseLG","I accept the terms of use");
  lb.put("termsofuseLink","(Διαβάστε τους όρους χρήσης)");
  lb.put("termsofuseLinkLG","(See terms of use)");
  lb.put("jstermsofuse","Πρέπει να αποδεχτείτε τους όρους χρήσης για να συνεχίσετε.");
  lb.put("jstermsofuseLG","You have to accept the terms of use to continue.");
}
%>

<%
DbRet dbRet = null;

String urlCart = "http://" + serverName + "/" + response.encodeRedirectURL("shopping_cart.jsp"),
       urlConfirmOrder = HTTP_PROTOCOL + serverName + "/checkout_placeorder.do";

Product product = null;
PrdPrice prdPrice = null;

ProductOptionsValue productOptionsValue = null;

TotalPrice orderPrice = null, shippingPrice = null;

int orderLines = order.getOrderLines();
if (order.getOrderLines() <= 0) {
    response.sendRedirect(urlCart);
    return;
}

dbRet = customer.isValidForCheckout();
if (dbRet.getRetInt() == 1) {
    response.sendRedirect(response.encodeRedirectURL("problem.jsp?errorStatus=12"));
    return;
}

orderPrice = order.getOrderPrice();

int index = 0;

String[][] availShipping = ShippingManager.getAvailableShipping(customer);

String shippingWay = request.getParameter("shippingWay");

if (shippingWay != null && shippingWay.length() > 0) order.setShippingWay(shippingWay);
else order.setShippingWay(availShipping[0][0]);
    
shippingWay = order.getShippingWay();
    
shippingPrice = ShippingManager.getShippingPrice(customer);
order.setShippingPrice(shippingPrice);

BigDecimal _zero = new BigDecimal("0");

Timestamp now = SwissKnife.currentDate();

int currYear = SwissKnife.getTDateInt(now, "year");

String[] months = new String[] {"","01","02","03","04","05","06","07","08","09","10","11","12"};
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <title><%= lb.get("htmlTitle" + lang) %></title>

  <script>
  var isSubmitted = false;

  function confirmOrder() {
    if (isSubmitted) {
      return false;
    }
    else if ( $('#shippingMethodForm input[name=shippingWay]:checked').length == 0 ) {
      alert("<%= lb.get("jsSelectShipping" + lang) %>");
      return false;
    }
    else if ( $('#orderForm input[name=ordPayWay]:checked').length == 0 ) {
      alert("<%= lb.get("jsSelectPayMethod" + lang) %>");
      return false;
    }
    else if ( $('#orderForm input[name=accepttermsoufuse]:checked').length == 0 ) {
      alert("<%= lb.get("jstermsofuse" + lang) %>");
      return false;
    }
    else {
      isSubmitted = true;
      return true;
    }
  }
  </script>

  <style>
  #customerInfo, #shippingInfo, #invoiceInfo {margin:0 0 20px 0;}
  #customerInfo p, #shippingInfo p, #invoiceInfo p {margin:0; padding:5px 0 0 0;}
  </style>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

<%@ include file="/include/checkout_steps.jsp" %>

<div class="row">
  
  <div class="col-md-8">
    
    <table class="table table-hover">
      <thead>
        <tr>
          <th><%= lb.get("items" + lang) %></th>
          <th class="text-center"><%= lb.get("price" + lang) %></th>
          <th><%= lb.get("qty" + lang) %></th>
          <th class="text-right"><%= lb.get("totalHeader" + lang) %></th>
        </tr>
      </thead>
      <tbody>
      <%
      for (int i=0; i<orderLines; i++) {
        product = order.getProductAt(i);
        prdPrice = product.getPrdPrice();
        productOptionsValue = product.getProductOptionsValue();
      %>
        <tr>
          <td class="col-sm-8 col-md-6">
            <div class="media">
              <%=product.getPrdName()%><%if (productOptionsValue != null) {%> - <%=productOptionsValue.getValue("PO_Name" + lang)%><%}%>
              <%if (product.isGiftWrap() == true) {%><br/><%=lb.get("giftWrap" + lang)%><%}%>
            </div>
          </td>
          <td class="col-sm-1 col-md-2 text-center"><%= SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>&euro;</td>
          <td class="col-sm-1 col-md-2" style="text-align: center"><%= product.getQuantity() %></td>
          <td class="col-sm-2 col-md-2 text-right"><%= SwissKnife.formatNumber(prdPrice.getTotalGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>&euro;</td>
        </tr>
      <%
      }
      %>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><span class="mt mb"><strong><%=lb.get("subtotal" + lang)%></strong></span></td>
          <td class="text-right"><span class="mt mb"><strong><%=SwissKnife.formatNumber(orderPrice.getGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;</strong></span></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><strong><span class="mt mb"><strong><%=lb.get("shipCost" + lang)%></strong></span></td>
          <td class="text-right"><span class="mt mb"><strong><%= SwissKnife.formatNumber(shippingPrice.getGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;</strong></span></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><h2 class="mt mb"><%=lb.get("total" + lang)%></h2></td>
          <td class="text-right"><h2 class="mt mb"><%= SwissKnife.formatNumber(orderPrice.getGrossCurr1().add(shippingPrice.getGrossCurr1()),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</h2></td>
        </tr>
      </tbody>
    </table>
        
  </div> <!-- col -->
  
  <div class="col-md-3">
    <div id="customerInfo">
      <div style="margin:0 0 10px 0;" class="clearfix">
        <span style="float:left; margin-top: 10px; margin-right: 5px; font-weight: bold;"><%= lb.get("customerInfo" + lang)%></span>
        <div style="float:left;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_billing.jsp")%>"><span class="button aux"><%= lb.get("change" + lang)%></span></a></div>
      </div>

      <p><%= customer.getFirstname() %> <%= customer.getLastname() %></p>
      <p><%= customer.getBillingAddress() %></p>
      <p><%= customer.getBillingZipCode() %> <%= customer.getBillingCity() %></p>
      <p><%= customer.getBillingCountry() %></p>
      <p><% if (customer.getBillingPhone().length()>0) { %><%= customer.getBillingPhone() %><% } %></p>
      <p><%= customer.getEmail() %></p>
    </div>

    <%if (customer.getBillingName().length()>0 && customer.getBillingAfm().length()>0) {%>
      <div id="invoiceInfo">
        <div style="margin:0 0 10px 0;" class="clearfix">
          <span style="float:left; margin-top: 10px; margin-right: 5px; font-weight: bold;"><%= lb.get("invoiceInfo" + lang) %></span>
          <div style="float: left;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_billing.jsp") %>"><span class="button aux"><%= lb.get("change" + lang)%></span></a></div>
        </div>

        <p><%= customer.getBillingName() %></p>
        <p><%= customer.getBillingAfm() %></p>
        <%if (customer.getBillingDoy().length()>0) { %><p><%= customer.getBillingDoy() %></p><%}%>
        <%if (customer.getBillingProfession().length()>0) { %><p><%= customer.getBillingProfession() %></p><%}%>
      </div>
    <%}%>

    <div id="shippingInfo">
      <div style="margin:0 0 10px 0;" class="clearfix">
        <span style="float:left; margin-top: 10px; margin-right: 5px; font-weight: bold;"><%= lb.get("shippingInfo" + lang) %></span>
        <div style="float:left;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_shipping.jsp") %>"><span class="button aux"><%= lb.get("change" + lang)%></span></a></div>
      </div>

      <p><%= customer.getShippingName() %></p>
      <p><%= customer.getShippingAddress() %></p>
      <p><%= customer.getShippingZipCode() %> <%= customer.getShippingCity() %></p>
      <p><%= customer.getShippingCountry() %></p>
      <p><%= customer.getShippingPhone() %></p>
    </div>
  </div> <!-- /col -->
</div> <!-- /row -->

<div class="row">
  <div class="col-md-12">
    
    <div id="shipMethodWrapper">
      <div class="sectionHeader"><%= lb.get("shipMethod" + lang) %></div>

      <form id="shippingMethodForm" name="shippingMethodForm" method="POST" action="<%= response.encodeURL("checkout_confirm.jsp") %>">

      <div id="shipMethodSection">
      <%
      while (availShipping != null && index < availShipping.length) {%>
        <div class="clearfix item<%if (order.getShippingWay().equals(availShipping[index][0])){%> selected<%}%>">
            <input id="delivery_type_<%=availShipping[index][0]%>" type="radio" name="shippingWay" value="<%=availShipping[index][0]%>" <% if (order.getShippingWay().equals(availShipping[index][0])) out.print("checked"); else { %>onclick='document.shippingMethodForm.submit();'<% } %> />
            <label for="delivery_type_<%=availShipping[index][0]%>"><span style="margin-left: 10px;"><%=availShipping[index][2]%> <%=SwissKnife.formatNumber(new BigDecimal(availShipping[index][3]),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%> &euro;</span></label>
        </div>
      <%
          index++;
      } %>
      </div>

      </form>
    </div>

    <div id="payMethodWrapper">
      <div class="sectionHeader"><%= lb.get("paymentMethod" + lang)%></div>
    
      <form id="orderForm" name="orderForm" action="<%=urlConfirmOrder%>" method="post" onsubmit="return confirmOrder();">

      <input type="hidden" name="action1" value="place_order">
      <input type="hidden" name="bnk" value="6"> <%-- '6' for cardlink, '1' for OLD alpha bank --%>

      <input type="hidden" name="var1" value="<%=request.getRemoteAddr()%>">
      <input type="hidden" name="var3" value="<%=customer.getEmail()%>">

      <div style="margin:10px 0 0 10px;"><input type="radio" id="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_ON_DELIVERY%>" name="ordPayWay" value="<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_ON_DELIVERY%>"> <label for="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_ON_DELIVERY%>"><span style="margin-left: 10px;"><%= lb.get("onDelivery" + lang)%></span></label></div>
      <div style="margin:10px 0 0 10px;"><input type="radio" id="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_DEPOSIT%>" name="ordPayWay" value="<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_DEPOSIT%>"> <label for="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_DEPOSIT%>"><span style="margin-left: 10px;"><%= lb.get("deposit" + lang) %></span></label></div>
      <%--<div style="margin:10px 0 0 10px;"><input type="radio" id="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_VIVA%>" name="ordPayWay" value="<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_VIVA%>"> <label for="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_VIVA%>"><span style="margin-left: 10px;"><%=lb.get("viva" + lang) %></span></label></div>--%>
      <%--<div style="margin:10px 0 0 10px;"><input type="radio" id="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_PAYPAL%>" name="ordPayWay" value="<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_PAYPAL%>"> <label for="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_PAYPAL%>"><span style="margin-left: 10px;"><%=lb.get("paypal" + lang) %></span></label></div>--%>
      <%--<div style="margin:10px 0 0 10px;"><input type="radio" id="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_CREDIT_CARD%>" name="ordPayWay" value="<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_CREDIT_CARD%>"> <label for="ordPayWay<%=gr.softways.dev.eshop.eways.v2.Order.PAY_TYPE_CREDIT_CARD%>"><span style="margin-left: 10px;"><%=lb.get("creditCard" + lang) %></span></label></div>--%>

      <div style="margin:30px 0 0 10px;"><input type="checkbox" id="accepttermsoufuse" name="accepttermsoufuse" value="Y" /> <label for="accepttermsoufuse"><%=lb.get("termsofuse" + lang) %></label> <a href="/site/page/?CMCCode=100302&extLang=<%=lang%>" target="_blank"><%=lb.get("termsofuseLink" + lang) %></a></div>

      <div style="margin:15px 0 0 0;"><input type="submit" class="button" value="<%= lb.get("confirmOrder" + lang)%>" /></div>

      </form>
    </div>
    
  </div> <!-- /col -->
</div> <!-- /row -->
      
</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>