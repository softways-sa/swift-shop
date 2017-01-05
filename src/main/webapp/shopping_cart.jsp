<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/shopping_cart.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Καλάθι Αγορών");
    lb.put("htmlTitleLG","Shopping Cart");
    lb.put("htmlTitleLG1","Shopping Cart");
    
    lb.put("topPath","Καλάθι Αγορών");
    lb.put("topPathLG","Shopping Cart");
    lb.put("topPathLG1","Shopping Cart");
    
    lb.put("deleteItem","αφαίρεση");
    lb.put("deleteItemLG","remove");
    lb.put("deleteItemLG1","remove");
    
    lb.put("updateQuan","Εάν αλλάξατε τις ποσότητες πατήστε εδώ");
    lb.put("updateQuanLG","If you changed quantities click here");
    lb.put("updateQuanLG1","If you changed quantities click here");
    
    lb.put("updateQuanTitle","Ενημέρωση");
    lb.put("updateQuanTitleLG","Update");
    lb.put("updateQuanTitleLG1","Update");
    
    lb.put("updateQuanAlt","Επανυπολογισμός");
    lb.put("updateQuanAltLG","Update");
    lb.put("updateQuanAltLG1","Update");
    
    lb.put("cartItems","ΠΡΟΪΟΝΤΑ");
    lb.put("cartItemsLG","CART ITEMS");
    lb.put("cartItemsLG1","Cart Items");
    
    lb.put("price","ΤΙΜΗ");
    lb.put("priceLG","PRICE");
    lb.put("priceLG1","Price");
    
    lb.put("qty","ΠΟΣΟΤΗΤΑ");
    lb.put("qtyLG","QTY");
    lb.put("qtyLG1","QTY");
    
    lb.put("proceedToCheckout","&gt; Ολοκλήρωση αγορών");
    lb.put("proceedToCheckoutLG","&gt; Proceed to Checkout");
    lb.put("proceedToCheckoutLG1","&gt; Proceed to Checkout");
    
    lb.put("total","ΣΥΝΟΛΟ");
    lb.put("totalLG","TOTAL");
    lb.put("totalLG1","TOTAL");
    
    lb.put("total2","Σύνολο");
    lb.put("total2LG","Total");
    lb.put("total2LG1","Total");
    
    lb.put("btnupdate","Ενημέρωση");
    lb.put("btnupdateLG","Update");
    lb.put("btnupdateLG1","Update");
    
    lb.put("giftWrap","+ συσκευασία δώρου");
    lb.put("giftWrapLG","+ gift wrap");
    lb.put("giftWrapLG1","+ gift wrap");
    
    lb.put("shippingMsg","** Το σύνολο δεν περιλαμβάνει τα έξοδα αποστολής, τα οποία θα υπολογιστούν κατά την ολοκλήρωση της αγοράς σας.");
    lb.put("shippingMsgLG","** Total does not include shipping, which will be calculated during check out.");
    lb.put("shippingMsgLG1","* Total does not include shipping, which will be calculated during check out.");
    
    lb.put("vatMsg","* Στις τιμές των προϊόντων συμπεριλαμβάνεται ο Φ.Π.Α.");
    lb.put("vatMsgLG","* VAT is included");
    
    lb.put("emptyCartMsg","<br/><br/><b>Το καλάθι σας είναι άδειο.</b>");
    lb.put("emptyCartMsgLG","<br/><br/><b>Your shopping cart is empty.</b>");
    lb.put("emptyCartMsgLG1","<br/><br/><b>Your shopping cart is empty.</b>");
}
%>

<%
DbRet dbRet = null;

Product product = null;
PrdPrice prdPrice = null;

ProductOptionsValue productOptionsValue = null;

dbRet = order.processRequest(request);

int orderLines = order.getOrderLines();

BigDecimal _zero = new BigDecimal("0");
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("topPath" + lang) %></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

<%@ include file="/include/checkout_steps.jsp" %>

