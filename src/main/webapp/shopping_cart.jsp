<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/shopping_cart.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Καλάθι Αγορών");
  lb.put("htmlTitleLG","Shopping Cart");
  lb.put("topPath","Καλάθι Αγορών");
  lb.put("topPathLG","Shopping Cart");
  lb.put("deleteItem","αφαίρεση");
  lb.put("deleteItemLG","remove");
  lb.put("updateQuan","Εάν αλλάξατε τις ποσότητες πατήστε εδώ");
  lb.put("updateQuanLG","If you changed quantities click here");
  lb.put("updateQuanTitle","Ενημέρωση");
  lb.put("updateQuanTitleLG","Update");
  lb.put("updateQuanAlt","Επανυπολογισμός");
  lb.put("updateQuanAltLG","Update");
  lb.put("cartItems","ΠΡΟΪΟΝΤΑ");
  lb.put("cartItemsLG","CART ITEMS");
  lb.put("price","ΤΙΜΗ");
  lb.put("priceLG","PRICE");
  lb.put("qty","ΠΟΣΟΤΗΤΑ");
  lb.put("qtyLG","QTY");
  lb.put("proceedToCheckout","Ολοκλήρωση αγορών");
  lb.put("proceedToCheckoutLG","Proceed to Checkout");
  lb.put("total","ΣΥΝΟΛΟ");
  lb.put("totalLG","TOTAL");
  lb.put("total2","Σύνολο");
  lb.put("total2LG","Total");
  lb.put("btnupdate","Ενημέρωση");
  lb.put("btnupdateLG","Update");
  lb.put("giftWrap","+ συσκευασία δώρου");
  lb.put("giftWrapLG","+ gift wrap");
  lb.put("shippingMsg","** Το σύνολο δεν περιλαμβάνει τα έξοδα αποστολής, τα οποία θα υπολογιστούν κατά την ολοκλήρωση της αγοράς σας.");
  lb.put("shippingMsgLG","** Total does not include shipping, which will be calculated during check out.");
  lb.put("vatMsg","* Στις τιμές των προϊόντων συμπεριλαμβάνεται ο Φ.Π.Α.");
  lb.put("vatMsgLG","* VAT is included");
  lb.put("emptyCartMsg","<br/><br/><b>Το καλάθι σας είναι άδειο.</b>");
  lb.put("emptyCartMsgLG","<br/><br/><b>Your shopping cart is empty.</b>");
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

  <form name="cartForm" action="<%="http://" + serverName + "/" + "shopping_cart.jsp"%>" method="post">

  <input name="action1" type="hidden" value="CART_RECALC">

  <div class="row">
    <div class="col-xs-12">

      <%
      if (orderLines > 0) {%>
        <table class="table table-hover">
          <thead>
            <tr>
              <th><%=lb.get("cartItems" + lang)%></th>
              <th class="text-center"><%=lb.get("price" + lang)%></th>
              <th><%=lb.get("qty" + lang)%></th>
              <th class="text-center"><%=lb.get("total" + lang)%></th>
              <th>&nbsp;</th>
            </tr>
          </thead>
          <tbody>
          <%
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
            <tr>
              <td class="col-sm-8 col-md-6">
                <div class="media">
                    <a style="margin-bottom: 0px;" class="thumbnail fl mr" href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" style="width: 80px; height: 80px;"></a>
                    <div class="media-body">
                      <h5><a href="<%=viewPrdPageURL%>"><%=product.getPrdName()%><%if (productOptionsValue != null) {%> - <%=productOptionsValue.getValue("PO_Name" + lang) %><%}%></a></h5>
                      <%if (product.isGiftWrap() == true) {%><div><%=lb.get("giftWrap" + lang) %></div><%}%>
                    </div>
                </div>
              </td>
              <td class="col-sm-1 col-md-1 text-center"><strong><%=SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%>&euro;</strong></td>
              <td class="col-sm-1 col-md-1" style="text-align: center"><input type="text" class="form-control input-sm" name="<%="quantity_" + i%>" value="<%=product.getQuantity()%>"></td>
              <td class="col-sm-1 col-md-1 text-center"><strong><%=SwissKnife.formatNumber(prdPrice.getTotalGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%>&euro;</strong></td>
              <td class="col-sm-1 col-md-1 text-right">
                <button type="submit" class="btn btn-info btn-sm"><span class="glyphicon glyphicon-refresh"></span></button>
                <a href="<%="http://" + serverName + "/" + response.encodeURL("shopping_cart.jsp?action1=CART_REMOVE&prdIndex=" + i)%>" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove"></span></a>
              </td>
            </tr>
          <%}%>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td><h2 class="mt mb"><%=lb.get("total2" + lang)%></h2></td>
              <td class="text-right"><h2 class="mt mb"><%=SwissKnife.formatNumber(orderPrice.getGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%> &euro;</h2></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td><a href="<%=HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_billing.jsp")%>" class="btn btn-primary"><%=lb.get("proceedToCheckout" + lang)%> <span class="glyphicon glyphicon-play"></span></a></td>
            </tr>
          </tbody>
        </table>
      <%
      }
      else {%>
        <div><%=lb.get("emptyCartMsg" + lang)%></div>
      <%}%>

    </div>
  </div>
  
  </form>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>