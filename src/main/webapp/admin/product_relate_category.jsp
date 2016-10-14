<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.eshop.category.Category" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_catPlan" scope="session" class="gr.softways.dev.eshop.category.AdminCatBrowser" />

<%
request.setAttribute("admin.topmenu","products");

app_catPlan.initBean(databaseId, request, response, this, session); 

String action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       catId = request.getParameter("catId") == null ? "" : request.getParameter("catId"),
       prdId = request.getParameter("prdId") == null ? "" : request.getParameter("prdId"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       anchorName = request.getParameter("anchorName") == null ? "" : request.getParameter("anchorName");

String urlBack = response.encodeURL("http://" + serverName + "/" + appDir + "admin/product_update.jsp?action1=EDIT&prdId=" + prdId + "&goLabel=cat&tab=tab8");

boolean openAllCat = false;

int catDepth = 0;

if (action.equals("SEARCH")) {
    app_catPlan.fetchCategories(openAllCat, prdId, true);
}
else if (action.equals("EXPAND_CATEGORY")) {
    app_catPlan.switchCategory(catId);
}

String pageTitle = "Αποθήκη&nbsp;<span class=\"menuPathTD\" id=\"white\">|</span>&nbsp;Προϊόν&nbsp;<span class=\"menuPathTD\" id=\"white\">|</span>&nbsp;Συσχέτιση με κατηγορία";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>ΣΥΣΧΕΤΙΣΗ ΚΑΤΗΓΟΡΙΑΣ</title>
    
    <SCRIPT LANGUAGE="JavaScript" SRC="js/jsfunctions.js"></SCRIPT>
		
    <SCRIPT LANGUAGE="JavaScript">
        function expandCategory(catId, anchorName) {
            document.searchForm.action1.value = "EXPAND_CATEGORY";
            document.searchForm.catId.value = catId;

            document.searchForm.anchorName.value = anchorName;
            
            document.searchForm.action = "<%= response.encodeURL("product_relate_category.jsp") %>";
            document.searchForm.submit();
        }

        function relateCategory(catId) {
            document.searchForm.action1.value = "INSERT";
            document.searchForm.catId.value = catId;
            
            document.searchForm.urlSuccess.value = "<%= response.encodeURL("http://" + serverName + "/" + appDir + "admin/product_update.jsp?action1=EDIT&prdId=" + prdId + "&goLabel=cat&tab=tab8") %>";
            
            document.searchForm.action = "<%= response.encodeURL("/servlet/admin/RelateProductCategory") %>";
            
            document.searchForm.submit();
        }
    </SCRIPT>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="menuPathTD">
            <table width="0" border="0" cellspacing="2" cellpadding="20">
            <tr>
            <td class="menuPathTD"><b><%= pageTitle %></b></td>
            </tr>
            </table>
        </td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#ffffff">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <form name="buttonForm" action="" method="">
            <input type="button" value="Επιστροφή" onclick='location.href="<%= urlBack %>"' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
            </form>
        
            <table width="0" border="0" cellspacing="0" cellpadding="2">
            
            <form name="searchForm" action="" method="POST">
            <input type="hidden" name="action1" value="">
            <input type="hidden" name="catId" value="">
            <input type="hidden" name="prdId" value="<%= prdId %>">
            <input type="hidden" name="urlSuccess" value="">
            <input type="hidden" name="databaseId" value="<%= databaseId %>">
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
            <input type="hidden" name="anchorName" value="">
            
            <%
            Category category = null;
        
            int size = app_catPlan.getSize();
        
            app_catPlan.firstCategory();
            for (int i=0; i<size; i++) {
                category = app_catPlan.nextCategory();
                catId = category.getCatId();
                catDepth = category.getCatDepth();
        
                if (category.isVisible() == true) { %>
                    <tr>    
                        <a name="<%= i %>"></a>
                        <%
                        for (int spaces=1; spaces<catDepth; spaces++) { %>
                            <td>&nbsp;</td>
                        <% } %>
                        <td>
                        <%
                        if (category.getCatParentFlag().equals("1")) { %>
                            <a class="resultsLink" href="javascript:expandCategory('<%= catId %>','<%= i %>')">(+)</a> <span class="text" id="black"><%= category.getCatName() %></span>
                        <%
                        }
                        else {
                            if (!category.isRelated() ) { %><a class="resultsLink" href="javascript:relateCategory('<%= catId %>')"><%= category.getCatName() %></a><% } else { %><span class="text" id="black"><%= category.getCatName() %></span><% } %>
                        <% } %>
                        </td>
                    </tr>
                <%
                }
            }
            %>
            </form>
            </table>
        
            <% if (anchorName.length() > 0) { %>
                <SCRIPT LANGUAGE="JavaScript">
                    document.location.hash = "<%= anchorName %>";
                </SCRIPT>
            <% } %>
        
            <br/>
            <form name="buttonForm1" action="" method="">
            <input type="button" value="Επιστροφή" onclick='location.href="<%= urlBack %>"' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
            </form>
        
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
  
</body>
</html>