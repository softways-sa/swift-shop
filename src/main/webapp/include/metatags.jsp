<%@ page pageEncoding="UTF-8" %>

<jsp:useBean id="metatag_cmrow" scope="page" class="gr.softways.dev.swift.cmrow.Present" />

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

<link rel="shortcut icon" href="/images/favicon.ico">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/megamenu.css">
<link rel="stylesheet" type="text/css" href="/css/core.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" href="/css/royalslider/royalslider.css">

<script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<script src="/js/typeahead.bundle.js"></script>
<script src="/js/megamenu_plugins.js"></script>
<script src="/js/megamenu.min.js"></script>
<script type="text/javascript" src="/js/pure_min.js"></script>
<script src="/js/jquery.royalslider.min.js"></script>
<script type="text/javascript" src="/js/jsfunctions.js"></script>

<script>
var productSearch = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: '/product_search_ajax.jsp?action1=SEARCH&qid=%QUERY'
});

productSearch.initialize();

function updateMinicartBar(quan, subtotal, flash) {
  if ('1' == flash) {
    $('#minicartBar').effect("highlight", {'color':'#000000'}, 3000);
  }

  $('#minicartBarQuan').html(quan);
  $('#minicartBarSubtotal').html(subtotal);
}

function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
      window.onload = func;
  } else {
      window.onload = function() {
          oldonload();
          func();
      }
  }
}

$(document).ready(function() {
  $(".item-box-image a img").hover(function() {
      $(this).stop().animate({opacity: "0.65"}, 500);
  },
  function() {
      $(this).stop().animate({opacity: "1"}, 500);
  });
    
  updateMinicartBar('<%=order.getProductCount().intValue()%>','<%=SwissKnife.formatNumber(order.getOrderPrice().getGrossCurr1(),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%>&nbsp;&euro;','0');
    
  $('.megamenu').megaMenuCompleteSet({
      menu_speed_show : 0, // Time (in milliseconds) to show a drop down
      menu_speed_hide : 0, // Time (in milliseconds) to hide a drop down
      menu_speed_delay : 0, // Time (in milliseconds) before showing a drop down
      menu_effect : 'hover_fade', // Drop down effect, choose between 'hover_fade', 'hover_slide', etc.
      menu_click_outside : 1, // Clicks outside the drop down close it (1 = true, 0 = false)
      menu_show_onload : 0, // Drop down to show on page load (type the number of the drop down, 0 for none)
      menu_responsive: 1 // 1 = Responsive, 0 = Not responsive
  });
  
  $('#search .typeahead').typeahead({
      minLength: 3
    },
    {
      name: 'product-search',
      displayKey: 'value',
      source: productSearch.ttAdapter(),
      templates: {
        footer: function(ctx) {
          if (ctx.isEmpty == false) return '<div class="footer-message"><a href="/site/search?qid=' + ctx.query + '"><%=bottom_lb.get("displayAll" + lang)%></a></div>';
        }
      }
    }
  ).on('typeahead:selected', function($e, suggestion) {
    window.location = suggestion.link;
  });
});
</script>

<%
metatag_cmrow.initBean(databaseId, request, response, this, session);
metatag_cmrow.getCMRow("0105", "");
while (metatag_cmrow.inBounds() == true) {out.println(metatag_cmrow.getColumn("CMRHeadHTML")); metatag_cmrow.nextRow();}
metatag_cmrow.closeResources();
%>