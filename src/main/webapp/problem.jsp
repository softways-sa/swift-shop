<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page isErrorPage="true" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/index.jsp"; %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Σφάλμα");
    lb.put("htmlTitleLG","Error");
    lb.put("htmlTitleLG1","Error");
    lb.put("htmlTitleLG2","Error");
    lb.put("htmlTitleLG3","Error");
        
    lb.put("genMsg","Παρουσιάστηκε κάποιο σφάλμα.");
    lb.put("genMsgLG","There was an error encountered.");
    lb.put("genMsgLG1","There was an error encountered.");
    lb.put("genMsgLG2","There was an error encountered.");
    lb.put("genMsgLG3","There was an error encountered.");
    
    lb.put("continueShopping","Συνεχίστε τις αγορές σας");
    lb.put("continueShoppingLG","Continue shopping");
    lb.put("continueShoppingLG1","Continue shopping");
    lb.put("continueShoppingLG2","Continue shopping");
    lb.put("continueShoppingLG3","Continue shopping");
    
    lb.put("continue","Συνέχεια");
    lb.put("continueLG","Continue");
    lb.put("continueLG1","Continue");
    lb.put("continueLG2","Continue");
    lb.put("continueLG3","Continue");
    
    lb.put("doOrderProblem","Παρουσιάστηκε κάποιο πρόβλημα κατά την επεξεργασία της παραγγελίας σας.");
    lb.put("doOrderProblemLG","There was a problem processing your order.");
    lb.put("doOrderProblemLG1","There was a problem processing your order.");
    lb.put("doOrderProblemLG2","There was a problem processing your order.");
    lb.put("doOrderProblemLG3","There was a problem processing your order.");
    
    lb.put("doOrderNoPrdsProblem","Η παραγγελία σας δεν πραγματοποιήθηκε λόγου το ότι το καλάθι σας είναι άδειο.");
    lb.put("doOrderNoPrdsProblemLG","Your order was cancelled because your cart is empty.");
    lb.put("doOrderNoPrdsProblemLG1","Your order was cancelled because your cart is empty.");
    lb.put("doOrderNoPrdsProblemLG2","Your order was cancelled because your cart is empty.");
    lb.put("doOrderNoPrdsProblemLG3","Your order was cancelled because your cart is empty.");
    
    lb.put("ccProblem","<p>Παρουσιάστηκε κάποιο πρόβλημα κατά την επεξεργασία των στοιχείων της κάρτας σας.</p><p>Η παραγγελία σας δεν έχει ολοκληρωθεί (η κάρτας σας δεν χρεώθηκε).</p>");
    lb.put("ccProblemLG","<p>There was a problem processing your credit card details.</p><p>Your order is not completed (your credit card has not been charged).</p>");
    lb.put("ccProblemLG1","<p>There was a problem processing your credit card details.</p><p>Your order is not completed (your credit card has not been charged).</p>");
    lb.put("ccProblemLG2","<p>There was a problem processing your credit card details.</p><p>Your order is not completed (your credit card has not been charged).</p>");
    lb.put("ccProblemLG3","<p>There was a problem processing your credit card details.</p><p>Your order is not completed (your credit card has not been charged).</p>");
}
%>

<%
String errorStatus = request.getParameter("errorStatus");
if (errorStatus == null) errorStatus = "";
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

<%@ include file="/include/product_catalog_left.jsp" %>

<div id="content">
  
<%
if (errorStatus.equals("20")) { %>
    <p><b><%= lb.get("doOrderProblem" + lang) %></b></p>
    <p><a href="<%= "http://" + serverName + "/" + response.encodeURL("index.jsp")%>"><%= lb.get("continueShopping" + lang)%></a></p>
<%
}
else if (errorStatus.equals("26")) { %>
        <p><b><%= lb.get("doOrderNoPrdsProblem" + lang)%></b></p>
        <p><a href="<%= "http://" + serverName + "/" + response.encodeURL("index.jsp")%>"><%= lb.get("continueShopping" + lang)%></a></p>
<%
}
else if (errorStatus.startsWith("cc")) { %>
    <p><b><%= lb.get("ccProblem" + lang)%></b></p>
<%
} else { %>
    <p><b><%= lb.get("genMsg" + lang)%></b></p>
    <p><a href="<%= "http://" + serverName + "/" + response.encodeURL("index.jsp")%>"><%= lb.get("continue" + lang)%></a></p>
<% } %>

<%
if (exception != null) { %>
    <% exception.printStackTrace(new java.io.PrintWriter(out)); %>
<% } %>

</div> <!-- end: content -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

</body>
</html>