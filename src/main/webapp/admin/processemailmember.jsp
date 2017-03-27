<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.eshop.emaillists.members.Present" />

<%
helperBean.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","newsletter");

JSPBean supp = new JSPBean();

supp.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       EMLMCode = request.getParameter("EMLMCode") != null ? request.getParameter("EMLMCode") : "",
       urlCallReturn = request.getParameter("urlCallReturn") != null ? request.getParameter("urlCallReturn") : "";
       
if (urlCallReturn.length() == 0) {
    urlCallReturn = "searchemailmembers.jsp";
}

String urlSuccess = "/" + appDir + "admin/" + urlCallReturn + "?action1=UPDATE_SEARCH&goLabel=results",
       urlFailure = "/" + appDir + "admin/problem.jsp",
       urlCancel = "/" + appDir + "admin/" + urlCallReturn + "?goLabel=results",
       urlSuccessInsAgain = "/" + appDir + "admin/processemailmember.jsp";

String EMLMEmail = "", EMLMAltEmail = "",
       EMLMLastName = "", EMLMFirstName = "",
       EMLMCompanyName = "", EMLMAddress = "",
       EMLMZipCode = "", EMLMCity = "",
       EMLMCountry = "", EMLMPhone = "",
       EMLMField1 = "", 
       EMLMField2 = "", EMLMField3 = "";

