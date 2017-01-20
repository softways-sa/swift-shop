<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/contact.jsp"; %>

<jsp:useBean id="contact_jsp_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("lastname","Επώνυμο");
  lb.put("lastnameLG","Last name");
  lb.put("firstname","Όνομα");
  lb.put("firstnameLG","First name");
  lb.put("companyname","Επωνυμία εταιρίας");
  lb.put("companynameLG","Company name");
  lb.put("address","Διεύθυνση");
  lb.put("addressLG","Address");
  lb.put("postalcode","Τ.Κ.");
  lb.put("postalcodeLG","Postal code");
  lb.put("city","Πόλη");
  lb.put("cityLG","City");
  lb.put("country","Xώρα");
  lb.put("countryLG","Country");
  lb.put("email","Εmail");
  lb.put("emailLG","Εmail");
  lb.put("phone","Τηλέφωνο");
  lb.put("phoneLG","Telephone");
  lb.put("fax","Φαξ");
  lb.put("faxLG","Fax");
  lb.put("cellphone","Κινητό");
  lb.put("cellphoneLG","Cellphone");
  lb.put("message","Μήνυμα");
  lb.put("messageLG","Message");
  lb.put("captchaLabel","Πληκτρολογείστε τους χαρακτήρες της παρακάτω εικόνας");
  lb.put("captchaLabelLG","Type the characters you see in the picture below");
  lb.put("sendButton","Αποστολή");
  lb.put("sendButtonLG","Send");
  lb.put("req","Απαραίτητα στοιχεία");
  lb.put("reqLG","Required fields");
  lb.put("jsLastName","Παρακαλούμε συμπληρώστε το επώνυμο σας.");
  lb.put("jsLastNameLG","Please enter your last name.");
  lb.put("jsFirstName","Παρακαλούμε συμπληρώστε το όνομα σας.");
  lb.put("jsFirstNameLG","Please enter your first name.");
  lb.put("jsEmail","Παρακαλούμε ελέγξτε το email σας.");
  lb.put("jsEmailLG","Please check your email.");
  lb.put("jsPhone","Παρακαλούμε συμπληρώστε το τηλέφωνό σας.");
  lb.put("jsPhoneLG","Please enter your telephone.");
  lb.put("jsCaptcha_response__hidden","Παρακαλούμε συμπληρώστε τους χαρακτήρες επαλήθευσης.");
  lb.put("jsCaptcha_response__hiddenLG","Please enter word verification.");
  lb.put("thankYou","Ευχαριστούμε που επικοινωνήσατε μαζί μας.");
  lb.put("thankYouLG","Thank you for contacting us.");
  lb.put("captchaError","Η λέξη επαλήθευσης ήταν λάθος.");
  lb.put("captchaErrorLG","The characters you entered didn't match the word verification.");
  lb.put("wrongCaptcha","Η λέξη επαλήθευσης ήταν λάθος.");
  lb.put("wrongCaptchaLG","The characters you entered didn't match the word verification.");
  lb.put("errorSending","Παρουσιάστηκε κάποιο πρόβλημα. Παρακαλούμε δοκιμάστε ξανά.");
  lb.put("errorSendingLG","An error occurred. Please try again.");
  lb.put("copyReq","Αποστολή αντιγράφου σε σας");
  lb.put("copyReqLG","Send copy to yourself");
}
%>

<%
contact_jsp_cmrow.initBean(databaseId, request, response, this, session);

String CONTACT_CMCCode = request.getParameter("CMCCode");

if (CONTACT_CMCCode == null) CONTACT_CMCCode = "";

String urlSuccess = "/contact.jsp?CMCCode=" + CONTACT_CMCCode + "&amp;extLang=" + lang;
       
String status = (String) request.getAttribute("regForm");

Map<String, List<String>> formFields = (Map<String, List<String>>) request.getAttribute("regFormFields");

String firstname = "", lastname = "", email = "", phone = "", message= "", copyReq__hidden = "";

