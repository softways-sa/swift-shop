<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/proxypay_nok.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Πρόβλημα");
  lb.put("htmlTitleLG","Problem");
  lb.put("msg","<p><h4>Παρουσιάστηκε κάποιο πρόβλημα κατά την επεξεργασία των στοιχείων της κάρτας σας.</h4></p><p><h4>Η παραγγελία σας δεν έχει ολοκληρωθεί (η κάρτας σας δεν χρεώθηκε).</h4></p>");
  lb.put("msgLG","<p><h4>There was a problem processing your credit card details.</h4></p><p><h4>Your order is not completed (your credit card has not been charged).</h4></p>");
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

<div id="contentContainer" class="container"><%= lb.get("msg" + lang)%></div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->

</body>
</html>