int EMLMBirthDateDay = 0 , EMLMBirthDateMonth = 0, EMLMBirthDateYear = 0,
    EMLMRegDateDay = 0 , EMLMRegDateMonth = 0, EMLMRegDateYear = 0,
    EMLMActive = -1;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = helperBean.locateEmailMember(EMLMCode);

    if (found < 0) {
        helperBean.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        
        return;
    }
    else if (found >= 1) {
        EMLMEmail = helperBean.getColumn("EMLMEmail");
        EMLMAltEmail = helperBean.getColumn("EMLMAltEmail");
        EMLMLastName = helperBean.getColumn("EMLMLastName");
        EMLMFirstName = helperBean.getColumn("EMLMFirstName");
        
        if (helperBean.getTimestamp("EMLMBirthDate") != null) {
           EMLMBirthDateDay = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMBirthDate"), "DAY");
           EMLMBirthDateMonth = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMBirthDate"), "MONTH");
           EMLMBirthDateYear = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMBirthDate"), "YEAR");
        }

        if (helperBean.getTimestamp("EMLMRegDate") != null) {
           EMLMRegDateDay = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMRegDate"), "DAY");
           EMLMRegDateMonth = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMRegDate"), "MONTH");
           EMLMRegDateYear = SwissKnife.getTDateInt( helperBean.getTimestamp("EMLMRegDate"), "YEAR");
        }

        EMLMCompanyName = helperBean.getColumn("EMLMCompanyName");
        EMLMAddress = helperBean.getColumn("EMLMAddress");
        EMLMZipCode = helperBean.getColumn("EMLMZipCode");
        EMLMCity = helperBean.getColumn("EMLMCity");
        EMLMCountry = helperBean.getColumn("EMLMCountry");
        EMLMPhone = helperBean.getColumn("EMLMPhone");
        EMLMActive = Integer.parseInt( helperBean.getColumn("EMLMActive") );
        
        EMLMField1 = helperBean.getColumn("EMLMField1");
        EMLMField2 = helperBean.getColumn("EMLMField2");
        EMLMField3 = helperBean.getColumn("EMLMField3");
        
        helperBean.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

String[] months = new String[] {"","Ιαν","Φεβ","Μάρ","Απρ","Μάϊ","Ιουν","Ιουλ","Αυγ","Σεπ","Οκτ","Νοε","Δεκ"};
int currYear = SwissKnife.getTDateInt(SwissKnife.currentDate(), "YEAR");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="JavaScript" src="js/date.js"></script>
    
    <script language="JavaScript">
    var downYear = 1990;
    var upYear = 2010;

    function validateForm(forma) {
      // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
      if (isEmpty(forma.EMLMEmail.value) == true) {
          alert("Το email είναι απαραίτητο.");
          forma.EMLMEmail.focus();
          return false;
      }
      else return true;
    }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>

    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    <td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Μέλη</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/MailListMember") %>">
        
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="EMLMCode" value="<%= EMLMCode %>" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            <tr>
                <td class="inputFrmLabelTD">Επίθετο</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMLastName" size="40" maxlength="100" value="<%= EMLMLastName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Όνομα</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMFirstName" size="40" maxlength="100" value="<%= EMLMFirstName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επωνυμία εταιρίας</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMCompanyName" size="40" maxlength="150" value="<%= EMLMCompanyName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">E-mail</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMEmail" size="40" maxlength="150" value="<%= EMLMEmail %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Εναλλακτικό e-mail</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMAltEmail" size="40" maxlength="150" value="<%= EMLMAltEmail %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ενεργός</td>
                <td class="inputFrmFieldTD">
                    <select name="EMLMActive" class="inputFrmField">
                        <option value="1" <% if (EMLMActive == 1) { %> SELECTED <% } %> >ΝΑΙ</option>
                        <option value="0" <% if (EMLMActive == 0) { %> SELECTED <% } %> >ΟΧΙ</option>
                        <option value="2" <% if (EMLMActive == 2) { %> SELECTED <% } %> >ΑΠΕΓΓΡΑΦΗ</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Διεύθυνση</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMAddress" size="40" maxlength="100" value="<%= EMLMAddress %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ταχ.Κώδικας</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMZipCode" size="40" maxlength="10" value="<%= EMLMZipCode %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Πόλη</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMCity" size="40" maxlength="50" value="<%= EMLMCity %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Χώρα</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMCountry" size="40" maxlength="50" value="<%= EMLMCountry %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τηλέφωνο</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMPhone" size="40" maxlength="50" value="<%= EMLMPhone %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ημερομηνία γέννησης</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="EMLMBirthDateDay" value="<% if (EMLMBirthDateDay != 0) out.print(EMLMBirthDateDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'EMLMBirthDateDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="EMLMBirthDateMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (EMLMBirthDateMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="EMLMBirthDateYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (EMLMBirthDateYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ημερομηνία εγγραφής</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="EMLMRegDateDay" value="<% if (EMLMRegDateDay != 0) out.print(EMLMRegDateDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'EMLMRegDateDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="EMLMRegDateMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (EMLMRegDateMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="EMLMRegDateYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (EMLMRegDateYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Πεδίο 1</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMField1" size="40" maxlength="100" value="<%= EMLMField1 %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Πεδίο 2</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMField2" size="40" maxlength="100" value="<%= EMLMField2 %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Πεδίο 3</td>
                <td class="inputFrmFieldTD"><input type="text" name="EMLMField3" size="40" maxlength="100" value="<%= EMLMField3 %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmHeader" colspan="2" align="center">Διαθέσιμες λίστες</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Λίστα</td>
                <td class="inputFrmLabelTD">Συμμετοχή</td>
            </tr>
            <% 
            int rows = supp.getTable("emailListTab", "EMLTName");
            
            int memberRegisteredLists = 0;

            if (found >= 1) {
                memberRegisteredLists = helperBean.locateMemberLists(EMLMCode);
            }

            for (int i=0; i<rows; i++) { %>
                <tr>
                    <td class="inputFrmLabelTD"><%= supp.getColumn("EMLTName") %></td>
                    <td class="inputFrmFieldTD">
                        <input type="checkbox" name="listMemberActive_<%= i %>" value="1" <% if ( (memberRegisteredLists > 0) && helperBean.locateOneRow("EMLRListCode", supp.getColumn("EMLTCode")) == true) out.print(" CHECKED"); %> onClick='document.inputForm.updated_<%= i %>.value = "1";' class="inputFrmField" />
                        <input type="hidden" name="listCode_<%= i %>" value="<%= supp.getColumn("EMLTCode") %>" />
                        <input type="hidden" name="regCode_<%= i %>" value="<% if (memberRegisteredLists > 0) out.print(helperBean.getColumn("EMLRCode")); %>" />
                        <input type="hidden" name="updated_<%= i %>" value="0" />
                    </td>
                </tr>
            <%
                supp.nextRow();
            } %>
            
            <input type="hidden" name="listsRows" value="<%= rows %>">
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit(); } }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit()} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; document.inputForm.submit() }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <% } %>
                    <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            
            </form>
            
            </table>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <%
    helperBean.closeResources();
    supp.closeResources();
    %>
    
</body>
</html>