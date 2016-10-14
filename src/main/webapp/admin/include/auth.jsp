<%@ page pageEncoding="UTF-8" %>

<%
String authUsername = "", authPassword = "";
// AUTHENTICATION CHECK {
if ( (session.getAttribute(databaseId + ".authUsername") == null) 
		|| (session.getAttribute(databaseId + ".authPassword") == null) 
		|| (session.getAttribute(databaseId + ".authGrantLogin") == null)) {
    response.sendRedirect(urlLoginFirst);
    return;
}
else {
    authUsername = session.getAttribute(databaseId + ".authUsername").toString();
    authPassword = session.getAttribute(databaseId + ".authPassword").toString();
}
//  } AUTHENTICATION CHECK
%>
