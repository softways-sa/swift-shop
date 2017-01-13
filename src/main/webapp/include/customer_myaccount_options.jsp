<%@ page pageEncoding="UTF-8" %>

<%!
static Hashtable cust_myaccount_options_lb = new Hashtable();
static {
    cust_myaccount_options_lb.put("customerInformation","Προσωπικά Στοιχεία");
    cust_myaccount_options_lb.put("customerInformationLG","Personal Information");
    cust_myaccount_options_lb.put("orderHistory","Ιστορικό Αγορών");
    cust_myaccount_options_lb.put("orderHistoryLG","Order History");
    cust_myaccount_options_lb.put("wishlist","Wishlist");
    cust_myaccount_options_lb.put("wishlistLG","Wishlist");
    cust_myaccount_options_lb.put("messages","Πληροφορίες");
    cust_myaccount_options_lb.put("messagesLG","Messages");
    cust_myaccount_options_lb.put("signout","Έξοδος");
    cust_myaccount_options_lb.put("signoutLG","Sign out");
}
%>

<div style="margin-bottom:15px;">
  <div class="clearfix">
    <div style="float:left; margin-right:15px;"><a href="<%= "http://" + serverName + "/" + "customer_myaccount.jsp?extLang=" + lang%>"><span class="button aux"><%= cust_myaccount_options_lb.get("customerInformation" + lang)%></span></a></div>
    <div style="float:left; margin-right:15px;"><a href="<%= "http://" + serverName + "/" + "customer_order_history.jsp?extLang=" + lang%>"><span class="button aux"><%= cust_myaccount_options_lb.get("orderHistory" + lang)%></span></a></div>
    <div style="float:left; margin-right:15px;"><a href="<%= "http://" + serverName + "/" + "wishlist.jsp?extLang=" + lang%>"><span class="button aux"><%= cust_myaccount_options_lb.get("wishlist" + lang)%></span></a></div>
    <div style="float:left; margin-right:15px;"><a href="<%= "http://" + serverName + "/" + "customer.do?cmd=signout"%>"><span class="button aux"><%= cust_myaccount_options_lb.get("signout" + lang)%></span></a></div>
  </div>
</div>