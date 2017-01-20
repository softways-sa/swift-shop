<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.sql.Timestamp, gr.softways.dev.util.*,gr.softways.dev.util.SwissKnife,gr.softways.dev.swift.cmcategory.CMCategoryType" %>

<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="sw_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<jsp:useBean id="sw_cmcategory" scope="page" class="gr.softways.dev.swift.cmcategory.Present" />

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","content");

DbRet dbRet = null;

sw_cmrow.initBean(databaseId, request, response, this, session);
sw_cmcategory.initBean(databaseId, request, response, this, session);
helperBean.initBean(databaseId, request, response, this, session);

String action = request.getParameter("action1") != null ? request.getParameter("action1") : "",
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"), 
       CMRCode = request.getParameter("CMRCode") != null ? request.getParameter("CMRCode") : "",
       tab = request.getParameter("tab") == null ? "" : request.getParameter("tab");

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/cmrow.jsp?action1=UPDATE_SEARCH&goLabel=results"),
       urlCMCat = response.encodeURL("/servlet/admin/RelateCMRowCMCategory"),        
       urlRelCMRow = response.encodeURL("/servlet/admin/RelateCMRow"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlCancel = response.encodeURL("http://" + serverName + "/" + appDir + "admin/cmrow.jsp?goLabel=results"),
       urlSuccess1 = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processcmrow.jsp?action1=EDIT&CMRCode=" + CMRCode),        
       urlSuccessInsAgain = response.encodeURL("http://" + serverName + "/" + appDir + "admin/processcmrow.jsp");

       String[] months = new String[] {"","Ιαν","Φεβ","Μαρ","Απρ","Μάϊ","Ιουν","Ιουλ","Αυγ","Σεπ","Οκτ","Νοε","Δεκ"};

Timestamp currentDate = SwissKnife.currentDate();

int currYear = SwissKnife.getTDateInt(currentDate, "YEAR");

String CMRTitle = "", CMRTitleLG = "", 
       CMRSummary = "", CMRSummaryLG = "",
       CMRText = "",  CMRTextLG = "",
       CMRKeyWords = "", CMRKeyWordsLG = "",
       CMRIsSticky = "", CMCCode = "", CCCR_CMCCode = "", CCCRRank = "",
       CMRHeadHTML = "", CMRBodyHTML = "";

int CMRDateCreatedDay = 0, CMRDateCreatedMonth = 0, CMRDateCreatedYear = 0;
int CMRDateUpdatedDay = 0, CMRDateUpdatedMonth = 0, CMRDateUpdatedYear = 0;

Timestamp CMRDateCreated = null, CMRDateUpdated = null;

int found = 0, rows = 0;

String tableHeader = "";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
    
    found = sw_cmrow.getTablePK("CMRow","CMRCode",CMRCode);
    if (found < 0) {
        sw_cmrow.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + found) );
        return;
    }
    else if (found > 0) {
        CMRIsSticky = sw_cmrow.getColumn("CMRIsSticky");
        CMRKeyWords = sw_cmrow.getColumn("CMRKeyWords");
        CMRKeyWordsLG = sw_cmrow.getColumn("CMRKeyWordsLG");
        CMRTitle = sw_cmrow.getColumn("CMRTitle");
        CMRTitleLG = sw_cmrow.getColumn("CMRTitleLG");
        CMRSummary = sw_cmrow.getColumn("CMRSummary");
        CMRSummaryLG = sw_cmrow.getColumn("CMRSummaryLG");
        CMRText = sw_cmrow.getColumn("CMRText");
        CMRTextLG = sw_cmrow.getColumn("CMRTextLG");
	
        if ( ( CMRDateCreated  = sw_cmrow.getTimestamp("CMRDateCreated") ) != null ) {
            CMRDateCreatedDay = SwissKnife.getTDateInt(CMRDateCreated,"DAY");
            CMRDateCreatedMonth = SwissKnife.getTDateInt(CMRDateCreated,"MONTH");
            CMRDateCreatedYear = SwissKnife.getTDateInt(CMRDateCreated,"YEAR");
        }
        if ( ( CMRDateUpdated  = sw_cmrow.getTimestamp("CMRDateUpdated") ) != null ) {
            CMRDateUpdatedDay = SwissKnife.getTDateInt(CMRDateUpdated,"DAY");
            CMRDateUpdatedMonth = SwissKnife.getTDateInt(CMRDateUpdated,"MONTH");
            CMRDateUpdatedYear = SwissKnife.getTDateInt(CMRDateUpdated,"YEAR");
        }
        
        CMRHeadHTML = sw_cmrow.getColumn("CMRHeadHTML");
        CMRBodyHTML = sw_cmrow.getColumn("CMRBodyHTML");
    }
}
else {
  tableHeader = "Στοιχεία νέας εγγραφής";

  CMRDateCreatedDay = SwissKnife.getTDateInt(currentDate,"DAY");
  CMRDateCreatedMonth = SwissKnife.getTDateInt(currentDate,"MONTH");
  CMRDateCreatedYear = SwissKnife.getTDateInt(currentDate,"YEAR");

  CMRDateUpdatedDay = SwissKnife.getTDateInt(currentDate,"DAY");
  CMRDateUpdatedMonth = SwissKnife.getTDateInt(currentDate,"MONTH");
  CMRDateUpdatedYear = SwissKnife.getTDateInt(currentDate,"YEAR");
}

