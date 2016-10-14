<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page errorPage="problem.jsp" %>

<%@ page import="java.math.*,gr.softways.dev.util.*" %>

<%@ include file="include/config.jsp" %>

<%@ include file="include/auth.jsp" %>

<jsp:useBean id="helperBean" scope="page" class="gr.softways.dev.util.SQLHelper2" />

<%
request.setAttribute("admin.topmenu","dashboard");

helperBean.initBean(databaseId, request, response, this, session);

BigDecimal zero = new BigDecimal("0"), totalOrderValue = zero, avgOrderValue = zero;
int totalOrders = 0, totalProducts = 0;

helperBean.getSQL("SELECT SUM(valueEU + vatValEU) AS totalOrderValue, COUNT(orderId) AS totalOrders FROM orders WHERE status NOT IN ('" + gr.softways.dev.eshop.eways.Order.STATUS_CANCELED + "')");

totalOrders = helperBean.getInt("totalOrders");
if (helperBean.getBig("totalOrderValue") != null) totalOrderValue = helperBean.getBig("totalOrderValue");
if (totalOrders > 0 && totalOrderValue.compareTo(zero) == 1) avgOrderValue = totalOrderValue.divide(new BigDecimal(totalOrders), RoundingMode.HALF_UP);
helperBean.closeResources();

