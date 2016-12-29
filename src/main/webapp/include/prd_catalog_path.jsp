<%@ page pageEncoding="UTF-8" %>

<%
String cat_path_url = "", i_c_url = "";

if (category_path_length > 0) {
    product_catalogue.goToRow(0);
    
    
%>
    <div class="row">
    <div class="col-xs-12">
    <div id="prdCatalogPath">
    
    <h3><%=lb.get("rootCat" + lang)%>&nbsp;&rsaquo;&rsaquo;</h3>
<%
    for (int x=0; x<category_path_length; x++) {
      
        if (product_catalogue.getColumn("catParentFlag").equals("1")) cat_path_url = "http://" + serverName + "/site/category/" + i_c_url + SwissKnife.sefEncode(product_catalogue.getColumn("catName" + lang)) + "?catId=" + product_catalogue.getColumn("catId") + "&amp;extLang=" + lang;
        else cat_path_url = "http://" + serverName + "/site/search/" + i_c_url + SwissKnife.sefEncode(product_catalogue.getColumn("catName" + lang)) + "?catId=" + product_catalogue.getColumn("catId") + "&amp;extLang=" + lang;
        
        i_c_url += SwissKnife.sefEncode( product_catalogue.getColumn("catName" + lang) ) + "/";
    %>
        <h3><a href="<%= cat_path_url %>"><%= product_catalogue.getColumn("catName" + lang) %></a></h3><% if (category_path_length>x+1) out.print("<h3>&nbsp;&rsaquo;&rsaquo;</h3>"); %>
    <%  
        product_catalogue.nextRow();
    }
    %>
    </div>
    </div>
    </div>
    <% if (product_catalogue.getColumn("catDescr" + lang).length()>0 && !whereAmI.equals("/product_detail.jsp")) { %><div id="productSearchCatDescr"><%= product_catalogue.getColumn("catDescr" + lang) %></div><% } %>
<%    
}
else { %>
  <div class="row"><div id="prdCatalogPath"><div class="col-xs-12"><h3><%=lb.get("rootCat" + lang)%></h3></div></div></div>
<%
} %>