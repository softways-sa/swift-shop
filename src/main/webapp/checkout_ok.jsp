<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/checkout_ok.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Η παραγγελία σας πραγματοποιήθηκε");
    lb.put("htmlTitleLG","Your order has been completed");
    
    lb.put("msgOK","Η παραγγελία σας πραγματοποιήθηκε.");
    lb.put("msgOKLG","Your order has been completed.");

    lb.put("msgOK2","Σύντομα θα λάβετε ένα email με τις λεπτομέρειες τις παραγγελίας σας. Σας ευχαριστούμε πολύ.");
    lb.put("msgOK2LG","Shortly you will receive an email with the details of your order. Thank you.");
    
    lb.put("continueShopping","Συνεχίστε τις αγορές σας");
    lb.put("continueShoppingLG","Continue shopping");
}
%>

<!DOCTYPE html>

<html lang="en">
<head>
    <%@ include file="/include/metatags.jsp" %>
    
    <title><%= lb.get("htmlTitle" + lang) %></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="clearfix">

<div id="shopWrapper">

<h4><%= lb.get("msgOK" + lang)%></h4>
<p><%= lb.get("msgOK2" + lang) %></p>
<div style="float:left"><a href="<%= "http://" + serverName + "/?extLang=" + lang %>"><span class="button aux"><%= lb.get("continueShopping" + lang) %></span></a></div>

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>