<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="/problem.jsp" %>

<%@ include file="/include/config.jsp" %>

<% whereAmI = "/index.jsp"; %>

<jsp:useBean id="searchArticle" scope="page" class="gr.softways.dev.swift.cmrow.SearchArticle3" />

<%
searchArticle.initBean(databaseId, request, response, this, session);

String htmlTitle = "", htmlKeywords = "", CMRHeadHTML = "", CMRBodyHTML = "";

int dispRows = 1, totalRowCount = 0;

searchArticle.setDispRows(dispRows);
searchArticle.setSortedByCol("CCCRRank DESC, CMRDateCreated");
searchArticle.setSortedByOrder("DESC");
DbRet dbRet = searchArticle.doAction(request);

totalRowCount = searchArticle.getTotalRowCount();

if (totalRowCount == 1) {
  htmlTitle = searchArticle.getColumn("CMRTitle" + lang);
  htmlKeywords = searchArticle.getColumn("CMRKeyWords" + lang);
  CMRHeadHTML = searchArticle.getColumn("CMRHeadHTML");
  CMRBodyHTML = searchArticle.getColumn("CMRBodyHTML");
}
else {
  htmlTitle = "";
  htmlKeywords = "";
}
%>

<!DOCTYPE html>
<html lang="<%=localeLanguage%>">
<head>
  <%@ include file="/include/metatags.jsp" %>
  
  <%if (htmlKeywords.length() > 0) {%><meta name="keywords" content="<%=htmlKeywords%>"><%}%>
  
  <title><%=htmlTitle%></title>

  <link href='/css/owl-carousel/owl.carousel.css' rel='stylesheet'>
  <link href='/css/owl-carousel/owl.theme.css' rel='stylesheet'>
  <style>.owl-carousel .item-box-wrapper{width: 200px; margin-right: 0; display: block; float: none; margin: 0 auto;}</style>

  <%=CMRHeadHTML%>
</head>

<body>

  <div id="site">

  <%@ include file="/include/top.jsp" %>

  <%=searchArticle.getColumn("CMRSummary" + lang)%>

  <div class="container" id="homeContainer">
  <div class="row">
  <div class="col-xs-12">

  <div id="homeContainerMain" class="clearfix">
    <jsp:include page="/WEB-INF/views/itemsCarousel.jsp"><jsp:param name="group" value="1"/></jsp:include>

    <jsp:include page="/WEB-INF/views/itemsCarousel.jsp"><jsp:param name="group" value="2"/></jsp:include>

    <%if (totalRowCount == 1) {%><div class="clearfix"><%=searchArticle.getColumn("CMRText" + lang)%></div><%}%>
  </div> <!-- end: homeContainerMain -->

  </div> <!-- /col -->
  </div> <!-- /row -->
  </div> <!-- /homeContainer -->

  <%@ include file="/include/bottom.jsp" %>

  </div> <!-- /site -->

  <%=CMRBodyHTML%>

  <script src='/js/owl.carousel.min.js'></script>
  <script>$(document).ready(function() {$('.owl-carousel').owlCarousel({navigation: true, items: 5, itemsDesktop: [1199,4], itemsDesktopSmall: [991,3], itemsTablet: [677,2], itemsMobile: [540,1]});});</script>

  <%
  searchArticle.closeResources();
  %>

</body>
</html>