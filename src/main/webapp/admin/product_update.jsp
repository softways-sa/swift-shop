<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*,
         java.sql.Timestamp,
         gr.softways.dev.eshop.eways.Product,
         gr.softways.dev.eshop.product.v2.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="prdadmin" scope="page" class="gr.softways.dev.eshop.product.Present" />

<jsp:useBean id="relatedPrds" scope="page" class="gr.softways.dev.eshop.product.v2.Present" />

<jsp:useBean id="jspbean" scope="page" class="gr.softways.dev.util.SQLHelper2" />

<%
request.setAttribute("admin.topmenu","products");

prdadmin.initBean(databaseId, request, response, this, session);
relatedPrds.initBean(databaseId, request, response, this, session);
jspbean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int rows = 0;

boolean hasFacets = request.getAttribute("FACETED_SEARCH_ENABLED") != null ? (Boolean) request.getAttribute("FACETED_SEARCH_ENABLED") : false;

String prdId2 = "", name = "", nameLG = "", nameLG1 = "", catId = "", catName = "",
       prdManufactId = "", supplierId = "",
       descr = "", descrLG = "", descrLG1 = "",
       img = "", img2 = "",
       img3 = "", img4 = "",
       hotdealFlag = "",  hotdealFlagW = "",
       prdHideFlag = "", prdHideFlagW = "",
       eaddress = "", prdHasAttributes = "", prdNewColl = "", prdCompFlag = "",
       prdStopSalesGlobal = "", prd_SCCode = "",
       specs = "", specsLG = "", specsLG1 = "", PRD_GiftWrapAvail = "", PRD_VAT_ID = "",
       prdAvailability = "", barcode = "";

String prdEntryDateS = "";

String[][] textTabs = new String[5][4];

int hdBeginDateDay = 0, hdBeginDateMonth = 0, hdBeginDateYear = 0,
    hdEndDateDay = 0, hdEndDateMonth = 0, hdEndDateYear = 0;
int hdBeginDateWDay = 0, hdBeginDateWMonth = 0, hdBeginDateWYear = 0,
    hdEndDateWDay = 0, hdEndDateWMonth = 0, hdEndDateWYear = 0;

String[] months = new String[] {"","Ιανουάριος","Φεβρουάριος","Μάρτιος","Απρίλιος","Μάϊος","Ιούνιος","Ιούλιος","Αύγουστος","Σεπτέμβριος","Οκτώβριος","Νοέμβριος","Δεκέμβριος"};

Timestamp hdBeginDate = null, hdEndDate = null,
          hdBeginDateW = null, hdEndDateW = null,
          prdEntryDate = null;

BigDecimal _zero = new BigDecimal("0");

BigDecimal vatPct = _zero,
           retailPrcEU = _zero, hdRetailPrcEU = _zero,
           wholesalePrcEU = _zero, hdWholesalePrcEU = _zero,
           giftPrcEU = _zero,
           weight = _zero,  cubemeter = _zero,
           stockQua = _zero,
           inQua = _zero, outQua = _zero,
           inVal = _zero, inValEU = _zero,
           outVal = _zero, outValEU = _zero,
           minOrderQua = _zero;

int deliveryDays = 0;

String action = request.getParameter("action1") == null ? "" : request.getParameter("action1"),
       prdId = request.getParameter("prdId") == null ? "" : request.getParameter("prdId"),
       goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel"),
       tab = request.getParameter("tab") == null ? "" : request.getParameter("tab");

String  urlPMA = "/servlet/admin/ProductMasterAttribute",
        urlCat = "/servlet/admin/RelateProductCategory",
        urlRelPrd = "/servlet/admin/RelateProduct",
        urlCancel = "/" + appDir + "admin/product_search.jsp?goLabel=results",
        urlSuccessInsAgain = "/" + appDir + "admin/product_update.jsp",
        urlRelateCategory = "/" + appDir + "admin/product_relate_category.jsp?action1=SEARCH",
        urlSuccess = "/" + appDir + "admin/product_search.jsp?action1=UPDATE_SEARCH&goLabel=results",
        urlSuccess1 = "/" + appDir + "admin/product_update.jsp?action1=EDIT&prdId=" + prdId,
        urlSuccessAttribute = "/" + appDir + "admin/chooseattraction.jsp?prdId=" + SwissKnife.hexEscape(prdId),
        urlFailure = "/" + appDir + "admin/problem.jsp",
        urlReturn = "/" + appDir + "admin/prd.jsp?action1=EDIT&prdId="+ SwissKnife.hexEscape(prdId),
        urlAttribute = "/" + appDir + "admin/chooseattraction.jsp",
        urlProductOptions = "/servlet/admin/ProductOptions";

String pageTitle = "", tableHeader = "";

pageTitle = "Αποθήκη&nbsp;<span class=\"menuPathTD\" id=\"white\">|</span>&nbsp;Προϊόν";

if (action.equals("EDIT")) {
    tableHeader = "Στοιχεία εγγραφής";
}
else {
    tableHeader = "Στοιχεία νέας εγγραφής";
}

int currYear = SwissKnife.getTDateInt(SwissKnife.currentDate(), "year");
int year = currYear - 2;

