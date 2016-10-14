<%@ page pageEncoding="UTF-8" %>

<input type="Hidden" name="goLabel" value="results">
<input type="Hidden" name="sr" value="<%= startRow %>">
<input type="Hidden" name="p" value="<%= pageNum %>">
<input type="Hidden" name="rowCount" value="<%= rowCount %>">
<input type="Hidden" name="gp" value="<%= groupPages %>">
<input type="Hidden" name="dr" value="<%= dispRows %>">

<table width="0" cellspacing="0" cellpadding="2" border="0">
<tr>
    <td><span class="text">Σελίδες</span></td>
    <% // create & display references to the pages
    if ( (groupPages + 10) < pageCount ) dispPages = groupPages + 10;
    else dispPages = pageCount;
    
    q = groupPages * dispRows;
    
    if (groupPages > 0) {
    %>
        <td><a href="javascript:document.nav.gp.value=<%= groupPages - 10 %>;document.nav.submit()"><img src="images/backw10.gif" border=0 alt="προηγούμενες 10"></a><% } else { %><td><img src="images/blank_nav.gif" border="0" /></td><% } %>
        <td>
            <%
            for (int i=groupPages; i<dispPages; i++) { %>
                <a href='javascript:document.nav.sr.value="<%= q %>"; document.nav.p.value="<%= i+1 %>"; document.nav.submit()' class="pageIndexLink"><% if(pageNum == i+1) out.print("<b>"); %><%= i+1 %><% if(pageNum == i+1) out.print("</b>"); %></a>
            <% 
                q += dispRows;
            } %>
       </td>
      <% if ( (groupPages+10) < pageCount ) { %><td><a href="javascript:document.nav.gp.value=<%= groupPages + 10 %>;document.nav.submit()"><img src="images/forw10.gif" border=0 alt="επόμενες 10"></a></td><% }
         else { %> <td><img src="images/blank_nav.gif" border=0></td> <% } %>

    <% if (pageNum  > 1) { %><td><a href="javascript:document.nav.p.value=<%= pageNum - 1 %>; document.nav.sr.value=<%= startRow - dispRows %>; document.nav.submit()"><img src="images/backw.gif"  border=0 alt="προηγούμενη σελίδα""></td></a><% } else { %><td><img src="images/blank_nav.gif"  border=0></td><% } %>
    <% if (pageNum < pageCount) { %><td><a href="javascript:document.nav.p.value=<%= pageNum + 1 %>; document.nav.sr.value=<%= startRow + dispRows %>; document.nav.submit()"><img src="images/forw.gif" border=0 alt="επόμενη σελίδα"></td></a><% } else { %><td><img src="images/blank_nav.gif" border=0 alt="next"></td><% } %>
</tr>
</table>