helperBean.getSQL("SELECT COUNT(prdId) AS totalProducts FROM product WHERE prdHideFlag = '0'");
totalProducts = helperBean.getInt("totalProducts");
helperBean.closeResources();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <%@ include file="include/metatags.jsp" %>
    
    <title>eΔιαχείριση</title>
    
    <link href="css/jquery-ui-1.10.3.custom.min.css" rel="stylesheet" type="text/css" media="all" />
    
    <style>
    #dashboard *, #dashboard *::before, #dashboard *::after {
      box-sizing: border-box;
    }
    #dashboard *, #dashboard *::before, #dashboard *::after {
      box-sizing: border-box;
    }
    .ui-widget {
      font-family: verdana,arial,helvetica;
      font-size: 12px;
    }
    
    .group:after {
      visibility: hidden;
      display: block;
      content: "";
      clear: both;
      height: 0;
    }
    .a-center {
      text-align: center !important;
    }
    .a-right {
      text-align: right !important;
    }
    .bold {
      font-weight: bold !important;
    }
    
    input, select {padding: 4px;}
    
    #dashboard {margin-top: 20px; margin-left: -15px; margin-right: -15px;}
    
    #top-reports, #charts {padding-top: 20px; float: left; padding-left: 15px; padding-right: 15px;}
    #top-reports {width: 40%;}
    #charts {width: 60%;}
    
    .table-report .table-report-head {
      background-color: #6f8992;
    }
    .table-report .table-report-head h4 {
      font-size: 12px;
      color: #ffffff;
      margin: 0;
      padding: 4px 0 4px 8px;
    }
    .table-report .table-report-body {
      background-color: #ffffff;
      border-color: #d6d6d6;
      border-style: solid;
      border-width: 0 1px 1px 1px;
      margin-bottom: 15px;
      padding-bottom: 10px;
      padding-left: 15px;
      padding-right: 15px;
      padding-top: 10px;
    }
    .table-report .table-report-body.list {
      font-size: 12px;
      padding: 0;
    }
    
    #chartContainer {width: 100%; margin: 10px 0 20px 0;}
    
    #dateControls,#compareDateControls,#conceptControls {float: left; margin-right: 5px;}
    #compareDateControls {display: none;}
    
    #overviews {margin-left: 80px; font-size: 13px;}
    #overviews .a-t-u {float: left; width: 180px; border-right-width: 1px; border-right-color: #CBCBCB; border-right-style: solid; margin-left: 20px;}
    #overviews .Mt {margin-top: 5px;}
    #overviews .GK {font-size: 22px; color: #009933;}
    #overviews .GL {font-size: 22px; color: #DD4B39;}
    #overviews .QU {color: #777777;}
    
    .grid td {
      padding: 0;
      vertical-align: top;
    }
    .grid tr.headings {
      background-attachment: scroll;
      background-clip: border-box;
      background-color: rgba(0, 0, 0, 0);
      background-image: url("images/sort_row_bg.gif");
      background-origin: padding-box;
      background-position: 0 50%;
      background-repeat: repeat-x;
      background-size: auto auto;
    }
    .grid tr.headings th {
        border-bottom-color: #f9f9f9;
        border-bottom-style: solid;
        border-bottom-width: 1px;
        border-left-color: #f9f9f9;
        border-left-style: solid;
        border-left-width: 1px;
        border-right-color: #d1cfcf;
        border-right-style: solid;
        border-right-width: 1px;
        border-top-color: #f9f9f9;
        border-top-style: solid;
        border-top-width: 1px;
        font-size: 0.9em;
        padding-bottom: 0;
        padding-top: 1px;
        color: #67767e;
        padding-bottom: 1px;
        padding-top: 2px;
    }
    .grid tr.headings th.last {
      border-right-color: -moz-use-text-color;
      border-right-style: none;
      border-right-width: 0;
    }
    .grid th {
      white-space: nowrap;
      padding-bottom: 0;
      padding-left: 0;
      padding-right: 0;
      padding-top: 0;
      text-align: left;
      vertical-align: top;
    }
    .grid th, .grid td {
        padding-bottom: 2px;
        padding-left: 4px;
        padding-right: 4px;
        padding-top: 2px;
    }
    .grid table td {
      border-bottom-color: #dadfe0;
      border-bottom-style: solid;
      border-bottom-width: 1px;
      border-left-color: #dadfe0;
      border-left-style: solid;
      border-left-width: 0;
      border-right-color: #dadfe0;
      border-right-style: solid;
      border-right-width: 1px;
      border-top-color: #dadfe0;
      border-top-style: solid;
      border-top-width: 0;
    }
    .grid table td.first, .grid table td.last {
      border-right-color: -moz-use-text-color;
      border-right-style: none;
      border-right-width: 0;
    }
    </style>
	
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/jquery.ui.datepicker-el.min.js"></script>
    <script type="text/javascript" src="js/jsfunctions.js"></script>
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>
    <script type="text/javascript" src="js/highcharts.js"></script>
    
    <script type="text/javascript">
    $(document).ajaxStop($.unblockUI);
    
    $(document).ready(function() {
      var chart;
      
      var options = {
          chart: {
            renderTo: 'chartContainer'
          },
          title: {
              text: ''
          },
          credits: {
            enabled: false
          },
          loading: {
            labelStyle: {
                color: 'white'
            },
            style: {
                backgroundColor: 'gray'
            }
          },
          xAxis: {
              type: 'datetime',
              dateTimeLabelFormats: {
                day: '%e %b'
              }
          },
          yAxis: {
              title: {},
              min: 0
          },
          tooltip: {
              //valuePrefix: '€',
              //shared: true,
               formatter: function() {
                 return this.point.name + ': <b>'+ this.y +'</b>';
               }
          },
          legend: {
              layout: 'vertical',
              align: 'center',
              verticalAlign: 'top'
          },
          plotOptions: {
            series: {
              lineWidth: 4,
              marker: {
                radius: 6,
                states: {
                    hover: {
                        radius: 10
                    }
                }
              }
            }
          }
        };
          
        function showChart() {
          var url = "/servlet/admin/OrderChart";
          
          var from = $("#from");
          var to = $("#to");
          
          var compare_from = $("#compare_from").val();
          var compare_to = $("#compare_to").val();
          
          var chartConcept = $('#chartConcept').val();
          
          var compare = "0";
          if ($("#compare").is(':checked')) compare = $("#compare").val();
          
          var dt = new Date();
          dt.setDate(dt.getDate() - 1);
          
          if (to.val() == '') {
            to.val($.datepicker.formatDate('dd/mm/yy', dt));
          }
          
          if (from.val() == '') {
            dt.setDate(dt.getDate() - 30);
            from.val($.datepicker.formatDate('dd/mm/yy', dt));
          }
          
          $.blockUI({ message: '<h3 style="font-size: 14px; padding: 20px;"><img style="vertical-align: middle;" src="images/ajax_loader.gif" /> Φόρτωση...</h3>' });
          $.ajax({
            type: "POST",
            url: url,
            data: {"action1": "chartdata", "from": from.val(), "to": to.val(), "compare": compare, "compare_from": compare_from, "compare_to": compare_to, "chartConcept": chartConcept},
            dataType: 'json',
            beforeSend: function() {
              //if (chart) chart.showLoading();
            },
            success: function(json) {
              options.series = [];
              
              $.each(json.series, function(index, serie) {
                  var obj = {
                    name: serie.name,
                    data: serie.data,
                    pointStart: serie.pointStart,
                    pointInterval: 24 * 3600 * 1000 // one day
                  };
                  
                  options.series.push(obj);
              });
              
              options.yAxis.title.text = json.yAxisTitle;
              
              $('#overviews').empty();
              $.each(json.overviews, function(index, overview) {
                var newdiv;
                var total_dif_pct_class;
                
                if (overview.total_dif_pct < 0) total_dif_pct_class = 'GL';
                else total_dif_pct_class = 'GK';
                  
                if (overview.total_dif_pct !== undefined) newdiv = $('<div class="a-t-u"><div>' + overview.title + '</div><div class="Mt"><div class="' + total_dif_pct_class + '">' + overview.total_dif_pct + '%</div><div class="QU">' + overview.total1 + ' έναντι ' +  overview.total2 + '</div></div></div>');
                else newdiv = $('<div class="a-t-u"><div>' + overview.title + '</div><div class="Mt"><div class="GK">' + overview.total1 + '</div></div></div>');
        
                $('#overviews').append(newdiv);
              });
            
              chart = new Highcharts.Chart(options);
            },
            error: function() { alert('Error!!!') },
            complete: function() {
              //chart.hideLoading();
            }
          });
        }
          
        $("#compare").on('click', function(){compareDateControls()});
        $('#chartConcept').on('change', function(){submitForm()});
        
        function compareDateControls() {
          if ($("#compare").is(':checked')) {
            $('#compareDateControls').fadeIn();
          }
          else {
            $('#compareDateControls').fadeOut();
          }
        }
        
        $('.date-pick').datepicker({
          constrainInput: true,
          showButtonPanel: true,
          maxDate: -1,
          numberOfMonths: [2,3],
          stepMonths: 6
        });
        
        $("#reportHeaderForm").on("submit", function(e){
          e.preventDefault();
          
          showChart();
        });
        
        function submitForm() {
          $("#reportHeaderForm").trigger('submit');
        }
        
        showChart();
    });
    </script>