if (action.equals("EDIT")) {
    rows = prdadmin.getTablePK("product","prdId",prdId);

    if (rows < 0) {
        prdadmin.closeResources();
        response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + rows) );
	return;
    }
    else if (rows >= 1) {
        prdId2 = prdadmin.getColumn("prdId2");

        name = prdadmin.getColumn("name");
        nameLG = prdadmin.getColumn("nameLG");
        nameLG1 = prdadmin.getColumn("nameLG1");

        descr = prdadmin.getColumn("descr");
        descrLG = prdadmin.getColumn("descrLG");
        descrLG1 = prdadmin.getColumn("descrLG1");

        specs = prdadmin.getColumn("specs");
        specsLG = prdadmin.getColumn("specsLG");
        specsLG1 = prdadmin.getColumn("specsLG1");

        vatPct = prdadmin.getBig("vatPct");

        retailPrcEU = prdadmin.getBig("retailPrcEU");
        hdRetailPrcEU = prdadmin.getBig("hdRetailPrcEU");

        wholesalePrcEU = prdadmin.getBig("wholesalePrcEU");
        hdWholesalePrcEU = prdadmin.getBig("hdWholesalePrcEU");

        giftPrcEU = prdadmin.getBig("giftPrcEU");

        weight = prdadmin.getBig("weight");
        cubemeter = prdadmin.getBig("cubemeter");
        stockQua = prdadmin.getBig("stockQua");

        minOrderQua = prdadmin.getBig("minOrderQua");

        img = prdadmin.getColumn("img");
        img2 = prdadmin.getColumn("img2");
        img3 = prdadmin.getColumn("img3");
        img4 = prdadmin.getColumn("img4");

        eaddress = prdadmin.getColumn("prdHomePageLink");

        deliveryDays = prdadmin.getInt("deliveryDays");

        prdManufactId = prdadmin.getColumn("prdManufactId");
        supplierId = prdadmin.getColumn("supplierId");

        hotdealFlag = prdadmin.getColumn("hotdealFlag");
        hotdealFlagW = prdadmin.getColumn("hotdealFlagW");

        prdHideFlag = prdadmin.getColumn("prdHideFlag");
        prdHideFlagW = prdadmin.getColumn("prdHideFlagW");

        prdHasAttributes = prdadmin.getColumn("prdHasAttributes");

        prdNewColl = prdadmin.getColumn("prdNewColl");
        prdCompFlag = prdadmin.getColumn("prdCompFlag");

        if ( ( hdBeginDate = prdadmin.getTimestamp("hdBeginDate") ) != null ) {
            hdBeginDateDay = SwissKnife.getTDateInt(hdBeginDate, "day");
            hdBeginDateMonth = SwissKnife.getTDateInt(hdBeginDate, "month");
            hdBeginDateYear = SwissKnife.getTDateInt(hdBeginDate, "year");
        }
        if ( ( hdEndDate = prdadmin.getTimestamp("hdEndDate") ) != null ) {
            hdEndDateDay = SwissKnife.getTDateInt(hdEndDate,"day");
            hdEndDateMonth = SwissKnife.getTDateInt(hdEndDate,"month");
            hdEndDateYear = SwissKnife.getTDateInt(hdEndDate,"year");
        }

        if ( ( hdBeginDateW = prdadmin.getTimestamp("hdBeginDateW") ) != null ) {
            hdBeginDateWDay = SwissKnife.getTDateInt(hdBeginDateW, "day");
            hdBeginDateWMonth = SwissKnife.getTDateInt(hdBeginDateW, "month");
            hdBeginDateWYear = SwissKnife.getTDateInt(hdBeginDateW, "year");
        }
        if ( ( hdEndDateW = prdadmin.getTimestamp("hdEndDateW") ) != null ) {
            hdEndDateWDay = SwissKnife.getTDateInt(hdEndDateW,"day");
            hdEndDateWMonth = SwissKnife.getTDateInt(hdEndDateW,"month");
            hdEndDateWYear = SwissKnife.getTDateInt(hdEndDateW,"year");
        }

        inQua = prdadmin.getBig("inQua");
        outQua = prdadmin.getBig("outQua");

        inVal = prdadmin.getBig("inVal");
        inValEU = prdadmin.getBig("inValEU");
        outVal = prdadmin.getBig("outVal");
        outValEU = prdadmin.getBig("outValEU");

        prdStopSalesGlobal = prdadmin.getColumn("prdStopSalesGlobal");

        prd_SCCode = prdadmin.getColumn("prd_SCCode");
        
        for (int i=1; i<=5; i++) {
            textTabs[i-1][0] = prdadmin.getColumn("text" + i + "Title");
            textTabs[i-1][1] = prdadmin.getColumn("text" + i);
            textTabs[i-1][2] = prdadmin.getColumn("text" + i + "TitleLG");
            textTabs[i-1][3] = prdadmin.getColumn("text" + i + "LG");
        }
        
        prdEntryDate = prdadmin.getTimestamp("prdEntryDate");
        if (prdEntryDate != null) prdEntryDateS = SwissKnife.formatDate(prdEntryDate, "dd/MM/yyyy");
        
        PRD_GiftWrapAvail = prdadmin.getColumn("PRD_GiftWrapAvail");
        PRD_VAT_ID = prdadmin.getColumn("PRD_VAT_ID");
        
        prdAvailability = prdadmin.getColumn("prdAvailability");
        barcode = prdadmin.getColumn("barcode");
    }
}
else {
    for (int i=1; i<=5; i++) {
        textTabs[i-1][0] = "";
        textTabs[i-1][1] = "";
        textTabs[i-1][2] = "";
        textTabs[i-1][3] = "";
    }
}

