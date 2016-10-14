<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="bean_selectattributevalue" scope="session" class="gr.softways.dev.eshop.product.v2.ShowAttributeValue" />

<jsp:useBean id="bean_selectslaveattributevalue" scope="session" class="gr.softways.dev.eshop.product.v2.ShowAttributeValue" />

<%
bean_selectattributevalue.initBean(databaseId, request, response, this, session);
bean_selectslaveattributevalue.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

String atrCode = request.getParameter("atrCode") != null ? request.getParameter("atrCode") : "",
       prdId = request.getParameter("prdId") != null ? request.getParameter("prdId") : "",
       PMACode = request.getParameter("PMACode") != null ? request.getParameter("PMACode") : "";

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

if (atrCode.length() == 0 || prdId.length() == 0) {
    bean_selectattributevalue.closeResources();
    response.sendRedirect( response.encodeURL("problem.jsp"));
    return;
}

String [][] PMAV = bean_selectattributevalue.getPMAV(PMACode,localeLanguage,localeCountry);
bean_selectattributevalue.closeResources();

dbRet = bean_selectattributevalue.getSlaveAttribute(atrCode);
if (dbRet.getAuthError() == 1) {
    bean_selectattributevalue.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}
String SLAT_slave_atrCode = "";
if (dbRet.getRetInt() > 0) {
  SLAT_slave_atrCode = bean_selectattributevalue.getColumn("SLAT_slave_atrCode");
}
bean_selectattributevalue.closeResources();


dbRet = bean_selectattributevalue.getAttributeValues(atrCode);
int atrRows = dbRet.getRetInt();
if (dbRet.getAuthError() == 1) {
    bean_selectattributevalue.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}
String atrName = bean_selectattributevalue.getColumn("atrName");
String atrKeepStock = bean_selectattributevalue.getColumn("atrKeepStock");
String atrHasPrice = bean_selectattributevalue.getColumn("atrHasPrice");
String slaveAtrName = "", slaveAtrKeepStock = "", slaveAtrHasPrice = "";

int slaveRows = 0;
if (SLAT_slave_atrCode.length() > 0) {
  dbRet = bean_selectslaveattributevalue.getAttributeValues(SLAT_slave_atrCode);
  slaveRows = dbRet.getRetInt(); 
  if (slaveRows > 0) {
    slaveAtrName = bean_selectslaveattributevalue.getColumn("atrName");
    slaveAtrKeepStock = bean_selectslaveattributevalue.getColumn("atrKeepStock");
    slaveAtrHasPrice = bean_selectslaveattributevalue.getColumn("atrHasPrice");
  }
}

String urlSuccess1 = response.encodeURL("http://" + serverName + "/" + appDir + "admin/" + "selectattributevalue.jsp?atrCode=" + atrCode + "&prdId=" + prdId + "&PMACode=" + PMACode),
       urlSuccess = response.encodeURL("product_update.jsp?action1=EDIT&prdId=" + prdId),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlPMAV = response.encodeURL("/servlet/admin/ProductAttributeValue"),
       urlPMASV = response.encodeURL("/servlet/admin/ProductAttributeValue");