</head>

<body <%= bodyString %>>
    <%@ include file="include/top.jsp" %>
    
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
        <%@ include file="include/left.jsp" %>
        
        <td valign="top">
          <div id="dashboard" class="group">
          
            <div id="top-reports">
              
              <div class="table-report">
                <div class="table-report-head"><h4>Συνολικός Τζίρος</h4></div>
                <div class="table-report-body a-center bold"><span style="font-size: 18px;">&euro;<%=SwissKnife.formatNumber(totalOrderValue.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%></span></div>
              </div>
              
              <div class="table-report">
                <div class="table-report-head"><h4>Μέσος Όρος Παρραγελίας</h4></div>
                <div class="table-report-body a-center bold"><span style="font-size: 18px;">&euro;<%=SwissKnife.formatNumber(avgOrderValue.setScale(curr1DisplayScale, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,minCurr1DispFractionDigits,curr1DisplayScale)%></span></div>
              </div>
              
              <div class="table-report">
                <div class="table-report-head"><h4>Σύνολο ενεργών προϊόντων</h4></div>
                <div class="table-report-body a-center bold"><span style="font-size: 18px;"><%=totalProducts%></span></div>
              </div>
              
              <div class="table-report">
                <div class="table-report-head"><h4>Bestsellers</h4></div>
                <div class="table-report-body list">
                  <div class="grid">
                  <table width="100%" cellspacing="0" style="border:0;">
                  <thead>
                    <tr class="headings">
                      <th>Προϊόν</th>
                      <th>Κωδικός</th>
                      <th class="last">Τεμάχια</th>
                    </tr>
                  </thead>
                  <tbody>
                  <%
                  helperBean.getSQL("SELECT FIRST 5 SUM(transactions.quantity) AS quan,transactions.prdId,product.name FROM transactions LEFT JOIN product ON transactions.prdId = product.prdId WHERE transactions.status NOT IN ('" + gr.softways.dev.eshop.eways.Order.STATUS_CANCELED + "') GROUP BY transactions.prdid,product.name ORDER BY quan DESC");
                  while (helperBean.inBounds() == true) {
                  %>
                    <tr>
                      <td><%=helperBean.getColumn("name")%></td>
                      <td class="a-right"><%=helperBean.getColumn("prdId")%></td>
                      <td class="a-right last"><%=SwissKnife.formatNumber(helperBean.getBig("quan").setScale(0, BigDecimal.ROUND_HALF_UP),localeLanguage,localeCountry,0,0)%></td>
                    </tr>
                  <%
                    helperBean.nextRow();
                  }
                  helperBean.closeResources();
                  %>
                  </tbody>
                  </table>
                  </div>
                </div>
              </div>
              
            </div> <!-- /top-reports -->
          
            <div id="charts">
              <div class="group">
              <form id="reportHeaderForm" role="form">
                <div id="conceptControls">
                  <select id="chartConcept" name="chartConcept" class="form-control input-sm selectpicker">
                    <option value="1">Τζίρος</option>
                    <option value="2">Παραγγελίες</option>
                  </select>
                </div>
                
                <div id="dateControls">
                  <input id="from" name="from" type="text" placeholder="Από" class="form-control input-sm date-pick">
                  <input id="to" name="to" type="text" placeholder="Εώς" class="form-control input-sm date-pick">
                    
                  <button type="submit" id="applyBtn" class="btn btn-primary">Εφαρμογή</button>
                    
                  <input id="compare" name="compare" type="checkbox" value="1"> Σύγκριση με
                </div>
                
                <div id="compareDateControls">
                  <input id="compare_from" name="compare_from" type="text" placeholder="Από" class="form-control input-sm date-pick">
                  <input id="compare_to" name="compare_to" type="text" placeholder="Εώς" class="form-control input-sm date-pick">
                </div>
              </form>
              </div>
              
              <div id="chartContainer"></div> <!-- /chartContainer -->
  
              <div id="overviews"></div> <!-- /overviews -->
            </div>
          
          </div> <!-- /dashboard -->
        </td>
        
      <%@ include file="include/right.jsp" %>
    </tr>
    </table>
    
    <%@ include file="include/bottom.jsp" %>

</body>
</html>