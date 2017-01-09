<%@page pageEncoding="UTF-8"%>

<nav id="mobile-menu" class="hidden">
  <ul>
    <li><span style="overflow: visible;"><form id="mobileSearchForm" name="mobileSearchForm" action="/site/search" method="get"><input type="text" name="qid" class="form-control typeahead" placeholder="<%=top_jsp_lb.get("productSearch" + lang)%>"><button class="submit"><span class="glyphicon glyphicon-search"></span></button></form></span></li>
    <li><a href="<%="http://" + serverName + "/"%>">Home</a></li>
    
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

    <%}%>
    
    <%
    menuLevel = 0;

    for (int i=0; i<top_jsp_menuLength; i++) {
      MenuOption menuOption = top_jsp_menu.getMenuOption(i);
    %>

      <%if ("<a>".equals(menuOption.getTag()) && menuOption.getCode().length() == 4 && "1".equals(menuOption.getParent())) {%>
        <li>
          <span><%=menuOption.getTitle()%></span><!-- Begin Item -->
          <ul>
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
        <li><a href="#_"><%=menuOption.getTitle()%></a><ul>
      <%}%>

      <%if ("</li>".equals(menuOption.getTag()) && menuLevel == 1) out.print("</li>"); else if ("</li>".equals(menuOption.getTag())) out.print("</li>");%>

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

    <%}%>
    
    <li><span><%=top_jsp_lb.get("languageSelector" + lang)%></span>
       <ul>
          <li><a href="/?lang=">Ελληνικά</a></li>
          <li><a href="/?lang=LG">English</a></li>
       </ul>
    </li>
 </ul>
</nav>