<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="top_jsp_prdCatMenu" scope="page" class="gr.softways.dev.eshop.category.v2.PrdCategoryMenu2" />
<jsp:useBean id="top_jsp_menu" scope="page" class="gr.softways.dev.swift.cmcategory.v1.Menu2" />

<%!
static Hashtable top_jsp_lb = new Hashtable();
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

<div id="headerContainer">
  
<div id="header">
    
<div><form name="langForm" method="post" action="#"><input type="hidden" name="lang" value="" /></form></div>
<div><noscript><a href="<%="http://" + serverName + "/?extLang="%>">ΕΛΛΗΝΙΚΑ</a></noscript></div>
<div><noscript><a href="<%="http://" + serverName + "/?extLang=LG"%>">ENGLISH</a></noscript></div>

<div class="clearfix">
    
<div id="headerLogo"><a href="<%="http://" + serverName + "/"%>"><img src="/images/logo<%= lang %>.png" alt="logo" style="width: 100%;"/></a></div>

<div id="headerRight">

<div id="fastMenuWrapper" class="clearfix">
<div style="float:right;">
<div id="fastMenu">
<ul>
    <%
    if (customer.isSignedIn() == false) { %>
      <li class="first"><a href="<%= HTTP_PROTOCOL + serverName + "/customer_signin.jsp"%>"><%=top_jsp_lb.get("signin" + lang)%></a></li>
    <%
    }
    else { %>
      <li class="first"><a href="<%= "http://" + serverName + "/" + "customer_myaccount.jsp"%>"><%=authUsername%></a>&nbsp;&nbsp;&nbsp;<span>[ <a href="<%= "http://" + serverName + "/" + "customer.do?cmd=signout"%>"><%=top_jsp_lb.get("signout" + lang)%></a> ]</span></li>
    <%
    }
    %>
    <li><a href="/wishlist.jsp">Wish List</a></li>
</ul>
</div>
<div id="langSelector">
  <div id="topLangSel"><% if (!lang.equals("")) {%><a href="javascript:document.langForm.lang.value='';document.langForm.submit();void(0);"><%}%><img src="/images/flag.png" alt="Ελληνικά" title="Ελληνικά" /><% if (!lang.equals("")) { %></a><% } %></div>
  <div id="topLangLGSel"><% if (!lang.equals("LG")) {%><a href="javascript:document.langForm.lang.value='LG';document.langForm.submit();void(0);"><%}%><img src="/images/flagLG.png" alt="English" title="English" /><% if (!lang.equals("LG")) { %></a><% } %></div>  
</div>
</div>
</div>

<div class="clearfix">
    
<div>
<div id="search">
<form name="searchForm" action="/site/search" method="get">

<input type="text" id="qid" name="qid" class="form-text typeahead" placeholder="<%=top_jsp_lb.get("productSearch" + lang)%>" onclick="this.value=''"/>
<input type="submit" name="search-submit" class="btn" value="Search"/>

</form>
</div>

<div id="minicartBar">
    <img src="/images/cart.png" alt="" style="display:inline; vertical-align:middle;"/><a href="/shopping_cart.jsp"><%=top_jsp_lb.get("shoppingCart" + lang)%>: <span id="minicartBarQuan"></span>&nbsp;<span id="minicartBarItemWord"><%=top_jsp_lb.get("items" + lang)%></span> <span id="minicartBarSubtotal"></span></a>
</div>
</div>

</div>

</div> <!-- end: headerRight -->

