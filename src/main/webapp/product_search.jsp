<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<%@ page import="gr.softways.dev.eshop.product.v2.*,
                org.apache.commons.lang3.StringUtils" %>

<% whereAmI = "/product_search.jsp"; %>

<jsp:useBean id="product_search" scope="page" class="gr.softways.dev.eshop.product.v2.Search3" />

<jsp:useBean id="product_catalogue" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("resultsFor","Αποτελέσματα αναζήτησης για");
  lb.put("resultsForLG","Search results for");
  lb.put("resultsForLG1","Search results for");
  lb.put("prdsFrom","Προϊόντα");
  lb.put("prdsFromLG","Products");
  lb.put("prdsFromLG1","Products");
  lb.put("fromTotal","από σύνολο");
  lb.put("fromTotalLG","of total");
  lb.put("fromTotalLG1","of total");
  lb.put("pages","Σελίδες");
  lb.put("pagesLG","Pages");
  lb.put("pagesLG1","Pages");
  lb.put("pPage","Προηγούμενη");
  lb.put("pPageLG","Previous");
  lb.put("pPageLG1","Previous");
  lb.put("nPage","Επόμενη");
  lb.put("nPageLG","Next");
  lb.put("nPageLG1","Next");
  lb.put("noResults","Δεν βρέθηκαν εγγραφές.");
  lb.put("noResultsLG","We are sorry but no results were found.");
  lb.put("noResultsLG1","We are sorry but no results were found.");
  lb.put("searchTips","Πληροφορίες Αναζήτησης");
  lb.put("searchTipsLG","Search Tips");
  lb.put("searchTipsLG1","Search Tips");
  lb.put("spellingCheck","Κάντε ορθογραφικό έλεγχο");
  lb.put("spellingCheckLG","Double-check your spelling");
  lb.put("spellingCheckLG1","Double-check your spelling");
  lb.put("useWords","Χρησιμοποιήστε μία ή δύο λέξεις");
  lb.put("useWordsLG","Use only one or two words");
  lb.put("useWordsLG1","Use only one or two words");
  lb.put("featuredPrds","Προτάσεις");
  lb.put("featuredPrdsLG","Featured Products");
  lb.put("featuredPrdsLG1","Featured Products");
  lb.put("rootCat","Προϊόντα");
  lb.put("rootCatLG","Products");
  lb.put("rootCatLG1","Products");
  lb.put("addtocart","Αγορά");
  lb.put("addtocartLG","Buy");
  lb.put("seerec","Έχετε δει πρόσφατα");
  lb.put("seerecLG","Recently viewed");
  lb.put("pLabelNew","ΝΕΟ!");
  lb.put("pLabelNewLG","NEW!");
  lb.put("pLabelSale","ΠΡΟΣΦΟΡΑ!");
  lb.put("pLabelSaleLG","SALE!");
  lb.put("sortLabel","Ταξινόμηση");
  lb.put("sortLabelLG","Sort");
  lb.put("sortAscLabel","φθηνότερο -> ακριβότερο");
  lb.put("sortAscLabelLG","price ascending");
  lb.put("sortDescLabel","ακριβότερο -> φθηνότερο");
  lb.put("sortDescLabelLG","price descending");
  lb.put("itemsPerPageLabel","Προϊόντα ανα σελίδα");
  lb.put("itemsPerPageLabelLG","Items per page");
  lb.put("newfirstLabel","νέες αφίξεις");
  lb.put("newfirstLabelLG","new arrivals");
}
%>

<%
product_search.initBean(databaseId, request, response, this, session);
product_catalogue.initBean(databaseId, request, response, this, session);

int dispRows = 16, dispPageNumbers = 10;

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

String sortBy = "",
    sort = request.getParameter("sort"),
    pperpage = request.getParameter("pperpage");
    
if ("priceasc".equals(sort)) sortBy = "retailPrcEU ASC";
else if ("pricedesc".equals(sort)) sortBy = "retailPrcEU DESC";
else if ("newfirst".equals(sort)) sortBy = "prdCompFlag DESC";
else {sort = ""; sortBy = "retailPrcEU ASC";}

