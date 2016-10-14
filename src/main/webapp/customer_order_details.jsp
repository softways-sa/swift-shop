<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_order_details.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.orders.v2.Present" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Στοιχεία Παραγγελίας");
    lb.put("htmlTitleLG","Order Details");
    
    lb.put("orderDetails","Στοιχεία Παραγγελίας");
    lb.put("orderDetailsLG","Order Details");
    lb.put("back","Επιστροφή");
    lb.put("backLG","Back");
    lb.put("productId","Κωδικός");
    lb.put("productIdLG","Product ID");
    lb.put("description","Περιγραφή");
    lb.put("descriptionLG","Description");
    lb.put("qty","Ποσότητα");
    lb.put("qtyLG","Qty");
    lb.put("amount","Ποσό (με ΦΠΑ)");
    lb.put("amountLG","Amount (VAT inc.)");
    
    lb.put("totalPrds", "Μερικό Σύνολο");
    lb.put("totalPrdsLG", "Subtotal");
    lb.put("shipCost","Έξοδα αποστολής");
    lb.put("shipCostLG","Shipping");
    lb.put("total","ΣΥΝΟΛΟ");
    lb.put("totalLG","TOTAL");
    
    lb.put("giftWrap", "συσκευασία δώρου");
    lb.put("giftWrapLG", "gift wrap");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

dbRet = helperBean.getOrder(customer.getCustomerId(), SwissKnife.sqlEncode(request.getParameter("orderId")), "");

if (dbRet.getNoError() == 0 || dbRet.getRetInt() <= 0) {
    helperBean.closeResources();
    response.sendRedirect( "http://" + serverName + "/" + response.encodeRedirectURL("problem.jsp") );
    return;
}

int rows = dbRet.getRetInt();

BigDecimal zero = new BigDecimal("0");

BigDecimal valueEU = zero, vatValEU = zero, shippingValueEU = zero, shippingVatValueEU = zero, quantity = zero;

BigDecimal prdNetValueEU = zero, prdVATValEU = zero, prdValueEU = zero;
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
</head>

<body>

<div id="siteContainer">
<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<%@ include file="/include/customer_myaccount_options.jsp" %>

<div class="sectionHeader"><%= lb.get("orderDetails" + lang) %></div>

<table cellpadding="4" cellspacing="1" border="0" style="width:100%;">
<thead>
<tr >
    <td ><b><%= lb.get("productId" + lang) %></b></td>
    <td ><b><%= lb.get("description" + lang) %></b></td>
    <td style="text-align: right;"><b><%= lb.get("qty" + lang) %></b></td>
    <td style="text-align: right;"><b><%= lb.get("amount" + lang) %></b></td>
</tr>
</thead>

<%
int transIdNext = 0;
int transIdPrevious = -1;

vatValEU = helperBean.getBig("vatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
valueEU = helperBean.getBig("valueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
valueEU = valueEU.add(vatValEU);

shippingValueEU = helperBean.getBig("shippingValueEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
shippingVatValueEU = helperBean.getBig("shippingVatValEU").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
shippingValueEU = shippingValueEU.add(shippingVatValueEU);

BigDecimal totalValueEU = valueEU.add(shippingValueEU).setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP);

for (int i=0; i<rows; i++) {
    transIdNext = helperBean.getInt("transId");
    
    if (transIdNext != transIdPrevious) {
        transIdPrevious = transIdNext;
        
        quantity = helperBean.getBig("quantity1").setScale(0, BigDecimal.ROUND_HALF_UP);

        prdNetValueEU = helperBean.getBig("valueEU1").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        prdVATValEU = helperBean.getBig("vatValEU1").setScale(curr1Scale, BigDecimal.ROUND_HALF_UP);
        prdValueEU = prdNetValueEU.add(prdVATValEU);
%>
        <tr>
            <td class="text"><%= helperBean.getColumn("prdId") %></td>
            <td class="text" align="left"><%= helperBean.getColumn("name" + lang) %><% if (helperBean.getColumn("transPO_Name" + lang) != null && helperBean.getColumn("transPO_Name" + lang).length()>0) {%> - <%= helperBean.getColumn("transPO_Name" + lang) %><% } %><% if ("1".equals(helperBean.getColumn("transPRD_GiftWrap"))) {%> + <%= lb.get("giftWrap" + lang) %><%}%></td>
            <td class="text" style="text-align: right;"><%= SwissKnife.formatNumber(quantity,localeLanguage,localeCountry,0,0) %></td>
            <td class="text" style="text-align: right;">&euro;<%= SwissKnife.formatNumber(prdValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
        </tr>
<%
        if (!helperBean.getColumn("TAVCode").equals("")) { %>
            <tr>
                <td>&nbsp;</td>
                <td><span class="text"><%= helperBean.getColumn("TAVAtrName") %>-<%= helperBean.getColumn("TAVValue") %></span></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
<%
        }
    }
    else { %>
        <tr>
            <td>&nbsp;</td>
            <td><span class="text"><%= helperBean.getColumn("TAVAtrName") %>-<%= helperBean.getColumn("TAVValue") %></span></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
<%
    }
    
    helperBean.nextRow();
}
%>
<tr>
    <td class="subheader" style="text-align: right;" colspan="3"><%= lb.get("shipCost" + lang) %>:</td>
    <td class="subheader" style="text-align: right;"><%= SwissKnife.formatNumber(shippingValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</td>
</tr>
<tr>
    <td class="subheader" style="text-align:right; font-weight:bold;" colspan="3"><%= lb.get("total" + lang) %>:</td>
    <td class="subheader" style="background-color:#e9e9e9; text-align:right; font-weight:bold;"><%= SwissKnife.formatNumber(totalValueEU,localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %> &euro;</td>
</tr>
</table>
<br/>
<div style="float:right;"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_order_history.jsp?extLang=" + lang) %>"><span class="button aux"><%= lb.get("back" + lang) %></span></a></div>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

<% helperBean.closeResources(); %>

</body>
</html>