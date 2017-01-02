<%@page pageEncoding="UTF-8"%>

<%@ include file="/include/config.jsp" %>

<jsp:useBean id="product_search" scope="page" class="gr.softways.dev.eshop.product.v2.Present2_2" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("addcart","Προσθήκη στο Καλάθι");
  lb.put("addcartLG","Add to Cart");
  lb.put("prdCode","Κωδ.");
  lb.put("prdCodeLG","Code");
  lb.put("pLabelNew","ΝΕΟ!");
  lb.put("pLabelNewLG","NEW!");
  lb.put("pLabelSale","ΠΡΟΣΦΟΡΑ!");
  lb.put("pLabelSaleLG","SALE!");
  lb.put("title1","Οι προτάσεις μας");
  lb.put("title1LG","Featured products");
  lb.put("title2","Ευκαιρίες");
  lb.put("title2LG","Hot deals");
}
%>

<%
product_search.initBean(databaseId, request, response, this, session);

String groupSearch = request.getParameter("group");
  
BigDecimal zero = BigDecimal.ZERO, one = BigDecimal.ONE;

PrdPrice prdPrice = null, hdPrice = null, oldPrice = null;

boolean isOffer = false;

int prdTotalRowCount = 0;

String prd_img = "", viewPrdPageURL = "";

int maxItemsCount = 15;

boolean hotdeals = false;
if ("2".equals(groupSearch)) {
  hotdeals = true;
}

prdTotalRowCount = product_search.getHomeFeaturedPrds(SwissKnife.jndiLookup("swconf/inventoryType"),maxItemsCount," product.prdId ASC",hotdeals).getRetInt();

if (prdTotalRowCount > 0) {
%>
  <div class="itemsCarouselWrapper">

    <h2 class="homeTitle"><%=lb.get("title" + groupSearch + lang)%></h2>

    <div class="itemsCarousel owl-carousel">
    <%
    while (product_search.inBounds() == true) {
      prdPrice = null;

      isOffer = false;

      if (PriceChecker.isOffer(product_search.getQueryDataSet(),customerType)) {
        isOffer = true;
        hdPrice = PriceChecker.calcPrd(one,product_search.getQueryDataSet(),customerType,isOffer,customer.getDiscountPct());

        oldPrice = PriceChecker.calcPrd(one,product_search.getQueryDataSet(),customerType,false,customer.getDiscountPct());
      }
      prdPrice = PriceChecker.calcPrd(one,product_search.getQueryDataSet(),customerType,false,customer.getDiscountPct());

      viewPrdPageURL = "http://" + serverName + "/site/product/" + SwissKnife.sefEncode(product_search.getColumn("name" + lang)) + "?prdId=" + product_search.getHexColumn("prdId") + "&amp;extLang=" + lang;

      if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + product_search.getColumn("prdId") + "-1.jpg")) {
        prd_img = "/prd_images/" + product_search.getColumn("prdId") + "-1.jpg";
      }
      else {
        prd_img = "/images/img_not_avail.jpg";
      }
    %>
      <div class="item-box-wrapper">
        <div class="item-box-image">
          <a href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" alt="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" title="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>"  /></a>

          <div class="product_labels">
          <%if (isOffer == true) {%><p><span class="heylabel sale"><%=lb.get("pLabelSale" + lang)%></span></p><%}%>
          <%if ("1".equals(product_search.getColumn("prdCompFlag"))) {%><p><span class="newlabel"><%=lb.get("pLabelNew" + lang)%></span></p><%}%>
          </div> <!-- /product_labels -->
        </div>
        <div class="item-box-content">
        <div class="item-box-bottom">
        <div class="item-box-price">
        <div class="item-box-addcart"><a href="<%=viewPrdPageURL%>"><img src="/images/add-to-cart.png" alt="<%=lb.get("addcart" + lang)%>" title="<%=lb.get("addcart" + lang)%>"/></a></div>
        <div class="item-box-amount">
        <%
        if (isOffer == true) { %>
        <span style="text-decoration:line-through;"><%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? oldPrice.getUnitNetCurr1() : oldPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%></span> &euro;&nbsp;<%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? hdPrice.getUnitNetCurr1() : hdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
        <%
        }
        else {%>
          <%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? prdPrice.getUnitNetCurr1() : prdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
        <%}%>
        </div>
        </div>
        </div>
        <div class="item-box-name"><a href="<%= viewPrdPageURL%>"><%= product_search.getColumn("name" + lang)%></a></div>
        </div>
      </div>
  <%
      product_search.nextRow();
    }
  %>
    </div>
    
  </div> <!-- /itemsCarouselWrapper -->
<%
}

product_search.closeResources();
%>