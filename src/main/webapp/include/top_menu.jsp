<div class="megamenu_container megamenu_light_bar megamenu_light">

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

</div><!-- /megamenu_container -->