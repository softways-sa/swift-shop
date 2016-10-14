<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ page import="gr.softways.dev.util.DbRet" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_searchgroup" scope="session" 
             class="gr.softways.dev.eshop.usergroups.Search" />

<%
app_searchgroup.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

String urlSearch = response.encodeURL("groups.jsp"),
       urlNewGroup = response.encodeURL("newgroup.jsp"),
       action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

dbRet = app_searchgroup.doAction(request);

if (dbRet.authError == 1) {
    app_searchgroup.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.authErrorCode) );
    return;
}

String userGroupName = app_searchgroup.getUserGroupName();

int rowCount = app_searchgroup.getRowCount();

int pageCount = 0, q = 0, pageNum = 1, 
    groupPages = 0, dispPages = 0, startRow = 0, rows = 0;

app_searchgroup.setDispRows(dispRows);
pageNum = app_searchgroup.getPageNum();
startRow = app_searchgroup.getStartRow();
groupPages = app_searchgroup.getGroupPages();

if (rowCount == 1 && action.equals("SEARCH")) { 
    response.sendRedirect( response.encodeURL( "processgroups.jsp?action1=SEARCH&action2=SEARCH&userGroupId=" + app_searchgroup.getColumn("userGroupId") ) );
    return;
}
%>

<HTML>
<HEAD>
    <%@ include file="include/metatags.jsp" %>

    <TITLE></TITLE>
	
    <SCRIPT LANGUAGE="JavaScript">
        function resetForm() {
            document.searchForm.userGroupName.value="";
	}		
    </SCRIPT>
	
    <SCRIPT LANGUAGE="JavaScript" SRC="js/jsfunctions.js"></SCRIPT>
</HEAD>

<body <%= bodyString %>>

    <center>
    <BR>

    <table width="80%" border="0" cellspacing="1" cellpadding="5" class="tablecolor">
    <form name="searchForm" method="POST" action="<%= urlSearch %>">
        <input type="Hidden" name="goLabel" value="results">
        <input type="Hidden" name="action1" value="SEARCH">

    <tr>
        <td colspan="2" class="tableheader" align="center">ΑΝΑΖΗΤΗΣΗ ΟΜΑΔΩΝ ΧΡΗΣΤΩΝ</td>
    </tr>
    <tr class="trcolor1">
        <td><span class="normalBold">Όνομα</span></td>
        <td><input type="Text" name="userGroupName" value="<%= userGroupName %>" size="25" class="input" onFocus="this.className='inputFocused'" onBlur="this.className='input'"></td>
    </tr>
    <tr class="tablefooter">
        <td colspan="2" align="center">
            <input type="Submit" name="" value="Αναζήτηση" class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
            <input type="Button" name="" value="Μηδενισμός πεδίων" onClick='resetForm()' class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
            <input type="Button" name="" value="Νέα Καταχώρηση" onClick='location.href = "<%= urlNewGroup %>"' class="submit" onMouseOver="this.className='submitFocused'" onMouseOut="this.className='submit'">
        </td>
    </tr>    
    </form>
    </table>

    <br>
    <A NAME="results"></a>

    <%
    // see if there are rows to display
    if (rowCount > 0) {
    
        // determine the number of pages
        if (rowCount > dispRows) {
            pageCount = (rowCount / dispRows);
            if ( (rowCount % dispRows) > 0 )
                pageCount++;
        }
        else pageCount = 1;
        %><br><br>

        <table width="80%" cellspacing="1" cellpadding="5" border="0" class="tablecolor">
        <tr>
            <td class="tableheader" colspan="2" align="center">ΑΠΟΤΕΛΕΣΜΑΤΑ ΑΝΑΖΗΤΗΣΗΣ</td>
        </tr>
        <tr class="columnheader">
            <td><span class="normalBold">Όνομα</span></td>
            <td><span class="normalBold">Περιγραφή</span></td>
	</tr>
        <%
        for (int i=0; i < dispRows; i++) { %>
            <tr class="trColor2" onmouseover="this.className='trColor1'" onmouseout="this.className='trColor2'">
                <td ><a href="<%= response.encodeURL( "processgroups.jsp?action1=SEARCH&action2=SEARCH&userGroupId=" + app_searchgroup.getHexColumn("userGroupId") ) %>" class="link"><%= app_searchgroup.getColumn("userGroupName") %></a></td>
		<td><span class="normal"><%= app_searchgroup.getColumn("userGroupDescr") %></span></td>
            </tr>
            <%
            if ( app_searchgroup.nextRow() == false ) break;
        }
        %>
        <%-- previus - next buttons --%>
        <tr class="tablefooter">
            <td colspan="2">
                <form name="nav" method="POST" action ="<%= response.encodeURL( "groups.jsp" ) %>" >
                      <%@ include file='include/navigationform.jsp' %>
            </td>
        </tr>    
	</form>
	<%-- / previus - next --%>

	</table>
	<%-- / παρουσίαση --%>



    <%
    } // if there were rows to display
    else { %>
        <%-- αναζήτηση χωρίς αποτελέσματα --%>
	<br><br>
	
            <!-- <center><b>Χώρος Αποτελεσμάτων</b></center> -->
	
        <%
    }
    %>
    <%-- / αναζήτηση χωρίς αποτελέσματα --%>
        
    </center>
    <br>
    
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