if (status != null && "ERROR".equals(status) && formFields != null) {
  if (formFields.get("firstname") != null && formFields.get("firstname").get(0) != null) firstname = formFields.get("firstname").get(0);
  if (formFields.get("lastname") != null && formFields.get("lastname").get(0) != null) lastname = formFields.get("lastname").get(0);
  if (formFields.get("email") != null && formFields.get("email").get(0) != null) email = formFields.get("email").get(0);
  if (formFields.get("phone") != null && formFields.get("phone").get(0) != null) phone = formFields.get("phone").get(0);
  if (formFields.get("message") != null && formFields.get("message").get(0) != null) message = formFields.get("message").get(0);
  if (formFields.get("copyReq__hidden") != null && formFields.get("copyReq__hidden").get(0) != null) copyReq__hidden = formFields.get("copyReq__hidden").get(0);
}

String htmlTitle = "", htmlKeywords = "", CMRHeadHTML = "", CMRBodyHTML = "";

int rowCount = contact_jsp_cmrow.getCMRow(CONTACT_CMCCode,"CCCRRank DESC, CMRDateCreated DESC").getRetInt();

if (rowCount > 0) {
  htmlTitle = contact_jsp_cmrow.getColumn("CMRTitle" + lang);
  htmlKeywords = contact_jsp_cmrow.getColumn("CMRKeyWords" + lang);
  
  CMRHeadHTML = contact_jsp_cmrow.getColumn("CMRHeadHTML");
  CMRBodyHTML = contact_jsp_cmrow.getColumn("CMRBodyHTML");
}
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <meta name="keywords" content="<%=htmlKeywords%>" />

  <title><%=htmlTitle%></title>

  <style>
  #contactForm label {
    display:inline-block;
    width:100px;
    float:left;
    margin-bottom: 5px;
  }
  #contactForm input,
  #contactForm textarea,
  #contactForm select {
    padding: 5px;
    font: 400 1em;
    color: #333;
    background:#eee;
    border: 1px solid #ccc;
    margin:0 0 10px 0;
    width:50%;
  }
  #contactForm input:focus,
  #contactForm textarea:focus,
  #contactForm select:focus {
    background: #fff;
    border: 1px solid #999;
  }
  #contactForm input.small {width: 35px;}
  #contactForm textarea {height:100px;}
  
  #contactForm input.radio, #contactForm input.checkbox {
    width:auto;
    display: block;
  }
  #contactForm input.checkbox {margin-bottom: 0;}
  
  #contactForm input.button {
    width: auto;
    background-color: #585656;
    background-image: url("/images/button_highlighter.png");
    background-repeat: repeat-x;
    border: 0 none;
    border-radius: 5px;
    color: #fff;
    padding: 3px 12px 5px;
    margin: 0;
  }
  </style>
    
  <script>
  function validateForm(form) {
    if (isEmpty(form.firstname.value) == true) {
      alert("<%= lb.get("jsFirstName" + lang) %>");
      form.firstname.focus();
      return false;
    }
    else if (isEmpty(form.lastname.value) == true) {
      alert("<%= lb.get("jsLastName" + lang) %>");
      form.lastname.focus();
      return false;
    }
    else if (form.email.value == "" || emailCheck(form.email.value) == false){
      alert("<%= lb.get("jsEmail" + lang) %>");
      form.email.focus();
      return false;
    }
    else if (isEmpty(form.captcha_response__hidden.value) == true) {
      alert("<%= lb.get("jsCaptcha_response__hidden" + lang) %>");
      form.captcha_response__hidden.focus();
      return false;
    }
    else return true;
  }
  </script>
    
  <%=CMRHeadHTML%>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">
  <div class="row"><div class="col-xs-12"><div id="google_map_canvas"></div></div></div>
  
  <div class="row mt">
    
    <div class="col-md-7">
      <div id="contactForm">

      <form id="mailForm" method="post" action="/ContactUsForm.do" enctype="multipart/form-data">

      <div>
      <input type="hidden" name="subject__hidden" value="WEB SITE ΕΠΙΚΟΙΝΩΝΙΑ"/>
      <input type="hidden" name="returnurl__hidden" value="<%=urlSuccess%>"/>
      <input type="hidden" name="formRecipientKey__hidden" value="contactEmailTo"/>
      </div>

      <fieldset id="field1">
        <legend>E-mail</legend>

        <%
        if (status != null && "OK".equals(status)) { %>
          <div style="padding-bottom: 25px;"><h3><%=lb.get("thankYou" + lang)%></h3></div>
        <%
        }
        else if (status != null && request.getAttribute("regFormCaptchaError") != null) { %>
          <div style="padding-bottom: 25px;"><h3 style="color: red;"><%=lb.get("wrongCaptcha" + lang)%></h3></div>
        <%
        }
        else if (status != null && "ERROR".equals(status)) { %>
          <div style="padding-bottom: 25px;"><h3 style="color: red;"><%=lb.get("errorSending" + lang)%></h3></div>
        <%
        } %>

        <input type="hidden" name="firstname__label" value="<%=lb.get("firstname" + lang)%>"/>
        <input type="hidden" name="lastname__label" value="<%=lb.get("lastname" + lang)%>"/>
        <input type="hidden" name="email__label" value="Email"/>
        <input type="hidden" name="phone__label" value="<%=lb.get("phone" + lang)%>"/>
        <input type="hidden" name="message__label" value="<%=lb.get("message" + lang)%>"/>

        <label for="firstname"><%=lb.get("firstname" + lang)%> <span class="required">*</span></label><input id="firstname" name="firstname" type="text" value="<%=firstname%>"/><br/>
        <label for="lastname"><%=lb.get("lastname" + lang)%> <span class="required">*</span></label><input id="lastname" name="lastname" type="text" value="<%=lastname%>" /><br/>
        <label for="email">E-mail <span class="required">*</span></label><input id="email" name="email" type="text" value="<%=email%>" /><br/>
        <label for="phone"><%= lb.get("phone" + lang) %></label><input id="phone" name="phone" type="text" value="<%=phone%>" /><br/>
        <label for="message"><%= lb.get("message" + lang) %></label><textarea id="message" name="message"><%=message%></textarea><br/>
        <label for="copyReq__hidden" style="width:auto;"><%=lb.get("copyReq" + lang)%>&nbsp;</label><input id="copyReq__hidden" name="copyReq__hidden" type="checkbox" value="1" class="checkbox" <%if ("1".equals(copyReq__hidden)) out.print("checked");%>/><br  class="spacer"/>
        <br/>
        <label style="width:auto;" for="captcha_response__hidden"><%=lb.get("captchaLabel" + lang)%> *</label>
        <br/>
        <input id="captcha_response__hidden" name="captcha_response__hidden" type="text" value="" />
        <br/>
        <img alt="captcha" src="/servlet/captcha" onclick="this.src='/servlet/captcha?' + Math.floor(Math.random()*100)" />
        <br/>

        <input type="button" onclick="if (validateForm(document.getElementById('mailForm')) == true) document.getElementById('mailForm').submit();" value="<%=lb.get("sendButton" + lang)%>" name="submitbtn" id="submitbtn" class="button" />

        <div style="margin-top: 15px;">* <%=lb.get("req" + lang)%></div>
      </fieldset>

      </form>

      </div> <!-- /contactForm -->
    </div> <!-- /col -->

    <div class="col-md-5">
      <div id="contactFormRight">

      <%
      if (rowCount > 0) { %>
        <div id="contactFormAddres"><%= contact_jsp_cmrow.getColumn("CMRText" + lang)%></div>
      <% } %>

      </div> <!-- /contactFormRight -->
    </div>
      
    </div> <!-- /row -->
      
</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- /site -->

<%=CMRBodyHTML%>

<% contact_jsp_cmrow.closeResources(); %>

</body>
</html>