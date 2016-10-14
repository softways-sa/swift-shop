<%@ page language="java" contentType="text/html; charset=UTF-8" import="gr.softways.dev.util.*" %>
 
<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","newsletter");

helperBean.initBean(databaseId, request, response, this, session);
   
String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/sendemail.jsp"),
       urlFailure = "http://" + serverName + "/" + appDir + "admin/sendemail.jsp";

String body = "", from = "", subject = "", mailContent = "", mailCharset = "", NWLR_Title = "";

String NWLR_Code = request.getParameter("NWLR_Code");
if (NWLR_Code != null && NWLR_Code.length() > 0) {
    helperBean.getTablePK("Newsletter", "NWLR_Code", SwissKnife.sqlEncode(NWLR_Code));
    
    from = helperBean.getColumn("NWLR_From");
    subject = helperBean.getColumn("NWLR_Subject");
    mailContent = helperBean.getColumn("NWLR_ContentType");
    mailCharset = helperBean.getColumn("NWLR_Charset");
    body = helperBean.getColumn("NWLR_Message");
    NWLR_Title = helperBean.getColumn("NWLR_Title");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.js"></script> 
    
    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script language="javascript" src="js/jscripts/tiny_mce/tiny_mce.js"></script>
    
    <script language="JavaScript">
    function validateForm(forma) {
        // έλεγξε αν έχουν συμπληρωθεί τα απαραίτητα στοιχεία
        if (isEmpty(forma.from.value)) {
            alert("Ο αποστολέας πρέπει να συμπληρωθεί.");
            forma.from.focus();
            return false;
        }
        else return true;
    }

    tinyMCE.init({
        verify_html : false,
        theme : "advanced",
        mode : "exact",
        convert_urls: true,
        relative_urls : false,
        remove_script_host: false,
        entity_encoding : "raw",
        plugins : "table,preview,template,advimage",
        elements : "body",
        extended_valid_elements : "a[href|target|name]",
        debug : false,
        theme_advanced_buttons1 : "bold, italic, underline, bullist, numlist, separator, justifyleft, justifycenter, justifyright, justifyfull, separator, formatselect, fontselect, fontsizeselect, ",
        theme_advanced_buttons2 : "sub, sup, separator, table, row_props, cell_props, delete_col, delete_row, col_after, col_before, row_after, row_before, split_cells, merge_cells, image, link, unlink, removeformat, visualaid, template, code, preview",
        theme_advanced_buttons3 : "",
        template_templates : [
          {
          title : "Newsletter",
          src : "/admin/tinymce_templates/newsletter01.html",
          description : "Newsletter"
          }
        ]
    });
    
    $(document).ready(function() {
        var options = {
            beforeSubmit:  showRequest, // pre-submit callback 
            success:       showResponse, // post-submit callback 
            url:           '/admin/savenewsletter.do', // override for form's 'action' attribute 
            type:          'post' // 'get' or 'post', override for form's 'method' attribute 
            
            // other available options: 
            // target: '#output1', // target element(s) to be updated with server response 
            // beforeSubmit: showRequest, // pre-submit callback 
            //url:       url         // override for form's 'action' attribute 
            //type:      type        // 'get' or 'post', override for form's 'method' attribute 
            //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
            //clearForm: true        // clear all form fields after successful submit 
            //resetForm: true        // reset the form after successful submit 

            // $.ajax options can be used here too, for example: 
            //timeout:   3000 
        }; 

        // bind form using 'ajaxForm'
        $('#inputForm').ajaxForm(options);
        
        // with jQuery Form plugin, here's how to update the textareas before the form fields are serialized and sent via Ajax:
        $('#inputForm').bind('form-pre-serialize', function(e) {
            tinyMCE.triggerSave();
        });
    });
    
    // pre-submit callback 
    function showRequest(formData, jqForm, options) {
        // formData is an array; here we use $.param to convert it to a string to display it 
        // but the form plugin does this for you automatically when it submits the data 
        //var queryString = $.param(formData);

        // jqForm is a jQuery object encapsulating the form element.  To access the 
        // DOM element for the form do this: 
        // var formElement = jqForm[0]; 
        //alert('About to submit: \n\n' + queryString); 

        // here we could return false to prevent the form from being submitted; 
        // returning anything other than false will allow the form submit to continue 
        return true; 
    }
    
    // post-submit callback 
    function showResponse(responseText, statusText, xhr, $form)  {
        // for normal html responses, the first argument to the success callback 
        // is the XMLHttpRequest object's responseText property 

        // if the ajaxForm method was passed an Options Object with the dataType 
        // property set to 'xml' then the first argument to the success callback 
        // is the XMLHttpRequest object's responseXML property 

        // if the ajaxForm method was passed an Options Object with the dataType 
        // property set to 'json' then the first argument to the success callback 
        // is the json data object returned by the server 
        if (responseText == 1) alert('Η αποθήκευση ολοκληρώθηκε.');
        else alert('Αποτυχία αποθήκευσης.');
    }
    </script>
</head>

<body <%= bodyString %>>
    
    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
    <td class="menuPathTD" align="middle"><b>Ταχυδρομικές λίστες&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Αποστολή email</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
            
            <form id="inputForm" name="inputForm" method="post" action="/servlet/admin/MailListSendEmail">
                
            <input type="hidden" name="action1" value="" />
            <input type="hidden" name="urlSuccess" value="<%= urlSuccess %>" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            
            <% String values[] = Configuration.getValues(new String[] {"smtpServer"}); %>
            <input type="hidden" name="mailhost" value="<%= values[0] %>" />
            <tr>
                <td class="inputFrmLabelTD">Από</td>
                <td class="inputFrmFieldTD"><input type="text" name="from" value="<%=from%>" size="50" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Θέμα</td>
                <td class="inputFrmFieldTD"><input type="text" name="subject" value="<%=subject%>" size="50" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Τύπος μηνύματος</td>
                <td class="inputFrmFieldTD">
                    <select name="mailContent" class="inputFrmField">
                        <option value="text/html" <%if ("text/html".equals(mailContent)) out.print("selected");%>>HTML ΜΟΡΦΗ</option>
                        <option value="text/plain" <%if ("text/plain".equals(mailContent)) out.print("selected");%>>ΑΠΛΟ ΚΕΙΜΕΝΟ</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Charset</td>
                <td class="inputFrmFieldTD">
                    <select name="mailCharset" class="inputFrmField">
                        <option value="UTF-8" <%if ("UTF-8".equals(mailCharset)) out.print("selected");%>>UTF-8</option>
                        <option value="ISO-8859-7" <%if ("ISO-8859-7".equals(mailCharset)) out.print("selected");%>>ISO-8859-7</option>
                        <option value="ISO-8859-1" <%if ("ISO-8859-1".equals(mailCharset)) out.print("selected");%>>ISO-8859-1</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD">Περιεχόμενο</td>
                <td class="inputFrmFieldTD">
                    <div style="margin:20px 0 20px 0;"><input type="submit" value="Αποθήκευση ως" /> <input type="text" name="NWLR_Title" value="<%=NWLR_Title%>" size="50" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></div>
                    <div><textarea id="body" name="body" cols="120" rows="35" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'"><%=org.apache.commons.lang3.StringEscapeUtils.escapeHtml4(body)%></textarea></div>
                </td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" colspan="2"></br></br>
                    <table width="100%" border="0" cellspacing="1" cellpadding="5" class="inputFrmTBL">
                    <tr>
                        <td class="inputFrmLabelTD"><b>Λίστα</b></td>
                        <td class="inputFrmLabelTD"><b>Περιγραφή</b></td>
                        <td class="inputFrmLabelTD"><b>Αποστολή</b></td>
                    </tr>
                    <%
                    int rows = helperBean.getTable("emailListTab", "EMLTName");
    
                    for (int i=0; i<rows; i++) { %>
                        <tr>
                            <td class="inputFrmLabelTD"><%= helperBean.getColumn("EMLTName") %></td>
                            <td class="inputFrmLabelTD"><%= helperBean.getColumn("EMLTDescr") %></td>
                            <td class="inputFrmFieldTD">
                                <input type="checkbox" name="send_<%= i %>" value="1" <% if (helperBean.getColumn("EMLTActive").equals("1")) out.print("CHECKED"); %> class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" />
                                <input type="hidden" name="EMLTCode_<%= i %>" value="<%= helperBean.getColumn("EMLTCode") %>">
                            </td>
                        </tr>
                    <%
                        helperBean.nextRow();
                    } %>

                    <input type="hidden" name="rowCount" value="<%= rows %>" />
                    
                    </table>
                </td>
            </tr>
            
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br></br>
                    <input type="button" value="Αποστολή" onClick='if (validateForm(document.inputForm) == true && confirm("Είστε σίγουρος για την αποστολή;") == true) { document.inputForm.action1.value="SEND"; document.inputForm.submit(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type="button" value="Φόρτωση" onClick="if (confirm('Είστε σίγουρος; Τυχόν αλλαγές που έχετε κάνει θα χαθούν.') == true) { document.location.href= 'newsletter_search.jsp?action1=SEARCH'; } else return false;" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            
            </form>
            
            </table>
            
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% helperBean.closeResources(); %>
    
</body>
</html>