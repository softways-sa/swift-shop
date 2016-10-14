<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/wishlist.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="wishList" scope="page" class="gr.softways.dev.eshop.orders.v2.WishList" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Wish List");
    lb.put("htmlTitleLG","Wish List");
    lb.put("htmlTitleLG1","Wish List");
    
    lb.put("topPath","WISH LIST");
    lb.put("topPathLG","WISH LIST");
    lb.put("topPathLG1","WISH LIST");
    
    lb.put("prdCode","Κωδικός #:");
    lb.put("prdCodeLG","Item #:");
    lb.put("prdCodeLG1","Codice #:");
    
    lb.put("deleteItem","Διαγραφή από την wish list");
    lb.put("deleteItemLG","Delete this item");
    lb.put("deleteItemLG1","Omissione dal vostro cestino");
    
    lb.put("proceedToCheckout","Ολοκλήρωση Αγοράς");
    lb.put("proceedToCheckoutLG","Proceed to Checkout");
    lb.put("proceedToCheckoutLG1","Completamento dei Mercati");
    
    lb.put("cartItems","ΠΡΟΪΟΝΤΑ");
    lb.put("cartItemsLG","CART ITEMS");
    lb.put("cartItemsLG1","Cart Items");
    
    lb.put("price","ΤΙΜΗ");
    lb.put("priceLG","PRICE");
    lb.put("priceLG1","Price");
    
    lb.put("qty","ΠΟΣΟΤΗΤΑ");
    lb.put("qtyLG","QTY");
    lb.put("qtyLG1","QTY");
    
    lb.put("total","ΣΥΝΟΛΟ");
    lb.put("totalLG","TOTAL");
    lb.put("totalLG1","TOTAL");
    
    lb.put("btnupdate","Ενημέρωση");
    lb.put("btnupdateLG","Update");
    lb.put("btnupdateLG1","Istruzione");
    
    lb.put("emptyCartMsg","<br/><br/><b>Η wish list είναι άδεια.</b>");
    lb.put("emptyCartMsgLG","<br/><br/><b>Your wish list is empty.</b>");
    lb.put("emptyCartMsgLG1","<br/><br/><b>Your wish list is empty.</b>");
    
    lb.put("addcart","Μεταφορά στο καλάθι");
    lb.put("addcartLG","Transfer to cart");
    lb.put("addcartLG1","Aggiunta nel cestino");
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

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("topPath" + lang) %></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<div>
    <ul id="cart-table" class="clearfix">
    <li class="title">
        <div class="items" style="width:490px;"><%= lb.get("topPath" + lang) %></div>
        <div class="price"><%= lb.get("price" + lang) %></div>
        <div class="qty"><%= lb.get("qty" + lang) %></div>
        <div class="total"><%= lb.get("total" + lang) %></div>
    </li>
    <%
    if (orderLines>0) {
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
        <li class="product-line">
            <form name="cartForm<%= i %>" action="/wishlist.jsp" method="post">
            
            <input name="action1" id="action1" type="hidden" value="WISH_LIST_TRANSFER" />
            <input name="prdId" id="prdId" type="hidden" value="<%= wishList.getColumn("prdId") %>" />
            <input name="PO_Code" id="PO_Code" type="hidden" value="<%= wishList.getColumn("WLST_PO_Code") %>" />
        
            <div class="product-image"><img src="<%= prd_img%>" width="80" height="80" style="display:inline; vertical-align:top;" alt="" /></div>
            <div class="product-descr" style="width:404px;"><a href="<%= viewPrdPageURL %>"><%= wishList.getColumn("name" + lang) %><%if (productOptionsValue != null) { %> - <%= productOptionsValue.getValue("PO_Name" + lang) %><% } %></a></div>
            <div class="product-price"><%= SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</div>
            <div class="product-qty"><input type="text" name="quantity" value="<%= wishList.getBig("WLST_quantity").setScale(0, BigDecimal.ROUND_HALF_UP) %>" class="text small" /></div>
            <div class="product-total">
                <%
                if (isOffer==true && s_hdPrice != null) { %>
                  <%= s_hdPrice %>&nbsp;&euro;
                <%
                }
                else if (s_price != null) { %>
                    <%= s_price %>&nbsp;&euro;
                <% } %>
            </div>
            <div class="product-remove" style="width:68px; margin-top:15px;">
                <div style="float:left;"><input type="image" src="/images/add_cart_button_small<%= lang%>.png" alt="<%= lb.get("addcart" + lang)%>" title="<%= lb.get("addcart" + lang)%>" /></div>
                <div style="float:left; margin:8px 0 0 15px;"><a href="<%= "http://" + serverName + "/" + response.encodeURL("wishlist.jsp?action1=WISH_LIST_REMOVE&prdId=" + wishList.getColumn("prdId") + "&PO_Code=" + wishList.getColumn("WLST_PO_Code"))%>"><img src="/images/shop_cart_deleteitem_btn<%= lang%>.png" alt="<%= lb.get("deleteItem" + lang)%>" title="<%= lb.get("deleteItem" + lang)%>" style="display:inline;"/></a></div>
            </div>
            
            </form>
        </li>
    <%
        wishList.nextRow();
    } %>

<%
}
else { %>
    <%= lb.get("emptyCartMsg" + lang) %>
<% } %>
</div>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>