</div>

        <div class="megamenu_container megamenu_light_bar megamenu_light"><!-- Begin Menu Container -->
        
        <ul class="megamenu"><!-- Begin Mega Menu -->
           
            <li class="megamenu_button"><a href="#_"><%=top_jsp_lb.get("menuTitle" + lang)%></a></li>
            
            <%
            if (USE_MEGAMENU) { %>
            
            <%-- product megamenu --%>
            <li><a href="#_" class="megamenu_drop"><%=top_jsp_lb.get("prdTitle" + lang)%></a><!-- Begin Item -->
              <div class="dropdown_fullwidth"><!-- Begin Item Container -->
                
                <div class="col_9">
                <%
                menuLevel = 0;
                
                int li_level = 0, divLevel = 0, megamenuCols = 3;
                
                for (int i=0; i<top_jsp_prdCatMenuLength; i++) {
                  PrdCategoryMenuOption2 menuOption = top_jsp_prdCatMenu.getMenuOption(i);
                %>

                <%if ("<ul>".equals(menuOption.getTag()) || ("<a>".equals(menuOption.getTag()) && menuOption.getCode().length() == 2) ) {
                  menuLevel++;
                %>
                  <%if (menuLevel == 1) {%><div class="col_4 myprdmenu"><%}%>
                  
                  <ul class="level-<%=(menuLevel > 3) ? 3 : menuLevel%>">
                <%
                }%>
                  
                <%if ("</li>".equals(menuOption.getTag())) {
                  li_level--;
                %>
                  </li>
                  <%if (li_level == 0) {menuLevel--;%></ul></div><%divLevel++; if (divLevel == megamenuCols) {divLevel = 0; out.print("<div class='clearfix'></div>");}}%>
                <%
                }%>
                
                <%if ("</ul>".equals(menuOption.getTag())) {
                  menuLevel--;
                %>
                  </ul>
                  <%if (menuLevel == 0) {%></div><%}%>
                <%
                }%>
      
                <%
                if ("<a>".equals(menuOption.getTag())) {
                  if ("1".equals(menuOption.getParent())) top_MenuURL = "http://" + serverName + "/site/category/" + menuOption.getSefFullPath() + "?catId=" + menuOption.getCode() + "&amp;extLang=" + lang;
                  else top_MenuURL = "http://" + serverName + "/site/search/" + menuOption.getSefFullPath() + "?catId=" + menuOption.getCode() + "&amp;extLang=" + lang;
                  
                  li_level++;
                %>
                <li class="level-<%=(menuLevel > 3) ? 3 : menuLevel%>"><a href="<%=top_MenuURL%>"><%=menuOption.getTitle()%></a>
                <%
                }%>

                <%
                } %>
                </div>
              
                <div id="megamenuAllCategories" class="col_3">
                  <%if (MEGAMENU_PRDPROMO_URL != null && MEGAMENU_PRDPROMO_URL.length() > 0){%><a href="<%=MEGAMENU_PRDPROMO_URL%>"><%}%><img src="/images/products_mega_menu_promo<%=lang%>.png" alt="promo"/><%if (MEGAMENU_PRDPROMO_URL != null && MEGAMENU_PRDPROMO_URL.length() > 0){%></a><%}%>
                  <div id="megamenuAllCategoriesBlock"><hr/><a href="/site/category?extLang=<%=lang%>"><%=top_jsp_lb.get("showAllCat" + lang)%>&nbsp;&rsaquo;&rsaquo;</a></div>
                </div>
              
              </div><!-- End Item Container -->
            </li><!-- End Item -->
            
            <%
            } // /product megamenu
            else { %>
            
            <%-- product menu flyout --%>
            <li>
                <a href="#_" class="megamenu_drop"><%=top_jsp_lb.get("prdTitle" + lang)%></a><!-- Begin Item -->
                <div class="dropdown_2columns dropdown_container"><!-- Begin Item Container -->
                <ul class="dropdown_flyout">
                  
                <%
                menuLevel = 1;
                
                for (int i=0; i<top_jsp_prdCatMenuLength; i++) {
                  PrdCategoryMenuOption2 menuOption = top_jsp_prdCatMenu.getMenuOption(i);
                %>

                <%
                if ("<a>".equals(menuOption.getTag()) && !"1".equals(menuOption.getParent())) {
                  top_MenuURL = "http://" + serverName + "/site/search/" + menuOption.getSefFullPath() + "?catId=" + menuOption.getCode() + "&amp;extLang=" + lang;
                %>
                  <li><a href="<%=top_MenuURL%>"><%=menuOption.getTitle()%></a><!-- Simple Link -->
                <%
                  //if (menuOption.getCode().length() == 2) menuLevel = 1;
                }%>

                <%
                if ("<a>".equals(menuOption.getTag()) && "1".equals(menuOption.getParent())) {
                  top_MenuURL = "http://" + serverName + "/site/category/" + menuOption.getSefFullPath() + "?catId=" + menuOption.getCode() + "&amp;extLang=" + lang;
                %>
                  <li class="dropdown_parent"><a href="<%=top_MenuURL%>"><%=menuOption.getTitle()%></a><ul class="dropdown_flyout_level">
                <%}%>

                <% if ("</li>".equals(menuOption.getTag())) {%></li><%}%>

                <% if ("<ul>".equals(menuOption.getTag())) {
                  menuLevel++;
                }%>

                <% if ("</ul>".equals(menuOption.getTag()) && menuLevel > 1) {%>
                  </ul>
                <%
                  menuLevel--;
                }%>

                <%
                } %>
                <li id="flyoutAllCategories"><hr/><a href="/site/category?extLang=<%=lang%>"><%=top_jsp_lb.get("showAllCatFly" + lang)%></a></li>
              </ul></div>
            </li>
            
            <%
            } // /product menu flyout
            %>
            
            <%-- options menu --%>
            <%
            menuLevel = 0;
            
            for (int i=0; i<top_jsp_menuLength; i++) {
              MenuOption menuOption = top_jsp_menu.getMenuOption(i);
            %>
            
            <%if ("<a>".equals(menuOption.getTag()) && menuOption.getCode().length() == 4 && "1".equals(menuOption.getParent())) {%>
              <li>
                <a href="#_" class="megamenu_drop"><%=menuOption.getTitle()%></a><!-- Begin Item -->
                <div class="dropdown_2columns dropdown_container"><!-- Begin Item Container -->
                <ul class="dropdown_flyout">
            <%
              menuLevel = 1;
            }%>
            
            <%
            if ("<a>".equals(menuOption.getTag()) && menuOption.getCode().length() >= 4 && !"1".equals(menuOption.getParent())) {
              if (menuOption.getURL() == null) top_MenuURL = "http://" + serverName + "/site/page/" + SwissKnife.sefEncode(menuOption.getTitle()) + "?CMCCode=" + menuOption.getCode() + "&amp;extLang=" + lang;
              else top_MenuURL = menuOption.getURL();
            %>
              <li><a href="<%=top_MenuURL%>"><%=menuOption.getTitle()%></a><!-- Simple Link -->
            <%
              if (menuOption.getCode().length() == 4) menuLevel = 0;
            }%>
            
            <%if ("<a>".equals(menuOption.getTag()) && menuOption.getCode().length() > 4 && "1".equals(menuOption.getParent())) {%>
              <li class="dropdown_parent"><a href="#_"><%=menuOption.getTitle()%></a><ul class="dropdown_flyout_level">
            <%}%>
        
            <%if ("</li>".equals(menuOption.getTag()) && menuLevel == 1) out.print("</div></li>"); else if ("</li>".equals(menuOption.getTag())) out.print("</li>");%>
            
            <% if ("</ul>".equals(menuOption.getTag()) && menuLevel == 1) {%>
              </ul></div>
            <%
              menuLevel = 0;
            }%>
            
            <% if ("<ul>".equals(menuOption.getTag())) {
              menuLevel++;
            }%>
            
            <% if ("</ul>".equals(menuOption.getTag()) && menuLevel > 1) {%>
              </ul>
            <%
              menuLevel--;
            }%>
            
            <%
            } %>
            <%-- /options menu --%>
            
        </ul><!-- End Mega Menu -->
        
        </div><!-- End Menu Container -->

</div> <!-- end: header -->

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