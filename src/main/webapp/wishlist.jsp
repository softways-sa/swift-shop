<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/wishlist.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="wishList" scope="page" class="gr.softways.dev.eshop.orders.v2.WishList" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Wish List");
  lb.put("htmlTitleLG","Wish List");
  lb.put("topPath","WISH LIST");
  lb.put("topPathLG","WISH LIST");
  lb.put("prdCode","Κωδικός #:");
  lb.put("prdCodeLG","Item #:");
  lb.put("deleteItem","Διαγραφή από την wish list");
  lb.put("deleteItemLG","Delete this item");
  lb.put("proceedToCheckout","Ολοκλήρωση Αγοράς");
  lb.put("proceedToCheckoutLG","Proceed to Checkout");
  lb.put("cartItems","ΠΡΟΪΟΝΤΑ");
  lb.put("cartItemsLG","CART ITEMS");
  lb.put("price","ΤΙΜΗ");
  lb.put("priceLG","PRICE");
  lb.put("qty","ΠΟΣΟΤΗΤΑ");
  lb.put("qtyLG","QTY");
  lb.put("total","ΣΥΝΟΛΟ");
  lb.put("totalLG","TOTAL");
  lb.put("btnupdate","Ενημέρωση");
  lb.put("btnupdateLG","Update");
  lb.put("emptyCartMsg","<br/><br/><b>Η wish list είναι άδεια.</b>");
  lb.put("emptyCartMsgLG","<br/><br/><b>Your wish list is empty.</b>");
  lb.put("addcart","Μεταφορά στο καλάθι");
  lb.put("addcartLG","Transfer to cart");
}
%>

<%
wishList.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

BigDecimal zero = new BigDecimal("0"), one = new BigDecimal("1");

ProductOptionsValue productOptionsValue = null;

order = customer.getOrder();

dbRet = order.processRequest(request);

PrdPrice prdPrice = null, hdPrice = null, oldPrice = null;

boolean isOffer = false;

int orderLines = 0;

dbRet = wishList.getTable(customer.getCustomerId());
orderLines = dbRet.getRetInt();
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%=lb.get("topPath" + lang)%></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

  <div class="row">
    <div class="col-xs-12">
      
      <%
      if (orderLines > 0) {%>
        <table class="table table-hover">
          <thead>
            <tr>
              <th><%=lb.get("topPath" + lang)%></th>
              <th class="text-center"><%=lb.get("price" + lang)%></th>
              <th><%=lb.get("qty" + lang)%></th>
              <th class="text-center"><%=lb.get("total" + lang)%></th>
              <th>&nbsp;</th>
            </tr>
          </thead>
          <tbody>
          <%
          String viewPrdPageURL = "", prd_img = "";

          for (int i=0; i<orderLines; i++) {
            viewPrdPageURL = "http://" + serverName + "/" + response.encodeURL("product_detail.jsp?prdId=" + wishList.getHexColumn("prdId") + "&amp;extLang=" + lang);

            prdPrice = null;

            isOffer = false;

            boolean giftWrapExtraCost = false;

            productOptionsValue = null;
            if (wishList.getColumn("WLST_PO_Code").length()>0) {
                productOptionsValue = ProductOptionsValue.getProductOptionsValue(wishList.getColumn("WLST_PO_Code"), wishList.getColumn("WLST_prdId"));
            }

            if (PriceChecker.isOffer(wishList.getQueryDataSet(),customerType)) {
                isOffer = true;
                hdPrice = PriceChecker.calcPrd(one,wishList.getQueryDataSet(),productOptionsValue,customerType,isOffer,customer.getDiscountPct(),giftWrapExtraCost);

                oldPrice = PriceChecker.calcPrd(one,wishList.getQueryDataSet(),productOptionsValue,customerType,false,customer.getDiscountPct(),giftWrapExtraCost);
            }
            prdPrice = PriceChecker.calcPrd(one,wishList.getQueryDataSet(),productOptionsValue,customerType,false,customer.getDiscountPct(),giftWrapExtraCost);

            String s_price = null, s_hdPrice = null, s_oldPrice = null;
            if (gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL == customerType) {
                if (prdPrice.getUnitGrossCurr1().compareTo(zero) == 1) s_price = SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);

                if (isOffer == true && hdPrice.getUnitGrossCurr1().compareTo(zero) == 1) {
                    s_oldPrice = SwissKnife.formatNumber(oldPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                    s_hdPrice = SwissKnife.formatNumber(hdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                }
            }
            else if (gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType) {
                s_price = SwissKnife.formatNumber(prdPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);

                if (isOffer == true) {
                    s_oldPrice = SwissKnife.formatNumber(oldPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                    s_hdPrice = SwissKnife.formatNumber(hdPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                }
            }

            prd_img = "";

            if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + wishList.getColumn("prdId") + "-1.jpg")) {
                prd_img = "/prd_images/" + wishList.getColumn("prdId") + "-1.jpg";
            }
            else {
                prd_img = "/images/img_not_avail.jpg";
            }
          %>
            <tr>
              <form name="cartForm<%=i%>" action="/wishlist.jsp" method="post">

              <input name="action1" id="action1" type="hidden" value="WISH_LIST_TRANSFER" />
              <input name="prdId" id="prdId" type="hidden" value="<%= wishList.getColumn("prdId") %>" />
              <input name="PO_Code" id="PO_Code" type="hidden" value="<%= wishList.getColumn("WLST_PO_Code") %>" />
              
              <td class="col-sm-7 col-md-6">
                <div class="media">
                    <a style="margin-bottom: 0px;" class="thumbnail fl mr" href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" style="width: 80px; height: 80px;"></a>
                    <div class="media-body">
                      <h5><a href="<%=viewPrdPageURL%>"><%=wishList.getColumn("name" + lang)%><%if (productOptionsValue != null) {%> - <%=productOptionsValue.getValue("PO_Name" + lang)%><%}%></a></h5>
                    </div>
                </div>
              </td>
              <td class="col-sm-1 col-md-1 text-center"><strong><%=SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%>&euro;</strong></td>
              <td class="col-sm-1 col-md-1" style="text-align: center"><input type="text" class="form-control input-sm" name="quantity" value="<%=wishList.getBig("WLST_quantity").setScale(0, BigDecimal.ROUND_HALF_UP)%>"></td>
              <td class="col-sm-1 col-md-1 text-center">
                <strong><%if (isOffer==true && s_hdPrice != null) {%><%=s_hdPrice%>&euro;<%}else if (s_price != null) {%><%=s_price%>&euro;<%}%></strong>
              </td>
              <td class="col-sm-2 col-md-1 text-right">
                <button type="submit" class="btn btn-info btn-sm"><span class="glyphicon glyphicon-transfer"></span></button>
                <a href="<%="http://" + serverName + "/" + response.encodeURL("wishlist.jsp?action1=WISH_LIST_REMOVE&prdId=" + wishList.getColumn("prdId") + "&PO_Code=" + wishList.getColumn("WLST_PO_Code"))%>" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove"></span></a>
              </td>
              
              </form>
            </tr>
        <%
            wishList.nextRow();
        } %>
          </tbody>
          </table>
      <%
      }
      else { %>
        <%=lb.get("emptyCartMsg" + lang)%>
      <% } %>
    </div>
  </div>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>