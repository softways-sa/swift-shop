<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.DbRet" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_processgroup" scope="session" 
             class="gr.softways.dev.eshop.usergroups.SearchSPGrp" />

<jsp:useBean id="app_processso" scope="session" 
             class="gr.softways.dev.eshop.securityobjects.SearchGrpSO" />
<%
app_processgroup.initBean(databaseId, request, response, this, session);

app_processso.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

dbRet = app_processgroup.doAction(request);

if (dbRet.authError == 1) {
    app_processgroup.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
} 

dbRet = app_processso.doAction(request);

if (dbRet.authError == 1) {
    app_processgroup.closeResources();
    app_processso.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
} 

String userGroupId = app_processgroup.getUserGroupId();

int rowCount2 = app_processgroup.getRowCount();

int pageCount2 = 0, q2 = 0, pageNum2 = 1, 
    groupPages2 = 0, dispPages2 = 0, startRow2 = 0, rows2 = 0;

app_processgroup.setDispRows(dispRows);
pageNum2 = app_processgroup.getPageNum();
startRow2 = app_processgroup.getStartRow();
groupPages2 = app_processgroup.getGroupPages();

int rowCount = app_processso.getRowCount();

int pageCount = 0, q = 0, pageNum = 1, 
    groupPages = 0, dispPages = 0, startRow = 0, rows = 0;

app_processso.setDispRows(dispRows);
pageNum = app_processso.getPageNum();
startRow = app_processso.getStartRow();
groupPages = app_processso.getGroupPages();

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

String urlSearchGrp = response.encodeURL("processgroups.jsp?action1=UPDATE_SEARCH"),
       urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processgroups.jsp?action1=UPDATE_SEARCH&action2=UPDATE_SEARCH&userGroupId=" + userGroupId + "&goLabel=results"),
       urlSuccessDelete = response.encodeURL("http://" + serverName + "/" + appDir + "admin/groups.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlSuccessLocalUpdate = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processgroups.jsp?action1=UPDATE_SEARCH&action2=UPDATE_SEARCH&userGroupId=" + userGroupId),
       urlSuccessSO = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processgroups.jsp?action1=UPDATE_SEARCH&action2=UPDATE_SEARCH&userGroupId=" + userGroupId + "&goLabel=results2"),
       urlFailure  = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlReturn = response.encodeURL("groups.jsp?action1=UPDATE_SEARCH&goLabel=results");

String userGroupName       = app_processgroup.getColumn("userGroupName");
String userGroupDescr      = app_processgroup.getColumn("userGroupDescr");
String userGroupDefFlag    = app_processgroup.getColumn("userGroupDefFlag");
String userGroupGrantLogin = app_processgroup.getColumn("userGroupGrantLogin");  
%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE></TITLE>
	
    <SCRIPT LANGUAGE="JavaScript">
        function validateForm(){
            if (document.updateGrpForm.userGroupName.value == ""){
                alert("Παρακαλούμε εισάγετε το όνομα");
                document.updateGrpForm.userGroupName.focus();
                return false;
            }
            return true;
        }
    </SCRIPT>

    <SCRIPT LANGUAGE="JavaScript" SRC="js/jsfunctions.js"></SCRIPT>
</HEAD>

