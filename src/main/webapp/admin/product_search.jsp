<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.BigDecimal,gr.softways.dev.util.*
                ,gr.softways.dev.eshop.eways.Customer
                ,gr.softways.dev.eshop.eways.v5.PriceChecker,gr.softways.dev.eshop.eways.v2.PrdPrice" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="app_searchprd" scope="session" class="gr.softways.dev.eshop.product.v2.AdminSearch2_2" />

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.JSPBean" />

<%
request.setAttribute("admin.topmenu","products");

app_searchprd.initBean(databaseId, request, response, this, session);
helperBean.initBean(databaseId, request, response, this, session);

DbRet dbRet = null;

int dispPageNumbers = 10;

app_searchprd.setDispRows(dispRows);

dbRet = app_searchprd.doAction(request);

if (dbRet.getAuthError() == 1) {
    app_searchprd.closeResources();
    response.sendRedirect( response.encodeURL("noaccess.jsp?authCode=" + dbRet.getAuthErrorCode()) );
    return;
}

int currentPage = 0, currentRowCount = 0, totalRowCount = 0, totalPages = 0;

currentRowCount = app_searchprd.getCurrentRowCount();
totalRowCount = app_searchprd.getTotalRowCount();
totalPages = app_searchprd.getTotalPages();
currentPage = app_searchprd.getCurrentPage();

int start = app_searchprd.getStart();

String prdId = app_searchprd.getPrdId(),
       name = app_searchprd.getName(),
       catId = app_searchprd.getCatId(),
       prdHideFlag = app_searchprd.getPrdHideFlag(),
       hotdeal = app_searchprd.getHotdeal(),
       prdNewColl = app_searchprd.getPrdNewColl();

BigDecimal stockQua = app_searchprd.getStockQua();

String urlSearch = response.encodeURL("product_search.jsp"),
    urlNew = response.encodeURL("product_update.jsp"),
    action = request.getParameter("action1") == null ? "" : request.getParameter("action1");

String urlQuerySearch = "product_search.jsp?prdId=" + SwissKnife.hexEscape(prdId)
                      + "&name=" + SwissKnife.hexEscape(name)
                      + "&catId=" + SwissKnife.hexEscape(catId)
                      + "&prdHideFlag=" + SwissKnife.hexEscape(prdHideFlag)
                      + "&hotdeal=" + SwissKnife.hexEscape(hotdeal);
if (stockQua != null) urlQuerySearch += "&stockQua=" + stockQua;

String goLabel = request.getParameter("goLabel") == null ? "" : request.getParameter("goLabel");

BigDecimal _one = new BigDecimal("1");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>

    <title>eΔιαχείριση</title>
	
    <script type="text/javascript" language="javascript" src="js/jsfunctions.js"></script>
    
    <script type="text/javascript" language="javascript">
        function resetForm() {
            document.searchForm.prdId.value = "";
            document.searchForm.name.value = "";
            document.searchForm.stockQua.value = "";
            document.searchForm.catId.selectedIndex = 0;
            document.searchForm.prdHideFlag.selectedIndex = 0;
            document.searchForm.hotdeal.checked = false;
            document.searchForm.prdNewColl.checked = false;
        }
    </script>
</head>

