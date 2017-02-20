<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="processcateg" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
processcateg.initBean(databaseId, request, response, this, session);

request.setAttribute("admin.topmenu","products");

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       catId = request.getParameter("catId") != null ? request.getParameter("catId") : "";

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/category.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlSuccess1 = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processcateg.jsp?action1=EDIT&catId=" + catId),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/category.jsp?goLabel=results"),
       urlSuccessInsAgain = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processcateg.jsp");

String catName = "", catNameLG = "", catNameLG1 = "", keywords = "", 
       keywordsLG = "", catParentFlag = "", catShowFlag = "1",
       catImgName1 = "", catImgName2 = "", catDescr = "", catDescrLG = "";
       
int catRank = 0;

int found = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = processcateg.getTablePK("prdCategory", "catId", catId);

    if (found < 0) {
        processcateg.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found >= 1) {
        catName = processcateg.getColumn("catName");
        catNameLG = processcateg.getColumn("catNameLG");
        catNameLG1 = processcateg.getColumn("catNameLG1");
        keywords = processcateg.getColumn("keywords");
        keywordsLG = processcateg.getColumn("keywordsLG");
        catParentFlag = processcateg.getColumn("catParentFlag");
        catShowFlag = processcateg.getColumn("catShowFlag");
        catRank = processcateg.getInt("catRank");
        
        catImgName1 = processcateg.getColumn("catImgName1");
        catImgName2 = processcateg.getColumn("catImgName2");
        
        catDescr = processcateg.getColumn("catDescr");
        catDescrLG = processcateg.getColumn("catDescrLG");
        
        processcateg.closeResources();
    }
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
    
    <style>
    #uploading-loader {
      position: fixed;
      top: 50%;
      left: 50%;
    }
    #uploading-loader div {
      width: 44px;
      height: 44px;
      background: url('images/ajax-loader-black.gif') center center no-repeat;
    }
    
    #uploading-overlay {
      position: absolute;
      top: 0;
      left: 0;
      overflow: hidden;
      display: none;
      z-index: 8010;
      background: #000000;
      opacity: 0.5;
      filter: alpha(opacity=50);
      display: block;
    }
    #uploading-overlay.overlay-fixed {
      position: fixed;
      bottom: 0;
      right: 0;
    }
    </style>
    
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>
    
    <script language="JavaScript">
    function validateForm(forma) {
      // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
      if (isEmpty(forma.catId.value)) {
          alert("Παρακαλούμε πληκτρολογήστε τον κωδικό.");
          forma.catId.focus();
          return false;
      }
      else if (isEmpty(forma.catName.value)) {
          alert("Παρακαλούμε πληκτρολογήστε την ονομασία.");
          forma.catName.focus();
          return false;
      }
      else if (isInteger(forma.catRank.value) == false) {
          alert("Το πεδίο είναι αριθμητικό.");
          forma.catRank.focus();
          return false;
      }
      else return true;
    }
    
    tinyMCE.init({
        elements : "catDescr,catDescrLG",
        verify_html : false,
        relative_urls : false,
        theme : "advanced",
        mode : "exact",
        entity_encoding : "raw",
        plugins : "table,template,advlink,paste,advhr,media,advimage",
        content_css : "/css/core.css",
        theme_advanced_buttons1 : "bold, italic, underline, |, justifyleft, justifycenter, justifyright, justifyfull, separator, anchor, formatselect, fontselect, fontsizeselect, forecolor, backcolor",
        theme_advanced_buttons2 : "removeformat, advhr,  |, sub, sup, |, bullist, numlist, |,media,  separator, pasteword, table, row_props, cell_props, delete_col, delete_row, col_after, col_before, row_after, row_before, split_cells, merge_cells, image, link, unlink, visualaid, template, code",
        theme_advanced_buttons3 : "",
        extended_valid_elements : "a[name|href|target|title|onclick|rel],hr[class|width|size|noshade]"
    });
    
    $(document).ready(function() {
      $('#inputForm').submit(function() {
        $('body').append('<div id="uploading-overlay" style="display: block;"></div>');
        $('#uploading-overlay').addClass('overlay-fixed');
        
        $("body").append('<div id="uploading-loader"><div></div></div>');
      });
    });
    
    function sendForm() {
      $('#inputForm').submit();
    }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Κατηγορία προϊόντων</b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form id="inputForm" name="inputForm" method="post" action="<%= response.encodeURL("/servlet/admin/PrdCategory") %>" enctype="multipart/form-data">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="uploadPath" value="<%= userImagesFilePath %>" />
            <input type="hidden" name="oldimg1" value="<%=catImgName1%>" />
            <input type="hidden" name="oldimg2" value="<%=catImgName2%>" />
            <input type="hidden" name="flag" value="" />
            
            <input type="hidden" name="imageMaxWidth" value="300" />
            <input type="hidden" name="imageMaxHeight" value="210" />
            <input type="hidden" name="bgColor" value="#ffffff" />
            
            <input type="hidden" value="0" name="buttonPressed" />
            
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmFieldTD"><input type="text" name="catId" maxlength="25" value="<%= catId %>" <% if (action.equals("EDIT")) out.print("onfocus=\"blur();\""); else out.print("onfocus=\"this.className='inputFrmFieldFocus'\""); %> class="inputFrmField" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ονομασία</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" /></td>
                        <td class="inputFrmFieldTD"><input type="text" name="catName" size="80" maxlength="160" value="<%= catName %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif" /></td>
                        <td class="inputFrmFieldTD"><input type="text" name="catNameLG" size="80" maxlength="160" value="<%= catNameLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Περιέχει υποκατηγορίες</td>
                <td class="inputFrmFieldTD">
                    <select name="catParentFlag" class="inputFrmField">
                        <option value="1" <% if (catParentFlag.equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                        <option value="0" <% if (catParentFlag.equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Βαρύτητα εμφάνισης <br/>(υψηλή τιμή-υψηλή θέση εμφάνισης)</td>
                <td class="inputFrmFieldTD"><input type="text" name="catRank" size="5" value="<%= catRank %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Εμφανίζεται</td>
                <td class="inputFrmFieldTD"><input type="checkbox" name="catShowFlag" value="1" <% if (catShowFlag.equals("1")) out.print("CHECKED"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κείμενο</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                   <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><textarea name="catDescr" id="catDescr" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= catDescr %></textarea></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><textarea name="catDescrLG" id="catDescrLG" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= catDescrLG %></textarea></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Φωτογραφία</td>
                <%
                if (catImgName1.equals("")) { %>
                    <td class="inputFrmFieldTD"><input type="file" name="img1" size="80" /></td>
                <%
                }
                else { %>
                    <td class="inputFrmFieldTD"><img src="/images/<%=catImgName1%>" alt="" width="200" height="150"/>&nbsp;&nbsp;<input type="file" name="img1" size="80" /> <input type="button" name="" value="Διαγραφή φωτογραφίας" onclick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.inputForm.flag.value = "1"; document.inputForm.action1.value="DELETE_IMG"; document.inputForm.urlSuccess.value="<%= urlSuccess1 %>"; sendForm(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"></td>
                <% } %>
            </tr>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center">
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; sendForm(); }}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; sendForm(); }}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; sendForm();} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; sendForm();}' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; sendForm(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
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
    
    <% processcateg.closeResources(); %>
    
</body>
</html>