<body <%= bodyString %>>

    <center>
    <BR>

    <table width="80%" cellspacing="1" cellpadding="5" border="0" class="tablecolor">
    <tr>
        <td class="tableheader" colspan="2" align="center">ΣTOIXEIA ΟΜΑΔΩΝ ΧΡΗΣΤΩΝ</td>
    </tr>

    <FORM NAME="updateGrpForm" ACTION="<%= response.encodeURL("/servlet/admin/UserGroups") %>" METHOD="post">
        <input type="Hidden" name="action1" value="">
        <input type="Hidden" name="urlSuccess" value="">
        <input type="Hidden" name="urlFailure" value="<%= urlFailure %>">
        <input type="Hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
        <input type="Hidden" name="databaseId" value="<%= databaseId %>">
        <input type="Hidden" name="userGroupId" value="<%= userGroupId %>">
        <INPUT TYPE="hidden" NAME="buttonPressed" VALUE="0">
        
        <TR class="trcolor1">
            <TD><span class="normalBold">Κωδικός</span></TD>
            <TD><span class="normal"><%= userGroupId %></span></TD>
        </TR>
        <TR class="trcolor1">
            <TD><span class="normalBold">Όνομα</span></TD>
            <TD><INPUT TYPE="text" NAME="userGroupName" VALUE="<%= userGroupName %>" SIZE="25"  MAXLENGTH="25" class="input" onFocus="this.className='inputFocused'" onBlur="this.className='input'"></TD>
        </TR>
        <TR class="trcolor1">
            <TD><span class="normalBold">Περιγραφή</span></TD>
            <TD><INPUT TYPE="text" NAME="userGroupDescr" VALUE="<%= userGroupDescr %>" SIZE="40" MAXLENGTH="250" class="input" onFocus="this.className='inputFocused'" onBlur="this.className='input'"></TD>
        </TR>
        <TR class="trcolor1">
            <TD><span class="normalBold">Εξ' ορισμού ομάδα (κύρια χρήση για τους πελάτες του καταστήματος)</span></TD>
            <TD>
                <select name="userGroupDefFlag" style="HEIGHT: 25px; WIDTH: 200px" width="200" height="25" class="select">
                    <option value="0" <% if (userGroupDefFlag.equals("0")) out.print("SELECTED"); %> >ΟΧΙ</option>
                    <option value="1" <% if (userGroupDefFlag.equals("1")) out.print("SELECTED"); %> >ΝΑΙ</option>
    		</select>
            </TD>
        </TR>
        <TR class="trcolor1">
            <TD><span class="normalBold">Δυνατότητα σύνδεσης στο σύστημα διαχείρισης</span></TD>
            <TD>
                <select name="userGroupGrantLogin" style="HEIGHT: 25px; WIDTH: 200px" width="200" height="25" class="select">
                    <option value="0" <% if (userGroupGrantLogin.equals("0")) out.print("SELECTED"); %> >ΟΧΙ</option>
                    <option value="1" <% if (userGroupGrantLogin.equals("1")) out.print("SELECTED"); %> >ΝΑΙ</option>
    		</select>
            </TD>
        </TR>
        <TR class="tablefooter">
            <TD colspan="2" align="center">
                <INPUT TYPE="button" VALUE="Μεταβολή" onClick='if (validateForm() == true){ if (checkButton(document.updateGrpForm.buttonPressed) == true) { document.updateGrpForm.action1.value="UPDATE"; document.updateGrpForm.urlSuccess.value="<%= urlSuccessLocalUpdate %>"; document.updateGrpForm.submit(); } else return false}' class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
                <INPUT TYPE="button" VALUE="Διαγραφή" onClick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.updateGrpForm.action1.value="DELETE"; document.updateGrpForm.urlSuccess.value="<%= urlSuccessDelete %>";document.updateGrpForm.submit(); } else return false;' class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
                <input type="button" value="Επιστροφή" onClick='document.location.href="<%= urlReturn %>"' class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
            </TD>
        </TR>    
    </FORM>    
    </TABLE>

    <br>
    <A NAME="results"></a>
    <%
    // see if there are rows to display
    if (rowCount2 > 0) {

    // determine the number of pages
        if (rowCount2 > dispRows) {
            pageCount2 = (rowCount2 / dispRows);
            if ( (rowCount2 % dispRows) > 0 )
                pageCount2++;
        }
        else pageCount2 = 1;
  
        // move the pointer of the queryDataSet to the appropriate row
        app_processgroup.goToRow(startRow2);
        %>

        <table width="80%" cellspacing="1" cellpadding="5" border="0" class="tablecolor">
        <tr>
            <td class="tableheader" colspan="6" align="center">ΕΝΕΡΓΟΠΟΙΗΜΕΝΕΣ ΑΡΜΟΔΙΟΤΗΤΕΣ</td>
        </tr>
        <form name="changeForm" method="post" action="<%= response.encodeURL("/servlet/admin/UserGroups") %>" onSubmit='return checkButton(document.changeForm.buttonPressed)'>
            <INPUT TYPE="hidden" NAME="buttonPressed" VALUE="0">
            <input type="Hidden" name="action1" value="UPDATE_PERM">
            <input type="Hidden" name="urlSuccess" value="<%= urlSuccess %>">
            <input type="Hidden" name="urlFailure" value="<%= urlFailure %>">
            <input type="Hidden" name="databaseId" value="<%= databaseId %>">
            <input type="Hidden" name="userGroupId" value="<%= userGroupId %>">
            <INPUT TYPE="hidden" NAME="delRow" VALUE="0">

            <%-- παρουσίαση --%>
            <tr class="columnheader">
                <td><span class="normalBold">Όνομα</span></td>
                <td align="center"><span class="normalBold">Ανάγνωση</span></td>
                <td align="center"><span class="normalBold">Καταχώρηση</span></td>
                <td align="center"><span class="normalBold">Μεταβολή</span></td>
                <td align="center"><span class="normalBold">Διαγραφή</span></td>
                <td align="center"><span class="normalBold">Αφαίρεση</span></td>
            </tr>
            <%
            int rowCounter = 0;
  
            for (int i=0; i < dispRows; i++)  {
                rowCounter = i;
                %>
                <tr class="trColor2" onmouseover="this.className='trColor1'" onmouseout="this.className='trColor2'">
                    <INPUT TYPE="hidden" NAME="updated<%= i %>" VALUE="0">
                    <INPUT TYPE="hidden" NAME="SPObject<%= i %>" VALUE="<%= app_processgroup.getColumn("SPObject") %>">
                    <td><span class="normal"><%= app_processgroup.getColumn("SPObject") %></span></td>
                    <td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="authRead<%= i %>" VALUE="1" <% if ( (app_processgroup.getInt("SPPermissions") & 1) > 0 ) out.print(" CHECKED"); %> onClick = 'document.changeForm.updated<%= i %>.value = 1;'></td>
                    <td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="authInsert<%= i %>" VALUE="2" <% if ( (app_processgroup.getInt("SPPermissions") & 2) > 0 ) out.print(" CHECKED"); %> onClick = 'document.changeForm.updated<%= i %>.value = 1;'></td>
                    <td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="authUpdate<%= i %>" VALUE="4" <% if ( (app_processgroup.getInt("SPPermissions") & 4) > 0 ) out.print(" CHECKED"); %> onClick = 'document.changeForm.updated<%= i %>.value = 1;'></td>
                    <td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="authDelete<%= i %>" VALUE="8" <% if ( (app_processgroup.getInt("SPPermissions") & 8) > 0 ) out.print(" CHECKED"); %> onClick = 'document.changeForm.updated<%= i %>.value = 1;'></td>
                    <td ALIGN="MIDDLE"><INPUT TYPE="button" NAME="delete<%= i %>" VALUE="αφαίρεση" onClick = 'document.changeForm.action1.value="DEL_PERM";document.changeForm.delRow.value="<%= i %>";document.changeForm.submit()' onMouseOver="this.className='submitFocused2'" onMouseOut="this.className='submit2'" class="submit2"></td>
                </tr>
                <%
                if ( app_processgroup.nextRow() == false ) break;
            }
            %>
            <INPUT TYPE="hidden" NAME="rowCounter" VALUE="<%= rowCounter %>">
            <tr class="tablefooter">
                <td colspan="6" align="center">
                    <INPUT TYPE="submit" VALUE="ΜΕΤΑΒΟΛΗ" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
                </td>
            </tr>   
        </form>    
	<%-- / παρουσίαση --%>

	<%-- previus - next buttons --%>
        <tr class="tablefooter">
            <td colspan='6'> 
                <form name="nav" method="POST" action ="<%= urlSearchGrp %>" >
                  <input type="Hidden" name="userGroupId" value="<%= userGroupId %>">
                  <input type="Hidden" name="sr2" value="<%= startRow2 %>">
                  <input type="Hidden" name="p2" value="<%= pageNum2 %>">
                  <input type="Hidden" name="dr" value="<%= dispRows %>">
                  <input type="Hidden" name="rowCount2" value="<%= rowCount2 %>">
                  <input type="Hidden" name="gp2" value="<%= groupPages2 %>">

                  <input type="Hidden" name="goLabel" value="results">

                  <table width="0" cellspacing="0" cellpadding="2" border="0">
                    <tr>
                        <td><span class="normal">Σελίδες</span></td>
	  	        <% // create & display references to the pages
			if ( (groupPages2 + 10) < pageCount2 )
                            dispPages2 = groupPages2 + 10;
  			else dispPages2 = pageCount2;
                            q = groupPages2 * dispRows;
                        if (groupPages2 > 0) { %><td><a href="javascript:document.nav.gp2.value=<%= groupPages2 - 10 %>;document.nav.submit()"><img src="images/backw10.gif" border=0 alt="προηγούμενες 10"></a><% }
                        else { %> <td><img src="images/blank_nav.gif" border=0></td> <% } %>
                        <td>
  			<% for (int i=groupPages2; i<dispPages2; i++) { %>
                            <a href='javascript:document.nav.sr2.value="<%= q %>"; document.nav.p2.value="<%= i+1 %>"; document.nav.submit()' <% if(pageNum2 == i+1) { %> class="bLink" <% } else { %> class="link" <% } %> ><%= i+1 %></a> 
			   <%  q += dispRows;
  			     }
			   %>
			</td>
                        <% if ( (groupPages2+10) < pageCount2 ) { %><td><a href="javascript:document.nav.gp2.value=<%= groupPages2 + 10 %>;document.nav.submit()"><img src="images/forw10.gif" border=0 alt="επόμενες 10"></a></td><% }
                        else { %> <td><img src="images/blank_nav.gif" border=0></td> <% } %>

                        <% if (pageNum2  > 1) { %><td><a href="javascript:document.nav.p2.value=<%= pageNum2 - 1 %>; document.nav.sr2.value=<%= startRow2 - dispRows %>; document.nav.submit()"><img src="images/backw.gif"  border=0 alt="προηγούμενη σελίδα"></td></a><% }
                        else { %><td><img src="images/blank_nav.gif"  border=0></td> <% } %>
                        <% if (pageNum2 < pageCount2) { %><td><a href="javascript:document.nav.p2.value=<%= pageNum2 + 1 %>; document.nav.sr2.value=<%= startRow2 + dispRows %>; document.nav.submit()"><img src="images/forw.gif" border=0 alt="επόμενη σελίδα"></td></a><% }
                        else { %><td><img src="images/blank_nav.gif" border=0 alt="next"></td> <% } %>
                    </tr>
                </table>	
            </td>
        </tr>
        </form> 
    </table>
	<%-- / previus - next --%>
<br>
<%
  } // if there were rows to display
  else {
%>
	<%-- αναζήτηση χωρίς αποτελέσματα --%>
	<br><br>
	
	  <!-- <center><b>Χώρος Αποτελεσμάτων</b></center> -->
	
<%
  }
