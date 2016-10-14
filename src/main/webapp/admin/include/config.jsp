<%@ page pageEncoding="UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

String serverName = request.getServerName();
%>

<%@ include file="../deployment/deployment.jsp" %>

<% 
String bodyString = "bgcolor=\"#ffffff\" leftMargin=0 topMargin=0 marginheight=\"0\" marginwidth=\"0\" ";

int dispRows = 10;

String urlLoginFirst = "http://" + serverName + "/admin/" + response.encodeURL("login.jsp"),
       urlNoAccess = "http://" + serverName + "/admin/" + response.encodeURL("noaccess.jsp");

/** FileTemplate σταθερές { */
String TEMPLATE_OP_INNew = "INNew";
String TEMPLATE_OP_IN = "IN";
String TEMPLATE_OP_OUT = "OUT";
/** } FileTemplate σταθερές */

if (session != null) session.setMaxInactiveInterval(1 * 60 * 60);

int yearDnLimit = 10, yearUpLimit = 5;

String localeLanguage = "el", localeCountry = "GR";

int curr1Scale = Integer.parseInt(gr.softways.dev.util.SwissKnife.jndiLookup("swconf/curr1Scale"));
int curr2Scale = 0;
try {
    curr2Scale = Integer.parseInt(gr.softways.dev.util.SwissKnife.jndiLookup("swconf/curr2Scale"));
}
catch (Exception e) { }

int curr1DisplayScale = 2, curr2DisplayScale = 0;
int minCurr1DispFractionDigits = 2, minCurr2DispFractionDigits = 0;
int curr1CheckFractionDigits = 2, curr2CheckFractionDigits = 0;
%>
