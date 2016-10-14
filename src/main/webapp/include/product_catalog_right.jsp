<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="product_catalog_right_jsp_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<%!
static Hashtable right_jsp_lb = new Hashtable();
static {
    right_jsp_lb.put("myaccount","Ο Λογαριασμός μου");
    right_jsp_lb.put("myaccountLG","My Account");
    right_jsp_lb.put("shopCart","Καλάθι Αγορών");
    right_jsp_lb.put("shopCartLG","Shopping Cart");
    right_jsp_lb.put("proceedtoCheckout","Ολοκλήρωση Αγοράς");
    right_jsp_lb.put("proceedtoCheckoutLG","Proceed to Checkout");
    
    right_jsp_lb.put("cartItems","προϊόντα");
    right_jsp_lb.put("cartItemsLG","items");
    
    right_jsp_lb.put("total","σύνολο");
    right_jsp_lb.put("totalLG","total");
    
    right_jsp_lb.put("emptyCart","Το καλάθι σας είναι άδειο");
    right_jsp_lb.put("emptyCartLG","Your cart is empty");
}
%>

<%
String right_jsp_cartMsg = "";

int right_jsp_rows = 0;

Order right_jsp_order = null;
Product right_jsp_product = null;
PrdPrice right_jsp_prdPrice = null;

ProductOptionsValue right_jsp_productOptionsValue = null;

right_jsp_order = customer.getOrder();

int right_jsp_orderLines = right_jsp_order.getOrderLines();

product_catalog_right_jsp_cmrow.initBean(databaseId, request, response, this, session);

int product_catalog_right_jsp_rowCount = 0;
%>

<div id="productCatalogRightContainer">

<div id="productCatalogRightCart">

<a href="<%= "http://" + serverName + "/" + response.encodeURL("shopping_cart.jsp?extLang=" + lang) %>"><img src="/images/cart_top.png" alt="" /></a>

<div id="productCatalogRightCartContents">
  
<div style="width:179px; border:1px dotted #ffffff; margin:0 5px 15px 5px;"><!-- empty --></div>

<%
if (right_jsp_orderLines>0) {
    TotalPrice orderPrice = right_jsp_order.getOrderPrice();
    
    String right_jsp_viewPrdPageURL = "";
    
    for (int i=0; i<right_jsp_orderLines; i++) {
        right_jsp_product = right_jsp_order.getProductAt(i);
        right_jsp_prdPrice = right_jsp_product.getPrdPrice();
        right_jsp_productOptionsValue = right_jsp_product.getProductOptionsValue();
            
        right_jsp_viewPrdPageURL = "http://" + serverName + "/" + response.encodeURL("product_detail.jsp?prdId=" + right_jsp_product.getPrdId());
%>
        <table style="width:100%; border:0px;" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" style="width:5px;">&nbsp;</td>
            <td valign="top"><span style="white-space: nowrap"><%= right_jsp_product.getQuantity() %> x</span></td>
            <td valign="top">&nbsp;<%= right_jsp_product.getPrdName() %><%if (right_jsp_productOptionsValue != null) { %> - <%= right_jsp_productOptionsValue.getValue("PO_Name" + lang) %><% } %></td>
            <td valign="top" align="right"><span style="color:#000000; white-space:nowrap; text-align:right;"> &euro;<%= SwissKnife.formatNumber(right_jsp_prdPrice.getTotalGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></span></td>
            <td valign="top" style="width:5px;">&nbsp;</td>
        </tr>
        </table>
        <div style="height:5px;"><!-- empty --></div>
<%
    }
%>
<div align="right" style="margin-right:5px; color:#000000;"><b><%= right_jsp_lb.get("total" + lang)%></b> &euro;<%= SwissKnife.formatNumber(customer.getOrder().getOrderPrice().getGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%></div>
<%
}
else { %>
  <div style="margin-left:5px;"><%= right_jsp_lb.get("emptyCart" + lang)%></div>
<% } %>

<div style="width:179px; border:1px dotted #ffffff; margin:10px 5px 10px 5px;"><!-- empty --></div>

<table>
<tr>
    <td><img src="/images/ar01.gif" alt="" /></td>
    <td style="text-align: left;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("customer_myaccount.jsp") %>" style="font-weight:bold;"><%= right_jsp_lb.get("myaccount" + lang) %></a></td>
</tr>
<tr>
    <td><img src="/images/ar01.gif" alt="" /></td>
    <td style="text-align: left;"><a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("checkout_billing.jsp") %>" style="font-weight:bold;"><%= right_jsp_lb.get("proceedtoCheckout" + lang) %></a></td>
</tr>
</table>

</div> <!-- end: productCatalogRightCartContents -->

<img src="/images/cart_bottom.png" alt="" />

</div> <!-- end: productCatalogRightCart -->

<%
product_catalog_right_jsp_rowCount = product_catalog_right_jsp_cmrow.getCMRow(RIGHT_INFO_TABLE_CMCCode,"CCCRRank DESC, CMRDateCreated DESC").getRetInt();

if (product_catalog_right_jsp_rowCount > 0) { %>
  <div style="margin-top:10px;"><%= product_catalog_right_jsp_cmrow.getColumn("CMRText" + lang) %></div>
<%
  product_catalog_right_jsp_cmrow.closeResources();
} %>

</div> <!-- end: productCatalogRightContainer -->