%>
	<%-- / αναζήτηση χωρίς αποτελέσματα --%>

<br>
<A NAME="results2"></A>


<%
  //------------------------second list------------------------------------------
  // see if there are rows to display
  if (rowCount > 0) {

  // determine the number of pages
  if (rowCount > dispRows) {
    pageCount = (rowCount / dispRows);
    if ( (rowCount % dispRows) > 0 )
      pageCount++;
  }
  else pageCount = 1;
  
  // move the pointer of the queryDataSet to the appropriate row
  app_processso.goToRow(startRow);
%>
    
    <table width="80%" cellspacing="1" cellpadding="5" border="0" class="tablecolor">
    <tr>
        <td class="tableheader" colspan="5" align="center">ΜΗ ΕΝΕΡΓΟΠΟΙΗΜΕΝΕΣ ΑΡΜΟΔΙΟΤΗΤΕΣ</td>
    </tr>
    <form name="addForm" method="post" action="<%= response.encodeURL("/servlet/admin/UserGroups") %>" onSubmit='return checkButton(document.addForm.buttonPressed)'>
        <INPUT TYPE="hidden" NAME="buttonPressed" VALUE="0">
        <input type="Hidden" name="action1" value="ADD_PERM">
        <input type="Hidden" name="urlSuccess" value="<%= urlSuccessSO %>">
        <input type="Hidden" name="urlFailure" value="<%= urlFailure %>">
        <input type="Hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
        <input type="Hidden" name="databaseId" value="<%= databaseId %>">
        <input type="Hidden" name="userGroupId" value="<%= userGroupId %>">

	<%-- παρουσίαση objects --%>
	<tr class="columnheader">
            <td align="center"><span class="normalBold">Όνομα</span></td>
            <td align="center"><span class="normalBold">Αναγνωση</span></td>
            <td align="center"><span class="normalBold">Καταχώρηση</span></td>
            <td align="center"><span class="normalBold">Μεταβολή</span></td>
            <td align="center"><span class="normalBold">Διαγραφή</span></td>
	</tr>
        <%
        // display 
        int rowCounter2=0;
  
        for (int i=0; i < dispRows; i++) {
            rowCounter2 = i;
            %>
            <tr class="trColor2" onmouseover="this.className='trColor1'" onmouseout="this.className='trColor2'">
                <INPUT TYPE="hidden" NAME="SOUpdated<%= i %>" VALUE="0">
		<INPUT TYPE="hidden" NAME="SOObjectName<%= i %>" VALUE="<%= app_processso.getColumn("SOObjectName") %>">
		<td ><span class="normal"><%= app_processso.getColumn("SOObjectName") %></span></td>
		<td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="SOAuthRead<%= i %>" VALUE="1" <% if ( (app_processso.getInt("SODefPerm") & 1) > 0 ) out.print(" CHECKED"); %> onClick = 'document.addForm.SOUpdated<%= i %>.value = 1;'></td>
		<td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="SOAuthInsert<%= i %>" VALUE="2" <% if ( (app_processso.getInt("SODefPerm") & 2) > 0 ) out.print(" CHECKED"); %> onClick = 'document.addForm.SOUpdated<%= i %>.value = 1;'></td>
		<td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="SOAuthUpdate<%= i %>" VALUE="4" <% if ( (app_processso.getInt("SODefPerm") & 4) > 0 ) out.print(" CHECKED"); %> onClick = 'document.addForm.SOUpdated<%= i %>.value = 1;'></td>
		<td ALIGN="MIDDLE"><INPUT TYPE="checkbox" NAME="SOAuthDelete<%= i %>" VALUE="8" <% if ( (app_processso.getInt("SODefPerm") & 8) > 0 ) out.print(" CHECKED"); %> onClick = 'document.addForm.SOUpdated<%= i %>.value = 1;'></td>
            </tr>
            <%
            if ( app_processso.nextRow() == false ) break;
        }
        %>
	<INPUT TYPE="hidden" NAME="rowCounter2" VALUE="<%= rowCounter2 %>">
        <tr class="tablefooter">
            <td colspan="5" align="center">
                <INPUT TYPE="submit" VALUE="ΠΡΟΣΘΗΚΗ" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'" class="submit">
            </td>
        </tr>    
        </form>
	     
	<%-- / παρουσίαση --%>

	<%-- previus - next buttons --%>
        <tr class="tablefooter">
            <td colspan='5'> 
                <form name="nav2" method="POST" action ="<%= response.encodeURL( "processgroups.jsp" ) %>" >
                  <input type="Hidden" name="userGroupId" value="<%= userGroupId %>">
                  <input type="Hidden" name="sr" value="<%= startRow %>">
                  <input type="Hidden" name="p" value="<%= pageNum %>">
                  <input type="Hidden" name="dr" value="<%= dispRows %>">
                  <input type="Hidden" name="rowCount" value="<%= rowCount %>">
                  <input type="Hidden" name="gp" value="<%= groupPages %>">

                  <input type="Hidden" name="goLabel" value="results2">  

                  <table width="0" cellspacing="0" cellpadding="2" border="0">
                  <tr>
                    <td><span class="normal">Σελίδες</span></td>
                    <% // create & display references to the pages
                    if ( (groupPages + 10) < pageCount )
                        dispPages = groupPages + 10;
                    else dispPages = pageCount;
                        q2 = groupPages * dispRows;
                        if (groupPages > 0) { %><td><a href="javascript:document.nav2.gp.value=<%= groupPages - 10 %>;document.nav2.submit()"><img src="images/backw10.gif" border=0 alt="προηγούμενες 10"></a><% }
                        else { %> <td><img src="images/blank_nav.gif" border=0></td> <% } %>
                    <td>
                    <%
                        for (int i=groupPages; i<dispPages; i++) { %>
                            <a href='javascript:document.nav2.sr.value="<%= q2 %>"; document.nav2.p.value="<%= i+1 %>"; document.nav2.submit()' <% if(pageNum == i+1) { %> class="bLink" <% } else { %> class="link" <% } %>><%= i+1 %></a> 
                            <%  q2 += dispRows;
                        }
                        %>
                    </td>
                    <%
                    if ( (groupPages+10) < pageCount ) { %>
                        <td><a href="javascript:document.nav2.gp.value=<%= groupPages + 10 %>;document.nav2.submit()"><img src="images/forw10.gif" border=0 alt="επόμενες 10"></a></td><% }
                    else { %> 
                        <td><img src="images/blank_nav.gif" border=0></td> <%
                    } %>
                    <% if (pageNum  > 1) { %><td><a href="javascript:document.nav2.p.value=<%= pageNum - 1 %>; document.nav2.sr.value=<%= startRow - dispRows %>; document.nav2.submit()"><img src="images/backw.gif"  border=0 alt="προηγούμενη σελίδα"></td></a><% }
                       else { %><td><img src="images/blank_nav.gif"  border=0></td> <% } %>
                    <% if (pageNum < pageCount) { %><td><a href="javascript:document.nav2.p.value=<%= pageNum + 1 %>; document.nav2.sr.value=<%= startRow + dispRows %>; document.nav2.submit()"><img src="images/forw.gif" border=0 alt="επόμενη σελίδα"></td></a><% }
                       else { %><td><img src="images/blank_nav.gif" border=0 alt="next"></td> <% } %>
                  </tr>
                  </table>
              </td>
          </tr>    
          </form>
          </table>
	
	<%-- / previus - next --%>
	
<%
  } // if there were rows to display
  else {
%>
	<%-- αναζήτηση χωρίς αποτελέσματα --%>
	<br><br>
	
	  <!-- <center><b>Χώρος Αποτελεσμάτων</b></center> -->
	
<%
  }
%>
    <%-- / αναζήτηση χωρίς αποτελέσματα --%>

    <br>
    </center>

    <SCRIPT LANGUAGE="JavaScript">
     <% 
     if (goLabel.equals("") == false) { %>
       document.location.hash = "<%= goLabel %>";            
     <%
     }
     %>
    </SCRIPT>

</BODY>
</HTML>
