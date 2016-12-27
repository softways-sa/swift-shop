<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/index.jsp"; %>

<jsp:useBean id="searchArticle" scope="page" class="gr.softways.dev.swift.cmrow.SearchArticle3" />

<jsp:useBean id="product_search" scope="page" class="gr.softways.dev.eshop.product.v2.Present2_2" />

<%!
static Hashtable lb = new Hashtable();
static {
  lb.put("htmlTitle","");
  lb.put("htmlTitleLG","");

  lb.put("more","περισσότερα");
  lb.put("moreLG","more");

  lb.put("noRecords","Δεν βρέθηκαν καταχωρήσεις.");
  lb.put("noRecordsLG","No records found.");

  lb.put("next","Επόμενη");
  lb.put("nextLG","Next");

  lb.put("previous","Προηγούμενη");
  lb.put("previousLG","Previous");

  lb.put("featuredPrds","Οι προτάσεις μας");
  lb.put("featuredPrdsLG","Featured products");
  lb.put("hotdealsTitle","Ευκαιρίες");
  lb.put("hotdealsTitleLG","Hot deals");

  lb.put("addcart","Προσθήκη στο Καλάθι");
  lb.put("addcartLG","Add to Cart");
  lb.put("addcartLG1","Add to Cart");

  lb.put("prdCode","Κωδ.");
  lb.put("prdCodeLG","Code");
  lb.put("prdCodeLG1","Code");
  
  lb.put("pLabelNew","ΝΕΟ!");
  lb.put("pLabelNewLG","NEW!");
  lb.put("pLabelSale","ΠΡΟΣΦΟΡΑ!");
  lb.put("pLabelSaleLG","SALE!");
}
%>

<%
searchArticle.initBean(databaseId, request, response, this, session);
product_search.initBean(databaseId, request, response, this, session);

int CMRRows = 0;

int dispRows = 10, dispPageNumbers = 10;

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

searchArticle.setDispRows(dispRows);
searchArticle.setSortedByCol("CCCRRank DESC, CMRDateCreated");
searchArticle.setSortedByOrder("DESC");
DbRet dbRet = searchArticle.doAction(request);

currentRowCount = searchArticle.getCurrentRowCount();
totalRowCount = searchArticle.getTotalRowCount();
totalPages = searchArticle.getTotalPages();
currentPage = searchArticle.getCurrentPage();

int startPage = 0, endPage = 0;

int start = searchArticle.getStart();

String urlQuerySearch = "http://" + serverName + "/index.jsp?CMCCode=" + SwissKnife.hexEscape(searchArticle.getCMCCode()) + "&amp;extLang=" + lang;

String htmlTitle = "", htmlKeywords = "", CMRHeadHTML = "", CMRBodyHTML = "";

if (totalRowCount == 1) {
  htmlTitle = searchArticle.getColumn("CMRTitle" + lang);
  htmlKeywords = searchArticle.getColumn("CMRKeyWords" + lang);
  CMRHeadHTML = searchArticle.getColumn("CMRHeadHTML");
  CMRBodyHTML = searchArticle.getColumn("CMRBodyHTML");
}
else {
  htmlTitle = lb.get("htmlTitle" + lang).toString();
  htmlKeywords = "";
}
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>
  
  <%if (htmlKeywords.length() > 0) {%><meta name="keywords" content="<%=htmlKeywords%>"><%}%>
  
  <title><%=htmlTitle%></title>

  <link href='/css/owl-carousel/owl.carousel.css' rel='stylesheet'>
  <link href='/css/owl-carousel/owl.theme.css' rel='stylesheet'>

  <style>#hdItemsCarouselWrapper{margin-top: 10px;} .owl-carousel .item-box-wrapper{margin-right: 0; display: block; float: none; margin: 0 auto;}</style>

  <%=CMRHeadHTML%>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<%=searchArticle.getColumn("CMRSummary" + lang)%>

<div class="container" id="homeContainer">
<div class="row">
<div class="col-xs-12">

<div id="homeContainerMain" class="clearfix">
    <%
    BigDecimal zero = new BigDecimal("0"), one = new BigDecimal("1");

    PrdPrice prdPrice = null, hdPrice = null, oldPrice = null;

    boolean isOffer = false;

    int prdTotalRowCount = 0;
    
    String prd_img = "", viewPrdPageURL = "";
    
    boolean hotdealFlag = false;
    
    int maxItemsCount = 15;
    
    prdTotalRowCount = product_search.getHomeFeaturedPrds(SwissKnife.jndiLookup("swconf/inventoryType"),maxItemsCount," product.prdId ASC",hotdealFlag).getRetInt();

    if (prdTotalRowCount > 0) {
    %>
      <div id="itemsCarouselWrapper">

        <h2 class="homeTitle"><%=lb.get("featuredPrds" + lang)%></h2>

        <div id="itemsCarousel" class="owl-carousel">
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
            <a href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" alt="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" title="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" width="160" height="160" /></a>

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
          } else { %>
          <%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? prdPrice.getUnitNetCurr1() : prdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
          <% } %>
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
    } %>
    
    <%
    hotdealFlag = true;
    prdTotalRowCount = product_search.getHomeFeaturedPrds(SwissKnife.jndiLookup("swconf/inventoryType"),maxItemsCount," product.prdId ASC",hotdealFlag).getRetInt();

    if (prdTotalRowCount > 0) {
    %>
      <div id="hdItemsCarouselWrapper">

        <h2 class="homeTitle"><%=lb.get("hotdealsTitle" + lang)%></h2>

        <div id="hdItemsCarousel" class="owl-carousel">
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
            <a href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" alt="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" title="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" width="160" height="160" /></a>

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
          } else { %>
          <%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? prdPrice.getUnitNetCurr1() : prdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
          <% } %>
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
      </div> <!-- /hdItemsCarouselWrapper -->
    <%
    } %>
    
  <%if (totalRowCount == 1) {%><div class="clearfix"><%= searchArticle.getColumn("CMRText" + lang) %></div><%}%>
</div> <!-- end: homeContainerMain -->

</div> <!-- /col -->
</div> <!-- /row -->
</div> <!-- /homeContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

<%=CMRBodyHTML%>

<script src='/js/owl.carousel.min.js'></script>
<script>$(document).ready(function() {$('.owl-carousel').owlCarousel({navigation: true, items : 5, itemsDesktop : [1200,4], itemsDesktopSmall : [900,3], itemsTablet: [640,3], itemsMobile : [540,1]});});</script>

<%
searchArticle.closeResources();
product_search.closeResources();
%>

</body>
</html>