prdadmin.closeResources();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <link href="css/jquery-ui-1.10.3.custom.min.css" rel="stylesheet" type="text/css" media="all" />
  
    <script type="text/javascript" src="js/calendar/calendar.js"></script>
    <script type="text/javascript" src="js/calendar/calendar-setup.js"></script>
    <script type="text/javascript" src="js/calendar/calendar-el.js"></script>

    <link rel="stylesheet" type="text/css" media="all" href="css/calendar-system.css" title="system" />
    
    <%@ include file="include/metatags.jsp" %>

    <style>
    ul.tabs {
            margin: 0;
            padding: 0;
            list-style: none;
            height: 32px;
            background-color:#D4D3D3;
            border-bottom: 1px solid #999;
            border-left: 1px solid #999;
            width: 100%;
            font-size: 11px;
    }
    ul.tabs li {
            float: left;
            margin: 0;
            padding: 0;
            height: 31px;
            line-height: 31px;
            border: 1px solid #999;
            border-left: none;
            margin-bottom: -1px;
            background: #e0e0e0;
            overflow: hidden;
            position: relative;
    }
    ul.tabs li a {
            text-decoration: none;
            color: #000;
            display: block;
            font-size: 1.2em;
            padding: 0 20px;
            border: 1px solid #fff;
            outline: none;
    }
    ul.tabs li a:hover {
            background: #ccc;
    }	
    html ul.tabs li.active, html ul.tabs li.active a:hover {
            background: #ECECEC;
            border-bottom: 1px solid #ECECEC;
            font-weight:bold;
    }
    .tab_container {
            width: 100%;
            background: #ECECEC;
            border: 1px solid #999;
            border-top: none;
            clear: both;
            float: left; 
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

    <title>eΔιαχείριση</title>

    <!-- from front-end -->
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.min.js"></script>
    <script language="JavaScript" src="js/jsfunctions.js" charset="UTF-8"></script>
    <script type="text/javascript" language="javascript" src="js/date.js" charset="UTF-8"></script>
    <script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>

    <script language="javascript">
    var downYear = <%= currYear - yearDnLimit %>;
    var upYear = <%= currYear + yearUpLimit %>;

    function showNewDate(d, m, y) {
        var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
        var weekDay = Math.floor(((dayFirst + d -1) % 7));
        if (m >= 1 && m <= 12) {
            document.inputForm.hdBeginDateMonth.options[document.inputForm.hdBeginDateMonth.selectedIndex].value = m;
            document.inputForm.hdBeginDateMonth.options[document.inputForm.hdBeginDateMonth.selectedIndex].text = monthName[m-1];
        }
        document.inputForm.hdBeginDateYear.options[document.inputForm.hdBeginDateYear.selectedIndex].value = y;
        document.inputForm.hdBeginDateYear.options[document.inputForm.hdBeginDateYear.selectedIndex].text = y;
        document.inputForm.hdBeginDateDay.value = d;
    }

    function showNewDate1(d, m, y) {
        var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
        var weekDay = Math.floor(((dayFirst + d -1) % 7));
        if (m >= 1 && m <= 12)	{
            document.inputForm.hdEndDateMonth.options[document.inputForm.hdEndDateMonth.selectedIndex].value = m;
            document.inputForm.hdEndDateMonth.options[document.inputForm.hdEndDateMonth.selectedIndex].text = monthName[m-1];
        }
        document.inputForm.hdEndDateYear.options[document.inputForm.hdEndDateYear.selectedIndex].value = y;
        document.inputForm.hdEndDateYear.options[document.inputForm.hdEndDateYear.selectedIndex].text = y;
        document.inputForm.hdEndDateDay.value = d;
    }

    function showNewDate3(d, m, y) {
        var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
        var weekDay = Math.floor(((dayFirst + d -1) % 7));
        if (m >= 1 && m <= 12) {
            document.inputForm.hdBeginDateWMonth.options[document.inputForm.hdBeginDateWMonth.selectedIndex].value = m;
            document.inputForm.hdBeginDateWMonth.options[document.inputForm.hdBeginDateWMonth.selectedIndex].text = monthName[m-1];
        }
        document.inputForm.hdBeginDateWYear.options[document.inputForm.hdBeginDateWYear.selectedIndex].value = y;
        document.inputForm.hdBeginDateWYear.options[document.inputForm.hdBeginDateWYear.selectedIndex].text = y;
        document.inputForm.hdBeginDateWDay.value = d;
    }

    function showNewDate4(d, m, y) {
        var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
        var weekDay = Math.floor(((dayFirst + d -1) % 7));
        if (m >= 1 && m <= 12)	{
            document.inputForm.hdEndDateWMonth.options[document.inputForm.hdEndDateWMonth.selectedIndex].value = m;
            document.inputForm.hdEndDateWMonth.options[document.inputForm.hdEndDateWMonth.selectedIndex].text = monthName[m-1];
        }
        document.inputForm.hdEndDateWYear.options[document.inputForm.hdEndDateWYear.selectedIndex].value = y;
        document.inputForm.hdEndDateWYear.options[document.inputForm.hdEndDateWYear.selectedIndex].text = y;
        document.inputForm.hdEndDateWDay.value = d;
    }

    function validateForm(form) {
        if (isEmpty(form.prdId.value) == true) {
            alert('Παρακαλούμε πληκτρολογήστε τoν κωδικό.');
            form.prdId.focus();
            return false;
        }
        else if (isValidCodeChars(form.prdId.value) == false) {
            alert('Χρησιμοποιήσατε μη έγκυρους χαρακτήρες για τον κωδικό.');
            form.prdId.focus();
            return false;
        }
        else if (isEmpty(form.name.value) == true) {
            alert('Παρακαλούμε πληκτρολογήστε την ονομασία.');
            form.name.focus();
            return false;
        }
        else if (form.PRD_VAT_ID.options[form.PRD_VAT_ID.selectedIndex].value == "") {
            alert('Παρακαλούμε επιλέξτε Φ.Π.Α..');
            form.PRD_VAT_ID.focus();
            return false;
        }
        else if (isEmpty(form.retailPrcEU.value) == true || isDecimal(form.retailPrcEU.value) == false) {
            alert("Παρακαλούμε πληκτρολογήστε την τιμή λιανικής.");
            form.retailPrcEU.focus();
            return false;
        }
        else if (isEmpty(form.hdRetailPrcEU.value) == true || isDecimal(form.hdRetailPrcEU.value) == false) {
            alert("Παρακαλούμε πληκτρολογήστε την τιμή προσφοράς λιανικής.");
            form.hdRetailPrcEU.focus();
            return false;
        }
        else if (isEmpty(form.wholesalePrcEU.value) == true || isDecimal(form.wholesalePrcEU.value) == false) {
            alert("Παρακαλούμε πληκτρολογήστε την τιμή χονδρικής.");
            form.wholesalePrcEU.focus();
            return false;
        }
        else if (isEmpty(form.hdWholesalePrcEU.value) == true || isDecimal(form.hdWholesalePrcEU.value) == false) {
            alert("Παρακαλούμε πληκτρολογήστε την τιμή προσφοράς χονδρικής.");
            form.hdWholesalePrcEU.focus();
            return false;
        }
        else return true;
    }

    // build urlSuccess for 'Create/Relate category'
    function urlRelCatSuccess() {
        document.inputForm.urlSuccess.value = "<%= urlRelateCategory %>" + "&prdId=" + document.inputForm.prdId.value;
    }

    tinyMCE.init({
        elements : "descr,descrLG",
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
        extended_valid_elements : "a[name|href|target|title|onclick|rel],hr[class|width|size|noshade]",
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
        
        <%
        for (int i=1; i<=5; i++) {
        %>
          $("#rbtn<%=i%>").click(function(e){
            e.preventDefault();
            
            <%
            for (int x=1; x<=5; x++) {
            %>
              if (tinyMCE.getInstanceById('text<%=x%>')) {
                tinyMCE.execCommand('mceRemoveControl', false, 'text<%=x%>');
                tinyMCE.execCommand('mceRemoveControl', false, 'text<%=x%>LG');
              }
            <%
            } %>
                  
            $("#tabs_slide_container div").css('display','none');
            
            $("#tabs_slide_container #slidetab<%=i%>").slideToggle(function () {
              tinyMCE.execCommand('mceAddControl', true, 'text<%=i%>');
              tinyMCE.execCommand('mceAddControl', true, 'text<%=i%>LG');
              
              tinyMCE.execCommand('mceFocus', false, 'text<%=i%>');
              }
            );
          });
        <%
        } %>
    });
    
    function focusTab(tab) {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        
        $('#' + 'a' + tab).addClass("active"); //Add "active" class to selected tab

        $(".tab_content").hide(); //Hide all tab content

        $('#' + tab).show(); // show active content
    }
    
    $(document).ready(function() {
      $('#prdImagesForm').submit(function() {
        $('body').append('<div id="uploading-overlay" style="display: block;"></div>');
        $('#uploading-overlay').addClass('overlay-fixed');
        
        $("body").append('<div id="uploading-loader"><div></div></div>');
      });
    });
    
    function sendFiles() {
      $('#prdImagesForm').submit();
    }
    </script>
</head>

<body <%=bodyString%>>
    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    	<td class="menuPathTD" align="middle"><b><%= pageTitle %></b></td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>

        <td valign="top">
            <ul class="tabs">
                <li id="atab1"><a href="#tab1">Κεντρική σελίδα</a></li>
                <li id="atab10"><a href="#tab10">Λιανική</a></li>
                <li id="atab11"><a href="#tab11">Χονδρική</a></li>
                <li id="atab2"><a href="#tab2">Περιγραφή</a></li>
                <li id="atab3"><a href="#tab3">Πλαίσια</a></li>
                <%if (action.equals("EDIT")) {%>
                  <%if (hasFacets) {%><li id="atab85"><a href="#tab85">Φίλτρα</a></li><%}%>
                  <li id="atab8"><a href="#tab8">Κατηγορίες / Επιλογές / Συναφή</a></li>
                  <li id="atab9"><a href="#tab9">Φωτογραφίες</a></li>
                <%}%>
            </ul>

            <form name="inputForm" method="post" action="<%= response.encodeURL("/servlet/admin/Product") %>" enctype="multipart/form-data">

            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            <input type="hidden" name="urlSuccess" value="" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />

            <input type="hidden" name="uploadPath" value="<%= productImagesFilePath %>" />
            <input type="hidden" name="img01" value="<%= img %>" />
            <input type="hidden" name="img02" value="<%= img2 %>" />
            <input type="hidden" name="img03" value="<%= img3 %>" />
            <input type="hidden" name="img04" value="<%= img4 %>" />
            <input type="hidden" name="flag" value="" />

            <input type="hidden" name="localeLanguage" value="<%= localeLanguage %>" />
            <input type="hidden" name="localeCountry" value="<%= localeCountry %>" />

            <input type="hidden" value="0" name="buttonPressed" />
            
            <input type="hidden" value="<%=hasFacets%>" name="hasFacets" />
            
            <div class="tab_content" id="tab1">

            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmLabelTD">Κωδικός</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" name="prdId" maxlength="25" size="30" value="<%= prdId %>" <% if (action.equals("EDIT")) out.print("onfocus=\"blur();\""); else out.print("onfocus=\"this.className='inputFrmFieldFocus'\""); %> class="inputFrmField" onblur="this.className='inputFrmField'" /> * Μόνο λατινικοί χαρακτήρες, χωρις σύμβολα και κενά</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Ημ/νία</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" name="prdEntryDate" id="prdEntryDate" value="<%=prdEntryDateS%>" size="10"/><img style="display:inline; vertical-align:middle; margin-left:5px;" src="images/calendar.png" alt="calendar" id="trigger1" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" valign="top">Ονομασία</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" /></td>
                        <td class="inputFrmFieldTD"><input type="text" name="name" maxlength="160" size="80" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif" /></td>
                        <td class="inputFrmFieldTD"><input type="text" name="nameLG" maxlength="160" size="80" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                    </tr>
                    </table>
                </td>
            </tr>
            <script language="JavaScript">
                document.inputForm.name.value = "<%= name.replaceAll("[\"]","\\\\\"").replaceAll("[']","\\\\\'") %>";
                document.inputForm.nameLG.value = "<%= nameLG.replaceAll("[\"]","\\\\\"").replaceAll("[']","\\\\\'") %>";
            </script>
            
            
            <%--<tr>
                <td class="inputFrmLabelTD">Κατασκευαστής</td>
                <td class="inputFrmFieldTD">
                    <select name="prdManufactId" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = relatedPrds.getTable("manufact","manufactNameUp");

                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= relatedPrds.getColumn("manufactId") %>" <% if (prdManufactId.equals(relatedPrds.getColumn("manufactId"))) out.print("SELECTED"); %>><%= relatedPrds.getColumn("manufactName") %></option>
                        <%
                            relatedPrds.nextRow();
                        } %>
                    </select>
                </td>
            </tr>--%>
            <tr>
                <td class="inputFrmLabelTD">Φ.Π.Α.</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <select name="PRD_VAT_ID" class="inputFrmField">
                        <option value="">---</option>
                        <%
                        rows = relatedPrds.getTable("VAT","VAT_Pct");

                        for (int i=0; i<rows; i++) { %>
                            <option value="<%= relatedPrds.getColumn("VAT_ID") %>" <% if (PRD_VAT_ID.equals(relatedPrds.getColumn("VAT_ID"))) out.print("SELECTED"); %>><%= relatedPrds.getColumn("VAT_Title") %></option>
                        <%
                            relatedPrds.nextRow();
                        } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τεμάχια</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="stockQua" value="<%= SwissKnife.formatNumber(stockQua.setScale(0, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,0,0) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /> <%if (action.equals("EDIT")) {%><input type="button" name="" value="αλλαγή τεμαχίων" onclick='document.inputForm.action1.value="UPDATE_STOCKQUA"; document.inputForm.urlSuccess.value="<%= urlSuccess1 %>"; document.inputForm.submit();' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'"/> * Η αλλαγή τεμαχίων γίνεται μόνο με το κουμπί 'αλλαγή τεμαχίων'<%}%></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Κατασκευαστής</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" name="prdHomePageLink" maxlength="100" size="30" value="<%=eaddress%>" class="inputFrmField" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">MPN (μοναδικός κωδικός κατασκευαστή)</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" name="barcode" maxlength="25" size="30" value="<%=barcode%>" class="inputFrmField" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Διαθεσιμότητα</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <select name="prdAvailability" class="inputFrmField">
                        <option value="">---</option>
                        <option value="1" <% if ("1".equals(prdAvailability)) out.print("SELECTED"); %>>Σε απόθεμα</option>
                        <option value="2" <% if ("2".equals(prdAvailability)) out.print("SELECTED"); %>>1 έως 3 ημέρες</option>
                        <option value="3" <% if ("3".equals(prdAvailability)) out.print("SELECTED"); %>>4 έως 7 ημέρες</option>
                        <option value="4" <% if ("4".equals(prdAvailability)) out.print("SELECTED"); %>>7+ ημέρες</option>
                        <option value="5" <% if ("5".equals(prdAvailability)) out.print("SELECTED"); %>>Κατόπιν Παραγγελίας</option>
                        <option value="6" <% if ("6".equals(prdAvailability)) out.print("SELECTED"); %>>Προ-παραγγελία</option>
                    </select>
                </td>
            </tr>
            <%--<tr>
                <td class="inputFrmLabelTD">Φωτογραφία</td>
                <%
                if (img.equals("")) { %>
                    <td class="inputFrmFieldTD" colspan="2"><input type="file" name="img01" size="80" /></td>
                <%
                }
                else { %>
                    <td class="inputFrmFieldTD" colspan="2"><a href="<%= "/prd_images/" + img %>" target="_blank">Προβολή</a>&nbsp;&nbsp;<input type="file" name="img01" size="80" /> <input type="button" name="" value="Διαγραφή φωτογραφίας" onclick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.inputForm.flag.value = "1"; document.inputForm.action1.value="DELETE_IMG"; document.inputForm.urlSuccess.value="<%= urlSuccess1 %>"; document.inputForm.submit(); } else return false;'></td>
                <% } %>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Μεγέθυνση Φωτογραφίας</td>
                <%
                if (img2.equals("")) { %>
                    <td class="inputFrmFieldTD" colspan="2"><input type="file" name="img02" size="80" /></td>
                <%
                }
                else { %>
                    <td class="inputFrmFieldTD" colspan="2"><a href="<%= "/prd_images/" + img2 %>" target="_blank">Προβολή</a>&nbsp;&nbsp;<input type="file" name="img02" size="80" /> <input type="button" name="" value="Διαγραφή φωτογραφίας" onclick='if (confirm("Είστε σίγουρος για την διαγραφή;") == true) { document.inputForm.flag.value = "2"; document.inputForm.action1.value="DELETE_IMG"; document.inputForm.urlSuccess.value="<%= urlSuccess1 %>"; document.inputForm.submit(); } else return false;'></td>
                <% } %>
            </tr>--%>
            <tr>
                <td class="inputFrmLabelTD">Νέο προϊόν</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="checkbox" name="prdCompFlag" value="1" <% if (prdCompFlag.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προβεβλημένο προϊόν</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="checkbox" name="prdNewColl" value="1" <% if (prdNewColl.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <%--<tr>
                <td class="inputFrmLabelTD">Βαρύτητα εμφάνισης προβεβλημένων<br/>(υψηλή τιμή-υψηλή θέση εμφάνισης)</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" name="deliveryDays" size="5" value="<%= deliveryDays %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>--%>
            <tr>
                <td class="inputFrmLabelTD">Επιλογή συσκευασίας δώρου</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="checkbox" name="PRD_GiftWrapAvail" value="1" <% if (PRD_GiftWrapAvail.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Επιπρόσθετο κόστος συσκευασίας</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="giftPrcEU" value="<%= SwissKnife.formatNumber(giftPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>

            <tr class="inputFrmFooter">
                <td colspan="3" align="center">
                    <%
                    if (action.equals("EDIT")) { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { if (checkButton(document.inputForm.buttonPressed) == true) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="UPDATE"; document.inputForm.submit();}}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Διαγραφή" onClick='if (confirm("Είστε σίγουρος(η) για τη διαγραφή") == true) { document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.action1.value="DELETE"; document.inputForm.submit()} else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <%
                    }
                    else { %>
                        <input type="button" value="Αποθήκευση" onClick='if (validateForm(document.inputForm)) { document.inputForm.action1.value="INSERT"; document.inputForm.urlSuccess.value="<%= urlSuccess %>"; document.inputForm.submit();}' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Συσχέτιση Κατηγορίας" onClick='if (validateForm(inputForm)) {urlRelCatSuccess(); document.inputForm.action1.value="INSERT"; document.inputForm.submit(); }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                        <input type="button" value="Αποθήκευση/Νέα Καταχώρηση" onClick='if (validateForm(document.inputForm)) { document.inputForm.urlSuccess.value="<%= urlSuccessInsAgain %>"; document.inputForm.action1.value="INSERT"; document.inputForm.submit() }' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <% } %>
                    <input type="button" value="Ακύρωση" onClick="location.href='<%= urlCancel %>'" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            
            </table>
            
            </div> <!-- end: tab1 -->
            
            <div class="tab_content" id="tab10">
                
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmLabelTD">Τιμή &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="retailPrcEU" value="<%= SwissKnife.formatNumber(retailPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή προσφοράς &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="hdRetailPrcEU" value="<%= SwissKnife.formatNumber(hdRetailPrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προτεραιότητα προσφοράς</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <select name="hotdealFlag" class="inputFrmField">
                        <option value="0" <% if (hotdealFlag.equals("0")) out.print("SELECTED"); %>>---</option>
                        <option value="<%= Product.HOTDEAL_FLAG_ALWAYS %>" <% if (hotdealFlag.equals(Product.HOTDEAL_FLAG_ALWAYS)) out.print("SELECTED"); %>>Πάντα</option>
                        <option value="<%= Product.HOTDEAL_FLAG_DATE %>" <% if (hotdealFlag.equals(Product.HOTDEAL_FLAG_DATE)) out.print("SELECTED"); %>>Ημ/νία</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προσφορά από (περιλαμβάνεται)</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="hdBeginDateDay" value="<% if (hdBeginDateDay != 0) out.print(hdBeginDateDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'hdBeginDateDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="hdBeginDateMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (hdBeginDateMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="hdBeginDateYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (hdBeginDateYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προσφορά έως (δεν περιλαμβάνεται)</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="hdEndDateDay" value="<% if (hdEndDateDay != 0) out.print(hdEndDateDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'hdEndDateDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="hdEndDateMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for(int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (hdEndDateMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="hdEndDateYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (hdEndDateYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Απόκρυψη</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="checkbox" name="prdHideFlag" value="1" <% if (prdHideFlag.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            </table>
                
            </div> <!-- end: tab10 -->
            
            <div class="tab_content" id="tab11">
                
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmLabelTD">Τιμή &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="wholesalePrcEU" value="<%= SwissKnife.formatNumber(wholesalePrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τιμή προσφοράς &euro;</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="text" size="12" name="hdWholesalePrcEU" value="<%= SwissKnife.formatNumber(hdWholesalePrcEU.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προτεραιότητα προσφοράς</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <select name="hotdealFlagW" class="inputFrmField">
                        <option value="0" <% if (hotdealFlagW.equals("0")) out.print("SELECTED"); %>>---</option>
                        <option value="<%= Product.HOTDEAL_FLAG_ALWAYS %>" <% if (hotdealFlagW.equals(Product.HOTDEAL_FLAG_ALWAYS)) out.print("SELECTED"); %>>Πάντα</option>
                        <option value="<%= Product.HOTDEAL_FLAG_DATE %>" <% if (hotdealFlagW.equals(Product.HOTDEAL_FLAG_DATE)) out.print("SELECTED"); %>>Ημ/νία</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προσφορά από (περιλαμβάνεται)</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="hdBeginDateWDay" value="<% if (hdBeginDateWDay != 0) out.print(hdBeginDateWDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'hdBeginDateWDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="hdBeginDateWMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for (int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (hdBeginDateWMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="hdBeginDateWYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (hdBeginDateWYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Προσφορά έως (δεν περιλαμβάνεται)</td>
                <td class="inputFrmFieldTD" colspan="2">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td><input type="text" name="hdEndDateWDay" value="<% if (hdEndDateWDay != 0) out.print(hdEndDateWDay); %>" size="2" maxlength="2" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="valInt('inputForm', 'hdEndDateWDay', 0, 1, 31); this.className='inputFrmField'" /></td>
                        <td>
                            <select name="hdEndDateWMonth" class="inputFrmField">
                                <option value="">Μήνας</option>
                                <% for(int i=1; i<=12; i++) { %>
                                    <option value="<%= i %>" <% if (hdEndDateWMonth == i) out.print("SELECTED"); %> ><%= months[i] %></option>
                                <% } %>
                            </select>
                        </td>
                        <td>
                            <select name="hdEndDateWYear" class="inputFrmField">
                                <option value="">Έτος</option>
                                <% for (int i = (currYear - yearDnLimit); i <= (currYear + yearUpLimit); i++) { %>
                                    <option value="<%= i %>" <% if (hdEndDateWYear == i) out.print("SELECTED"); %> ><%= i %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Απόκρυψη</td>
                <td class="inputFrmFieldTD" colspan="2"><input type="checkbox" name="prdHideFlagW" value="1" <% if (prdHideFlagW.equals("1")) out.print("checked"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            </table>
                
            </div> <!-- end: tab11 -->
            
            <div class="tab_content" id="tab2">
                
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            <tr>
                <td class="inputFrmLabelTD" valign="top">Περιγραφή</td>
                <td class="inputFrmFieldTD">
                    <table width="0" border="0" cellspacing="2" cellpadding="0">
                    <tr>
                        <td valign="top"><img src="images/flag.gif" /></td>
                        <td class="inputFrmFieldTD"><textarea style="width:800px; height:400px;" name="descr" id="descr" class="editor inputFrmField"><%= descr %></textarea></td>
                    </tr>
                    <tr>
                        <td valign="top"><img src="images/flagLG.gif" /></td>
                        <td class="inputFrmFieldTD"><textarea style="width:800px; height:400px;" name="descrLG" id="descrLG" class="editor inputFrmField"><%= descrLG %></textarea></td>
                    </tr>
                    </table>
                </td>
            </tr>
            </table>
                
            </div> <!-- end: tab2 -->
            
            <div class="tab_content" id="tab3">

            <div id="tabs_slide_container">
                
              <%
              for (int i=1; i<=5; i++) {
              %>
                <h4><a href="#" id="rbtn<%=i%>">πλαίσιο #<%=i%> - <%=textTabs[i-1][0]%></a></h4>
                <div id="slidetab<%=i%>">
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                <tr>
                    <td class="inputFrmLabelTD" valign="top">Ονομασία Πλαισίου #<%=i%></td>
                    <td class="inputFrmFieldTD" colspan="2">
                        <table width="0" border="0" cellspacing="2" cellpadding="0">
                        <tr>
                            <td valign="top"><img src="images/flag.gif" /></td>
                            <td class="inputFrmFieldTD"><input type="text" name="text<%=i%>Title" value="<%=textTabs[i-1][0]%>" maxlength="250" size="120" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                        </tr>
                        <tr>
                            <td valign="top"><img src="images/flagLG.gif" /></td>
                            <td class="inputFrmFieldTD"><input type="text" name="text<%=i%>TitleLG" value="<%=textTabs[i-1][2]%>" maxlength="250" size="120" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                        </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="inputFrmLabelTD" valign="top">Πλαίσιο #<%=i%></td>
                    <td class="inputFrmFieldTD" colspan="2">
                        <table width="0" border="0" cellspacing="2" cellpadding="0">
                        <tr>
                            <td valign="top"><img src="images/flag.gif" /></td>
                            <td class="inputFrmFieldTD"><textarea name="text<%=i%>" id="text<%=i%>" style="width:800px; height:400px;" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%=textTabs[i-1][1]%></textarea></td>
                        </tr>
                        <tr>
                            <td valign="top"><img src="images/flagLG.gif" /></td>
                            <td class="inputFrmFieldTD"><textarea name="text<%=i%>LG" id="text<%=i%>LG" style="width:800px; height:400px;" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%=textTabs[i-1][3]%></textarea></td>
                        </tr>
                        </table>
                    </td>
                </tr>
                </table>
                </div>
              <% } %>
              
            </div> <!-- end: tabs_slide_container -->

            </div> <!-- end: tab3 -->
            
            <div class="tab_content" id="tab85">
                <div style="background-color: #ffffff; padding: 15px;">
                  <script>
                  $(function() {
                    var allFacets = [
                    <%
                    List<Facet> facets = FacetService.getAdminFacets();
                    for (Facet facet : facets) {
                      for (FacetValue val : facet.facetValues) {
                        out.print("{label: '" + facet.name + " > " + val.name + "', id: '" + val.id + "'},");
                      }
                    }
                    %>
                    ];

                    $("#facet-input").autocomplete({
                      source: allFacets,
                      select: function(event, ui) {
                        $("#facet_val" + ui.item.id).remove();
                        $("#facets").append('<div id="facet_val' + ui.item.id + '"><span class="ui-icon ui-icon-circle-minus" style="display: inline-block;"></span> ' + ui.item.label + '<input type="hidden" name="facet_val_id" value="' + ui.item.id + '"></div>');
                        $("#facet-input").val("");
                        return false;
                      }
                    });

                    $('#facets').delegate('.ui-icon-circle-minus', 'click', function() {
                      $(this).parent().remove();
                    });
                  });
                  </script>
                  <div class="ui-widget">
                    <label for="facet-input">Προσθήκη φίλτρου: </label>
                    <input id="facet-input">
                  </div>
                  <style>#facets div {margin-top: 10px;}</style>
                  <div id="facets" style="margin-top: 20px;">
                    <%
                    facets = FacetService.getProductFacets(prdId);
                    for (Facet facet : facets) {
                      for (FacetValue val : facet.facetValues) {%>
                        <div id="facet_val<%=val.id%>"><span class="ui-icon ui-icon-circle-minus" style="display: inline-block;"></span> <%=facet.name%> > <%=val.name%><input type="hidden" name="facet_val_id" value="<%=val.id%>"></div>
                    <%}
                    }
                    %>
                  </div>
                </div>
              </div> <!-- /tab85 -->
            
            </form>
            
            <%
            if (action.equals("EDIT")) { %>
            
                <div class="tab_content" id="tab8">

                <%-- Related categories { --%>
                <br/>
                <a name="cat"></a>
                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="3" class="resultsHeader" align="center">Συσχετισμένες κατηγορίες</td>
                </tr>
                <%
                dbRet = prdadmin.getPrdCategories(prdId, "catId");

                rows = dbRet.getRetInt();

                if (rows > 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Ονομασία</td>
                        <td class="resultsLabelTD">Βασική κατηγορία</td>
                        <%--<td class="resultsLabelTD">Βαρύτητα</td>--%>
                        <td class="resultsLabelTD">&nbsp;</td>
                    </tr>
                    <%
                    for (int i=0; i<rows; i++) { %>
                        <form name="relatedCatForm<%= i %>" method="post" action="<%= urlCat %>">
                        <input type="hidden" name="action1" value="">
                        <input type="hidden" name="databaseId" value="<%= databaseId %>">
                        <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=cat&tab=tab8" %>">
                        <input type="hidden" name="urlFailure" value="<%= urlFailure %>">
                        <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>">
                        <input type="hidden" name="prdId" value="<%= prdId %>">
                        <input type="hidden" name="catId" value="<%= prdadmin.getColumn("catId") %>">
                        <input type="hidden" name="PINCRank" value="0">

                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <%
                                int catParents = relatedPrds.getParents(prdadmin.getColumn("catId"), "catId").getRetInt();

                                for (int x=0; x<catParents-1; x++) { %>
                                    <%= relatedPrds.getColumn("catName") %>&nbsp;&gt;&nbsp;
                                <%
                                    relatedPrds.nextRow();
                                }
                                relatedPrds.closeResources();
                                %>
                                <%= prdadmin.getColumn("catName") %>
                            </td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">
                                <select name="PINCPrimary" class="inputFrmField">
                                    <option value="1" <% if (prdadmin.getColumn("PINCPrimary").equals("1")) { %> SELECTED <% } %>>ΝΑΙ</option>
                                    <option value="0" <% if (prdadmin.getColumn("PINCPrimary").equals("0")) { %> SELECTED <% } %>>ΟΧΙ</option>
                                </select>
                            </td>
                            <%--<td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="text" name="PINCRank" size="5" value="<%= prdadmin.getInt("PINCRank") %>" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>--%>
                            <td><input type="button" name="changePr" value="μεταβολή" onclick ='document.relatedCatForm<%= i %>.action1.value="UPDATE"; document.relatedCatForm<%= i %>.submit();' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                                <input type="button" name="delcat" value="αποσυσχέτιση" onclick ='if (confirm("Είστε σίγουρος(η) οτι θέλετε να αποσυσχετίσετε την συγεκριμένη κατηγορία;") == true) { document.relatedCatForm<%= i %>.action1.value="DELETE"; document.relatedCatForm<%= i %>.submit(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                            </td>
                        </tr>
                        </form>
                    <%
                        if (prdadmin.nextRow() == false ) break;
                    }
                }
                else if (dbRet.getAuthError() == 1)  { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="4">Δεν έχετε πρόσβαση στις κατηγορίες.</td>
                    </tr>
                <%
                }
                else if (rows == 0 && dbRet.getNoError() == 1) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="4">Δεν υπάρχουν συσχετισμένες κατηγορίες.</td>
                    </tr>
                <%
                } %>
                <form name="buttonForm1">
                <tr class="resultsFooterTR">
                    <td colspan="4"><input type="button" value="Συσχέτιση με νέα κατηγορία" onclick='location.href=("<%= response.encodeURL("product_relate_category.jsp?prdId=" + prdId + "&action1=SEARCH" ) %>")' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /></td>
                </tr>
                </form>
                </table>
                <%-- } Related categories --%>

                <%-- ProductOptions { --%>
                <br/>
                <a name="ProductOptions"></a>

                <form name="ProductOptionsForm" method="POST" action="<%= urlProductOptions %>">

                <input type="hidden" name="action1" value="" />
                <input type="hidden" name="databaseId" value="<%= databaseId %>" />
                <input type="hidden" name="urlSuccess" value="" />
                <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
                <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />

                <input type="hidden" name="PO_prdId" value="<%=prdId%>" />
                <input type="hidden" name="PO_Code" value="" />

                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="6" class="resultsHeader" align="center">Επιλογές</td>
                </tr>
                <%
                rows = prdadmin.getTablePK("ProductOptions", "PO_prdId", prdId, "PO_Order ASC, PO_Name ASC");

                if (rows > 0) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Α/Α</td>
                        <td class="resultsLabelTD">Επιλογή</td>
                        <td class="resultsLabelTD">Λιανική</td>
                        <td class="resultsLabelTD">Χονδρική</td>
                        <td class="resultsLabelTD">Διαθέσιμο</td>
                        <td class="resultsLabelTD">&nbsp;</td>
                    </tr>
                <%
                    for (int i=0; i<rows; i++) {
                %>
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= prdadmin.getColumn("PO_Order") %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("product_options_update.jsp?action1=EDIT&PO_Code=" + prdadmin.getHexColumn("PO_Code") + "&PO_prdId=" + SwissKnife.hexEscape(prdId)) %>" class="resultsLink"><%= prdadmin.getColumn("PO_Name") %></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= SwissKnife.formatNumber(prdadmin.getBig("PO_RetailPrcEU").setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= SwissKnife.formatNumber(prdadmin.getBig("PO_WholesalePrcEU").setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><% if (prdadmin.getColumn("PO_Enabled").equals("1")) out.print("ΝΑΙ"); else out.print("ΟΧΙ"); %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="button" name="deleteProductSpecsEntry" value="διαγραφή" onclick ='if (confirm("Είστε σίγουρος(η) οτι θέλετε να διαγράψετε την συγκεκριμένη εγγραφή;") == true) { document.ProductOptionsForm.PO_Code.value="<%= prdadmin.getColumn("PO_Code") %>"; document.ProductOptionsForm.action1.value="DELETE"; document.ProductOptionsForm.urlSuccess.value="<%= urlSuccess1 + "&goLabel=ProductOptions&tab=tab8" %>"; document.ProductOptionsForm.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>
                        </tr>
                <%
                        if (prdadmin.nextRow() == false) break;
                    }
                }
                else if (rows <= 0) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="6">Δεν υπάρχουν εγγραφές.</td>
                    </tr>
                <%
                } %>

                <tr class="resultsFooterTR">
                    <td colspan="6"><input type="button" value="Νέα εγγραφή" onclick='location.href="<%= response.encodeURL("product_options_update.jsp?PO_prdId=" + SwissKnife.hexEscape(prdId)) %>"' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" /></td>
                </tr>
                </table>
                
                </form>
                <%-- } ProductOptions --%>
                
                <br/>
                <a name="RelatedProducts"></a>

                <script>
                $(document).ready(function() {
                  $("#RelatedProductsForm").submit(
                    function() {
                      document.RelatedProductsForm.action1.value="RELATE";
                      document.RelatedProductsForm.PRDRP_relPrdId.value = document.RelatedProductsForm.relPrdId.value;
                      document.RelatedProductsForm.submit();
                    }
                  );
                });
                </script>
                
                <form id="RelatedProductsForm" name="RelatedProductsForm" method="POST" action="<%= urlRelPrd %>">

                <input type="hidden" name="action1" value="" />
                <input type="hidden" name="databaseId" value="<%= databaseId %>" />
                <input type="hidden" name="urlSuccess" value="<%=urlSuccess1 + "&goLabel=RelatedProductsForm&tab=tab8"%>" />
                <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
                <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />

                <input type="hidden" name="PRDRP_prdId" value="<%=prdId%>" />
                <input type="hidden" name="PRDRP_relPrdId" value="" />

                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
                <tr>
                    <td colspan="3" class="resultsHeader" align="center">Συναφή προϊόντα</td>
                </tr>
                <%
                rows = jspbean.getSQL("SELECT * FROM prdRelatedProducts LEFT JOIN product ON PRDRP_relPrdId = prdId WHERE PRDRP_prdId = '" + prdId + "'").getRetInt();

                if (rows > 0) { %>
                    <tr class="resultsLabelTR">
                        <td class="resultsLabelTD">Κωδ. προϊόντος</td>
                        <td class="resultsLabelTD">Προϊόν</td>
                        <td class="resultsLabelTD">&nbsp;</td>
                    </tr>
                <%
                    for (int i=0; i<rows; i++) {
                %>
                        <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= jspbean.getColumn("prdId") %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= jspbean.getColumn("name") %></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><input type="button" name="deletePrdRelatedProductEntry" value="αποσυσχέτιση" onclick ='if (confirm("Είστε σίγουρος(η) οτι θέλετε να αποσυσχετίσετε την συγκεκριμένη εγγραφή;") == true) { document.RelatedProductsForm.PRDRP_relPrdId.value="<%= jspbean.getColumn("PRDRP_relPrdId") %>"; document.RelatedProductsForm.action1.value="UNRELATE"; document.RelatedProductsForm.submit(); } else return false;' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" /></td>
                        </tr>
                <%
                        if (jspbean.nextRow() == false) break;
                    }
                }
                else if (rows <= 0) { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" colspan="3">Δεν υπάρχουν εγγραφές.</td>
                    </tr>
                <%
                } %>

                <tr class="resultsFooterTR">
                    <td colspan="3">
                        κωδ. προϊόντος <input type="text" name="relPrdId" size="25" value="" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                        <input type="submit" value="συσχέτιση" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    </td>
                </tr>
                </table>
                
                </form>
                
                </div> <!-- end: tab8 -->
                
                <div class="tab_content" id="tab9">
              
                <br/>
                <a name="prdImages"></a>

                <form id="prdImagesForm" name="prdImagesForm" method="post" enctype="multipart/form-data" action="/servlet/admin/ProductImageScaleServlet">

                <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=cat&tab=tab9" %>" />
                <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
                <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
                <input type="hidden" name="prdId" value="<%=prdId%>" />
                <input type="hidden" name="uploadPath" value="<%=productImagesFilePath%>" />

                <input type="hidden" name="maxDimension" value="500" />
                <input type="hidden" name="bgColor" value="#ffffff" />

                <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                <tr>
                    <td colspan="3" class="resultsHeader" align="center">Φωτογραφίες</td>
                </tr>
                <%--<tr>
                  <td class="inputFrmLabelTD">Μέγιστη διάσταση μικρής (thumbnail)</td>
                  <td class="inputFrmFieldTD" colspan="2" align="left"><input type="text" name="maxDimension" size="5" value="320" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                </tr>
                <tr>
                  <td class="inputFrmLabelTD">Χρώμα background</td>
                  <td class="inputFrmFieldTD" colspan="2" align="left"><input type="text" name="bgColor" size="8" value="#ffffff" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                </tr>--%>

                <%
                for (int i=1; i<=10; i++) {
                %>
                  <tr>
                    <td class="inputFrmLabelTD">Φωτογραφία #<%=i%></td>
                    <td class="inputFrmFieldTD" align="left">
                    <%
                    if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + prdId + "-" + i + ".jpg")) {
                    %>
                      <a href="/prd_images/<%=prdId + "-" + i + "z.jpg"%>" target="_blank"><img src="/prd_images/<%=prdId + "-" + i + ".jpg"%>" alt="" width="100" height="100"/></a>
                      <br/>
                      <input type="button" value="διαγραφή" onclick='if (confirm("Είστε σίγουρος;") == true) { document.productImagesDelete.slotNum.value = "<%=i%>"; document.productImagesDelete.submit(); }' class="inputFrmBtn" onmouseover="this.className='inputFrmBtnOver'" onmouseout="this.className='inputFrmBtn'" />
                    <%
                    } %>
                    </td>
                    <td class="inputFrmFieldTD" align="left"><input type="file" name="<%=i%>" size="100" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                  </tr>
                <%
                } %>

                <tr class="inputFrmFooter">
                  <td colspan="3" align="center">
                      <input type=button value="Ανέβασμα εικόνων" onClick='if (confirm("Είστε σίγουρος;") == true) { sendFiles(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                      <input type=reset value="Καθαρισμός πεδίων" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                      <br/>
                      <span>* Μέγιστο συνολικό μέγεθος αποστολής 3 MB</span>
                  </td>
                </tr>
                </table>

                </form>

                <form id="productImagesDelete" name="productImagesDelete" method="post" action="/servlet/admin/ProductImageDeleteServlet">
                <input type="hidden" name="urlSuccess" value="<%= urlSuccess1 + "&goLabel=cat&tab=tab9" %>" />
                <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
                <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
                <input type="hidden" name="prdId" value="<%=prdId%>" />
                <input type="hidden" name="slotNum" value="" />
                <input type="hidden" name="uploadPath" value="<%=productImagesFilePath%>" />
                </form>

              </div> <!-- end: tab9 -->
            <%
            } /** action.equals("EDIT") **/ %>
            
            <script type="text/javascript">
            Calendar.setup({
            inputField     :    "prdEntryDate",   //  id of the input field
            ifFormat       :    "%d/%m/%Y",     //  format of the input field
            button         :    "trigger1",  // trigger for the calendar (button ID)
            align          :    "Bl",           // alignment (defaults to "Bl")
            singleClick    :    true
            });
            </script>
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

    <%
    prdadmin.closeResources();
    relatedPrds.closeResources();
    jspbean.closeResources();
    %>

</body>
</html>