if ("32".equals(pperpage)) { dispRows = 32; pperpage = "32"; }
else if ("48".equals(pperpage)) { dispRows = 48; pperpage = "48"; }
else { dispRows = 16; pperpage = "16"; }

product_search.setSortedByCol(sortBy);
product_search.setSortedByOrder("");
product_search.setDispRows(dispRows);

DbRet dbRet = product_search.doAction(request);

if (dbRet.getNoError() == 0) {
    product_search.closeResources();
    pageContext.forward("/");
    return;
}

String action1 = request.getParameter("action1");

String catId = product_search.getCatId();

currentRowCount = product_search.getCurrentRowCount();
totalRowCount = product_search.getTotalRowCount();
totalPages = product_search.getTotalPages();
currentPage = product_search.getCurrentPage();

int startPage = 0, endPage = 0;

int start = product_search.getStart();

String htmlTitle = "", sef_url = "";

int category_path_length = 0;

if (catId.length() > 0) {
  category_path_length = product_catalogue.getCatPath(catId, "catId").getRetInt();
  for (int i=0; i<category_path_length; i++) {
    htmlTitle += product_catalogue.getColumn("catName" + lang);

    sef_url += SwissKnife.sefEncode( product_catalogue.getColumn("catName" + lang) ) + "/";

    if ( product_catalogue.nextRow() == true) htmlTitle += " - ";
  }
}
else htmlTitle = lb.get("rootCat" + lang).toString();
    
BigDecimal zero = new BigDecimal("0"), one = new BigDecimal("1");

PrdPrice prdPrice = null, hdPrice = null, oldPrice = null;

boolean isOffer = false;

request.setAttribute("catId",catId);

//if (totalRowCount == 1) {
  //response.sendRedirect( "/site/product/" + java.net.URLEncoder.encode( SwissKnife.sefEncode(product_search.getColumn("name" + lang)), "UTF-8") + "?prdId=" + product_search.getHexColumn("prdId") + "&extLang=" + lang );
  //return;
//}

String urlQuerySearch = "/site/search" + (sef_url.length() > 0 ? "/" + sef_url.substring(0,sef_url.length()-1) : "") + "?catId=" + SwissKnife.hexEscape(product_search.getCatId()) + "&amp;qid=" + SwissKnife.hexEscape(product_search.getQID()) + "&amp;spof=" + SwissKnife.hexEscape(product_search.getHotdealFlag()) + "&amp;newarr=" + SwissKnife.hexEscape(product_search.getPrdCompFlag()) + "&amp;fprd=" + SwissKnife.hexEscape(product_search.getPrdNewColl()) + "&amp;sort=" + SwissKnife.hexEscape(sort) + "&amp;pperpage=" + SwissKnife.hexEscape(pperpage) + "&amp;extLang=" + lang;
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <title><%=htmlTitle%></title>

  <style>
  .searchSort {margin:0 0 10px 0; float:right;}
  .searchSort select {
    font-size:11px;
    padding:0;
    height:18px;
    margin:0;
    width:155px;
  }
  .searchSort .pperpage {
    width:40px;
  }
  </style>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div class="container" id="contentContainer">
  
<%@ include file="/include/prd_catalog_path.jsp" %>

