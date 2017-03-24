<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ page import="org.json.*,java.io.*"%>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/product_search_ajax.jsp"; %>

<jsp:useBean id="product_search" scope="page" class="gr.softways.dev.eshop.product.v2.Search2_3" />

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1);

product_search.initBean(databaseId, request, response, this, session);

int dispRows = 10;

int currentRowCount = 0;

JSONArray product_listing = new JSONArray();

product_search.setDispRows(dispRows);
DbRet dbRet = product_search.doAction(request);

currentRowCount = product_search.getTotalRowCount();

for (int i=0; i<currentRowCount; i++) {
  JSONObject product = new JSONObject();
  product.put("value", product_search.getColumn("name" + lang));
  product.put("link", "/site/product/" + SwissKnife.sefEncode(product_search.getColumn("catName" + lang)) + "/" + SwissKnife.sefEncode(product_search.getColumn("name" + lang)) + "?prdId=" + product_search.getHexColumn("prdId") + "&extLang=" + lang);

  product_listing.put(i, product);

  product_search.nextRow();
}

PrintWriter writer = response.getWriter();
product_listing.write(writer);

product_search.closeResources();
%>