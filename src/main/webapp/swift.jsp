<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/swift.jsp"; %>

<jsp:useBean id="searchArticle" scope="page" class="gr.softways.dev.swift.cmrow.SearchArticle3" />
<jsp:useBean id="cmcategory" scope="page" class="gr.softways.dev.swift.cmcategory.Present" />

<%!
static HashMap lb = new HashMap();
static {
  lb.put("htmlTitle","");
  lb.put("htmlTitleLG","");
  lb.put("more","Διαβάστε περισσότερα");
  lb.put("moreLG","Read more");
  lb.put("moreLG1","Read more");
  lb.put("moreLG2","Read more");
  lb.put("pub","Δημοσιεύθηκε");
  lb.put("pubLG","Published on");
  lb.put("pubLG1","Published on");
  lb.put("pubLG2","Published on");
  lb.put("noRecords","Δεν βρέθηκαν καταχωρήσεις.");
  lb.put("noRecordsLG","No records found.");
  lb.put("next","Επόμενη");
  lb.put("nextLG","Next");
  lb.put("previous","Προηγούμενη");
  lb.put("previousLG","Previous");
}
%>

<%
searchArticle.initBean(databaseId, request, response, this, session);
cmcategory.initBean(databaseId, request, response, this, session);

int CMRRows = 0;

int dispRows = 10, dispPageNumbers = 10;

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

searchArticle.setDispRows(dispRows);
searchArticle.setSortedByCol("CCCRRank DESC, CMRDateCreated");
searchArticle.setSortedByOrder("DESC");
DbRet dbRet = searchArticle.doAction(request);

currentRowCount = searchArticle.getCurrentRowCount();
totalRowCount = searchArticle.getTotalRowCount();
totalPages = searchArticle.getTotalPages();
currentPage = searchArticle.getCurrentPage();

int startPage = 0, endPage = 0;

int start = searchArticle.getStart();

String urlQuerySearch = "http://" + serverName + "/site/page" + "?CMCCode=" + SwissKnife.hexEscape(searchArticle.getCMCCode()) + "&amp;extLang=" + lang;

String htmlTitle = "", htmlKeywords = "", CMRHeadHTML = "", CMRBodyHTML = "";

if (totalRowCount == 1) {
    htmlTitle = searchArticle.getColumn("CMRTitle" + lang);
    htmlKeywords = searchArticle.getColumn("CMRKeyWords" + lang);
    CMRHeadHTML = searchArticle.getColumn("CMRHeadHTML");
    CMRBodyHTML = searchArticle.getColumn("CMRBodyHTML");
    
    if (CMCCode.equals("")) {
      CMCCode = searchArticle.getColumn("CCCR_CMCCode");

      request.setAttribute("CMCCode",CMCCode);
    }
}
else {
    htmlTitle = lb.get("htmlTitle" + lang).toString();
    htmlKeywords = "";
}
String CMCURL = "";
String[][] CMCTree = null;
// get category path
if (!CMCCode.equals("") && !CMCCode.trim().startsWith("01")) {
    CMCTree = cmcategory.getCMCategoryTreePath(CMCCode, lang);
    if (CMCTree != null) {
        for (int i=0; i<CMCTree.length; i++) {
            if (i==0) {
                // the first category
                //top_jsp_path += CMCTree[i][0];
            }
            else {
                top_jsp_path += CMCTree[i][0];

                if ((i+1)<CMCTree.length) top_jsp_path += "&nbsp;|&nbsp;";

                CMCURL = CMCTree[i][2];
                if (CMCURL.equals("")) CMCURL = "http://" + serverName + "/" + "swift.jsp?CMCCode=" + CMCTree[i][1] + "&amp;extLang=" + lang;
            }
        }
    }
}
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>

  <meta name="keywords" content="<%= htmlKeywords %>" />

  <title><%= htmlTitle %></title>

  <%=CMRHeadHTML%>
</head>

<body>

<div id="site">

<%@ include file="/include/top.jsp" %>

<div id="contentContainer" class="container">

