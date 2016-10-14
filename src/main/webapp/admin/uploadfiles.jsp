<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="ebb_listdir" scope="page" class="gr.softways.dev.util.ListDir" />

<%
request.setAttribute("admin.topmenu","content");

String urlSuccess = response.encodeURL("http://" + serverName + "/" + appDir + "admin/uploadfiles.jsp"),
       urlFailure = response.encodeURL("http://" + serverName + "/" + appDir + "admin/problem.jsp"),
       urlPost = response.encodeURL("/servlet/admin/UploadFiles");
       
String fileAction = request.getParameter("fileAction") == null ? "" : request.getParameter("fileAction");
String fileName = request.getParameter("fileName") == null ? "" : request.getParameter("fileName");

int filesCount = 5;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
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

    <title>Upload files</title>
    
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>

    <script language="JavaScript" src="js/jsfunctions.js"></script>
    
    <script type="text/javascript">
    function confirmFileAction(fn) {
      if (confirm("Είστε σίγουρη(ος) ότι θέλετε να διαγράψετε το αρχείο: " + fn) == true) { 
          return true;
      }
      else return false;
    }
    
    $(document).ready(function() {
      $('#upFileForm').submit(function() {
        $('body').append('<div id="uploading-overlay" style="display: block;"></div>');
        $('#uploading-overlay').addClass('overlay-fixed');
        
        $("body").append('<div id="uploading-loader"><div></div></div>');
      });
    });
    
    function sendFiles() {
      $('#upFileForm').submit();
    }
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
	<td class="menuPathTD" align="middle"><b>Περιεχόμενο&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Αποστολή αρχείων/εικόνων</b></td>
    </tr>
    </table>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
        
            <table width="0" border="0" cellspacing="0" cellpadding="10" class="inputFrmTBL" align="center">
            
            <form id="upFileForm" name="upFileForm" action="<%= urlPost %>"  enctype="multipart/form-data" method="POST">
            
            <input type="hidden" name="databaseId" value="<%= databaseId %>" />
            <input type="hidden" name="urlNoAccess" value="<%= urlNoAccess %>" />
            <input type="hidden" name="urlFailure" value="<%= urlFailure %>" />
            <input type="hidden" name="urlSuccess" value="<%= urlSuccess %>" />
            
            <input type="hidden" name="filesCount" value="<%= filesCount %>" />
            <input type="hidden" name="overwrite" value="true" />
            <input type="hidden" name="lowerCase" value="false" />
            
            <tr>
                <td colspan="2" class="inputFrmHeader" align="center">Επιλογή και ανέβασμα αρχείων/εικόνων</td>
            </tr>
            <tr>
                <td class="inputFrmLabelTD" align="left"><b>Αρχείο</b></td>
                <td class="inputFrmLabelTD" align="left"><b>Προορισμός</b></td>
            </tr>
            <%
            for (int i=1; i<=filesCount; i++) { %>
                <tr>
                    <td class="inputFrmFieldTD" align="right"><input type="file" name="file<%= i %>" size="70" /></td>
                    <td class="inputFrmFieldTD" align="left">
                        <select name="uploadPath<%= i %>" class="inputFrmField">
                            <option value="<%= userImagesFilePath %>">Φωτογραφίες</option>
                            <option value="<%= userFilesFilePath %>">Αρχεία</option>
                        </select>
                    </td>
                </tr>
            <%
            } %>
            <tr class="inputFrmFooter">
                <td colspan="2" align="center"></br>
                    <input type=button value="Αποστολή" onClick='if (confirm("Είστε σίγουρος;") == true) { sendFiles(); } else return false;' class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                    <input type=reset value="Καθαρισμός πεδίων" class="loginFrmBtn" onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'" />
                </td>
            </tr>
            
            </form>
            
            </table>
            <br/>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            
            <form name="listFilesForm" method="POST" action="<%= response.encodeURL("http://" + serverName + "/" + appDir + "admin/uploadfiles.jsp") %>">
            
            <input type="hidden" name="fileAction" value="">
            <input type="hidden" name="fileName" value="">
            
            <%
            
            if (fileAction != null && fileAction.equals("DELETE")) ebb_listdir.deleteFile(fileName);

            String[] title = new String[] {"Φωτογραφίες","Αρχεία"};
            String[] imagesFilePath = new String[] {userImagesFilePath,userFilesFilePath};
            String[] imagesWebPath = new String[] {userImagesWebPath,userFilesWebPath};
            
            for (int x=0; x<title.length; x++) { %>
                <tr class="resultsLabelTR">
                    <td colspan="6" class="resultsLabelTD" align="left"><%= title[x] %></td>
                </tr>
                <%
                String[] images = ebb_listdir.getFileNames(imagesFilePath[x]);
                
                if (images != null && images.length > 0) {
                
                    int imagesLength = images.length;
                    
                    int imagesLastRowLength = imagesLength % 3;
                    int mainI = 0;
                    for (; mainI<imagesLength - imagesLastRowLength; mainI+=3) {
                %>
                        <tr class="resultsDataTR">
                            <td width="15" valign="middle"><a href="javascript:document.listFilesForm.fileAction.value='DELETE';document.listFilesForm.fileName.value='<%= imagesFilePath[x] + "/" + images[mainI] %>';document.listFilesForm.submit();" onclick="return confirmFileAction('<%= images[mainI] %>');"><img src="/admin/images/delfile.png" border="0"></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= imagesWebPath[x] + "/" + images[mainI] %>" target="blank" class="resultsLink"><%= images[mainI] %></a></td>
                            <td width="15" valign="middle"><a href="javascript:document.listFilesForm.fileAction.value='DELETE';document.listFilesForm.fileName.value='<%= imagesFilePath[x] + "/" + images[mainI+1] %>';document.listFilesForm.submit();" onclick="return confirmFileAction('<%= images[mainI+1] %>');"><img src="/admin/images/delfile.png" border="0"></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= imagesWebPath[x] + "/" + images[mainI+1] %>" target="blank" class="resultsLink"><%= images[mainI+1] %></a></td>
                            <td width="15" valign="middle"><a href="javascript:document.listFilesForm.fileAction.value='DELETE';document.listFilesForm.fileName.value='<%= imagesFilePath[x] + "/" + images[mainI+2] %>';document.listFilesForm.submit();" onclick="return confirmFileAction('<%= images[mainI+2] %>');"><img src="/admin/images/delfile.png" border="0"></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= imagesWebPath[x] + "/" + images[mainI+2] %>" target="blank" class="resultsLink"><%= images[mainI+2] %></a></td>
                        </tr>
                <%
                    }
                    if (imagesLastRowLength > 0) {
                    %>
                        <tr class="resultsDataTR">
                        <%
                        int i=0;
                        for (; i <imagesLastRowLength; i++, mainI++) {
                        %>
                            <td width="15" valign="middle"><a href="javascript:document.listFilesForm.fileAction.value='DELETE';document.listFilesForm.fileName.value='<%= imagesFilePath[x] + "/" + images[mainI] %>';document.listFilesForm.submit();" onclick="return confirmFileAction('<%= images[mainI] %>');"><img src="/admin/images/delfile.png" border="0"></a></td>
                            <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= imagesWebPath[x] + "/" + images[mainI] %>" target="blank" class="resultsLink"><%= images[mainI] %></a></td>
                        <% 
                        }
                        for (int j=i; j<3; j++) {
                        %>
                            <td width="15">&nbsp;</td><td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                        <% 
                        }
                        %>
                        </tr>
                    <%
                    }
                }
                else { %>
                    <tr class="resultsDataTR">
                        <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'" colspan="6">Δεν υπάρχουν περιεχόμενα</td>
                    </tr>
            <%
                }
            }
            %>
            
            </form>
            
            </table>
        </td>
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>

</body>
</html>