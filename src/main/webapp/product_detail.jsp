<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/product_detail.jsp"; %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.product.v2.Present2_2" />

<jsp:useBean id="product_catalogue" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />

<%!
static Hashtable lb = new Hashtable();
static {
  lb.put("zoom","Μεγέθυνση");
  lb.put("zoomLG","Enlarge image");
  lb.put("zoomLG1","Enlarge image");

  lb.put("goback","Επιστροφή στην προηγούμενη σελίδα");
  lb.put("gobackLG","Back to Previous Page");
  lb.put("gobackLG1","Back to Previous Page");

  lb.put("rootCat","Προϊόντα");
  lb.put("rootCatLG","Products");
  lb.put("rootCatLG1","Products");

  lb.put("addcart","ΠΡΟΣΘΗΚΗ ΣΤΟ ΚΑΛΑΘΙ");
  lb.put("addcartLG","Add to Cart");
  lb.put("addcartLG1","Add to Cart");

  lb.put("addwishlist","Προσθήκη στη Wish List");
  lb.put("addwishlistLG","Add to Wish List");
  lb.put("addwishlistLG1","Add to Wish List");

  lb.put("prdCode","Κωδ.");
  lb.put("prdCodeLG","Code");
  lb.put("prdCodeLG1","Code");

  lb.put("productOptions","Επιλογές");
  lb.put("productOptionsLG","Options");
  lb.put("productOptionsLG1","Options");

  lb.put("productOptionsSelect","Επιλέξτε");
  lb.put("productOptionsSelectLG","Select");
  lb.put("productOptionsSelectLG1","Select");

  lb.put("productOptionsValue","Τιμή");
  lb.put("productOptionsValueLG","Price");
  lb.put("productOptionsValueLG1","Price");

  lb.put("choose_PRD_GiftWrap","Επιλέξτε για συσκευασία δώρου");
  lb.put("choose_PRD_GiftWrapLG","Gift wrap");
  lb.put("choose_PRD_GiftWrapLG1","Gift wrap");

  lb.put("jsSelectOption","Παρακαλούμε επιλέξτε μία από τις διαθέσιμες επιλογές.");
  lb.put("jsSelectOptionLG","Please select one of the available options.");
  lb.put("jsSelectOptionLG1","Please select one of the available options.");

  lb.put("addedwishlist","Προστέθηκε στη wish list σας");
  lb.put("addedwishlistLG","Added to your wish list");
  lb.put("addedwishlistLG1","Added to your wish list");
  lb.put("viewwishlist","Δείτε τη wish list");
  lb.put("viewwishlistLG","View your wish list");
  lb.put("viewwishlistLG1","View your wish list");

  lb.put("addedtoyourcart","Προστέθηκε στο καλάθι σας");
  lb.put("addedtoyourcartLG","Added to your cart");
  lb.put("itemsincart","προϊόντα στο καλάθι σας");
  lb.put("itemsincartLG","items in your cart");
  lb.put("totalCart","ΣΥΝΟΛΟ");
  lb.put("totalCartLG","TOTAL");
  lb.put("checkout","Ταμείο");
  lb.put("checkoutLG","Checkout");

  lb.put("seealso","Δείτε επίσης");
  lb.put("seealsoLG","See also");

  lb.put("availability","Διαθεσιμότητα");
  lb.put("availabilityLG","Availability");

  lb.put("manufact","Κατασκευαστής");
  lb.put("manufactLG","Brand");

  lb.put("availability_1","Σε απόθεμα");
  lb.put("availability_1LG","In stock");
  lb.put("availability_2","1 έως 3 ημέρες");
  lb.put("availability_2LG","1 to 3 days");
  lb.put("availability_3","4 έως 7 ημέρες");
  lb.put("availability_3LG","4 to 7 days");
  lb.put("availability_4","7+ ημέρες");
  lb.put("availability_4LG","7+ days");
  lb.put("availability_5","Κατόπιν Παραγγελίας");
  lb.put("availability_5LG","Upon Request");
  lb.put("availability_6","Προ-παραγγελία");
  lb.put("availability_6LG","Preorder");
    
  lb.put("pLabelNew","ΝΕΟ!");
  lb.put("pLabelNewLG","NEW!");
  lb.put("pLabelSale","ΠΡΟΣΦΟΡΑ!");
  lb.put("pLabelSaleLG","SALE!");
  
  lb.put("priceStart","από");
  lb.put("priceStartLG","from");
  lb.put("priceNow","τώρα");
  lb.put("priceNowLG","now");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);