<div id="prdContainer" class="row">
  <div class="col-md-2">
    <%
    List<FacetValue> selectedFacetValues = null;
    List<Facet> facets = null;
    String facetsQuery = "";
    
    if (request.getAttribute("FACETED_SEARCH_ENABLED") != null && (Boolean) request.getAttribute("FACETED_SEARCH_ENABLED") == true) {%>
      <div id="swift-filters">
        <%
        facetsQuery = product_search.getFacetsQuery();

        if (product_search.isFacetedSearch()) {
          selectedFacetValues = FacetService.getFacetValuesFromQuery(facetsQuery);
        }

        facets = FacetService.getFacets(catId, request);
        for (Facet facet : facets) {
          out.println("<div class='filter-by-title'>" + facet.name + "</div><ul class='filter-by-content'>");
          for (FacetValue val : facet.facetValues) {
            String u = "";
            if (selectedFacetValues != null && selectedFacetValues.contains(val)) {
              u = urlQuerySearch + "&amp;facets=" + FacetService.removeFacetValueFromQuery(facetsQuery, val);
              out.println("<li><input name='filter' checked='' type='checkbox' data-url=\"" + u + "\"> <a style='color: red;' href='" + u + "'>" + val.name + "</a></li>");
            }
            else {
              u = urlQuerySearch + "&amp;facets=" + FacetService.addFacetValueToQuery(facetsQuery, val);
              out.println("<li><input name='filter' type='checkbox' data-url=\"" + u + "\"> <a href='" + u + "'>" + val.name + "</a></li>");
            }
          }
          out.println("</ul><hr/>");
        }
        %>
      </div>
      <script>
      $(document).ready(function() {
        $('#swift-filters input').click(function() {
          $(location).attr("href", $(this).data('url'));
        });
        $('#swift-filters .filter-by-title').click(function() {
          $(this).next().slideToggle();
          $(this).toggleClass("filter-by-title-collapsed");
        });
      });
      </script>
    <%}%>
    <div class="hidden-xs hidden-sm"><%@ include file="/include/product_catalog_left.jsp" %></div>
  </div>
  
  <div class="col-md-10">

    <%if (product_search.getQID().length()>0) {%>
      <div id="productSearchFor">
        <b><%= lb.get("resultsFor" + lang) %> "<%= product_search.getQID() %>"</b>
      </div>
    <%}%>
    
    <%
    if (request.getAttribute("FACETED_SEARCH_ENABLED") != null && (Boolean) request.getAttribute("FACETED_SEARCH_ENABLED") == true) {
      if (selectedFacetValues != null) {%>
        <div id="selectedFilters" class="clearfix">
        <%
        for (Facet facet : facets) {
          for (FacetValue val : facet.facetValues) {
            if (selectedFacetValues != null && selectedFacetValues.contains(val)) {
              String u = urlQuerySearch + "&amp;facets=" + FacetService.removeFacetValueFromQuery(facetsQuery, val);
              out.println("<a class='selected-filter' href='" + u + "'><i class='fa fa-times-circle' aria-hidden='true'></i> " + val.name + "</a>");
            }
          }
        }
        %>
        </div>
    <%
      }
    }
    %>
    
