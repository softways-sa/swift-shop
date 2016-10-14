<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="prd_catalogue_left_helperBean1" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />
<jsp:useBean id="prd_catalogue_left_helperBean2" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />
<jsp:useBean id="prd_catalogue_left_helperBean3" scope="page" class="gr.softways.dev.eshop.category.v2.Present" />

<jsp:useBean id="product_catalog_left_jsp_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<%!
static Hashtable left_jsp_lb = new Hashtable();
static {
    left_jsp_lb.put("search","Αναζήτηση");
    left_jsp_lb.put("searchLG","Search");
    left_jsp_lb.put("productSearch","κωδικός ή περιγραφή");
    left_jsp_lb.put("productSearchLG","item code or title");
}
%>

<%
prd_catalogue_left_helperBean1.initBean(databaseId, request, response, this, session);
prd_catalogue_left_helperBean2.initBean(databaseId, request, response, this, session);
prd_catalogue_left_helperBean3.initBean(databaseId, request, response, this, session);

product_catalog_left_jsp_cmrow.initBean(databaseId, request, response, this, session);

String prd_catalogue_left_rootCatID = "", p_cat_1 = "", p_cat_2 = "";

int product_catalog_left_jsp_rowCount = 0;
%>

<div id="productNavColumn">

<%
prd_catalogue_left_helperBean1.getCategLevel(1, "catRank DESC, catId");
prd_catalogue_left_helperBean2.getCategLevel(2, "catRank DESC, catId");
prd_catalogue_left_helperBean3.getCategLevel(3, "catRank DESC, catId");

String left_cat_url = "";
%>

