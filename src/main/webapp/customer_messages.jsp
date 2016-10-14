<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_messages.jsp"; %>

<%@ include file="/include/shopping_auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Πληροφορίες");
    lb.put("htmlTitleLG","Messages");
    
    lb.put("header","Πληροφορίες");
    lb.put("headerLG","Messages");
}
%>

<%
helperBean.initBean(databaseId, request, response, this, session);
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

<div id="myaccountContainer">

<div id="customerAccount">

<%@ include file="/include/customer_myaccount_options.jsp" %>

<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
<tr>
    <td class="customerCaptionHeaderTD"><h2 class="customerCaptionHeader"><%= lb.get("header" + lang) %></h2></td>
</tr>
<tr>
    <td><img src="/images/dot_blank.gif" height="1" alt="" /></td>
</tr>
<tr>
    <td class="customerCaptionLine"><img src="/images/dot_blank.gif" height="3" alt="" /></td>
</tr>
<tr>
    <td><img src="/images/dot_blank.gif" width="1" height="5" alt="" /></td>
</tr>
</table>

<%
int custInfRow = helperBean.getTablePK("customer","customerId",customer.getCustomerId());
if (custInfRow >= 1) { %>
    <div style="margin-top:15px;"><%= helperBean.getColumn("custText")%></div>
<%
} %>

</div> <!-- end: customerAccount -->

</div> <!-- end: myaccountContainer -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

<% helperBean.closeResources(); %>

</body>
</html>
