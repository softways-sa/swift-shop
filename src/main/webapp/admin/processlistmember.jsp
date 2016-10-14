<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="show" scope="page" class="gr.softways.dev.eshop.emaillists.members.Present" />

<%
show.initBean(databaseId, request, response, this, session);

JSPBean supp = new JSPBean();

supp.initBean(databaseId, request, response, this, session);

String EMLMCode = request.getParameter("EMLMCode") != null ? request.getParameter("EMLMCode") : "",
       action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       urlCallReturn = request.getParameter("urlCallReturn") != null ? request.getParameter("urlCallReturn") : "";

if (urlCallReturn.length() == 0) {
    urlCallReturn = "emailmembers.jsp";
}

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/" + urlCallReturn + "?action1=UPDATE_SEARCH&goLabel=results"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlReturn = response.encodeURL(urlCallReturn + "?goLabel=results");

int found = 0;

if (action.equals("EDIT")) found = show.locateEmailMember(EMLMCode);
		
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

if (found < 0) {
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
    return;
}
else if (found >= 1) {
	EMLMEmail = show.getColumn("EMLMEmail");
	EMLMAltEmail = show.getColumn("EMLMAltEmail");
	EMLMLastName = show.getColumn("EMLMLastName");
	EMLMFirstName = show.getColumn("EMLMFirstName");
	
	if (show.getTimestamp("EMLMBirthDate") != null) {
	   EMLMBirthDateDay = SwissKnife.getTDateInt( show.getTimestamp("EMLMBirthDate"), "DAY");
	   EMLMBirthDateMonth = SwissKnife.getTDateInt( show.getTimestamp("EMLMBirthDate"), "MONTH");
	   EMLMBirthDateYear = SwissKnife.getTDateInt( show.getTimestamp("EMLMBirthDate"), "YEAR");
	}

	if (show.getTimestamp("EMLMRegDate") != null) {
	   EMLMRegDateDay = SwissKnife.getTDateInt( show.getTimestamp("EMLMRegDate"), "DAY");
	   EMLMRegDateMonth = SwissKnife.getTDateInt( show.getTimestamp("EMLMRegDate"), "MONTH");
	   EMLMRegDateYear = SwissKnife.getTDateInt( show.getTimestamp("EMLMRegDate"), "YEAR");
	}

	EMLMCompanyName = show.getColumn("EMLMCompanyName");
	EMLMAddress = show.getColumn("EMLMAddress");
	EMLMZipCode = show.getColumn("EMLMZipCode");
	EMLMCity = show.getColumn("EMLMCity");
	EMLMCountry = show.getColumn("EMLMCountry");
	EMLMPhone = show.getColumn("EMLMPhone");
	EMLMActive = Integer.parseInt( show.getColumn("EMLMActive") );
	
	EMLMField1 = show.getColumn("EMLMField1");
	EMLMField2 = show.getColumn("EMLMField2");
	EMLMField3 = show.getColumn("EMLMField3");
}

String[] months = new String[] {"","Ιαν","Φεβ","Μάρ","Απρ","Μάϊ","Ιουν","Ιουλ","Αυγ","Σεπ","Οκτ","Νοε","Δεκ"};
int currYear = SwissKnife.getTDateInt(SwissKnife.currentDate(), "YEAR");
%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE>ΔΙΑΧΕΙΡΙΣΗ ΣΤΟΙΧΕΙΩΝ ΜΕΛΟΥΣ</TITLE>

    <SCRIPT LANGUAGE="JavaScript" SRC="js/jsfunctions.js"></SCRIPT>

    <SCRIPT LANGUAGE="JavaScript" SRC="js/date.js"></SCRIPT>

    <script language="JavaScript">
	var downYear = 1990;
	var upYear = 2010;

	function showNewDate(d, m, y) {
            var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
            var weekDay = Math.floor(((dayFirst + d -1) % 7));  
            if (m >= 1 && m <= 12)	{
                document.inputForm.EMLMBirthDateMonth.options[document.inputForm.EMLMBirthDateMonth.selectedIndex].value = m;   
   		document.inputForm.EMLMBirthDateMonth.options[document.inputForm.EMLMBirthDateMonth.selectedIndex].text = monthName[m-1]; 
            }
		
            document.inputForm.EMLMBirthDateYear.options[document.inputForm.EMLMBirthDateYear.selectedIndex].value = y;   
            document.inputForm.EMLMBirthDateYear.options[document.inputForm.EMLMBirthDateYear.selectedIndex].text = y; 
 	
            document.inputForm.EMLMBirthDateDay.value = d;  
	}
	
	function showNewDate1(d, m, y) {
            var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
            var weekDay = Math.floor(((dayFirst + d -1) % 7));  
            if (m >= 1 && m <= 12)	{
                document.inputForm.EMLMRegDateMonth.options[document.inputForm.EMLMRegDateMonth.selectedIndex].value = m;   
   		document.inputForm.EMLMRegDateMonth.options[document.inputForm.EMLMRegDateMonth.selectedIndex].text = monthName[m-1]; 
            }
		
            document.inputForm.EMLMRegDateYear.options[document.inputForm.EMLMRegDateYear.selectedIndex].value = y;   
            document.inputForm.EMLMRegDateYear.options[document.inputForm.EMLMRegDateYear.selectedIndex].text = y; 
 		
            document.inputForm.EMLMRegDateDay.value = d;  
	}
    </script>

    <SCRIPT LANGUAGE="JavaScript">
        function checkForm(form) {
            if (form.EMLMEmail.value == "") {
                alert("Το email είναι απαραίτητο.");
		form.EMLMEmail.focus();
		return false;
            }
            else return true;
	}
    </SCRIPT>