<%--<img src="/images/browse_catalog<%=lang%>.png" alt=""/>--%>
<div class="LeftNavTree" id="ctl00_cphContentFull_cphContentLeft_ucLeftNav_productNav_tvSideNav">
<div class="AspNet-TreeView">
<ul id="ctl00_cphContentFull_cphContentLeft_ucLeftNav_productNav_tvSideNav_UL">
    <li class="AspNet-TreeView-Root">
    <ul>

        <%
        while (prd_catalogue_left_helperBean1.inBounds() == true) {
          p_cat_1 = SwissKnife.sefEncode(prd_catalogue_left_helperBean1.getColumn("catName" + lang)) + "/";
          
          if (prd_catalogue_left_helperBean1.getColumn("catParentFlag").equals("1")) left_cat_url = "http://" + serverName + "/site/category/" + SwissKnife.sefEncode(prd_catalogue_left_helperBean1.getColumn("catName" + lang)) + "?catId=" + prd_catalogue_left_helperBean1.getColumn("catId") + "&amp;extLang=" + lang;
          else left_cat_url = "http://" + serverName + "/site/search/" + p_cat_1.substring(0,p_cat_1.length()-1) + "?catId=" + prd_catalogue_left_helperBean1.getColumn("catId") + "&amp;extLang=" + lang;
        %>
            <li style="border-bottom:1px solid #e0e0e0;" class="AspNet-TreeView-Parent<% if(prd_catalogue_left_catId.startsWith(prd_catalogue_left_helperBean1.getColumn("catId"))) out.print(" AspNet-TreeView-Selected"); %>"><a href="<%= left_cat_url %>"><%= prd_catalogue_left_helperBean1.getColumn("catName" + lang) %></a>

            <%
                prd_catalogue_left_rootCatID = prd_catalogue_left_helperBean1.getColumn("catId");

                boolean write_ul = true;
                while (prd_catalogue_left_helperBean2.inBounds() == true) {
                    if (prd_catalogue_left_helperBean2.getColumn("catId").startsWith(prd_catalogue_left_rootCatID) && !prd_catalogue_left_helperBean2.getColumn("catId").equals(prd_catalogue_left_rootCatID)) {
                      p_cat_2 = p_cat_1 + SwissKnife.sefEncode(prd_catalogue_left_helperBean2.getColumn("catName" + lang)) + "/";
                      
                      if (prd_catalogue_left_helperBean2.getColumn("catParentFlag").equals("1")) left_cat_url = "http://" + serverName + "/site/category/" + p_cat_1 + SwissKnife.sefEncode(prd_catalogue_left_helperBean2.getColumn("catName" + lang)) + "?catId=" + prd_catalogue_left_helperBean2.getColumn("catId") + "&amp;extLang=" + lang;
                      else left_cat_url = "http://" + serverName + "/site/search/" + p_cat_2.substring(0,p_cat_2.length()-1) + "?catId=" + prd_catalogue_left_helperBean2.getColumn("catId") + "&amp;extLang=" + lang;
                        
                      if (write_ul == true) out.print("<ul>");
            %>
                            <li class="AspNet-TreeView-Parent<% if(prd_catalogue_left_catId.startsWith(prd_catalogue_left_helperBean2.getColumn("catId"))) out.print(" AspNet-TreeView-Selected"); %>"><a href="<%= left_cat_url %>"><%= prd_catalogue_left_helperBean2.getColumn("catName" + lang) %></a>
                            
                            <%
                                String prd_catalogue_left_rootCatID3 = prd_catalogue_left_helperBean2.getColumn("catId");

                                boolean write_ul3 = true;
                                while (prd_catalogue_left_helperBean3.inBounds() == true) {
                                    if (prd_catalogue_left_helperBean3.getColumn("catId").startsWith(prd_catalogue_left_rootCatID3) && !prd_catalogue_left_helperBean3.getColumn("catId").equals(prd_catalogue_left_rootCatID3)) {
                                      if (prd_catalogue_left_helperBean3.getColumn("catParentFlag").equals("1")) left_cat_url = "http://" + serverName + "/site/category/" + p_cat_2 + SwissKnife.sefEncode(prd_catalogue_left_helperBean3.getColumn("catName" + lang)) + "?catId=" + prd_catalogue_left_helperBean3.getColumn("catId") + "&amp;extLang=" + lang;
                                      else left_cat_url = "http://" + serverName + "/site/search/" + p_cat_2.substring(0,p_cat_2.length()) + SwissKnife.sefEncode(prd_catalogue_left_helperBean3.getColumn("catName" + lang)) + "?catId=" + prd_catalogue_left_helperBean3.getColumn("catId") + "&amp;extLang=" + lang;

                                      if (write_ul3 == true) out.print("<ul>");
                            %>
                                        <li <%if(prd_catalogue_left_catId.startsWith(prd_catalogue_left_helperBean3.getColumn("catId"))) out.print("style=\"list-style:url(/images/bg_li.png)\""); %> class="AspNet-TreeView-Leaf<%if(prd_catalogue_left_catId.startsWith(prd_catalogue_left_helperBean3.getColumn("catId"))) out.print(" AspNet-TreeView-Selected");%>"><a href="<%= left_cat_url %>"><%= prd_catalogue_left_helperBean3.getColumn("catName" + lang) %></a></li>
                            <%
                                        write_ul3 = false;
                                    }
                                    prd_catalogue_left_helperBean3.nextRow();
                                }
                                if (write_ul3 == false) out.print("</ul>");

                                prd_catalogue_left_helperBean3.goToRow(0);
                            %>
                            
                            </li>
            <%
                        write_ul = false;
                    }
                    prd_catalogue_left_helperBean2.nextRow();
                }
                if (write_ul == false) out.print("</ul>");

                prd_catalogue_left_helperBean2.goToRow(0);
            %>
            
            </li>
        <%
            prd_catalogue_left_helperBean1.nextRow();
        } %>

    </ul>
    </li>
</ul>
</div>
</div>

<%
product_catalog_left_jsp_rowCount = product_catalog_left_jsp_cmrow.getCMRow(LEFT_INFO_TABLE_CMCCode,"CCCRRank DESC, CMRDateCreated DESC").getRetInt();

if (product_catalog_left_jsp_rowCount > 0) { %>
    <div style="margin-top:15px;"><%= product_catalog_left_jsp_cmrow.getColumn("CMRText" + lang) %></div>
<% } %>

<%
prd_catalogue_left_helperBean1.closeResources();
prd_catalogue_left_helperBean2.closeResources();
prd_catalogue_left_helperBean3.closeResources();

product_catalog_left_jsp_cmrow.closeResources();
%>

</div> <!-- end: productNavColumn -->