<body <%= bodyString %>>

    <%@ include file="include/top.jsp" %>
    
    <table width="0" border="0" cellspacing="2" cellpadding="20">
    <tr>
      <td class="menuPathTD" align="middle"><b>Αποθήκη&nbsp;<span class="menuPathTD" id="white">|</span>&nbsp;Προϊόντα</b></td>
      <td align="right" valign="middle">
        <table width="0" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><a href="<%= urlNew %>" class="text" id="white"><img src="images/addnew.png" border ="0" alt="Προσθήκη νέας εγγραφής"></a></td>
          <td>&nbsp;</td>
        </tr>
        </table>
      </td>
    </tr>
    </table>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="searchFrmTBL">
            
            <form name="searchForm" method="POST" action="<%= urlSearch %>">
            <input type="hidden" name="action1" value="SEARCH" />
            <input type="hidden" name="goLabel" value="results" />
        
            <tr>
                <td>
                    <table width="0" border="0" cellspacing="0" cellpadding="10">
                    <tr>
                        <td>
                            <table width="0" border="0" cellspacing="0" cellpadding="2">
                            <tr>
                                <td class="searchFrmTD" align="left">Κωδικός</td>
                                <td class="searchFrmTD" align="left">Ονομασία</td>
                                <td class="searchFrmTD" align="left">Απόκρυψη</td>
                                <td class="searchFrmTD" align="right">Κατηγορία</td>
                                <td class="searchFrmTD" align="right">Προσφορές</td>
                                <td class="searchFrmTD" align="right">Προβεβλημένα</td>
                                <td class="searchFrmTD" align="right">Προϊόντα με τεμάχια κάτω από</td>
                                <td class="searchFrmTD" align="right"></td>
                                <td class="searchFrmTD" align="right"><img src="images/dot_blank.gif" width="20" height="1" /></td>				
                                <td class="searchFrmTD" align="right"></td>
                                <td class="searchFrmTD" align="right"></td>
                            </tr>
                            <tr>
                              <td><input type="text" name="prdId" value="<%= prdId %>" size="25" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                              <td><input type="text" name="name" value="<%= name %>" size="25" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                              <td>
                                <select name="prdHideFlag" class="inputFrmField">
                                    <option value="">---</option>
                                    <option value="0" <% if (prdHideFlag.equals("0")) { %>SELECTED <% } %>>ΟΧΙ</option>
                                    <option value="1" <% if (prdHideFlag.equals("1")) { %>SELECTED <% } %>>ΝΑΙ</option>
                                </select>
                               </td>
                               <td>
                                  <select name="catId" class="inputFrmField">
                                    <option value="">---</option>
                                    <%
                                    int catRows = helperBean.getTable("prdCategory", "catId");

                                    for (int i=0; i<catRows; i++) { %>
                                        <option value="<%= helperBean.getColumn("catId") %>" <% if (helperBean.getColumn("catId").equals(catId)) { %>SELECTED <% } %>><% for (int i0=0; i0<(helperBean.getColumn("catId").length()-2); i0++) out.print("&nbsp;&nbsp;"); %><%= helperBean.getColumn("catName") %></option>
                                    <%
                                        helperBean.nextRow();
                                    } %>
                                  </select>
                                </td>
                                <td><input type="checkBox" name="hotdeal" VALUE="1" <% if (hotdeal.equals("1")) { %> CHECKED <% } %> class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                <td><input type="checkBox" name="prdNewColl" VALUE="1" <% if (prdNewColl.equals("1")) { %> CHECKED <% } %> class="searchFrmInput" onfocus="this.className='searchFrmInputFocus'" onblur="this.className='searchFrmInput'" /></td>
                                <td><input type="text" name="stockQua" value="<% if (stockQua != null) out.print(stockQua); %>" size="5" class="inputFrmField" onfocus="this.className='inputFrmFieldFocus'" onblur="this.className='inputFrmField'" /></td>
                                <td class="searchFrmTD" align="left"></td>
                                <td class="searchFrmTD"><input type="submit" name="" value="αναζήτηση" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>
                                <td class="searchFrmTD"><input type="button" name="" value="μηδενισμός" onclick="resetForm()" class="loginFrmBtn"  onmouseover="this.className='loginFrmBtnOver'" onmouseout="this.className='loginFrmBtn'"/></td>  
                            </tr>
                            </table>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
            
            </form>
            
            </table>
            
            <%
            boolean moreDataRows = true;
            
            if (currentRowCount <= 0) moreDataRows = false;
            %>

            <%-- παρουσίαση --%>
            <a name="results"></a>
            
            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="resultsTBL">
            <tr class="resultsLabelTR">
                <td class="resultsLabelTD">Κωδικός</td>
                <td class="resultsLabelTD">Ονομασία</td>
                <td class="resultsLabelTD">Τιμή λιανικής</td>
                <td class="resultsLabelTD">Τεμάχια</td>
                <td class="resultsLabelTD">Απόκρυψη</td>
            </tr>
            <%
            int disp = 0;
            
            PrdPrice retailPrice = new PrdPrice();
    
            String prdHideFlagMsg = null, prdImg = "";
    
            boolean retailOffer = false;
            
            for (disp=0; moreDataRows && disp < dispRows; disp++) {
                if (app_searchprd.getColumn("prdHideFlag").equals("0")) {
                    prdHideFlagMsg = "ΟΧΙ";
                }
                else if (app_searchprd.getColumn("prdHideFlag").equals("1")) {
                    prdHideFlagMsg = "ΝΑΙ";
                }
    
                if (PriceChecker.isOffer(app_searchprd.getQueryDataSet(),Customer.CUSTOMER_TYPE_RETAIL)) {
                    retailOffer = true;
                }
                else {
                    retailOffer = false;
                }
                retailPrice = PriceChecker.calcPrd(_one,app_searchprd.getQueryDataSet(),Customer.CUSTOMER_TYPE_RETAIL,retailOffer);
                
                if (SwissKnife.fileExists(wwwrootFilePath + "/prd_images/" + app_searchprd.getColumn("prdId") + "-1.jpg")) {
                    prdImg = "/prd_images/" + app_searchprd.getColumn("prdId") + "-1.jpg";
                }
                else {
                    prdImg = "/images/img_not_avail.jpg";
                }
            %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= app_searchprd.getColumn("prdId") %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><a href="<%= response.encodeURL("product_update.jsp?action1=EDIT&prdId=" + app_searchprd.getHexColumn("prdId")) %>" class="resultsLink"><img style="border:none; vertical-align: middle; margin-right:10px;" src="<%=prdImg%>" valign="top" width="80" height="80" alt=""/><%= app_searchprd.getColumn("name") %></a></td>
                    <td align="right" class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&euro;<%= SwissKnife.formatNumber(retailPrice.getUnitGrossCurr1().setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale) %></td>
                    <td align="right" class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= SwissKnife.formatNumber(app_searchprd.getBig("stockQua").setScale(0, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,0,0) %></td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'"><%= prdHideFlagMsg %></td>
                </tr>
            <%
                moreDataRows = app_searchprd.nextRow();
            }
            for (; disp < dispRows; disp++) { %>
                <tr class="resultsDataTR" onmouseover="this.className='resultsDataTROver'" onmouseout="this.className='resultsDataTR'">
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                    <td class="resultsDataTD" onmouseover="this.className='resultsDataTDOver'" onmouseout="this.className='resultsDataTD'">&nbsp;</td>
                </tr>
            <% } %>
            
            <%-- previus - next buttons --%>
            <form name="nav" method="POST" action="<%= urlSearch %>">
            
            <tr class="resultsFooterTR">
                <td colspan="5"><%@ include file="include/navigationform2.jsp" %></td>
            </tr>
            
            </form>
            
            </table>
            <%-- / παρουσίαση --%>
        </td>
        
        <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>
    
    <% 
    if (goLabel.length()>0) { %>
        <script type="text/javascript" language="javascript">
            document.location.hash = "<%= goLabel %>";
        </script>
    <% } %>
    
    <% helperBean.closeResources(); %>
    
</body>
</html>
