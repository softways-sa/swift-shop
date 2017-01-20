<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page isErrorPage="true" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/index.jsp"; %>

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","Σφάλμα");
  lb.put("htmlTitleLG","Error");
  lb.put("genMsg","Παρουσιάστηκε κάποιο σφάλμα.");
  lb.put("genMsgLG","There was an error encountered.");
  lb.put("continueShopping","Συνεχίστε τις αγορές σας");
  lb.put("continueShoppingLG","Continue shopping");
  lb.put("continue","Συνέχεια");
  lb.put("continueLG","Continue");
  lb.put("doOrderProblem","Παρουσιάστηκε κάποιο πρόβλημα κατά την επεξεργασία της παραγγελίας σας.");
  lb.put("doOrderProblemLG","There was a problem processing your order.");    
  lb.put("doOrderNoPrdsProblem","Η παραγγελία σας δεν πραγματοποιήθηκε λόγου το ότι το καλάθι σας είναι άδειο.");
  lb.put("doOrderNoPrdsProblemLG","Your order was cancelled because your cart is empty.");
  lb.put("ccProblem","<p>Παρουσιάστηκε κάποιο πρόβλημα κατά την επεξεργασία των στοιχείων της κάρτας σας.</p><p>Η παραγγελία σας δεν έχει ολοκληρωθεί (η κάρτας σας δεν χρεώθηκε).</p>");
  lb.put("ccProblemLG","<p>There was a problem processing your credit card details.</p><p>Your order is not completed (your credit card has not been charged).</p>");
}
%>

<%
String errorStatus = request.getParameter("errorStatus");
if (errorStatus == null) errorStatus = "";
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

<div id="content">
  
  <%
  if (errorStatus.equals("20")) { %>
    <p><b><%= lb.get("doOrderProblem" + lang) %></b></p>
    <p><a href="<%="http://" + serverName + "/"%>"><%=lb.get("continueShopping" + lang)%></a></p>
  <%
  }
  else if (errorStatus.equals("26")) { %>
    <p><b><%= lb.get("doOrderNoPrdsProblem" + lang)%></b></p>
    <p><a href="<%="http://" + serverName + "/"%>"><%= lb.get("continueShopping" + lang)%></a></p>
  <%
  }
  else if (errorStatus.startsWith("cc")) { %>
    <p><b><%=lb.get("ccProblem" + lang)%></b></p>
  <%
  } else { %>
    <p><b><%= lb.get("genMsg" + lang)%></b></p>
    <p><a href="<%="http://" + serverName + "/"%>"><%= lb.get("continue" + lang)%></a></p>
  <% } %>

  <%
  if (exception != null) { %>
      <% exception.printStackTrace(new java.io.PrintWriter(out)); %>
  <% } %>

</div> <!-- /content -->

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- /site -->

</body>
</html>