</HEAD>

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
                    <td class="menuPathTD" align="middle"><b>Μέλη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Εγγραφή</b></td>
                    </tr>
                    </table>
                </td>
                <td width="70%" align = "middle">&nbsp;</td>
            </tr>
            </table>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td width="80%">
                
                    <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                    <tr>
                        <td class="tableheader" colspan="2" align="center">ΣΤΟΙΧΕΙA ΜΕΛΟΥΣ</td>
                    </tr>
        
                    <FORM NAME="inputForm" ACTION="<%= response.encodeURL("/servlet/admin/MailListMember") %>" METHOD="post">
                    
                    <input type="Hidden" name="action1" value="">
                    
                    <input type="Hidden" name="urlSuccess" value="<%= urlSuccess %>">
                    <input type="Hidden" name="urlFailure" value="<%= urlFailure %>">
                    <input type="Hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                    <input type="Hidden" name="databaseId" value="<%= databaseId %>">
                    <INPUT TYPE="hidden" NAME="buttonPressed" VALUE="0">
                    
                    <input type="Hidden" name="EMLMCode" value="<%= EMLMCode %>">
                    
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Επίθετο</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMLastName" size="40" maxlength="100" value="<%= EMLMLastName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Όνομα</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMFirstName" size="40" maxlength="100" value="<%= EMLMFirstName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Email</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMEmail" size="40" maxlength="150" value="<%= EMLMEmail %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Ενεργός</span></TD>
                        <td class="inputFrmFieldTD" colspan="2"><SELECT NAME="EMLMActive" style="HEIGHT: 25px; WIDTH: 100px" width="100" height="25" class="select">
                                <OPTION VALUE="1" <% if (EMLMActive == 1) { %> SELECTED <% } %> >ΝΑΙ</OPTION>
                                <OPTION VALUE="0" <% if (EMLMActive == 0) { %> SELECTED <% } %> >ΟΧΙ</OPTION>
                                <OPTION VALUE="2" <% if (EMLMActive == 2) { %> SELECTED <% } %> >ΑΠΕΓΓΡΑΦΗ</OPTION>
                            </SELECT>
                        </td>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Διεύθυνση</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMAddress" size="40" maxlength="100" value="<%= EMLMAddress %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Ταχ.Κώδικας</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMZipCode" size="40" maxlength="10" value="<%= EMLMZipCode %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Πόλη</span></TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMCity" size="40" maxlength="50" value="<%= EMLMCity %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Τηλέφωνο</TD>
                        <TD class="inputFrmFieldTD" colspan="2"><input type="Text" name="EMLMPhone" size="40" maxlength="50" value="<%= EMLMPhone %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></TD>
                    </TR>
                    <TR>
                        <td class="inputFrmLabelTD"><span class='normalBold'>Ημερομηνία εγγραφής</span></td>
                        <td class="inputFrmFieldTD" colspan='2'><INPUT TYPE="text" NAME="EMLMRegDateDay" VALUE="<% if (EMLMRegDateDay != 0) out.print(EMLMRegDateDay); %>" SIZE="3" MAXLENGTH="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                            <select name="EMLMRegDateMonth" style="HEIGHT: 25px; WIDTH: 80px" width="80" height="25" class="select">
                                <option value="">Μήνας</option>
                                <%
                                for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (EMLMRegDateMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                            <% 
                                } %>
                        </select>
                        <select name="EMLMRegDateYear" style="HEIGHT: 25px; WIDTH: 80px" width="80" height="25" class="select">
                                <option value="">Έτος</otpion>
                                <%
                                for (int i=(currYear - 5); i<=(currYear+5); i++) { %>
                                    <option value="<%= i %>" <% if (EMLMRegDateYear == i) out.print("SELECTED"); %> ><%= i %></otpion>
                            <%
                                } %>
                        </select>
                            <input type="button" name="b1" value="Calendar" onclick="show_calendar(1, window.self, document.inputForm.EMLMRegDateDay.value, document.inputForm.EMLMRegDateMonth.options[document.inputForm.EMLMRegDateMonth.selectedIndex].value, document.inputForm.EMLMRegDateYear.options[document.inputForm.EMLMRegDateYear.selectedIndex].value, 0, 'showNewDate1')" onMouseOver="this.className='submitFocused2'" onMouseOut="this.className='submit2'" class="submit2">
                        </td>
                    </TR>
                    <TR class="inputFrmFooter">
                        <TD colspan="3" align=center>
                        <%
                        if (action.equals("EDIT")) { %>
                            <input type="Button" value="Μεταβολή" onClick='if (checkForm(inputForm) == true) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.action1.value="UPDATE"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();} else return false; }' onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
                            <input type="Button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.inputForm.action1.value="DELETE"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit(); } else return false;' onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
                            <%
                        } 
                        else { %>
                            <input type="Button" value="Δημιουργία" onClick='if (checkForm(inputForm) == true) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();} else return false; }' onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
                            <%
                        } %>
                        <input type="Button" value="Επιστροφή" onClick='location.href="<%= urlReturn %>"' onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
                        </td>
                    </TR>
                    </table>
                </td>
    	
                <TD WIDTH="20%" VALIGN="TOP">
                    <TABLE WIDTH="100%" CELLSPACING="1" CELLPADDING="5" BORDER="0" class="tablecolor">
                    <TR>
                        <TD class="tableheader" colspan="2" align="center">ΔΙΑΘΕΣΙΜΕΣ ΛΙΣΤΕΣ</TD>
                    </TR>
                    <TR>
                        <TD class="inputFrmLabelTD"><span class='normalBold'>Λίστα</span></TD>
                        <TD class="inputFrmFieldTD"><span class='normalBold'>Συμμετοχή</span></TD>
                    </TR>
                    <% 
                    int rows = supp.getTable("emailListTab", "EMLTName");
                    
                    int memberRegisteredLists = 0;
        
                    if (found >= 1) {
                        memberRegisteredLists = show.locateMemberLists(EMLMCode);
                    }
        
                    for (int i=0; i<rows; i++) { %>
                        <TR>
                            <TD class="inputFrmLabelTD"><span class='normalBold'><%= supp.getColumn("EMLTName") %></span></TD>
                            <TD class="inputFrmFieldTD"><INPUT TYPE="checkbox" NAME="listMemberActive_<%= i %>" VALUE="1" <% if ( (memberRegisteredLists > 0) && show.locateOneRow("EMLRListCode", supp.getColumn("EMLTCode")) == true) out.print(" CHECKED"); %> onClick='document.inputForm.updated_<%= i %>.value = "1";'>
                                <INPUT TYPE="hidden" NAME="listCode_<%= i %>" VALUE="<%= supp.getColumn("EMLTCode") %>">
                                <INPUT TYPE="hidden" NAME="regCode_<%= i %>" VALUE="<% if (memberRegisteredLists > 0) out.print(show.getColumn("EMLRCode")); %>">
                                <INPUT TYPE="hidden" NAME="updated_<%= i %>" VALUE="0">
                            </TD>
                        </TR>
                    <%
                        supp.nextRow();
                    }
                    %>
                    <INPUT TYPE="hidden" NAME="listsRows" VALUE="<%= rows %>">
                    </TABLE>
                </TD>
            
            </tr>
            
            </FORM>
            
            </table>
        
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>

<% 
show.closeResources();
supp.closeResources();
%>

</BODY>
</HTML>