%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <div align="center">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
 
            <tr>
                <td class="menuPathTD" align="middle" width="40%" height="40">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                        <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Προϊόν:&nbsp;<%= prdId %>&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;<%= atrName %>&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Επιλογή τιμών</b></td>
                    </tr>
                    </table>
                </td>
                <td width="60%">&nbsp;</td>
                
            </tr>
           
            </table>

            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Τιμή</td>            
                <td class="resultsLabelTD"> Εξαρτώμενη Τιμή</td>
                <td class="resultsLabelTD">&nbsp;</td>
                <%
                if (atrKeepStock.equals("1") || slaveAtrKeepStock.equals("1")) { %>
                <td class="resultsLabelTD">Stock</td>
                <%
                } else { %>
                <td class="resultsLabelTD">&nbsp;</td>
                <%
                } %>
                <%
                if (atrHasPrice.equals("1") || slaveAtrHasPrice.equals("1")) { %>
                <td class="resultsLabelTD">Πρ.Αξία</td>
                <%
                } else { %>
                <td class="resultsLabelTD">&nbsp;</td>
                <%
                } %>                
                <td class="resultsLabelTD">Φωτο μικρή</td>
                <td class="resultsLabelTD">Φωτο μεγάλη</td>
                <td class="resultsLabelTD">Βαρύτητα</td>
                <td width="18%">&nbsp;</td>
            </tr>
            <%
            // display
            int i = 0;
            int jj = 0;
            int PMAVIndex = -1, PMASVIndex = -1;
            for (i=0; i < atrRows; i++) {
              PMAVIndex = bean_selectattributevalue.getPMAVIndex(PMAV,2,bean_selectattributevalue.getColumn("ATVACode"));              
            %>
                    <form name="PMAVForm<%= i %>" method="post" action="<%= urlPMAV %>">
                      <a name="<%= bean_selectattributevalue.getColumn("ATVACode") %>"></a>
                      <input type="hidden" name="action1" value="">
                      <input type="hidden" name="databaseId" value="<%= databaseId %>">
                      <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 %>">
                      <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                      <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                      <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>">
                      <input type="hidden" name="localeCountry" value="<%= localeCountry %>">
                      <input type="hidden" name="goLabel" value="<%= bean_selectattributevalue.getColumn("ATVACode") %>">
                      <input type="hidden" name="PMACode" value="<%= PMACode %>">
                      <input type="hidden" name="atrCode" value="<%= atrCode %>">
                      <input type="hidden" name="PMAV_ATVACode" value="<%= bean_selectattributevalue.getColumn("ATVACode") %>">
                      <%
                      if (PMAVIndex >= 0) { %>
                      <input type="hidden" name="PMAVCode" value="<%= PMAV[PMAVIndex][0] %>">
                      <%
                      }
                      else {  %>
                      <input type="hidden" name="PMAVCode" value="">
                      <%
                      } %>
                      <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= bean_selectattributevalue.getColumn("ATVAValue") %></td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <%
                        if (PMAVIndex >= 0) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><img src="images/checked.gif" /></td>
                        <%
                        if (atrKeepStock.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVStock" size="10" maxlength="20" value="<%= PMAV[PMAVIndex][4] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        } else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        }
                        if (atrHasPrice.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVPrice" size="10" maxlength="20" value="<%= PMAV[PMAVIndex][5] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVImageName_s" size="20" maxlength="250" value="<%= PMAV[PMAVIndex][6] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVImageName_b" size="20" maxlength="250" value="<%= PMAV[PMAVIndex][7] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVRank" size="3" maxlength="3" value="<%= PMAV[PMAVIndex][10] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td width="18%">
                          <input type="button" name="updateRow" value="Μεταβολή" onclick ='document.PMAVForm<%= i %>.action1.value="UPDATEMASTER"; document.PMAVForm<%= i %>.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                          <input type="button" name="delRow" value="Διαγραφή" onclick ='if (confirm("Είστε σίγουρος(η) ότι θέλετε να διαγράψετε την τιμή;") == true) { document.PMAVForm<%= i %>.action1.value="DELETEMASTER"; document.PMAVForm<%= i %>.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                        </td>
                        <%
                        }
                        else { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <%
                        if (atrKeepStock.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVStock" size="10" maxlength="20" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <%
                        if (atrHasPrice.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVPrice" size="10" maxlength="20" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVImageName_s" size="20" maxlength="250" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVImageName_b" size="20" maxlength="250" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMAVRank" size="3" maxlength="3" value="0" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>                        
                        <td width="18%"><input type="button" name="insertRow" value="Επιλογή" onclick ='document.PMAVForm<%= i %>.action1.value="INSERTMASTER"; document.PMAVForm<%= i %>.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>                  
                        <%
                        }  %>
                        
                      </tr>
                    </form>
                    <%
                    bean_selectslaveattributevalue.goToRow(0);
                    for (int j=0; j < slaveRows; j++, jj++) {
                      PMASVIndex = bean_selectattributevalue.getPMASVIndex(PMAV,2,bean_selectattributevalue.getColumn("ATVACode"),3,bean_selectslaveattributevalue.getColumn("ATVACode"));
                    %>
                    <form name="PMASVForm<%= jj %>" method="post" action="<%= urlPMASV %>">
                      <input type="hidden" name="action1" value="">
                      <input type="hidden" name="databaseId" value="<%= databaseId %>">
                      <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 %>">
                      <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                      <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                      <input type="hidden" name="goLabel" value="<%= bean_selectattributevalue.getColumn("ATVACode") %>">
                      <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>">
                      <input type="hidden" name="localeCountry" value="<%= localeCountry %>">
                      <input type="hidden" name="PMACode" value="<%= PMACode %>">
                      <%
                      if (PMAVIndex >= 0) { %>
                      <input type="hidden" name="PMAVCode" value="<%= PMAV[PMAVIndex][0] %>">
                      <%
                      }
                      else {  %>
                      <input type="hidden" name="PMAVCode" value="">
                      <%
                      } 
                      if (PMASVIndex >= 0) { %>
                      <input type="hidden" name="PMASVCode" value="<%= PMAV[PMASVIndex][1] %>">
                      <%
                      }
                      else {  %>
                      <input type="hidden" name="PMASVCode" value="">
                      <%
                      } %>
                      <input type="hidden" name="atrCode" value="<%= atrCode %>">
                      <input type="hidden" name="PMAV_ATVACode" value="<%= bean_selectattributevalue.getColumn("ATVACode") %>">                      
                      <input type="hidden" name="PMASV_ATVACode" value="<%= bean_selectslaveattributevalue.getColumn("ATVACode") %>">
                      <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">                    
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>                
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= bean_selectslaveattributevalue.getColumn("ATVAValue") %></td>

                        <%
                        if (PMASVIndex >= 0) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><img src="images/checked.gif" /></td>
                        <%
                        if (slaveAtrKeepStock.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVStock" size="10" maxlength="20" value="<%= PMAV[PMASVIndex][8] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <%
                        if (slaveAtrHasPrice.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVPrice" size="10" maxlength="20" value="<%= PMAV[PMASVIndex][9] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVRank" size="3" maxlength="3" value="<%= PMAV[PMASVIndex][11] %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>                        
                        <td width="18%">
                          <input type="button" name="updateRow" value="Μεταβολή" onclick ='document.PMASVForm<%= jj %>.action1.value="UPDATESLAVE"; document.PMASVForm<%= jj %>.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                          <input type="button" name="delRow" value="Διαγραφή" onclick ='if (confirm("Είστε σίγουρος(η) ότι θέλετε να διαγράψετε την τιμή;") == true) { document.PMASVForm<%= jj %>.action1.value="DELETESLAVE"; document.PMASVForm<%= jj %>.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                        </td>
                        <%
                        }
                        else { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <%
                        if (slaveAtrKeepStock.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVStock" size="10" maxlength="20" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <%
                        if (slaveAtrHasPrice.equals("1")) { %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVPrice" size="10" maxlength="20" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <%
                        }  else { %>
                        <td class="resultsDataTD">&nbsp;</td>
                        <%
                        } %>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                          <input type="text" name="PMASVRank" size="3" maxlength="3" value="0" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>                                                
                        <%
                        if (PMAVIndex >= 0) {
                        %>
                        <td width="18%">
                          <input type="button" name="insertRow" value="Επιλογή" onclick ='document.PMASVForm<%= jj %>.action1.value="INSERTSLAVE"; document.PMASVForm<%= jj %>.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                        </td>
                        <%
                        }
                        else {
                        %>
                        <td width="18%">&nbsp;</td>                        
                        <% 
                        }
                        } %>
                      </tr>                      
                    </form>                    
                    <%
                      bean_selectslaveattributevalue.nextRow();
                    }
                bean_selectattributevalue.nextRow();
            }
            %>
            <%-- / παρουσίαση ιδιοτήτων --%>
          
            <tr class="resultsFooterTR">
                <td colspan="9" align="right"><input type="button" value="Επιστροφή" onclick='location.href=("<%= urlSuccess %>")' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>
            </tr>
            
            </table>
            
            </div>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% 
    if (goLabel.length()>0) { %>
        <script type="text/javascript" language="javascript">
            document.location.hash = "<%= goLabel %>";
        </script>
    <% }     
    
    bean_selectattributevalue.closeResources(); 
    bean_selectslaveattributevalue.closeResources();
    %>
    
</body>
</html>