product_catalogue.initBean(databaseId, request, response, this, session);

Product product = null;

String prdId = request.getParameter("prdId"), catId = request.getParameter("catId");

BigDecimal zero = new BigDecimal("0"), one = new BigDecimal("1");

PrdPrice prdPrice = null, hdPrice = null, oldPrice = null;

boolean isOffer = false;

DbRet dbRet = null;

dbRet = helperBean.getPrd(prdId, SwissKnife.jndiLookup("swconf/inventoryType"));
if (dbRet.getNoError() == 0 || dbRet.getRetInt() <= 0) {
    helperBean.closeResources();
    pageContext.forward("/problem.jsp");
    return;
}

ProductOptions productOptions = ProductOptions.getProductOptions(prdId);

if (catId == null || catId.length() == 0) catId = helperBean.getColumn("PINCCatId");

request.setAttribute("catId",catId);

String htmlTitle = "";

int category_path_length = 0;

if (catId.length() > 0) {
    category_path_length = product_catalogue.getCatPath(catId, "catId").getRetInt();
    for (int i=0; i<category_path_length; i++) {
        htmlTitle += product_catalogue.getColumn("catName" + lang);
        if ( product_catalogue.nextRow() == true) htmlTitle += " - ";
    }
}

htmlTitle += " - " + helperBean.getColumn("name" + lang);
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= htmlTitle %></title>
    
    <link rel="stylesheet" type="text/css" href="/css/product_detail.css" />
    <link rel="stylesheet" type="text/css" href="/css/magiczoomplus.css" />
    
    <script type="text/javascript" src="/js/magiczoomplus.js"></script>
    <script type="text/javascript">
      $(document).ready(function() {
        
        $("#zoomButton").click(function(e) { 
          e.preventDefault();
          MagicZoomPlus.expand('item_gallery');
        });
        
      });
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer">
  
<%@ include file="/include/prd_catalog_path.jsp" %>
    
<div id="prdContainer" class="clearfix">

<%@ include file="/include/product_catalog_left.jsp" %>

<div id="productMain">
    
    <div style="float:right; margin-right:231px;">
    <div id="minicart">
	<div id="minicart-content">
		<div id="minicart-error" class="errors" style="display: none;"><p>[minicart_error]</p></div>
                <div class="titleBar"><a id="closebtn" href="#" class="showMiniCart closeX">Close</a> <%=lb.get("addedtoyourcart" + lang)%></div>
		<div class="minicart-content-wrapper">
                        
			<div id="minicart-lines">
                            <div class="minicart-line">
                                <div class="minicart-line-content">
                                    <div class="minicart-product-line">
                                        <div class="minicart-img"><span class="itemImage"><img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" alt="" height="80" width="80"/></span></div>
                                        <div class="minicart-details">

                                                <h2><span class="itemName"></span></h2>
                                                <div class="minicart-data-list">
                                                        <ul class="minicart-line-content-details"><li></li></ul>
                                                        <div id="minicart-qty">: <strong>__itemQuantity__</strong></div>
                                                </div>
                                                <div class="minicart-unit-price"><span class="itemPrice"></span></div>
                                        </div>
                                    </div>
                                    <div class="minicart-total-price"></div>
                                </div>
                            </div>
			</div>
                        
			<div id="minicart-summary">
                            <div><span id="minicartTotalQty"></span>&nbsp;<%=lb.get("itemsincart" + lang)%></div>
                            <div class="subtotal"><%=lb.get("totalCart" + lang)%>: <span id="minicartSubtotal"></span></div>
			</div>
                        
			<div id="minicart-footer">
                            <a href="/shopping_cart.jsp" class="button-sec checkout"><span><%=lb.get("checkout" + lang)%></span></a>
			</div>
		</div>

	</div>
    </div>
    </div>

<%
String prd_img = "", zoom_prd_img = "";

if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + helperBean.getColumn("prdId") + "-1.jpg")) {
    prd_img = "/prd_images/" + helperBean.getColumn("prdId") + "-1.jpg";
}
else {
    prd_img = "/images/img_not_avail.jpg";
}