<%
if (totalRowCount == 1) {
  String gimg = "", zoom_gimg = "";
  boolean pgallery = false;
%>
  <div class="clearfix">
    <div id="content" class="clearfix"><%= searchArticle.getColumn("CMRText" + lang) %></div>
    
    <%
      for (int i=1; i<=20; i++) if (SwissKnife.fileExists(wwwrootFilePath + "/gimages/" + searchArticle.getColumn("CMRCode") + "-" + i + ".jpg")) {pgallery = true; gimg = "/gimages/" + searchArticle.getColumn("CMRCode") + "-" + i + ".jpg"; break;}
      
      if (pgallery == true) {
      %>
        <link rel="stylesheet" type="text/css" href="/css/psgallery.css" />
        
        <script type="text/javascript" src="/js/psgallery.js"></script>
      
        <div class="pgallery clearfix">
          
          <%--<div id="loader" class="loader"></div>--%>

          <div id="ps_container" class="ps_container">
          <div class="ps_image_wrapper">
            <!-- First initial image -->
            <img src="<%=gimg%>" alt="" />
          </div>
          <!-- Navigation items -->
          <div class="ps_next"></div>
          <div class="ps_prev"></div>
          <!-- Dot list with thumbnail preview -->
          <ul class="ps_nav">
            <%
            boolean first = true;

            for (int i=1; i<=20; i++) {
              if (SwissKnife.fileExists(wwwrootFilePath + "/gimages/" + searchArticle.getColumn("CMRCode") + "-" + i + ".jpg")) {
                gimg = "/gimages/" + searchArticle.getColumn("CMRCode") + "-" + i + ".jpg";
            %>
                  <li <%if (first == true) out.print("class=\"selected\"");%>><a href="<%=gimg%>" rel="<%=gimg%>">Image <%=i%></a></li>
            <%
                first = false;
              }
            }
            %>
          </ul>
          </div>
          
        </div> <!-- end: pgallery -->
      <%
      }
      %>
  </div>
<%
}
else if (totalRowCount > 1) {
    while (searchArticle.inBounds() == true) { %>
        <div class="clearfix post">
          <h5 class="entry-title"><a href="<%="http://" + serverName + "/site/page/" + SwissKnife.sefEncode(searchArticle.getColumn("CMRTitle" + lang)) + "?CMRCode=" + searchArticle.getColumn("CMRCode") + "&amp;extLang=" + lang%>"><%=searchArticle.getColumn("CMRTitle" + lang)%></a></h5>
          <%if (searchArticle.getColumn("CMRSummary" + lang).length()>0) {%><div class="post-content"><%=searchArticle.getColumn("CMRSummary" + lang)%></div><%}%>
          <div class="meta-info">
            <%=lb.get("pub" + lang)%> <%=SwissKnife.formatDate(searchArticle.getTimestamp("CMRDateCreated"),"dd/MM/yyyy")%> 
            <div class="right"><a class="read-more" href="<%="http://" + serverName + "/site/page/" + SwissKnife.sefEncode(searchArticle.getColumn("CMRTitle" + lang)) + "?CMRCode=" + searchArticle.getColumn("CMRCode") + "&amp;extLang=" + lang%>"><%=lb.get("more" + lang)%> &rsaquo;</a></div>
          </div>
        </div>
<%
        searchArticle.nextRow();
    }

    if (totalPages > 1) { %>
        <div id="searchPagination">
        <table class="centerPagination">
        <tr><td align="center">
        <table class="pagination" align="center"><tr>
        <%
        if (currentPage > 1) { %>
            <td><a href="<%= urlQuerySearch + "&amp;start=" + ((currentPage-2)*dispRows) %>"><b class="paginationArrows">&laquo;</b> <%= lb.get("previous" + lang) %></a></td>
        <%
        }
        else { %>
            <td><a href="#" class="searchPreviousPage"><b class="paginationArrows">&laquo;</b> <%= lb.get("previous" + lang) %></a></td>
        <%
        }

        startPage = currentPage - ((dispPageNumbers/2) - 1);

        if (startPage <= 1) {
            startPage = 1;

            endPage = startPage + (dispPageNumbers-1);
        }
        else {
            endPage = currentPage + (dispPageNumbers/2);
        }

        if (endPage >= totalPages) {
            endPage = totalPages;

            startPage = endPage - (dispPageNumbers-1);
            if (startPage <= 1) startPage = 1;
        }

        for (int i=startPage; i<=endPage; i++) {
            if (i == currentPage) { %>
                <td><a href="#" class="searchCurrentPage"><%= i %></a></td>
        <%  } else { %>
                <td class="hidden-xs"><a href="<%= urlQuerySearch + "&amp;start=" + ((i-1)*dispRows) %>"><%= i %></a></td>
        <%  }
        }

        if (currentPage < totalPages) { %>
            <td><a href="<%= urlQuerySearch + "&amp;start=" + (currentPage*dispRows) %>"><%= lb.get("next" + lang) %> <b class="paginationArrows">&raquo;</b></a></td>
        <%
        }
        else { %>
            <td><a href="#" class="searchNextPage"><%= lb.get("next" + lang) %> <b class="paginationArrows">&raquo;</b></a></td>
        <%
        } %>
        </tr></table>
        </td></tr></table>
        </div> <!-- end: pagination -->
<%
    }
}
else if (totalRowCount <= 0) { %>
    <div><b><%= lb.get("noRecords" + lang) %></b></div>
<% } %>

</div> <!-- /contentContainer -->

<%@ include file="/include/bottom.jsp" %>

</div> <!-- /site -->

<%=CMRBodyHTML%>

<%
searchArticle.closeResources();
cmcategory.closeResources();
%>

</body>
</html>