<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/product_catalog.jsp"; %>

<jsp:useBean id="product_catalogue" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />

<%!
static Hashtable lb = new Hashtable();
static {
  lb.put("rootCat","Προϊόντα");
  lb.put("rootCatLG","Products");
}
%>

<%
product_catalogue.initBean(databaseId, request, response, this, session);

String catId = request.getParameter("catId");
if (catId == null) catId = "";

int category_path_length = 0;

String htmlTitle = "", sef_url = "";

if (catId.length() > 0) {
  category_path_length = product_catalogue.getCatPath(catId, "catId").getRetInt();

  for (int i=0; i<category_path_length; i++) {
    htmlTitle += product_catalogue.getColumn("catName" + lang);

    sef_url += SwissKnife.sefEncode( product_catalogue.getColumn("catName" + lang) ) + "/";

    if ( product_catalogue.nextRow() == true) htmlTitle += " - ";
  }
}
else htmlTitle = lb.get("rootCat" + lang).toString();

request.setAttribute("catId",catId);
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= htmlTitle %></title>
    
    <script type="text/javascript">
    $(document).ready(function(){
        $(".prdcat_titlebox").hover(
          function() {
              $(this).css('background', 'url(/images/product_cell_bg_on.png)');
              $('.prdcCatnameLink', $(this)).css('color', '#333333');
          },
          function() {
              $(this).css('background', 'url(/images/product_cell_bg.png)');
              $('.prdcCatnameLink', $(this)).css('color', '#565656');
          }
        );
          
        $(".prdcat_img_link").hover(
          function() {
            $(this).parent().parent().parent().find('.prdcat_titlebox').css('background', 'url(/images/product_cell_bg_on.png)');
            $(this).parent().parent().parent().find('.prdcat_titlebox').find('.prdcCatnameLink').css('color', '#333333');
          },
          function() {
            $(this).parent().parent().parent().find('.prdcat_titlebox').css('background', 'url(/images/product_cell_bg.png)');
            $(this).parent().parent().parent().find('.prdcat_titlebox').find('.prdcCatnameLink').css('color', '#565656');
          }
        );
    });
    </script>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div class="container" id="contentContainer">
  
<%@ include file="/include/prd_catalog_path.jsp" %>

<div id="prdContainer" class="row">

  <div class="col-md-2 hidden-xs hidden-sm"><%@ include file="/include/product_catalog_left.jsp" %></div>

  <div class="col-md-10">
    <div class="row">
    <%
    product_catalogue.getSubCateg(catId, (catId.length() + 2) / 2,"catRank DESC,catId");

    while (product_catalogue.inBounds() == true) { %>  
    <%
      String cat_img = "", cat_url = "";

        
      if (product_catalogue.getColumn("catImgName1").length() > 0 && SwissKnife.fileExists(wwwrootFilePath + "/images/" + product_catalogue.getColumn("catImgName1").trim())) {
        cat_img = "/images/" + product_catalogue.getColumn("catImgName1").trim();
      }
      else {
        cat_img = "/images/prd_cat_not_avail.gif";
      }

      if (product_catalogue.getColumn("catParentFlag").equals("1")) cat_url = "http://" + serverName + "/site/category/" + sef_url + SwissKnife.sefEncode(product_catalogue.getColumn("catName" + lang)) + "?catId=" + product_catalogue.getColumn("catId") + "&amp;extLang" + lang;
      else cat_url = "http://" + serverName + "/site/search/" + sef_url + SwissKnife.sefEncode(product_catalogue.getColumn("catName" + lang)) + "?catId=" + product_catalogue.getColumn("catId") + "&amp;extLang=" + lang;
    %>
      <div class="col-sm-4" style="margin-bottom: 25px;">
        <%if (!"/images/prd_cat_not_avail.gif".equals(cat_img)) {%><div style="margin-bottom:10px; padding-left:6px; padding-right:6px;"><a href="<%=cat_url%>"><img src="<%=cat_img%>" style="width: 100%;" class="prdcat_img_link" alt="<%=product_catalogue.getColumn("catName" + lang).replace("\"", "&quot;")%>" title="<%=product_catalogue.getColumn("catName" + lang).replace("\"", "&quot;")%>" /></a></div><%}%>
        <div class="prdcat_titlebox" style="height: 57px; background:url('/images/product_cell_bg.png'); background-repeat: repeat;">
          <div style="float: left; width: 4%; display:inline; margin-top: 13px;"><img src="/images/ar01.gif" alt="nav arrow" /></div>
          <div style="float: left; width: 96%; display:inline; margin-top: 10px; padding: 0 10px 0 5px;"><a class="prdcCatnameLink" href="<%=cat_url%>"><%=product_catalogue.getColumn("catName" + lang)%></a></div>
        </div>
      </div>
    <%
      product_catalogue.nextRow();
    %>
    <%
    }
    %>
    </div>
  </div> <!-- /col -->
  
</div> <!-- /prdContainer -->

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- /site -->

<% product_catalogue.closeResources(); %>

</body>
</html>