<div class="row">
<div class="col-xs-12">
<div id="shoppingCart" style="width: 100%; overflow: hidden;">

  <form name="cartForm" action="<%= "http://" + serverName + "/" + "shopping_cart.jsp" %>" method="post">

  <input name="action1" type="hidden" value="CART_RECALC">

  <ul id="cart-table" class="clearfix">
      <li class="title">
          <div class="items"><%= lb.get("cartItems" + lang) %></div>
          <div class="price"><%= lb.get("price" + lang) %></div>
          <div class="qty"><%= lb.get("qty" + lang) %></div>
          <div class="total"><%= lb.get("total" + lang) %></div>
      </li>
      <%
      if (orderLines>0) {
          TotalPrice orderPrice = order.getOrderPrice();

          String viewPrdPageURL = "", prd_img = "";

          for (int i=0; i<orderLines; i++) {
              product = order.getProductAt(i);
              prdPrice = product.getPrdPrice();
              productOptionsValue = product.getProductOptionsValue();

              if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + product.getPrdId() + "-1.jpg")) {
                  prd_img = "/prd_images/" + product.getPrdId() + "-1.jpg";
              }
              else {
                  prd_img = "/images/img_not_avail.jpg";
              }

              viewPrdPageURL = "http://" + serverName + "/site/product/" + SwissKnife.sefEncode(product.getPrdName()) + "?prdId=" + SwissKnife.hexEscape(product.getPrdId()) + "&amp;extLang=" + lang;
      %>
          <li class="product-line">
            <div class="product-line-wrapper clearfix">
              <div class="product-image"><img src="<%= prd_img%>" width="80" height="80" style="display:inline; vertical-align:top;" alt="" /></div>
              <div class="product-descr">
                  <a href="<%= viewPrdPageURL %>"><%= product.getPrdName() %><%if (productOptionsValue != null) { %> - <%= productOptionsValue.getValue("PO_Name" + lang) %><% } %></a>
                  <%
                  if (product.isGiftWrap() == true) { %>
                  <br/><%= lb.get("giftWrap" + lang) %>
                  <% } %>
              </div>
              <div class="product-price"><%= SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</div>
              <div class="product-qty"><input type="text" class="text small" name="<%= "quantity_" + i %>" value="<%= product.getQuantity() %>" /></div>
              <div class="product-total"><%= SwissKnife.formatNumber(prdPrice.getTotalGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</div>
              <div class="product-remove"><a href="<%= "http://" + serverName + "/" + response.encodeURL("shopping_cart.jsp?action1=CART_REMOVE&prdIndex=" + i) %>"><img src="/images/shop_cart_deleteitem_btn<%= lang %>.png" style="display:inline; vertical-align:top;" alt="<%= lb.get("deleteItem" + lang) %>" title="<%= lb.get("deleteItem" + lang) %>" /></a></div>
            </div>
            <hr class="visible-xs"/>
          </li>
      <%
      } %>
      <li class="cart-total-row">
          <div class="cart-tips shop-tips"><%= lb.get("vatMsg" + lang) %><br/><%= lb.get("shippingMsg" + lang) %></div>
          <div class="cart-total"><h2><%= lb.get("total2" + lang) %>:</h2>&nbsp;&nbsp;<h2 class="shopcart-totalnum"><%= SwissKnife.formatNumber(orderPrice.getGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</h2></div>
      </li>
  </ul>

  <div style="margin-top:20px;" class="clearfix">
      <div style="float:right; margin-left:40px;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_billing.jsp")%>"><span class="button" ><%= lb.get("proceedToCheckout" + lang)%></span></a></div>
      <div style="float:right;"><input type="submit" class="button aux" name="update_quantity" value="<%= lb.get("updateQuan" + lang)%>" /></div>
  </div>
  <%
  }
  else { %>
    </ul>
    <div><%=lb.get("emptyCartMsg" + lang)%></div>
  <% } %>

  </form>

</div> <!-- end: shoppingCart -->
</div>
</div>

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>