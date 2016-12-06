<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/customer_myaccount.jsp"; %>

<%@ include file="/include/customer_auth.jsp" %>

<%!
static Hashtable lb = new Hashtable();
static {
    lb.put("htmlTitle","Προσωπικά Στοιχεία");
    lb.put("htmlTitleLG","Personal Information");
    lb.put("htmlTitleLG1","Personal Information");
    
    lb.put("top_path","Προσωπικά Στοιχεία");
    lb.put("top_pathLG","Personal Information");
    lb.put("top_pathLG1","Personal Information");
    
    lb.put("lastname","Επίθετο");
    lb.put("lastnameLG","Last name");

    lb.put("firstname","Όνομα");
    lb.put("firstnameLG","First name");

    lb.put("customerInformation","Προσωπικά Στοιχεία");
    lb.put("customerInformationLG","Personal Information");
    
    lb.put("updateInformationBtn","Αλλάξτε τα προσωπικά σας στοιχεία");
    lb.put("updateInformationBtnLG","Update your personal information");
}
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

<div id="shopWrapper">
    
<div id="myaccountContainer" class="clearfix">

<%@ include file="/include/customer_myaccount_options.jsp" %>

<div class="sectionHeader"><%= lb.get("customerInformation" + lang) %></div>

<p><%= lb.get("firstname" + lang) %>: <span style="font-weight:bold;"><%= customer.getFirstname() %></span></p>

<p><%= lb.get("lastname" + lang)%>: <span style="font-weight:bold;"><%= customer.getLastname()%></span></p>

<p>Email: <span style="font-weight:bold;"><%= customer.getEmail()%></span></p>

<div style="margin-top:20px; float:left;"><a href="<%= "http://" + serverName + "/" + response.encodeURL("customer_edit_info.jsp?extLang=" + lang)%>"><span class="button"><%= lb.get("updateInformationBtn" + lang)%></span></a></div>

</div> <!-- end: myaccountContainer -->

</div> <!-- end: shopWrapper -->

</div> <!-- end: contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- end: site -->
</div> <!-- end: siteContainer -->

</body>
</html>