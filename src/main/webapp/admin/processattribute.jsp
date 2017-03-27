<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="bean_attribute" scope="page" class="gr.softways.dev.eshop.attribute.Present" />

<%
DbRet dbRet = null;

bean_attribute.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       atrCode = request.getParameter("atrCode") != null ? request.getParameter("atrCode") : "";

String urlSuccess = "/" + appDir + "admin/attribute.jsp?action1=UPDATE_SEARCH&goLabel=results",
       urlRelAttribute = "/servlet/admin/RelateAttribute",
       urlATVA = "/servlet/admin/AttributeValue",
       urlFailure = "/" + appDir + "admin/problem.jsp",
       urlCancel = "/" + appDir + "admin/attribute.jsp?goLabel=results",
       urlSuccess1 = "/" + appDir + "admin/processattribute.jsp?action1=EDIT&atrCode=" + atrCode,
       urlSuccessInsAgain = "/" + appDir + "admin/processattribute.jsp";

String atrName = "", atrNameLG = "", atrKeepStock = "", atrHasPrice = "";
int ATVARows = 0;

int found = 0, rows = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = bean_attribute.getTablePK("attribute","atrCode",atrCode);
    if (found < 0) {
        bean_attribute.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found > 0) {
        atrName = bean_attribute.getColumn("atrName");        
        atrNameLG = bean_attribute.getColumn("atrNameLG");    
        atrKeepStock = bean_attribute.getColumn("atrKeepStock");        
        atrHasPrice = bean_attribute.getColumn("atrHasPrice");        
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

bean_attribute.closeResources();
%>

<html>
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript">
        function validateForm(forma) {
            // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
            if (forma.atrName.value == "") {
                alert('Η ονομασία είναι απαραίτητη.');
                forma.atrName.focus();
                return false;
            }
            else return true;
        }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            <tr height="40">
                <td width="30%" class="menuPathTD" align="middle">
                    <table width="0" border="0" cellspacing="2" cellpadding="2">
                    <tr>
                    <td class="menuPathTD" align="middle"><b>Ιδιότητες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Διαχείριση</b></td>
                    </tr>
                    </table>
                </td>
                <td width="70%" align = "middle">&nbsp;</td>
            </tr>
            </table>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/Attribute") %>">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="atrCode" value="<%= atrCode %>" />

            <input type="hidden" name="flag" value="" />

            <input type="hidden" value="0" name="buttonPressed" />

            <tr>
                <td class="inputFrmHeader" colspan="2" align="center"><%= tableHeader %></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmLabelTD"><%= atrCode %></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>            
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>            
                       <td class="inputFrmFieldTD">
                           <input type="text" name="atrName" size="80" maxlength="160" value="<%= atrName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                       </td>
                       <td><img src="images/flag.gif"></td>
                    </tr>
                    <tr>
                       <td class="inputFrmFieldTD">                       
                            <input type="text" name="atrNameLG" size="80" maxlength="160" value="<%= atrNameLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                       </td>
                       <td><img src="images/flagLG.gif"></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Παρακολούθηση Stock</td>            
                <td class="inputFrmFieldTD">
                    <select name="atrKeepStock" class="inputFrmField">
                        <option value="0" <% if (atrKeepStock.equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                        <option value="1" <% if (atrKeepStock.equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                    </select>                    
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προστιθέμενη Αξία</td>            
                <td class="inputFrmFieldTD">
                    <select name="atrHasPrice" class="inputFrmField">
                        <option value="0" <% if (atrHasPrice.equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                        <option value="1" <% if (atrHasPrice.equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                    </select>                    
                </td>
            </tr>            
            
 
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                    <%
                    if (action.equals("EDIT")) { %>
                    <td align="left" width="7%">
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); } }' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    </td>
                    <td align="left" width="11%">
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    </td>
                    <td align="left" width="7%">
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit()} else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    </td>
                    <td align="left" width="7%">
                        <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />                        
                    </td>
                    <td align="left" width="68%">&nbsp;</td>                                        
                    <%
                    }
                    else { %>
                    <td align="left" width="7%">
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    </td>
                    <td align="left" width="16%">
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; document.inputForm.submit() }' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    </td>
                    <td align="left" width="7%">
                        <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />                        
                    </td>
                    <td colspan="2" align="left" width="70%">&nbsp;</td>                    
                    <% } %>
                    </tr>
                    </table>
                </td>
            </tr>
            </form>
            </table>

            
            
            <%
            if (action.equals("EDIT")) { %>
            
                <%-- Attribute values { --%>
                <br/>
                <a name="ATVA"></a>
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="3" class="resultsHeader" align="center">Τιμές Ιδιότητας</td>
                </tr>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD" width="41%"><img src="images/flag.gif"></td>
                        <td class="resultsLabelTD" width="41%"><img src="images/flagLG.gif"></td>
                        <td class="resultsLabelTD" width="18%" >&nbsp;</td>
                    </tr>
                <%
                dbRet = bean_attribute.getValues(atrCode, "ATVACode");

                ATVARows = dbRet.getRetInt();

                if (ATVARows > 0 && dbRet.getNoError() == 1) { %>

                    <%
                    for (int i=0; i<ATVARows; i++) { %>
                        <form name="ATVAForm<%= i %>" method="post" action="<%= urlATVA %>">
                        <input type="hidden" name="action1" value="">
                        <input type="hidden" name="databaseId" value="<%= databaseId %>">
                        <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=ATVA" %>">
                        <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                        <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                        <input type="hidden" name="atrCode" value="<%= atrCode %>">
                        <input type="hidden" name="ATVACode" value="<%= bean_attribute.getColumn("ATVACode") %>">
                        
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" width="41%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                              <input type="text" name="ATVAValue" size="40" maxlength="250" value="<%= bean_attribute.getColumn("ATVAValue") %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                            </td>
                            <td class="resultsDataTD" width="41%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                              <input type="text" name="ATVAValueLG" size="40" maxlength="250" value="<%= bean_attribute.getColumn("ATVAValueLG") %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                            </td>                            
                            <td width="18%">
                                <input type="button" name="updateRow" value="Μεταβολή" onclick ='document.ATVAForm<%= i %>.action1.value="UPDATE"; document.ATVAForm<%= i %>.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                                <input type="button" name="delRow" value="Διαγραφή" onclick ='if (confirm("Είστε σίγουρος(η) ότι θέλετε να διαγράψετε την τιμή;") == true) { document.ATVAForm<%= i %>.action1.value="DELETE"; document.ATVAForm<%= i %>.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                            </td>
                        </tr>
                        </form>
                    <%
                        if (bean_attribute.nextRow() == false ) break;
                    }
                    bean_attribute.closeResources();
                }
                else if (dbRet.getAuthError() == 1)  { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="3">Δεν έχετε πρόσβαση σε αυτά τα στοιχεία</td>
                    </tr>
                <%
                } %>
                        <form name="ATVAForm" method="post" action="<%= urlATVA %>">
                        <input type="hidden" name="action1" value="">
                        <input type="hidden" name="databaseId" value="<%= databaseId %>">
                        <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=ATVA" %>">
                        <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                        <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                        <input type="hidden" name="atrCode" value="<%= atrCode %>">
                        
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" width="41%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                              <input type="text" name="ATVAValue" size="40" maxlength="250" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                            </td>
                            <td class="resultsDataTD" width="41%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                              <input type="text" name="ATVAValueLG" size="40" maxlength="250" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                            </td>                            
                            <td width="18%">
                                <input type="button" name="insertRow" value="Εισαγωγή" onclick ='document.ATVAForm.action1.value="INSERT"; document.ATVAForm.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                            </td>
                        </tr>
                        </form>
                </table>
                <%--  } Attribute values --%>            
            <%
            }
            %>            
            
            
            
            
            <%
            if (action.equals("EDIT")) { %>                
                <%-- Related Attributes { --%>
                <br/>
                <a name='relAttribute'></a>
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="2" class="resultsHeader" align="center">Εξαρτώμενη Ιδιότητα</td>
                </tr>
                <%
                dbRet = bean_attribute.getAdminRelatedAttributes(atrCode,"atrCode");
        
                rows = dbRet.getRetInt();
        
                if (rows > 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Ονομασία</td>
                        <td class="resultsLabelTD">&nbsp;</td>                        
                    </tr>
                    
                    <form name="unrelateAttributeForm" method="post" action="<%= urlRelAttribute %>">
                    <input type="hidden" name="action1" value="">
                    <input type="hidden" name="databaseId" value="<%= databaseId %>">
                    <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=relAttribute" %>">
                    <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                    <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                    <input type="hidden" name="SLATCode" value="">
        
                    <% 
                    for (int i=0; i<rows; i++) { %>
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= bean_attribute.getColumn("atrName") %></td>
                            <td class="resultsDataTD" width="18%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <input type="button" name="unrelateAttribute" value="αποσυσχέτιση" onclick ='if (confirm("Είστε σίγουρος(η) οτι θέλετε να αποσυσχετίσετε την εξαρτώμενη ιδιότητα;") == true) { document.unrelateAttributeForm.SLATCode.value="<%= bean_attribute.getColumn("SLATCode") %>"; document.unrelateAttributeForm.action1.value="UNRELATE"; document.unrelateAttributeForm.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                            </td>                    
                        </tr>
                    <%
                        if (bean_attribute.nextRow() == false ) break;
                    } 
                    bean_attribute.closeResources(); 
                    %>
                    </form>
                <%
                }
                else if (dbRet.getAuthError() == 1)  { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="2">Δεν έχετε πρόσβαση για προσθήκη εξαρτώμενης ιδιότητας.</td>
                    </tr>
                <%
                }
                else if (rows == 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="2">Δεν υπάρχει εξαρτώμενη ιδιότητα.</td>
                    </tr>
                <%
                } %>
                <form name="buttonForm1">
                    <tr class="resultsFooterTR">
                        <td colspan="2"><input type="button" value="Προσθήκη Εξαρτώμενης Ιδιότητας" onclick='location.href=("<%= response.encodeURL("relateattribute.jsp?action1=CLOSE_SEARCH&SLAT_master_atrCode=" + atrCode + "&atrName=" + atrName) %>")' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>
                    </tr>
                </form>
                </table>
                <%-- } Related Attributes --%>            
            <%
            }
            %>
       
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <%
    if (goLabel.length()>0) { %>
        <script language="javascript">
            document.location.hash = "<%= goLabel %>";
        </script>
    <% } %>    
</body>
</html>
