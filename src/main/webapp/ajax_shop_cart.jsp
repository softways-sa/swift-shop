<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/ajax_shop_cart.jsp"; %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.product.v2.Present" />

<%
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

Product product = null;
PrdPrice prdPrice = null;

dbRet = order.processRequest(request);

int orderLines = order.getOrderLines();

BigDecimal _zero = new BigDecimal("0");

boolean giftWrap = false;

String prdId = request.getParameter("prdId"),
    quantity = request.getParameter("quantity"),
    action1 = request.getParameter("action1"),
    PRD_GiftWrap = request.getParameter("PRD_GiftWrap"),
    PO_Code = request.getParameter("PO_Code");

if (PRD_GiftWrap != null && "1".equals(PRD_GiftWrap)) giftWrap = true;

dbRet = helperBean.getPrd(prdId, SwissKnife.jndiLookup("swconf/inventoryType"));

TotalPrice orderPrice = order.getOrderPrice();

String minicartSubtotal = "",
    itemImage = "", itemName = "", itemPrice = "";

BigDecimal minicartTotalQty = order.getProductCount();

minicartSubtotal = SwissKnife.formatNumber(orderPrice.getGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) + "&nbsp;&euro;";

itemName = helperBean.getColumn("name" + lang).replace("\"", "&quot;").replace("\t", "&nbsp;").replace("\n", "&nbsp;");

if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + prdId + "-1.jpg")) {
    itemImage = "/prd_images/" + prdId + "-1.jpg";
}
else {
    itemImage = "/images/img_not_avail.jpg";
}

product = order.existsProduct(prdId,PO_Code,giftWrap);

if (product != null) {
    prdPrice = product.getPrdPrice();
    itemPrice = SwissKnife.formatNumber(prdPrice.getUnitGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) + "&nbsp;&euro;";
}

helperBean.closeResources();
%>

{"minicartSubtotal":"<%=minicartSubtotal%>", "minicartTotalQty":<%=minicartTotalQty.intValue()%>, "itemImage":"<%=itemImage%>", "itemName":"<%=itemName%>", "itemPrice":"<%=itemPrice%>"}