sw_cmrow.closeResources();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
    
    <style>
    ul.tabs {
            margin: 0;
            padding: 0;
            list-style: none;
            height: 32px;
            background-color:#ebedf4;
            border-bottom: 1px solid #ffffff;
            border-left: 0px solid #999;
            width: 100%;
	    font-family: Arial, Helvetica, sans-serif;
            font-size: 11px;
    }
    ul.tabs li {
            float: left;
            margin: 0;
	    font-family: Arial, Helvetica, sans-serif;
            padding: 0;
            height: 31px;
            line-height: 31px;
            border: 0px solid #999;
            border-left: none;
            margin-bottom: -1px;
            background: #b2b2b2;
            overflow: hidden;
            position: relative;
    }
    ul.tabs li a {
    	    font-family: Arial, Helvetica, sans-serif;
            text-decoration: none;
            color: #ffffff;
            display: block;
            font-size: 1.2em;
            padding: 0 20px;
            border: 1px solid #fff;
            outline: none;
    }
    ul.tabs li a:hover {
            background: #00adee;
	    color: #ffffff;
    }	
    html ul.tabs li.active {
            background: #00adee;
            font-weight:bold;
	    color: #ffffff;
    }
    html ul.tabs li.active a:hover {
            background: #00adee;
            font-weight:bold;
	    color: #ffffff;
    }    
    .tab_container {
            width: 100%;
            background: #00adee;
            border: 1px solid #999;
            border-top: none;
            clear: both;
            float: left; 
	    color: #ffffff;
    }
    
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
    
    #slidetab1, #slidetab2, #slidetab3, #slidetab4, #slidetab5 {display: none;}
    </style>
