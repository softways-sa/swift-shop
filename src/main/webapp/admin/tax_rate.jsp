<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*,
                 java.math.BigDecimal,
                 gr.softways.dev.jdbc.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" 
             class="gr.softways.dev.util.JSPBean" />

<%
helperBean.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","products");

DbRet dbRet = new DbRet();

Director director = Director.getInstance();
Database database = null;
int prevTransIsolation = 0;
    
String alert_text = "";

if ("post".equalsIgnoreCase(request.getMethod())) {
  try {
    database = director.getDBConnection(databaseId);

    dbRet = database.beginTransaction(Database.TRANS_ISO_1);
    prevTransIsolation = dbRet.getRetInt();

    Enumeration params = request.getParameterNames();
    while (params.hasMoreElements()) {
      String paramName = (String) params.nextElement();

      if (paramName.startsWith("VAT_Pct_")) {
        String id = paramName.substring(paramName.indexOf("VAT_Pct_") + 8, paramName.length());

        BigDecimal pct = SwissKnife.parseBigDecimal(request.getParameter(paramName),"el","GR").movePointLeft(2);

        database.execQuery("UPDATE VAT SET VAT_Pct = '" + pct + "' WHERE VAT_ID = '" + SwissKnife.sqlEncode(id) + "'");
      }
    }
  }
  catch (Exception e) {
    dbRet.setNoError(0);
  }
  finally {
    dbRet = database.commitTransaction(dbRet.getNoError(), prevTransIsolation);
    director.freeDBConnection(databaseId, database);
  }
  
  if (dbRet.getNoError() == 0) {
    alert_text = "Δεν έγινε ενημέρωση!";
  }
  else {
    alert_text = "Η ενημέρωση ολοκληρώθηκε!";
  }
}
%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <style>
    .alert {
      display: none;
      background-color: #ecf3e6;
      border: 1px solid transparent;
      border-color: #dfebd5;
      border-radius: 3px;
      color: #8fbb6c;
      margin-bottom: 17px;
      padding: 10px;
    }
    </style>

    <script
      src="https://code.jquery.com/jquery-1.12.4.min.js"
      integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="
      crossorigin="anonymous"></script>
        
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script></script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
		
		<table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Κλίμακες Φ.Π.Α.</b></td>
      <td class="menuPathTD" align="middle">&nbsp;</td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
          <%
          if (alert_text.length() > 0) {%>
          <div id="notification" class="alert"><%=alert_text%></div>
          <script>
          $(document).ready(function() {
            $('#notification').fadeIn('slow').delay(3000).fadeOut('slow');
          });
          </script>
          <%
          }%>
          <form name="updateForm" method="post" action="tax_rate.jsp">
            <table border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
              <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός</td>
                <td class="resultsLabelTD">Συντελεστής</td>
                <td class="resultsLabelTD">Ποσοστό %</td>
              </tr>
              <%
              helperBean.getTable("VAT", "");
              while (helperBean.inBounds()) {
              %>
              <tr>
                <td class="inputFrmLabelTD"><%=helperBean.getColumn("VAT_ID")%></td>
                <td class="inputFrmLabelTD"><%=helperBean.getColumn("VAT_Title")%></td>
                <td class="inputFrmLabelTD"><input type="text" name="VAT_Pct_<%=helperBean.getColumn("VAT_ID")%>" maxlength="6" size="6" value="<%=SwissKnife.formatNumber(helperBean.getBig("VAT_Pct").movePointRight(2),localeLanguage,localeCountry,2,1)%>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
              </tr>
              <%
                helperBean.nextRow();
              }
              helperBean.closeResources();
              %>
              <tr class="resultsLabelTR">
                <td colspan="3" class="resultsLabelTD" style="text-align: center">
                  <input type="button" value="Αποθήκευση" onClick='document.updateForm.submit();' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
              </tr>
            </table>
          </form>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
</body>
</html>