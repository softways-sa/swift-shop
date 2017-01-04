<%@page pageEncoding="UTF-8"%>

<nav id="mobile-menu">
  <ul>
    <li><span style="overflow: visible;"><form id="mobileSearchForm" name="mobileSearchForm" action="/site/search" method="get"><input type="text" name="qid" class="form-control typeahead" placeholder="<%=top_jsp_lb.get("productSearch" + lang)%>"><button class="submit"><span class="glyphicon glyphicon-search"></span></button></form></span></li>
    <li><a href="<%="http://" + serverName + "/"%>">Home</a></li>
    
    <li><a href="<%="/" + "/browse/new/?newArrival=1"%>"><span><%=top_jsp_lb.get("newProductsCategory" + lang)%></span></a></li>
    <li><a href="<%="/" + "/browse/onsale/?onSale=1"%>"><span><%=top_jsp_lb.get("onsaleProductsCategory" + lang)%></span></a></li>
    <li><span><%=top_jsp_lb.get("languageSelector" + lang)%></span>
       <ul>
          <li><a href="/el/welcome">Ελληνικά</a></li>
          <li><a href="/en/welcome">Αγγλικά</a></li>
       </ul>
    </li>
 </ul>
</nav>