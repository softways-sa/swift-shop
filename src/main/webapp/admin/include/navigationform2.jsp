<%@ page pageEncoding="UTF-8" %>

<%
int navform2_startPage = 0, navform2_endPage = 0;

if (totalPages > 1) { %>
    <table width="0" cellspacing="0" cellpadding="2" border="0">
    <tr>
        <td class="text">
            Σελίδες
            <img src="images/dot_blank.gif" width="5" height="1" alt="" />
            <%
            navform2_startPage = currentPage - ((dispPageNumbers/2) - 1);
            
            if (navform2_startPage <= 1) {
                navform2_startPage = 1;
                
                navform2_endPage = navform2_startPage + (dispPageNumbers-1);
            }
            else {
                navform2_endPage = currentPage + (dispPageNumbers/2);
            }
            
            if (navform2_endPage >= totalPages) {
                navform2_endPage = totalPages;
                
                navform2_startPage = navform2_endPage - (dispPageNumbers-1);
                if (navform2_startPage <= 1) navform2_startPage = 1;
            }
            
            for (int i=navform2_startPage; i<=navform2_endPage; i++) {
                if (i == currentPage) { %>
                    <span class="pageIndexLink"><b><%= i %></b></span>
            <%  } else { %>
                    <a class="pageIndexLink" href="<%= "http://" + serverName + "/admin/" + response.encodeURL(urlQuerySearch + "&action1=SEARCH&start=" + ((i-1)*dispRows)) %>"><%= i %></a>
            <%  }
            }
            %>
        </td>
        <td align="right">
            <img src="images/dot_blank.gif" width="15" height="1" alt="" />
            <%
            if (currentPage > 1) { %>
                <a class="pageIndexLink" href="<%= "http://" + serverName + "/admin/" + response.encodeURL(urlQuerySearch + "&action1=SEARCH&start=" + ((currentPage-2)*dispRows)) %>"><b>&#139; προηγούμενη</b></a>
            <%
            }
            
            if (currentPage > 1 && currentPage < totalPages) { %>
                <span class="content" id="white"> | </span>
            <%
            }
            
            if (currentPage < totalPages) { %>
                <a class="pageIndexLink" href="<%= "http://" + serverName + "/admin/" + response.encodeURL(urlQuerySearch + "&action1=SEARCH&start=" + (currentPage*dispRows)) %>"><b>επόμενη &#155;</b></a>
            <%
            } %>
        </td>
    </tr>
    </table>
<%
}
else { %>
    <table width="0" cellspacing="0" cellpadding="2" border="0">
    <tr>
        <td class="text">&nbsp;</td>
    </tr>
    </table>
<% } %>
