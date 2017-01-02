<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="top_jsp_prdCatMenu" scope="page" class="gr.softways.dev.eshop.category.v2.PrdCategoryMenu2" />
<jsp:useBean id="top_jsp_menu" scope="page" class="gr.softways.dev.swift.cmcategory.v1.Menu2" />

<%!
static HashMap top_jsp_lb = new HashMap();
static {
  top_jsp_lb.put("allprds","Όλα τα προϊόντα");
  top_jsp_lb.put("allprdsLG","All products");

  top_jsp_lb.put("prdTitle","Προϊόντα");
  top_jsp_lb.put("prdTitleLG","Products");

  top_jsp_lb.put("menuTitle","Επιλογές");
  top_jsp_lb.put("menuTitleLG","Menu");

  top_jsp_lb.put("productSearch","Αναζήτηση προϊόντων");
  top_jsp_lb.put("productSearchLG","Search products");

  top_jsp_lb.put("shoppingCart","Καλάθι αγορών");
  top_jsp_lb.put("shoppingCartLG","Shopping cart");
  top_jsp_lb.put("myAccount","Ο Λογαριασμός μου");
  top_jsp_lb.put("myAccountLG","My Account");
  top_jsp_lb.put("signin","Είσοδος πελατών");
  top_jsp_lb.put("signinLG","Sign in");
  top_jsp_lb.put("signout","έξοδος");
  top_jsp_lb.put("signoutLG","sign out");

  top_jsp_lb.put("items","προϊόντα - ");
  top_jsp_lb.put("itemsLG","items - ");
  
  top_jsp_lb.put("showAllCat","Δείτε όλες τις κατηγορίες");
  top_jsp_lb.put("showAllCatLG","Show all categories");
  
  top_jsp_lb.put("showAllCatFly","Όλες οι κατηγορίες");
  top_jsp_lb.put("showAllCatFlyLG","All categories");
}
%>

<%
top_jsp_prdCatMenu.initBean(databaseId, request, response, this, session);
top_jsp_menu.initBean(databaseId, request, response, this, session);

String prd_catalogue_left_catId = (String) request.getAttribute("catId");

if (prd_catalogue_left_catId == null) prd_catalogue_left_catId = "";

top_jsp_prdCatMenu.getMenu("", lang);
top_jsp_prdCatMenu.closeResources();

top_jsp_menu.getMenu("20", lang);
top_jsp_menu.closeResources();

int top_jsp_prdCatMenuLength = top_jsp_prdCatMenu.getMenuLength();
int top_jsp_menuLength = top_jsp_menu.getMenuLength();

int menuLevel = 0;
String top_MenuURL = "";
%>

<div id="headerWrapper">
  <div><form name="langForm" method="post" action="#"><input type="hidden" name="lang" value="" /></form></div>
  <div><noscript><a href="<%="http://" + serverName + "/?extLang="%>">ΕΛΛΗΝΙΚΑ</a></noscript></div>
  <div><noscript><a href="<%="http://" + serverName + "/?extLang=LG"%>">ENGLISH</a></noscript></div>
  
  <div id="headerContainer">
  
    <div class="container" id="header">

      <div class="row">
        <div class="col-md-4 col-sm-5 col-xs-12"><div id="headerLogo"><a href="<%="http://" + serverName + "/"%>"><img src="/images/logo<%= lang %>.png" alt="logo" style="width: 100%;"/></a></div></div>
        
        <div class="col-md-8 col-sm-7 col-xs-12">
          <div style="float:right;">
          <div id="fastMenu">
          <ul>
              <%
              if (customer.isSignedIn() == false) { %>
                <li class="first"><a href="<%= HTTP_PROTOCOL + serverName + "/customer_signin.jsp"%>"><span class="glyphicon glyphicon-lock" aria-hidden="true"></span> <%=top_jsp_lb.get("signin" + lang)%></a></li>
              <%
              }
              else { %>
                <li class="first"><span class="glyphicon glyphicon-user" aria-hidden="true"></span> <a href="<%= "http://" + serverName + "/" + "customer_myaccount.jsp"%>"><%=authUsername%></a>&nbsp;&nbsp;&nbsp;<span>[ <a href="<%= "http://" + serverName + "/" + "customer.do?cmd=signout"%>"><%=top_jsp_lb.get("signout" + lang)%></a> ]</span></li>
              <%
              }
              %>
              <li><a href="/wishlist.jsp"><span style="color: red;" class="glyphicon glyphicon-heart" aria-hidden="true"></span> Wish List</a></li>
          </ul>
          </div>
          <div id="langSelector">
            <div id="topLangSel"><% if (!lang.equals("")) {%><a href="javascript:document.langForm.lang.value='';document.langForm.submit();void(0);"><%}%><img src="/images/flag.png" alt="Ελληνικά" title="Ελληνικά" /><% if (!lang.equals("")) { %></a><% } %></div>
            <div id="topLangLGSel"><% if (!lang.equals("LG")) {%><a href="javascript:document.langForm.lang.value='LG';document.langForm.submit();void(0);"><%}%><img src="/images/flagLG.png" alt="English" title="English" /><% if (!lang.equals("LG")) { %></a><% } %></div>  
          </div>
          </div>
        </div>
          
        <div class="col-xs-12">
          <div class="row">
            <div class="col-xs-6">
              <div id="product-search-top" class="pull-right">
             
              <style>.stylish-input-group .input-group-addon{
    background: white !important; 
}
.stylish-input-group .form-control{
	border-right:0; 
	box-shadow:0 0 0; 
	border-color:#ccc;
}
.stylish-input-group button{
    border:0;
    background:transparent;
                }</style>
                <form id="searchForm" name="searchForm" action="/site/search" method="get">
                <div class="input-group stylish-input-group">
                    <input id="qid" name="qid" type="text" class="form-control typeahead" placeholder="Search">
                    <span class="input-group-addon">
                        <button type="submit">
                            <span class="glyphicon glyphicon-search"></span>
                        </button>  
                    </span>
                </div>
                  </form>
              
              </div>
                
            </div>
            <div class="col-xs-6">
              <div id="minicartBar"><img src="/images/cart.png" alt="" style="display:inline; vertical-align:middle;"/><a href="/shopping_cart.jsp"><span class="hidden-xs"><%=top_jsp_lb.get("shoppingCart" + lang)%>: </span><span id="minicartBarQuan"></span>&nbsp;<span id="minicartBarItemWord"><%=top_jsp_lb.get("items" + lang)%></span> <span id="minicartBarSubtotal"></span></a></div>
            </div>
          </div>
        </div>
      </div> <!-- /row -->
      
      
  <div class="row">
    <%@ include file="/include/top_menu.jsp" %>
  </div> <!-- /row -->
