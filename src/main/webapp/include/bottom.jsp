<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="bottom_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<%
top_jsp_menu.getMenu("10", lang);
top_jsp_menuLength = top_jsp_menu.getMenuLength();
%>

<%!
static HashMap bottom_lb = new HashMap();
static {
  bottom_lb.put("nlTitle","Εγγραφή στο newsletter");
  bottom_lb.put("nlTitleLG","Sign up in our newsletter");
  bottom_lb.put("nlText","Το email σας");
  bottom_lb.put("nlTextLG","Enter your email");
  bottom_lb.put("subscribe","εγγραφή &gt;");
  bottom_lb.put("subscribeLG","subscribe &gt;");
  bottom_lb.put("js_email","Παρακαλούμε ελέγξτε το email σας.");
  bottom_lb.put("js_emailLG","Please check your email spelling.");

  bottom_lb.put("errorResponse","Παρουσιάστηκε κάποιο πρόβλημα. Παρακαλούμε δοκιμάστε αργότερα.");
  bottom_lb.put("errorResponseLG","There was some problem. Please try again later.");
  bottom_lb.put("successResponse","Η εγγραφή σας ήταν επιτυχημένη. Σας ευχαριστούμε.");
  bottom_lb.put("successResponseLG","Your request was successfully submitted. Thank you.");
  
  bottom_lb.put("displayAll","Δείτε όλα τα αποτελέσματα");
  bottom_lb.put("displayAllLG","Display all");
  bottom_lb.put("displayAllLG1","Display all");
  bottom_lb.put("displayAllLG2","Display all");
}
%>

<div id="footer" class="clearfix">
    
    <div id="footerNavWrapper" class="container">
    <div id="footerNav" class="clearfix">

    <div class="row">
      <%
      for (int i=0; i<top_jsp_menuLength; i++) {
        MenuOption menuOption = top_jsp_menu.getMenuOption(i); %>

        <% if ("<ul>".equals(menuOption.getTag())) { %><ul><% } %>
        <% if ("</ul>".equals(menuOption.getTag())) {%></ul></div><% }%>

        <%
        if ("<a>".equals(menuOption.getTag()) && "1".equals(menuOption.getParent())) { %>
          <div class="col-md-3 col-sm-6 column">
          <h3><%= menuOption.getTitle() %></h3>
        <%
        }
        else if ("<a>".equals(menuOption.getTag()) && !"1".equals(menuOption.getParent())) { %>
            <li>
            <% if (!"1".equals(menuOption.getParent()) && menuOption.getURL() == null) { %><a href="<%="http://" + serverName + "/site/page/" + SwissKnife.sefEncode(menuOption.getTitle()) + "?CMCCode=" + menuOption.getCode() + "&amp;extLang=" + lang%>"><%= menuOption.getTitle() %></a><% } %>
            <% if (!"1".equals(menuOption.getParent()) && menuOption.getURL() != null) { %><a href="<% if (menuOption.getURL().startsWith("/")) out.print("http://" + serverName + menuOption.getURL()); else out.print(menuOption.getURL()); %>"><%= menuOption.getTitle() %></a><% } %>
            </li>
        <% } %>
      <%
      }
      %>
    
      <div class="col-md-3 col-sm-6 column">
        <h3><%=bottom_lb.get("nlTitle" + lang)%></h3>
        
        <div id="leftNewsLetterFrameContainer">
        <div id="leftNewsLetterFrame">

        <div class="clearfix">
        <input type="text" id="leftNewsletterEmail" name="leftNewsletterEmail" class="form-text" value="<%=bottom_lb.get("nlText" + lang)%>" onfocus="if (this.value == '<%=bottom_lb.get("nlText" + lang)%>') this.value='';" onblur="if (this.value == '') this.value='<%=bottom_lb.get("nlText" + lang)%>';" maxlength="75"/>
        <input type="button" name="search-submit" class="btn" value="register" onclick="return sendNewsletterForm();"/>
        </div>

        <div id="leftNewsletterValidatorErrorMessages"></div>
        </div>
        </div> <!-- /leftNewsLetterFrameContainer -->  
        <%
        bottom_cmrow.initBean(databaseId, request, response, this, session);
        bottom_cmrow.getCMRow("0180", "");
        if (bottom_cmrow.inBounds() == true) {out.println(bottom_cmrow.getColumn("CMRHeadHTML")); out.println(bottom_cmrow.getColumn("CMRText" + lang)); out.println(bottom_cmrow.getColumn("CMRBodyHTML"));}
        bottom_cmrow.closeResources();
        %>
      </div> <!-- /col -->
    </div> <!-- /row -->
    
    </div> <!-- /footerNav -->
    </div> <!-- /footerNavWrapper -->
    
</div> <!-- /footer -->

<div id="footerBottomWrapper">
  <div id="footerBottom" class="container">
    <div class="row">
      <div class="col-sm-6"><img src="/images/vivapayments_logo_small.png" alt="viva logo"/> <img src="/images/paypal_logo_small.png" alt="paypal logo"/></div>
      <div class="col-sm-6"><span class="copyright">&copy; SOFTWAYS HELLAS SA&nbsp;&nbsp;&nbsp;&nbsp;Powered by <a href="http://www.softways.gr/" target="_blank">Softways</a></span></div>
    </div>
  </div>
</div>

<script type="text/javascript">
function sendNewsletterForm() {
  var leftNewsletterEmail = $("#leftNewsletterEmail").val();

  if (emailCheck(leftNewsletterEmail)) {
      sendNewsletterData(leftNewsletterEmail);
  }
  else {
      $("#leftNewsletterValidatorErrorMessages").text("<%=bottom_lb.get("js_email" + lang)%>");
  }

  return false;
}

function sendNewsletterData(email) {
  $.ajax({
      type: "GET",
      url: "/newsletter.do?cmd=subscribe&id=NEWSLETTER&EMLMEmail=" + email,
      dataType: "html",
      success: function(serverresponse) {
          if (serverresponse == 1) $("#leftNewsLetterFrame").text("<%=bottom_lb.get("successResponse" + lang)%>").css('font-weight','bold');
          else $("#leftNewsLetterFrame").text("<%=bottom_lb.get("errorResponse" + lang)%>").css('font-weight','bold');
      }
  });
}
</script>

<%
metatag_cmrow.goToRow(0);
while (metatag_cmrow.inBounds() == true) {out.println(metatag_cmrow.getColumn("CMRBodyHTML")); metatag_cmrow.nextRow();}
metatag_cmrow.closeResources();
%>