<%
if (totalRowCount > 0) {
    String prd_img = "", viewPrdPageURL = "";
%>
    <div class="row">
      <div class="col-xs-12">
      <div class="searchSort">
      <form id="searchSortForm" action="<%="/site/search" + (sef_url.length() > 0 ? "/" + sef_url.substring(0,sef_url.length()-1) : "")%>" method="get">
        <input name="qid" value="<%=product_search.getQID()%>" type="hidden"/>
        <input name="catId" value="<%=product_search.getCatId()%>" type="hidden">
        <input name="spof" value="<%=product_search.getHotdealFlag()%>" type="hidden">
        <input name="fprd" value="<%=product_search.getPrdNewColl()%>" type="hidden">
        <input name="newarr" value="<%=product_search.getPrdCompFlag()%>" type="hidden">
        <input name="facets" value="<%=facetsQuery%>" type="hidden">
        <input name="action1" value="SEARCH" type="hidden">

        <select name="sort" onchange="this.form.submit();" title="<%=lb.get("sortLabel" + lang)%>">
          <option value="" <%if ("".equals(sort)) out.print("selected");%>><%=lb.get("sortLabel" + lang)%></option>
          <option value="priceasc" <%if ("priceasc".equals(sort)) out.print("selected");%>><%=lb.get("sortAscLabel" + lang)%></option>
          <option value="pricedesc" <%if ("pricedesc".equals(sort)) out.print("selected");%>><%=lb.get("sortDescLabel" + lang)%></option>
          <option value="newfirst" <%if ("newfirst".equals(sort)) out.print("selected");%>><%=lb.get("newfirstLabel" + lang)%></option>
        </select>

        <select name="pperpage" class="pperpage" onchange="this.form.submit();" title="<%=lb.get("itemsPerPageLabel" + lang)%>">
          <option value="16" <%if ("16".equals(pperpage)) out.print("selected");%>>16</option>
          <option value="32" <%if ("32".equals(pperpage)) out.print("selected");%>>32</option>
          <option value="48" <%if ("48".equals(pperpage)) out.print("selected");%>>48</option>
        </select>
      </form>
      </div>
      </div> <!-- /col -->
    </div> <!-- /row -->
    
    <div id="productSearchListSection" class="row">
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

      viewPrdPageURL = "/site/product/" + SwissKnife.sefEncode(product_search.getColumn("name" + lang)) + "?prdId=" + product_search.getHexColumn("prdId") + "&amp;extLang=" + lang;

      if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + product_search.getColumn("prdId") + "-1.jpg")) {
        prd_img = "/prd_images/" + product_search.getColumn("prdId") + "-1.jpg";
      }
      else {
        prd_img = "/images/img_not_avail.jpg";
      }
    %>
      <div class="col-md-3 col-sm-4 col-xs-6 mb">
        <div class="item-box-image">
        <a href="<%=viewPrdPageURL%>"><img src="<%=prd_img%>" alt="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>" title="<%=product_search.getColumn("name" + lang).replace("\"", "&quot;")%>"/></a>

        <div class="product_labels">
        <%if (isOffer == true) {%><p><span class="heylabel sale"><%=lb.get("pLabelSale" + lang)%></span></p><%}%>
        <%if ("1".equals(product_search.getColumn("prdCompFlag"))) {%><p><span class="newlabel"><%=lb.get("pLabelNew" + lang)%></span></p><%}%>
        </div> <!-- /product_labels -->
        </div>
        <div class="item-box-content">
        <div class="item-box-bottom">
        <div class="item-box-price">
          <div class="item-box-addcart">
            <a href="<%=viewPrdPageURL%>"><span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span></a>
          </div>
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
      </div> <!-- /col -->
    <%
      product_search.nextRow();
    }%>
    </div> <!-- /productSearchListSection -->
    
    <div class="row">
      <div class="col-xs-12">
      <div class="searchSort hidden-xs">
      <form id="searchSortFormBtm" action="<%="/site/search" + (sef_url.length() > 0 ? "/" + sef_url.substring(0,sef_url.length()-1) : "")%>" method="get">
          <input name="qid" value="<%=product_search.getQID()%>" type="hidden"/>
          <input name="catId" value="<%=product_search.getCatId()%>" type="hidden">
          <input name="spof" value="<%=product_search.getHotdealFlag()%>" type="hidden">
          <input name="fprd" value="<%=product_search.getPrdNewColl()%>" type="hidden">
          <input name="newarr" value="<%=product_search.getPrdCompFlag()%>" type="hidden">
          <input name="facets" value="<%=facetsQuery%>" type="hidden">
          <input name="action1" value="SEARCH" type="hidden">

          <select name="sort" onchange="this.form.submit();" title="<%=lb.get("sortLabel" + lang)%>">
            <option value="" <%if ("".equals(sort)) out.print("selected");%>><%=lb.get("sortLabel" + lang)%></option>
            <option value="priceasc" <%if ("priceasc".equals(sort)) out.print("selected");%>><%=lb.get("sortAscLabel" + lang)%></option>
            <option value="pricedesc" <%if ("pricedesc".equals(sort)) out.print("selected");%>><%=lb.get("sortDescLabel" + lang)%></option>
            <option value="newfirst" <%if ("newfirst".equals(sort)) out.print("selected");%>><%=lb.get("newfirstLabel" + lang)%></option>
          </select>

          <select name="pperpage" class="pperpage" onchange="this.form.submit();" title="<%=lb.get("itemsPerPageLabel" + lang)%>">
            <option value="16" <%if ("16".equals(pperpage)) out.print("selected");%>>16</option>
            <option value="32" <%if ("32".equals(pperpage)) out.print("selected");%>>32</option>
            <option value="48" <%if ("48".equals(pperpage)) out.print("selected");%>>48</option>
          </select>
      </form>
      </div>
      </div> <!-- /col -->
    </div> <!-- /row -->
    
    <%
    if (totalPages > 1) {
    %>
        <div id="searchPagination">
        
        <table class="centerPagination">
        <tr><td align="center">
        <table class="pagination" align="center"><tr>
        <%
        if (currentPage > 1) { %>
            <td><a href="<%= urlQuerySearch + "&amp;facets=" + facetsQuery + "&amp;start=" + ((currentPage-2)*dispRows) %>"><b class="paginationArrows">&laquo;</b> <%= lb.get("pPage" + lang) %></a></td>
        <%
        }
        else { %>
            <td><a href="#" class="searchPreviousPage"><b class="paginationArrows">&laquo;</b> <%= lb.get("pPage" + lang) %></a></td>
        <%
        }
        
        startPage = currentPage - ((dispPageNumbers/2) - 1);
        
        if (startPage <= 1) {
            startPage = 1;
            
            endPage = startPage + (dispPageNumbers-1);
        }
        else {
            endPage = currentPage + (dispPageNumbers/2);
        }
        
        if (endPage >= totalPages) {
            endPage = totalPages;
            
            startPage = endPage - (dispPageNumbers-1);
            if (startPage <= 1) startPage = 1;
        }
        
        for (int i=startPage; i<=endPage; i++) {
            if (i == currentPage) { %>
                <td><a href="#" class="searchCurrentPage"><%= i %></a></td>
        <%  } else { %>
                <td class="hidden-xs"><a href="<%=urlQuerySearch + "&amp;facets=" + facetsQuery + "&amp;start=" + ((i-1)*dispRows)%>"><%=i%></a></td>
        <%  }
        }
        
        if (currentPage < totalPages) { %>
            <td><a href="<%=urlQuerySearch + "&amp;facets=" + facetsQuery + "&amp;start=" + (currentPage*dispRows)%>"><%= lb.get("nPage" + lang) %> <b class="paginationArrows">&raquo;</b></a></td>
        <%
        }
        else { %>
            <td><a href="#" class="searchNextPage"><%= lb.get("nPage" + lang) %> <b class="paginationArrows">&raquo;</b></a></td>
        <%
        } %>
        </tr></table>
        </td></tr></table>
        
        </div> <!-- end: searchPagination -->
<%
    }
}
else { %>
    <div><b><%= lb.get("noResults" + lang) %></b></div>
<% } %>

