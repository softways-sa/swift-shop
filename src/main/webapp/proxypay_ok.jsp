<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/proxypay_ok.jsp"; %>

<%!
static HashMap lb = new HashMap();
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
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <title><%= lb.get("htmlTitle" + lang) %></title>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

  <h4><%= lb.get("msgOK" + lang)%></h4>
  <p><%= lb.get("msgOK2" + lang) %></p>
  <div style="float:left"><a href="/"><span class="button aux"><%=lb.get("continueShopping" + lang)%></span></a></div>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>