<style type="text/css">
.stab {
	-moz-box-shadow:inset 0px 1px 0px 0px #bbdaf7;
	-webkit-box-shadow:inset 0px 1px 0px 0px #bbdaf7;
	box-shadow:inset 0px 1px 0px 0px #bbdaf7;
	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #79bbff), color-stop(1, #378de5) );
	background:-moz-linear-gradient( center top, #79bbff 5%, #378de5 100% );
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#79bbff', endColorstr='#378de5');
	background-color:#79bbff;
	-moz-border-radius:6px;
	-webkit-border-radius:6px;
	border-radius:6px;
	border:1px solid #84bbf3;
	display:inline-block;
	color:#ffffff;
	font-family:arial;
	font-size:14px;
	font-weight:normal;
	padding:6px 24px;
	text-decoration:none;
	text-shadow:1px 1px 0px #528ecc;
}.stab:hover {
	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #378de5), color-stop(1, #79bbff) );
	background:-moz-linear-gradient( center top, #378de5 5%, #79bbff 100% );
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#378de5', endColorstr='#79bbff');
	background-color:#378de5;
}.stab:active {
	position:relative;
	top:1px;
}
</style>
	
    <script type="text/javascript" src="js/jquery.min.js"></script>
    
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    <script language="JavaScript" src="js/date.js"></script>
    
    <script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>
    
    <script language="JavaScript">
    function validateForm(forma) {
        // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
        if (forma.CMRDateCreatedDay.value == "") {
            alert('Η ημ/νία είναι απαραίτητη.');
            forma.CMRDateCreatedDay.focus();
            return false;
        }
        else if (forma.CMRDateCreatedMonth.options[forma.CMRDateCreatedMonth.selectedIndex].value == "") {
            alert('Η ημ/νία είναι απαραίτητη.');
            forma.CMRDateCreatedMonth.focus();
            return false;
        }
        else if (forma.CMRDateCreatedYear.options[forma.CMRDateCreatedYear.selectedIndex].value == "") {
            alert('Η ημ/νία είναι απαραίτητη.');
            forma.CMRDateCreatedYear.focus();
            return false;
        }
        else if (forma.CMRTitle.value == "") {
            alert('Ο τίτλος είναι απαραίτητος.');
            forma.CMRTitle.focus();
            return false;
        }
        else return true;
    }

    var downYear = <%= currYear - yearDnLimit %>;
    var upYear = <%= currYear + yearUpLimit %>;

    <%
    if (!"1".equals(CMRIsSticky)) { %>
      tinyMCE.init({
        elements : "CMRSummary,CMRSummaryLG,CMRText,CMRTextLG",
        verify_html : false,
        relative_urls : false,
        theme : "advanced",
        mode : "exact",
        entity_encoding : "raw",
        plugins : "table,template,advlink,paste,advhr,media,fullscreen,advimage",
        content_css : "/css/core.css",
        theme_advanced_buttons1 : "bold, italic, underline, |, justifyleft, justifycenter, justifyright, justifyfull, separator, anchor, formatselect, fontselect, fontsizeselect, forecolor, backcolor, separator, fullscreen",
        theme_advanced_buttons2 : "removeformat, advhr,  |, sub, sup, |, bullist, numlist, |,media,  separator, pasteword, table, row_props, cell_props, delete_col, delete_row, col_after, col_before, row_after, row_before, split_cells, merge_cells, image, link, unlink, visualaid, template, code",
        theme_advanced_buttons3 : "",
        extended_valid_elements : "a[id|onclick|rel|rev|charset|hreflang|tabindex|accesskey|type|name|href|target|title|class|onfocus|onblur],hr[class|width|size|noshade]",
        template_templates : [
        {
          title : "Πίνακας οριζόντιος",
          src : "/admin/tinymce_templates/template1.html",
          description : ""
        },
        {
          title : "Πίνακας κάθετος",
          src : "/admin/tinymce_templates/template2.html",
          description : ""
        }
        ]
      });
    <% } %>
    
    function focusTab(tab) {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class

        $('#' + 'a' + tab).addClass("active"); //Add "active" class to selected tab

        $(".tab_content").hide(); //Hide all tab content

        $('#' + tab).show(); // show active content
    }
    
    function sendFiles() {
      $('#prdImagesForm').submit();
    }
    
    $(document).ready(function() {
      //Default Action
      $(".tab_content").hide(); //Hide all content
      $("ul.tabs li:first").addClass("active").show(); //Activate first tab
      $(".tab_content:first").show(); //Show first tab content

      //On Click Event
      $("ul.tabs li").click(function() {
          $("ul.tabs li").removeClass("active"); //Remove any "active" class
          $(this).addClass("active"); //Add "active" class to selected tab
          $(".tab_content").hide(); //Hide all tab content
          var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
          $(activeTab).fadeIn(); //Fade in the active content
          return false;
      });
      
      $('#prdImagesForm').submit(function() {
        $('body').append('<div id="uploading-overlay" style="display: block;"></div>');
        $('#uploading-overlay').addClass('overlay-fixed');
        
        $("body").append('<div id="uploading-loader"><div></div></div>');
      });
    });
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>

    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    <td class="menuPathTD" align="middle"><b>Περιεχόμενο&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Σελίδα</b></td>
    </tr>
    </table>

    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <ul class="tabs">
              <li id="atab1"><a href="#tab1">Κεντρική σελίδα</a></li>
              <%
              if (action.equals("EDIT")) {%>
                <li id="atab9"><a href="#tab9">Gallery</a></li>
              <%
              } %>
            </ul>
            
            <div class="tab_content" id="tab1">
            
            <form name="inputForm" method="POST" action="<%= response.encodeURL("/servlet/admin/CMRow") %>">
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <input type="hidden" name="CMRCode" value="<%= CMRCode %>" />

            <input type="hidden" name="flag" value="" />

            <input type="hidden" value="0" name="buttonPressed" />
            
            <input type="hidden" name="guploadPath" value="<%=wwwrootFilePath+"/gimages"%>" />
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmLabelTD"><%= CMRCode %></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Καταχώρηση</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="CMRDateCreatedDay" value="<% if (CMRDateCreatedDay != 0) out.print(CMRDateCreatedDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'CMRDateCreatedDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="CMRDateCreatedMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (CMRDateCreatedMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="CMRDateCreatedYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (CMRDateCreatedYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ενημέρωση</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="CMRDateUpdatedDay" value="<% if (CMRDateUpdatedDay != 0) out.print(CMRDateUpdatedDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'CMRDateUpdatedDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="CMRDateUpdatedMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (CMRDateUpdatedMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="CMRDateUpdatedYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (CMRDateUpdatedYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Απενεργοποίηση html editor</td>
                <td class="inputFrmFieldTD">
                    <input type="checkbox" name="CMRIsSticky" value="1" <% if (CMRIsSticky.equals("1")) out.print("CHECKED"); %> class="inputFrmField"/>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τίτλος</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                       <td><img src="images/flag.gif"></td>
                       <td class="inputFrmFieldTD"><input type="text" name="CMRTitle" size="80" maxlength="160" value="<%= CMRTitle %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td><img src="images/flagLG.gif"></td>
                       <td class="inputFrmFieldTD"><input type="text" name="CMRTitleLG" size="80" maxlength="160" value="<%= CMRTitleLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Λέξεις-κλειδιά (keywords)</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><img src="images/flag.gif"></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMRKeyWords" size="80" maxlength="500" value="<%= CMRKeyWords %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><input type="text" name="CMRKeyWordsLG" size="80" maxlength="500" value="<%= CMRKeyWordsLG %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Περίληψη</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><textarea name="CMRSummary" id="CMRSummary" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRSummary %></textarea></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><textarea name="CMRSummaryLG" id="CMRSummaryLG" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRSummaryLG %></textarea></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κείμενο</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" ></td>
                        <td class="inputFrmFieldTD"><textarea name="CMRText" id="CMRText" cols="100" rows="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRText %></textarea></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif"></td>
                        <td class="inputFrmFieldTD"><textarea name="CMRTextLG" id="CMRTextLG" cols="100" rows="20" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRTextLG %></textarea></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">head html code</td>
                <td class="inputFrmFieldTD"><textarea name="CMRHeadHTML" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRHeadHTML %></textarea></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">bottom html code</td>
                <td class="inputFrmFieldTD"><textarea name="CMRBodyHTML" cols="100" rows="10" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%= CMRBodyHTML %></textarea></td>
            </tr>
            
            <%
            int CMCRows = 0;
            if (!action.equals("EDIT")) { %>
            <tr>
                <% 
                CMCRows = sw_cmrow.getTable("CMCategory","CMCCode");
                %>
                <td class="inputFrmLabelTD">Ενότητα - Βαρύτητα - Απόκρυψη</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td class="inputFrmFieldTD">
                        <select name="CMCCode" class="inputFrmField">
                        <%
                        String identStr = "";
                        for (int i=0; i < CMCRows; i++) {
                            if (CMCCode.equals(CMCategoryType.HIDDEN)) { %>
                            <option value="<%= CMCategoryType.HIDDEN %>" SELECTED >Πουθενά</option>
                            <%
                            } else { 
                                int depth = sw_cmrow.getColumn("CMCCode").trim().length()/2;
                                identStr = "";
                                for (int ii=0; ii < depth-1; ii++){
                                    identStr += "--";
                                }
                            %>
                            <option value="<%= sw_cmrow.getColumn("CMCCode") %>" <% if (sw_cmrow.getColumn("CMCCode").equals(CCCR_CMCCode)) { %> SELECTED <% } %>><%= identStr + sw_cmrow.getColumn("CMCName") %></option>
                            <%
                            } 
                    
                            sw_cmrow.nextRow();
                        }
                        %>
                        </select>
                        </td>
                        <td class="inputFrmFieldTD">
                            <input type="text" name="CCCRRank" size="4" maxlength="4" value="<%= CCCRRank %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        </td>
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                            <select name="CCCRIsHidden" class="inputFrmField">
                                <option value="1">ΝΑΙ</option>
                                <option value="0" SELECTED>ΟΧΙ</option>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <%
            sw_cmrow.closeResources();
            }
            %>
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                    <%
                    if (action.equals("EDIT")) { %>
                    <td>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; tinyMCE.triggerSave(); document.inputForm.submit(); } }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /> 
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; tinyMCE.triggerSave(); document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /> 
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; tinyMCE.triggerSave(); document.inputForm.submit()} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /> 
                        <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />                        
                    </td>
                    <%--<td align="right" width="46%">
                        <select name="ELCode" class="inputFrmField">
                            <option value="" SELECTED>----</option>
                            <%
                            int ELRows = 0;
                            ELRows = helperBean.getTable("emailList","ELCode");
                            for (int i=0; i < ELRows; i++) {
                                if (helperBean.getColumn("ELActive").equals("1")) {
                            %>
                                <option value="<%= helperBean.getColumn("ELCode") %>" <% if (helperBean.getColumn("ELIsDefault").equals("1")) { %> SELECTED <% } %>><%= helperBean.getColumn("ELName") %></option>
                            <%
                                }
                                helperBean.nextRow();
                            }
                            helperBean.closeResources();
                            %>
                        </select>
                    </td>
                    <td align="right" width="7%">
                        <input type="button" value="Αποστολή" onClick='if (confirm("Είστε σίγουρος(η) για την αποστολή στην επιλεγμένη λίστα; Αν έχτε κάνει αλλαγές ακυρώστε την αποστολή και πατήστε <Μεταβολή> πρώτα.") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="SENDTOEMAILLIST"; document.inputForm.submit()} else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />                        
                    </td>--%>
                    <%
                    }
                    else { %>
                        <td>
                            <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; tinyMCE.triggerSave(); document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                            <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; tinyMCE.triggerSave(); document.inputForm.submit() }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                            <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />                        
                        </td>
                    <% } %>
                    </tr>
                    </table>
                </td>
            </tr>
            
            </form>
            
            </table>
                    
            <%
            if (action.equals("EDIT")) { %>
            
                <%-- Related categories { --%>
                <br/>
                <a name="CMCat"></a>
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="5" class="resultsHeader" align="center">Συσχετισμένες ενότητες</td>
                </tr>
                <%
                dbRet = sw_cmrow.getRelatedCMCategories(CMRCode, "CMCCode");

                CMCRows = dbRet.getRetInt();

                if (CMCRows > 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Ονομασία</td>
                        <td class="resultsLabelTD">Βασική ενότητα</td>
                        <td class="resultsLabelTD">Σε απόκρυψη</td>
                        <td class="resultsLabelTD">Βαρύτητα</td>
                        <td class="resultsLabelTD" width="18%" >&nbsp;</td>
                    </tr>
                    <%
                    for (int i=0; i<CMCRows; i++) { %>
                        <form name="relatedCMCatForm<%= i %>" method="post" action="<%= urlCMCat %>">
                        <input type="hidden" name="action1" value="">
                        <input type="hidden" name="databaseId" value="<%= databaseId %>">
                        <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=CMCat" %>">
                        <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                        <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                        <input type="hidden" name="CMRCode" value="<%= CMRCode %>">
                        <input type="hidden" name="CMCCode" value="<%= sw_cmrow.getColumn("CMCCode") %>">
                        
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <%
                                int CMCatParentsRows = sw_cmcategory.getParents(sw_cmrow.getColumn("CMCCode"), "CMCCode").getRetInt();
                                
                                for (int x=0; x<CMCatParentsRows-1; x++) { %>
                                    <%= sw_cmcategory.getColumn("CMCName") %>&nbsp;&gt;&nbsp;
                                <%
                                    sw_cmcategory.nextRow();
                                }
                                sw_cmcategory.closeResources();
                                %>
                                <%= sw_cmrow.getColumn("CMCName") %>
                            </td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <select name="CCCRPrimary" class="inputFrmField">
                                    <option value="1" <% if (sw_cmrow.getColumn("CCCRPrimary").equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                                    <option value="0" <% if (sw_cmrow.getColumn("CCCRPrimary").equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                                </select>
                            </td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <select name="CCCRIsHidden" class="inputFrmField">
                                    <option value="0" <% if (sw_cmrow.getColumn("CCCRIsHidden").equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                                    <option value="1" <% if (sw_cmrow.getColumn("CCCRIsHidden").equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                                </select>
                            </td>                            
                            <td class="resultsDataTD" width="18%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="text" name="CCCRRank" size="5" value="<%= sw_cmrow.getInt("CCCRRank") %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                            <td>

                                <input type="button" name="changePr" value="Μεταβολή" onclick ='document.relatedCMCatForm<%= i %>.action1.value="UPDATE"; document.relatedCMCatForm<%= i %>.submit();' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                                <% if (CMCRows > 1) { %>                                
                                <input type="button" name="delcat" value="Αποσυσχέτιση" onclick ='if (confirm("Είστε σίγουρος(η) ότι θέλετε να αποσυσχετίσετε την ενότητα;") == true) { document.relatedCMCatForm<%= i %>.action1.value="DELETE"; document.relatedCMCatForm<%= i %>.submit(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                                <%
                                }
                                %>                                
                            </td>
                        </tr>
                        </form>
                    <%
                        if (sw_cmrow.nextRow() == false ) break;
                    }
                    sw_cmrow.closeResources();
                }
                else if (dbRet.getAuthError() == 1)  { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="5">Δεν έχετε πρόσβαση σε αυτά τα στοιχεία</td>
                    </tr>
                <%
                }
                else if (rows == 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="5">Δεν υπάρχουν εγγραφές</td>
                    </tr>
                <%
                } %>
                <form name="buttonForm1">
                <tr class="resultsFooterTR">
                    <td colspan="5"></br><input type="button" value="Συσχέτιση με νέα ενότητα" onclick='location.href=("<%= response.encodeURL("relatecmcategory.jsp?CMRCode=" + CMRCode + "&action1=SEARCH" ) %>")' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /></br></br></td>
                </tr>
                </form>
                </table>
                <%--  } Related categories --%>
                
                <%-- Related CMRows { --%>
                <%--
                <br/>
                <a name='relCMRow'></a>
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="5" class="resultsHeader" align="center">Συναφή άρθρα</td>
                </tr>
                <%
                dbRet = sw_cmrow.getAdminRelatedCMRows(CMRCode,"CMRCode");
        
                rows = dbRet.getRetInt();
        
                if (rows > 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Καταχώρηση</td>
                        <td class="resultsLabelTD">Ενημέρωση</td>
                        <td class="resultsLabelTD">Τίτλος</td>
                        <td class="resultsLabelTD">Σε απόκρυψη</td>                        
                        <td class="resultsLabelTD" width="18%" >&nbsp;</td>                        
                    </tr>
                    
                    <form name="unrelateCMRowForm" method="post" action="<%= urlRelCMRow %>">
                    <input type="hidden" name="action1" value="">
                    <input type="hidden" name="databaseId" value="<%= databaseId %>">
                    <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=relCMRow" %>">
                    <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                    <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                    <input type="hidden" name="CMCMCode" value="">
        
                    <% 
                    for (int i=0; i<rows; i++) { %>
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + sw_cmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= SwissKnife.formatDate(sw_cmrow.getTimestamp("CMRDateCreated"),"dd-MM-yyyy") %></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("processcmrow.jsp?action1=EDIT&CMRCode=" + sw_cmrow.getHexColumn("CMRCode")) %>" class="resultsLink"><%= SwissKnife.formatDate(sw_cmrow.getTimestamp("CMRDateUpdated"),"dd-MM-yyyy") %></a></td>                    
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= sw_cmrow.getColumn("CMRTitle") %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <select name="CMCMIsHidden" class="inputFrmField">
                                    <option value="0" <% if (sw_cmrow.getColumn("CMCMIsHidden").equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                                    <option value="1" <% if (sw_cmrow.getColumn("CMCMIsHidden").equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                                </select>
                            </td>                                                        
                            <td class="resultsDataTD" width="18%" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <input type="button" name="changeCMRRelCMR" value="Μεταβολή" onclick ='document.unrelateCMRowForm.CMCMCode.value="<%= sw_cmrow.getColumn("CMCMCode") %>"; document.unrelateCMRowForm.action1.value="UPDATE"; document.unrelateCMRowForm.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                                <input type="button" name="unrelateCMRow" value="αποσυσχέτιση" onclick ='if (confirm("Είστε σίγουρος(η) οτι θέλετε να αποσυσχετίσετε το συγεκριμένο άρθρο;") == true) { document.unrelateCMRowForm.CMCMCode.value="<%= sw_cmrow.getColumn("CMCMCode") %>"; document.unrelateCMRowForm.action1.value="UNRELATE"; document.unrelateCMRowForm.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                            </td>
                            
                        </tr>
                    <%
                        if (sw_cmrow.nextRow() == false ) break;
                    } %>
                    </form>
                <%
                }
                else if (dbRet.getAuthError() == 1)  { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="5">Δεν έχετε πρόσβαση για συσχέτιση με συναφή άρθρα.</td>
                    </tr>
                <%
                }
                else if (rows == 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="5">Δεν υπάρχουν συναφή άρθρα.</td>
                    </tr>
                <%
                } %>
                <form name="buttonForm1">
                    <tr class="resultsFooterTR">
                        <td colspan="5"><input type="button" value="Συσχέτιση με συναφή άρθρα" onclick='location.href=("<%= response.encodeURL("relatecmrow.jsp?action1=CLOSE_SEARCH&CMCM_CMRCode1=" + CMRCode + "&CMRTitle=" + CMRTitle) %>")' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>
                    </tr>
                </form>
                </table>
                --%>
                <%-- } Related CMRows --%>
            <%
            }
            %>
            
            </div> <!-- end: tab1 -->
            
            <%
            if (action.equals("EDIT")) { %>
            
            <div class="tab_content" id="tab9">
              
              <a name="prdImages"></a>

              <form id="prdImagesForm" name="prdImagesForm" method="post" enctype="multipart/form-data" action="/servlet/admin/GalleryImageScaleServlet">

              <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&tab=tab9" %>" />
              <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
              <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
              <input type="hidden" name="CMRCode" value="<%=CMRCode%>" />
              <input type="hidden" name="uploadPath" value="<%=wwwrootFilePath+"/gimages"%>" />
              
              <input type="hidden" name="imageMaxWidth" value="1024" />
              <input type="hidden" name="imageMaxHeight" value="768" />
              <input type="hidden" name="bgColor" value="#ffffff" />

              <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
              <%--<tr>
                <td class="inputFrmLabelTD">Μέγιστη διάσταση μικρής (thumbnail)</td>
                <td class="inputFrmFieldTD" colspan="2" align="left"><input type="text" name="maxDimension" size="5" value="320" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
              </tr>
              <tr>
                <td class="inputFrmLabelTD">Χρώμα background</td>
                <td class="inputFrmFieldTD" colspan="2" align="left"><input type="text" name="bgColor" size="8" value="#ffffff" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
              </tr>--%>

              <%
              for (int i=1; i<=20; i++) {
              %>
                <tr>
                  <td class="inputFrmLabelTD">Φωτογραφία #<%=i%></td>
                  <td class="inputFrmFieldTD" align="middle">
                  <%
                  if (SwissKnife.fileExists(wwwrootFilePath + "/gimages/" + CMRCode + "-" + i + ".jpg")) {
                  %>
                    <a href="/gimages/<%=CMRCode + "-" + i + ".jpg"%>" target="_blank"><img src="/gimages/<%=CMRCode + "-" + i + ".jpg"%>" alt="" width="100" height="100"/></a>
                    <br/>
                    <input type="button" value="διαγραφή" onclick='if (confirm("Είστε σίγουρος;") == true) { document.productImagesDelete.slotNum.value = "<%=i%>"; document.productImagesDelete.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                  <%
                  } %>
                  </td>
                  <td class="inputFrmFieldTD" align="left"><input type="file" name="<%=i%>" size="100" /></td>
                </tr>
              <%
              } %>
              
              <tr class="inputFrmFooter">
                <td colspan="3" align="center">
                    <input type=button value="Αποστολή" onClick='if (confirm("Είστε σίγουρος;") == true) { sendFiles(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type=reset value="Καθαρισμός πεδίων" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <br/><br/>
                    <span>* Μέγιστο συνολικό μέγεθος αποστολής 3 MB</span>
                </td>
              </tr>
              </table>

              </form>
              
              <form id="productImagesDelete" name="productImagesDelete" method="post" action="/servlet/admin/GalleryImageDeleteServlet">
              <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&tab=tab9" %>" />
              <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
              <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
              <input type="hidden" name="CMRCode" value="<%=CMRCode%>" />
              <input type="hidden" name="slotNum" value="" />
              <input type="hidden" name="uploadPath" value="<%=wwwrootFilePath+"/gimages"%>" />
              </form>
                
            </div> <!-- end: tab9 -->
            <%
            } %>
       
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <%
    if (tab.length()>0) { %>
        <script language="javascript">
        $(document).ready(function() {
            focusTab("<%=tab%>");
        });
        </script>
    <% } %>
    
    <%
    if (goLabel.length()>0) { %>
        <script language="javascript">
            document.location.hash = "<%= goLabel %>";
        </script>
    <% } %>    
</body>
</html>