if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + helperBean.getColumn("prdId") + "-1z.jpg")) {
    zoom_prd_img = "/prd_images/" + helperBean.getColumn("prdId") + "-1z.jpg";
}

prdPrice = null;

isOffer = false;

if (PriceChecker.isOffer(helperBean.getQueryDataSet(),customerType)) {
    isOffer = true;
    hdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,isOffer,customer.getDiscountPct());

    oldPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,false,customer.getDiscountPct());
}
prdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,false,customer.getDiscountPct());

if (isOffer == true) {
    product = new Product(helperBean.getColumn("prdId"),one,hdPrice,isOffer);
}
else {
    product = new Product(helperBean.getColumn("prdId"),one,prdPrice,isOffer);
}

product.setPrdName(helperBean.getColumn("name" + lang));
product.setWeight(helperBean.getBig("weight"));
product.setImg(helperBean.getColumn("img"));
product.setImg2(helperBean.getColumn("img2"));
recentlyViewedProducts.addProduct(product);

String s_price = null, s_hdPrice = null, s_oldPrice = null;
if (gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL == customerType) {
    s_price = SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
    
    if (isOffer == true) {
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

boolean hasTabs = false;
for (int i=1; i<=5; i++) {
    if (helperBean.getColumn("text" + i + "Title" + lang).length()>0) {
        hasTabs = true;
        break;
    }
}
%>

    <script type="text/javascript">
    //var jsonData = {'minicart-total-qty': 5, 'itemImage': '/prd_images/50496-1.jpg'}
      
    var directive = {'#minicartSubtotal':'minicartSubtotal', '#minicartTotalQty':'minicartTotalQty', '.itemImage img@src':'itemImage', '.itemName':'itemName', '.itemPrice':'itemPrice'};
    
    var directiveWishList = {'.itemImage img@src':'itemImage', '.itemName':'itemName'};
        
    $(function() {
        $('.alternative-view-box img').click(function(e){
            //e.preventDefault();
            
            //$('.preImage').hide();
            
            //$('.preImage').attr('src', $(this).attr('src'));
            
            $('.alternative-view-box').removeClass('selected');
            $(this).parent().addClass('alternative-view-box selected');
            
            //$('.active-view a, .imagebox-zoom-control a').attr('href', $(this).parent().attr('href'));
            
            //$('.preImage').show();
        });
        
        $('.addtocart').click(function(e) {
            e.preventDefault();
            
            var PO_Code = '';
            
            if ( $('#PO_Code').length > 0) {
              if ( $('#PO_Code option:selected').val().length > 0) {
                PO_Code = $('#PO_Code option:selected').val();
              }
              else {
                alert('<%= lb.get("jsSelectOption" + lang) %>');
                return false;
              }
            }
          
            var prdId = $('#prdForm input[name=prdId]');
            var action1 = $('#prdForm input[name=action1]');
            
            var PRD_GiftWrap = '';
            if ( $('#prdForm input[name=PRD_GiftWrap]').attr('checked') == true) PRD_GiftWrap = '1';
        
            data = 'action1=' + action1.val() + '&prdId=' + encodeURIComponent(prdId.val()) + '&PRD_GiftWrap=' + encodeURIComponent(PRD_GiftWrap) + '&PO_Code=' + encodeURIComponent(PO_Code);
            
            $.ajax({
              type: 'POST',
              url: '/ajax_shop_cart.jsp',
              data: data,
              success: function (jsonData) {
                  updateMinicartBar(jsonData.minicartTotalQty, jsonData.minicartSubtotal, '1');
                  
                  $('.minicart-content-wrapper').render(jsonData, directive);
                  $('#minicart-content').slideDown(1000);
                  setTimeout(function(){$('#minicart-content').slideUp(1000);},5000);
              },
              dataType: 'json'
            });
      });
      
      $('.addtowishlist').click(function(e) {
            e.preventDefault();
            
            var PO_Code = '';
            
            if ( $('#PO_Code').length > 0) {
              if ( $('#PO_Code option:selected').val().length > 0) {
                PO_Code = $('#PO_Code option:selected').val();
              }
              else {
                alert('<%= lb.get("jsSelectOption" + lang) %>');
                return false;
              }
            }
          
            var prdId = $('#prdForm input[name=prdId]');
            var action1 = 'WISH_LIST_ADD';
        
            data = 'action1=' + action1 + '&prdId=' + encodeURIComponent(prdId.val()) + '&PO_Code=' + encodeURIComponent(PO_Code);
            
            $.ajax({
              type: 'POST',
              url: '/ajax_shop_cart.jsp',
              data: data,
              success: function (jsonData) {
                  $('.miniwishlist-content-wrapper').render(jsonData, directiveWishList);
                  $('#miniwishlist-content').slideDown(1000);
                  setTimeout(function(){$('#miniwishlist-content').slideUp(1000);},5000);
              },
              dataType: 'json'
            });
      });
      
      $('#closebtn').click(function(e) {
          e.preventDefault();

          $('#minicart-content').slideUp(1000);
      });
      
      $('#closebtnWishList').click(function(e) {
          e.preventDefault();

          $('#miniwishlist-content').slideUp(1000);
      });
       
    });
    
    <%
    if (hasTabs == true) { %>
      $(function() {
        //Default Action
        $(".tab_content").hide(); //Hide all content
        $("ul.tabs li:first").addClass("active").show(); //Activate first tab
        $(".tab_content:first").show(); //Show first tab content

        //On Click Event
        $("ul.tabs li").click(function() {
          $("ul.tabs li").removeClass("active"); //Remove any "active" class
          $(this).addClass("active"); //Add "active" class to selected tab
          $(".tab_content").hide(); //Hide all tab content
          var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
          $(activeTab).fadeIn(); //Fade in the active content
          return false;
        });
      });
    <% } %>
    </script>
    
    <div>
        <form id="prdForm" name="prdForm" method="post" action="<%= "http://" + serverName + "/" + response.encodeURL("shopping_cart.jsp") %>">

        <div>
        <input name="prdId" type="hidden" value="<%= helperBean.getHexColumn("prdId") %>" />
        <input name="action1" type="hidden" value="CART_ADD" />
        </div>
        
        <div id="item-main" class="clearfix">
            
        <div class="item-images clearfix">

        <img class="visible-xs" src="<%=prd_img%>" style="width:100%;" alt="<%=helperBean.getColumn("name" + lang).replace("\"", "&quot;")%>"/>
        
        <div id="item-views">
        <div class="active-view" style="position: relative;">
            <a id="item_gallery" href="<%=zoom_prd_img%>" class="MagicZoomPlus" rel="opacity:80;zoom-width:410px;zoom-height:410px;hint:false;show-title:false;opacity-reverse:true;zoom-distance:20px;zoom-align:center;top:200px;pan-zoom:false"><img class="preImage" src="<%=prd_img%>" alt="<%=helperBean.getColumn("name" + lang).replace("\"", "&quot;")%>" width="320" height="320" /></a>
            
            <div class="product_labels">
              <%if (isOffer == true) {%><p><span class="heylabel sale"><%=lb.get("pLabelSale" + lang)%></span></p><%}%>
              <%if ("1".equals(helperBean.getColumn("prdCompFlag"))) {%><p><span class="newlabel"><%=lb.get("pLabelNew" + lang)%></span></p><%}%>
              </div> <!-- /product_labels -->
            </div>
        <div class="controls-wrp clearfix">

          <div class="imagebox-zoom-control"><a id="zoomButton" href="<%=zoom_prd_img%>" style="float: right;">+ Zoom</a></div>
          <br style="clear: both;"/>
          <div class="alternative-wrp">

          <div class="alternative-view">
              <a href="<%=zoom_prd_img%>" rel="zoom-id:item_gallery" rev="<%=prd_img%>" class="alternative-view-box selected first"><img src="<%=prd_img%>" width="70" height="70" alt="thumbnail"/></a>
              <%
              int prdImagesFound = 1;
              
              for (int i=2; i<=8; i++) {
                  if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + helperBean.getColumn("prdId") + "-" + i + ".jpg")) {
                      prdImagesFound++;
                      
                      prd_img = "/prd_images/" + helperBean.getColumn("prdId") + "-" + i + ".jpg";

                      if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + helperBean.getColumn("prdId") + "-" + i + "z.jpg")) {
                          zoom_prd_img = "/prd_images/" + helperBean.getColumn("prdId") + "-" + i + "z.jpg";
                      }
                      else zoom_prd_img = "";
              %>
                      <%if (prdImagesFound == 5) {%><br style="clear: both;"/><%}%>
                      <a href="<%=zoom_prd_img%>" rel="zoom-id:item_gallery" rev="<%=prd_img%>" class="alternative-view-box <%if (prdImagesFound == 5) {out.print("first"); prdImagesFound = 1;}%>"><img src="<%=prd_img%>" width="70" height="70" alt="<%=helperBean.getColumn("name" + lang).replace("\"", "&quot;")%>"/></a>
              <%
                  }
              }
              %>
          </div>

          </div>
        </div>
        </div>
        
        </div> <!-- end: item-images -->
      
        <div class="item-options clearfix">

        <h2 style="line-height: 22px;"><%= helperBean.getColumn("name" + lang)%></h2>
        
            <div style="margin:10px 0 5px 0;"><%= lb.get("prdCode" + lang)%>: <%=helperBean.getColumn("prdId")%></div>
            
            <%if (helperBean.getColumn("prdHomePageLink").length() > 0) {%><div style="margin:10px 0 5px 0;"><%=lb.get("manufact" + lang)%>: <%=helperBean.getColumn("prdHomePageLink")%></div><%}%>
            
            <div style="border-bottom:dotted 1px #696464;" class="clearfix hidden-xs">
            <div style="float:right; margin-bottom:5px;">
            <!-- AddThis Button BEGIN -->
            <div class="addthis_toolbox addthis_default_style">
            <a class="addthis_button_facebook_like" fb:like:width="125" fb:like:layout="button_count" ></a>
            <a class="addthis_button_google_plusone" g:plusone:annotation="none"></a>
            <a class="addthis_button_twitter"></a>
            <a class="addthis_button_email"></a>
            <a class="addthis_button_print"></a>
            <a class="addthis_button_compact"></a>
            <a class="addthis_counter addthis_bubble_style"></a>
            </div>
            <!-- AddThis Button END -->
            </div>
            </div>
        
            <div style="margin:8px 0 10px 0;" class="clearfix"><%= helperBean.getColumn("descr" + lang)%></div>
            
            <%
            String prdAvailability = helperBean.getColumn("prdAvailability");
            %>
            
            <%if (prdAvailability.length() > 0) {%><div style="margin:8px 0 10px 0;"><%=lb.get("availability" + lang)%>: <%=lb.get("availability_" + prdAvailability + lang)%></div><%}%>
            
            <div style="margin-bottom:20px">
            <%
            if (isOffer == true) { %>
              <h3 style="font-size:14px;"><strike><%=s_oldPrice%> &nbsp;&euro;</strike> <span style="font-size:22px;"><%=s_hdPrice%>&nbsp;&euro;</span></h3>
            <%
            } else { %>
              <h3 style="font-size:22px;"><%=s_price%>&nbsp;&euro;</h3>
            <% } %>
            </div>
            
            <%
            if (productOptions != null) { %>
              <div style="margin-bottom:10px;">
                
              <select id="PO_Code" name="PO_Code">
              <option value=""><%=lb.get("productOptions" + lang)%></option>
              <%
              String po_s_oldPrice = null, po_s_hdPrice = null, po_s_price = null;
              
              while (productOptions.inBounds() == true) {
                ProductOptionsValue productOptionsValue = productOptions.getProductOptionsValue();
                
                hdPrice = null;
                oldPrice = null;
                prdPrice = null;
                
                po_s_oldPrice = null;
                po_s_hdPrice = null;
                po_s_price = null;
                
                if (PriceChecker.isOffer(helperBean.getQueryDataSet(),customerType)) {
                    isOffer = true;
                    hdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),productOptionsValue,customerType,isOffer,customer.getDiscountPct());

                    oldPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),productOptionsValue,customerType,false,customer.getDiscountPct());
                }
                prdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),productOptionsValue,customerType,false,customer.getDiscountPct());

                if (gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL == customerType) {
                  if (prdPrice.getUnitGrossCurr1().compareTo(zero) == 1) po_s_price = SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);

                  if (isOffer == true && hdPrice.getUnitGrossCurr1().compareTo(zero) == 1) {
                      po_s_oldPrice = SwissKnife.formatNumber(oldPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                      po_s_hdPrice = SwissKnife.formatNumber(hdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                  }
                }
                else if (gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType) {
                  if (prdPrice.getUnitNetCurr1().compareTo(zero) == 1) po_s_price = SwissKnife.formatNumber(prdPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);

                    if (isOffer == true) {
                        po_s_oldPrice = SwissKnife.formatNumber(oldPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                        po_s_hdPrice = SwissKnife.formatNumber(hdPrice.getUnitNetCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale);
                    }
                }
                
                //if ( (s_oldPrice != null && s_oldPrice.equals(po_s_oldPrice)) && DISP_EQUAL_OPTIONS_PRICE == false) po_s_oldPrice = null;
                //if ( (s_hdPrice != null && s_hdPrice.equals(po_s_hdPrice)) && DISP_EQUAL_OPTIONS_PRICE == false) po_s_hdPrice = null;
                //if ( (s_price != null && s_price.equals(po_s_price)) && DISP_EQUAL_OPTIONS_PRICE == false) po_s_price = null;
              %>
              <option value="<%=productOptionsValue.getPO_Code()%>"><%=productOptionsValue.getValue("PO_Name" + lang)%><% if (po_s_hdPrice != null || po_s_price != null) {%>&nbsp;-&nbsp;<%if (isOffer == true && po_s_hdPrice != null) {%><h1><%=lb.get("priceStart" + lang)%>&nbsp;<%=po_s_oldPrice%>&nbsp;&euro;&nbsp;<%=lb.get("priceNow" + lang)%>&nbsp;<%=po_s_hdPrice%>&nbsp;&euro;</h1><% } else if (po_s_price != null) {%><h1><%=po_s_price%>&nbsp;&euro;</h1><%} }%></option>
              <%
                productOptions.next();
              }
              %>
              </select>
              
              </div>
            <%
            } %>
      
      <div style="margin-top:10px;" class="clearfix">
          <div style="float:left;"><a class="addtocart" href="#"><img style="display:inline; vertical-align:middle;" src="/images/add_cart_button_small<%= lang%>.png" alt="<%= lb.get("addcart" + lang)%>" title="<%= lb.get("addcart" + lang)%>" /></a></div>
          <div class="addtocart_textbtn"><a class="addtocart" href="#"><%= lb.get("addcart" + lang)%></a></div>
      </div>
      
      <%
      if ("1".equals(helperBean.getColumn("PRD_GiftWrapAvail"))) {%>
        <div id="item-PRD_GiftWrap"><input type="checkbox" name="PRD_GiftWrap" value="1"/>&nbsp;&nbsp;<%= lb.get("choose_PRD_GiftWrap" + lang)%> (+<%=SwissKnife.formatNumber(helperBean.getBig("giftPrcEU"),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%> &euro;)</div>
      <% } %>
      
        <div id="wishlist-btn" style="float:left; margin-top:20px;">
            <img style="display:inline; vertical-align:middle;" src="/images/favorites_add.png" alt="<%=lb.get("addwishlist" + lang)%>"/>
            <%
            if (customer.isSignedIn() == true) { %>
                <a class="addtowishlist" href="#"><%=lb.get("addwishlist" + lang)%></a>
            <%
            }
            else { %>
                <a href="<%= HTTP_PROTOCOL + serverName + "/" + response.encodeURL("customer_signin.jsp")%>"><%=lb.get("addwishlist" + lang)%></a>
            <% } %>
        </div>
        <div id="miniwishlist">
        <div id="miniwishlist-content">
            <div class="titleBar"><a id="closebtnWishList" href="#" class="closeX">Close</a> <%=lb.get("addedwishlist" + lang)%></div>
            <div class="miniwishlist-content-wrapper">
                <div id="miniwishlist-lines">
                    <div class="miniwishlist-line-content">
                        <div class="miniwishlist-product-line">
                            <div class="miniwishlist-img"><span class="itemImage"><img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" alt="" height="80" width="80" /></span></div>
                            <div class="miniwishlist-details">
                                    <h2><span class="itemName"></span></h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="miniwishlist-footer">
                    <a href="/wishlist.jsp" class="miniwishlistViewBtn"><%=lb.get("viewwishlist" + lang)%></a>
                </div>
            </div>

        </div>
        </div>

      </div> <!-- end: item-options -->
      
      </div> <!-- end: item-main -->
      
      <%
      if (hasTabs == true) { %>
          <div class="item-tabs">
            <ul class="tabs">
                <%
                for (int i=1; i<=5; i++) { 
                    if (helperBean.getColumn("text" + i + "Title" + lang).length()>0) { %>
                        <li><a href="#tab<%=i%>"><%=helperBean.getColumn("text" + i + "Title" + lang)%></a></li>
                <% 
                    }
                } %>
            </ul>
            <%
            for (int i=1; i<=5; i++) { 
                if (helperBean.getColumn("text" + i + lang).length()>0) { %>
                    <div class="tab_content" id="tab<%=i%>"><%=helperBean.getColumn("text" + i + lang)%></div>
            <% 
                }
            } %>
          </div>
      <% } %>
      
      </form>
      
    <%
    int relPrds = helperBean.getRelatedPrds(prdId,SwissKnife.jndiLookup("swconf/inventoryType"),7," deliveryDays DESC, name" + lang + " ASC").getRetInt();
    
    if (relPrds > 0) { %>
        <div id="rvpbox">
        <h3 id="rvpbox-title"><%=lb.get("seealso" + lang)%></h3>
        <div id="rvpbox-items-list" class="clearfix">
        <%
        prdPrice = null; hdPrice = null; oldPrice = null;

        isOffer = false;
    
        String rvpViewURL = "", rvpPrdImg = "";

        for (int i=0; i<relPrds; i++) {
            prdPrice = null;

            isOffer = false;

            if (PriceChecker.isOffer(helperBean.getQueryDataSet(),customerType)) {
                isOffer = true;
                hdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,isOffer,customer.getDiscountPct());

                oldPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,false,customer.getDiscountPct());
            }
            prdPrice = PriceChecker.calcPrd(one,helperBean.getQueryDataSet(),customerType,false,customer.getDiscountPct());

            rvpViewURL = "http://" + serverName + "/site/product/" + SwissKnife.sefEncode(helperBean.getColumn("name" + lang)) + "?prdId=" + helperBean.getColumn("prdId") + "&amp;extLang=" + lang;

            if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + helperBean.getColumn("prdId") + "-1.jpg")) {
                rvpPrdImg = "/prd_images/" + helperBean.getColumn("prdId") + "-1.jpg";
            }
            else {
                rvpPrdImg = "/images/img_not_avail.jpg";
            }
        %>
            <div class="rvpbox-item <%if ( i == (relPrds-1)) out.print("rvpbox-item-last");%>">
                <div class="rvpbox-item-image"><a href="<%=rvpViewURL%>"><img src="<%=rvpPrdImg%>" alt="<%=helperBean.getColumn("name" + lang)%>" title="<%=helperBean.getColumn("name" + lang)%>" width="80" height="80" /></a></div>
                <div class="rvpbox-item-name"><a href="<%=rvpViewURL%>"><%=helperBean.getColumn("name" + lang)%></a></div>
                <div class="rvpbox-item-price">
                    <%
                    if (isOffer == true) { %>
                        <span style="text-decoration:line-through;"><%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? oldPrice.getUnitNetCurr1() : oldPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%></span> &euro;<br/><%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? hdPrice.getUnitNetCurr1() : hdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
                    <%
                    } else { %>
                        <%= SwissKnife.formatNumber(gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_WHOLESALE == customerType ? prdPrice.getUnitNetCurr1() : prdPrice.getUnitGrossCurr1(), localeLanguage, localeCountry, minCurr1DispFractionDigits, curr1DisplayScale)%> &euro;
                    <% } %>
                </div>
            </div>
    <%
            helperBean.nextRow();
        }
    %>
        </div>
        </div>
    <%
    }
    %>
    </div>

</div> <!-- end: productMain -->

</div> <!-- end: prdContainer -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

<%
helperBean.closeResources();
product_catalogue.closeResources();
%>

<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#async=1"></script>
<script type="text/javascript">
var addthis_config = {
  ui_use_css : false
}
$(document).ready(function(){addthis.init()});
</script>

</body>
</html>