</div> <!-- /header -->

</div> <!-- /headerContainer -->

</div> <!-- /headerWrapper -->

<%
String top_jsp_catId = "", top_jsp_CMCCode = "", top_img_code = "", top_jsp_bg_id = "";

if (request.getAttribute("CMCCode") != null) top_jsp_CMCCode = request.getAttribute("CMCCode").toString();

if (request.getAttribute("catId") != null) top_jsp_catId = request.getAttribute("catId").toString();
if ( ("/product_catalog.jsp".equals(whereAmI) && top_jsp_catId.length() == 0) || ("/product_search.jsp".equals(whereAmI) && top_jsp_catId.length() == 0) ) top_jsp_catId = "__";

if (top_jsp_catId.length()>0) {
    top_img_code = top_jsp_catId;
    top_jsp_bg_id = "_cid";
}
else if (top_jsp_CMCCode.length()>0) top_img_code = top_jsp_CMCCode;

if ( (top_jsp_path != null && top_jsp_path.length()>0) || top_jsp_catId.length()>0) {
    String bg_top_img = "bg_top.jpg";
    boolean bg_top_img_exists = false;
    
    if (top_img_code.length() > 6) top_img_code = top_img_code.substring(0,6);
    
    if ( (bg_top_img_exists = SwissKnife.fileExists(wwwrootFilePath + "/images/bg_top" + top_jsp_bg_id + top_img_code + ".jpg")) == true) bg_top_img = "bg_top" + top_jsp_bg_id + top_img_code + ".jpg";
    
    if (bg_top_img_exists == false && top_img_code.length() > 4) {
        top_img_code = top_img_code.substring(0,4);
        
        if ( (bg_top_img_exists = SwissKnife.fileExists(wwwrootFilePath + "/images/bg_top" + top_jsp_bg_id + top_img_code + ".jpg")) == true) bg_top_img = "bg_top" + top_jsp_bg_id + top_img_code + ".jpg";
    }
    
    if (bg_top_img_exists == false && top_img_code.length() > 2) {
        top_img_code = top_img_code.substring(0,2);

        if (SwissKnife.fileExists(wwwrootFilePath + "/images/bg_top" + top_jsp_bg_id + top_img_code + ".jpg")) bg_top_img = "bg_top" + top_jsp_bg_id + top_img_code + ".jpg";
    }
%>
    <%--<div id="topMenuPath" class="clearfix" style="background:url('/images/<%=bg_top_img%>') no-repeat;">
        <% if (top_jsp_path.length()>0) {%><div style="float:right; height:40px; margin:140px 0 0 0; background:url('/images/bg_top_path_title.png') repeat-x;"><h6 style="font-size:16px;font-weight:normal;color:#ffffff;margin:11px 25px 0 0"><%=top_jsp_path%></h6></div><div style="float:right; width:274px; height:40px; margin:140px 0 0 0; background:url('/images/bg_top_path_fade.png')"><!-- empty --></div><%}%>
    </div>--%>
<% } %>

<%
top_jsp_menu.closeResources();
%>