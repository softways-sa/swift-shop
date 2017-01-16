<%@ page pageEncoding="UTF-8" %>

<%!
static HashMap navLb = new HashMap();
static {
  navLb.put("navBarTitle1","ΚΑΛΑΘΙ ΑΓΟΡΩΝ");
  navLb.put("navBarTitle1LG","SHOPPING CART");
  navLb.put("navBarTitle2","ΣΤΟΙΧΕΙΑ ΧΡΕΩΣΗΣ");
  navLb.put("navBarTitle2LG","BILLING ADDRESS");
  navLb.put("navBarTitle3","ΑΠΟΣΤΟΛΗ");
  navLb.put("navBarTitle3LG","SHIPPING");
  navLb.put("navBarTitle4","ΕΠΙΒΕΒΑΙΩΣΗ ΑΓΟΡΑΣ");
  navLb.put("navBarTitle4LG","REVIEW ORDER");
}
%>
<div class="row">
    <div class="col-xs-12">
      
      <div id="checkout-steps-wrapper" class="hidden-xs">
      <div id="checkout-steps" class="clearfix">
        <ul>
            <li class="num1<% if (whereAmI.equals("/shopping_cart.jsp")) out.print(" active"); %>"><span><%= navLb.get("navBarTitle1" + lang)%></span></li>
            <li class="num2<% if (whereAmI.equals("/checkout_billing.jsp")) out.print(" active"); %>"><span><%= navLb.get("navBarTitle2" + lang) %></span></li>
            <li class="num3<% if (whereAmI.equals("/checkout_shipping.jsp")) out.print(" active"); %>"><span><%= navLb.get("navBarTitle3" + lang) %></span></li>
            <li class="num4<% if (whereAmI.equals("/checkout_confirm.jsp")) out.print(" active"); %>"><span><%= navLb.get("navBarTitle4" + lang) %></span></li>
        </ul>
      </div>
      </div>
        
  </div>
</div>