<%
if (recentlyViewedProducts.getSize() > 0) { %>
    <div id="rvpbox">
    <h3 id="rvpbox-title"><%=lb.get("seerec" + lang)%></h3>
    <div id="rvpbox-items-list" class="clearfix">
    <%
    String rvpViewURL = "", rvpPrdImg = "";
    
    for (int i=0; i<maxRecentlyViewedProducts; i++) {
        Product recentlyViewedProduct = recentlyViewedProducts.getProductAt(i);
        
        if (recentlyViewedProduct != null) {
            rvpViewURL = "/site/product/" + SwissKnife.sefEncode(recentlyViewedProduct.getPrdName()) + "?prdId=" + recentlyViewedProduct.getPrdId() + "&amp;extLang=" + lang;
            
            if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + recentlyViewedProduct.getPrdId() + "-1.jpg")) {
                rvpPrdImg = "/prd_images/" + recentlyViewedProduct.getPrdId() + "-1.jpg";
            }
            else {
                rvpPrdImg = "/images/img_not_avail.jpg";
            }
%>
        <div class="rvpbox-item <%if ( i == (maxRecentlyViewedProducts-1)) out.print("rvpbox-item-last");%>">
            <div class="rvpbox-item-image"><a href="<%=rvpViewURL%>"><img src="<%=rvpPrdImg%>" alt="<%=recentlyViewedProduct.getPrdName()%>" title="<%=recentlyViewedProduct.getPrdName()%>" width="80" height="80" /></a></div>
            <div class="rvpbox-item-name"><a href="<%=rvpViewURL%>"><%=recentlyViewedProduct.getPrdName()%></a></div>
            <div class="rvpbox-item-price"><%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? recentlyViewedProduct.getPrdPrice().getUnitNetCurr1() : recentlyViewedProduct.getPrdPrice().getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</div>
        </div>
<%
        }
    }
%>
    </div>
    </div>
<%
}
%>

</div> <!-- /col -->

</div> <!-- /prdContainer -->
</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

<%
product_search.closeResources();
product_catalogue.closeResources();
%>

</body>
</html>