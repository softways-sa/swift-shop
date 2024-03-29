<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="top_jsp_prdCatMenu" scope="page" class="gr.softways.dev.eshop.category.v2.PrdCategoryMenu2" />
<jsp:useBean id="top_jsp_menu" scope="page" class="gr.softways.dev.swift.cmcategory.v1.Menu2" />

<%!
static HashMap top_jsp_lb = new HashMap();
static {
  top_jsp_lb.put("allprds","Όλα τα προϊόντα");
  top_jsp_lb.put("allprdsLG","All products");
  top_jsp_lb.put("prdTitle","ΠΡΟΪΟΝΤΑ");
  top_jsp_lb.put("prdTitleLG","PRODUCTS");
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
  top_jsp_lb.put("languageSelector","Γλώσσα");
  top_jsp_lb.put("languageSelectorLG","Language");
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
  <%@ include file="/include/mobile_menu.jsp" %>
  
  <div><form name="langForm" method="post" action="#"><input type="hidden" name="lang" value="" /></form></div>
  <div><noscript><a href="/?extLang=">ΕΛΛΗΝΙΚΑ</a></noscript></div>
  <div><noscript><a href="/?extLang=LG">ENGLISH</a></noscript></div>
  
  <div id="headerContainer">
    <div class="container" id="header">

      <div id="headerLogoLinks" class="row">
        <div class="col-md-4"><div id="headerLogo"><a href="/"><img src="/images/logo<%=lang%>.png" alt="logo" style="width: 100%;"/></a></div></div>
        
        <div class="col-md-8">
        <div class="row">
          
          <div id="accountWrap" class="col-md-12">
            <div class="pull-right">
              <div id="fastMenu">
              <ul>
                  <%
                  if (customer.isSignedIn() == false) { %>
                    <li class="first"><a href="/customer_signin.jsp"><span class="glyphicon glyphicon-lock" aria-hidden="true"></span> <%=top_jsp_lb.get("signin" + lang)%></a></li>
                  <%
                  }
                  else { %>
                    <li class="first"><span class="glyphicon glyphicon-user" aria-hidden="true"></span> <a href="/customer_myaccount.jsp"><%=authUsername%></a>&nbsp;&nbsp;&nbsp;<span>[ <a href="/customer.do?cmd=signout"><%=top_jsp_lb.get("signout" + lang)%></a> ]</span></li>
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
          </div> <!-- /col -->
          
          <div id="searchCartWrap" class="col-md-12">
            <div class="pull-right">
              <div id="product-search-top-wrapper">
                <div id="product-search-top">
                  <form id="searchForm" name="searchForm" action="/site/search" method="get">
                    <input id="qid" name="qid" class="form-control typeahead" type="text" placeholder="<%=top_jsp_lb.get("productSearch" + lang)%>" onclick="this.value=''">
                    <button class="submit"><span class="glyphicon glyphicon-search"></span></button>
                  </form>
                </div>
              </div>

              <div id="minicartBar"><img src="/images/cart.png" alt="" style="display:inline; vertical-align:middle;"/><a href="/shopping_cart.jsp"><span class="hidden-xs"><%=top_jsp_lb.get("shoppingCart" + lang)%>: </span><span id="minicartBarQuan"></span>&nbsp;<span id="minicartBarItemWord"><%=top_jsp_lb.get("items" + lang)%></span> <span id="minicartBarSubtotal"></span></a></div>
            </div>
          </div> <!-- /col -->
          
        </div> <!-- /row -->
        </div> <!-- /col -->
      </div> <!-- /row -->
      
    </div> <!-- /header -->
  </div> <!-- /headerContainer -->
  
  <div id="main-nav">
    <div class="container">
      <div class="row"><%@ include file="/include/top_menu.jsp" %></div>
    </div>
  </div>

  <div id="mobile-wrapper" class="Fixed">
    <nav id="mobile-nav">
      <div class="mobileMenuBtnWrap"><a href="#" id="mobile-menu-link"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></a></div>
      <div class="mobileLogoWrap"><a href="/" id="mobile-logo"><img src="/images/mobile-logo.png"></a></div>
      <div class="mobileAccountWrap">
        <div class="mobileAccountContainer">
          <div class="myAccountContent"><a href="/customer_myaccount.jsp"><span class="glyphicon glyphicon-user" aria-hidden="true"></span></a></div>
          <div class="mobileCartContent">
            <a href="/shopping_cart.jsp"><span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span></a>
            <div class="cartItemsCount"></div>
          </div>
        </div>
      </div>
    </nav>
  </div>

</div> <!-- /headerWrapper -->

<%
top_jsp_menu.closeResources();
%>