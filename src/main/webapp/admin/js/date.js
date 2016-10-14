var dayName = new Array ("Κυριακή","Δευτέρα", "Τρίτη", "Tετάρτη", "Πέμπτη", "Παρασκευή", "Σάββατο");
var monthName = new Array ("Ιανουάριος", "Φεβρουάριος", "Μάρτιος", "Απρίλιος", "Μάιος", "Ιούνιος", "Ιούλιος", "Αύγουστος", "Σεπτέμβριος", "Οκτώβριος", "Νοέμβριος", "Δεκέμβριος" );
var cntDays = new Array (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
var downYear = 2000;
var upYear = 2020;

function CalcFirstOfMonth(yr, mn, dInM) {
  var firstDay; 
  var i;   
  if (yr < 1582) return (-1);
  if ((mn < 0) || (mn > 11)) return (-1);
  firstDay = CalcJanuaryFirst(yr);
  for (i = 0; i < mn; i++)
    firstDay += dInM[i];
  if ((mn > 1) && IsLeapYear(yr)) firstDay++;
//  return (Math.floor((firstDay % 7)));
  return ((firstDay % 7));
}

function IsLeapYear(yr) {
  if ((yr % 100) == 0 && (yr % 400) == 0) return 1;
  else if ((yr % 4) == 0) return 1;  
  else return 0;
}

function CalcJanuaryFirst(yr) {
  if (yr < 1582) return (-1);
  return (Math.floor(((5 + (yr - 1582) + CalcLeapYears(yr)) % 7)));
}

function CalcLeapYears(yr) {
   var leapYears;
   var hundreds;
   var fourHundreds;
   if (yr < 1582) return (-1);
   leapYears = ((yr - 1581) / 4);
   hundreds = Math.floor(((yr - 1501) / 100));
   leapYears -= hundreds;
   fourHundreds = Math.floor(((yr - 1201) / 400));
   leapYears += fourHundreds;
   return (leapYears);
}

function getDayName(ds, ms, ys) {
  var d = parseInt(ds);
  var m = parseInt(ms);
  var y = parseInt(ys);    
  var dayFirst = Math.floor(CalcFirstOfMonth(y, (m-1), cntDays));
  var weekDay = Math.floor(((dayFirst + d -1) % 7));  
  if (weekDay >= 0 && weekDay < 7) {
    return dayName[weekDay];
  }  
  else
    return "overflow";
}


function show_calendar(ow, myWindow, myday, mymonth, myyear, mylang, customFunc) {
  var daynameEN = new Array ("Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");  
  var dayname = new Array ("Κυριακή","Δευτέρα", "Τρίτη", "Tετάρτη", "Πέμπτη", "Παρασκευή", "Σάββατο");
  var monthnameEN = new Array ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" );
  var monthname = new Array ("Ιανουάριος", "Φεβρουάριος", "Μάρτιος", "Απρίλιος", "Μάιος", "Ιούνιος", "Ιούλιος", "Αύγουστος", "Σεπτέμβριος", "Οκτώβριος", "Νοέμβριος", "Δεκέμβριος" );
  var dayOfWeek = 0;
  var rowsNeeded = 0;
  var cnt = 0;
  var ii = 0;
  var firstDay = 0;
  var cntDays = new Array (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
  calendar = new Date();
  date = parseInt(myday);
  month = parseInt(mymonth) - 1;
  year = parseInt(myyear);
  if (parseInt(navigator.appVersion.substring(0,1)) < 4)  return;
  var ns = navigator.appName == "Netscape";
  if (myday== '' || date < 1 || date > 31)   date = calendar.getDate();
  if (mymonth == '' || month < 0 || month > 11)   month = calendar.getMonth();  
  if (myyear == '' || year < 1582 || year > 3000)  {
    year = calendar.getYear();    
    if (ns == 1) {	
      year += 1900;
	}
  }
  if (ns == 1) {
    mylang = 1;
  }
  cent = parseInt(year/100);
  g = year % 19;
  k = parseInt((cent - 17)/25);
  i = (cent - parseInt(cent/4) - parseInt((cent - k)/3) + 19*g + 15) % 30;
  i = i - parseInt(i/28)*(1 - parseInt(i/28)*parseInt(29/(i+1))*parseInt((21-g)/11));
  j = (year + parseInt(year/4) + i + 2 - cent + parseInt(cent/4)) % 7;
  l = i - j;
  emonth = 3 + parseInt((l + 40)/44);
  edate = l + 28 - 31*parseInt((emonth/4));
  emonth--;
 
  firstDay = Math.floor(CalcFirstOfMonth(year, month, cntDays));
  dayOfWeek = Math.floor(((firstDay + date -1) % 7));
  if (IsLeapYear(year) == 1) cntDays[1] = 29;  
  if (ow == 1)
    newWindow = window.open("",'','left=0,top=0,width=400,height=300');
  else if (ow == 0) {
    newWindow = myWindow;
    newWindow.document.close();	
    newWindow.document.clear();
    newWindow.document.open("text/html");	
  }
  newWindow.document.writeln("<HTML><HEAD>");
  newWindow.document.writeln("<meta http-equiv=\"Content-Type\" content=\"text\/html; charset=iso-8859-7\">");  
  if (mylang == 0)  
    newWindow.document.writeln("<TITLE> ΗΜΕΡΟΛΟΓΙΟ</title>");  
  else if (mylang == 1)
  newWindow.document.writeln("<TITLE> CALENDAR </title>");
  newWindow.document.writeln("<STYLE TYPE=\"text/css\">");
  newWindow.document.writeln(".content { text-decoration : none; color : #000000; font-family : arial,verdana,helvetica; font-size : 8pt; font-weight : normal; } ");
  newWindow.document.writeln("a.content:hover, a.content:active { color : #000000;  text-decoration : underline; } ");
  newWindow.document.writeln(".boldnav { text-decoration : none; color : #FFFFFF;  font-family : arial,verdana,helvetica;  font-size : 8pt; font-weight : bold; } ");
  newWindow.document.writeln("a.boldnav:hover, a.boldnav:active { color : #FFFFFF; text-decoration : underline; } ");
  newWindow.document.writeln(".contentbig { text-decoration : none;  color : #000000; font-family : verdana,arial,helvetica; font-size : 9pt; font-weight : bold; } ");
  newWindow.document.writeln("#lightblue {color : #0068cc;} ");
  newWindow.document.writeln("#black {color : #000000;} ");
  newWindow.document.writeln("#blue {color : #000066;} ");
  newWindow.document.writeln("#orange {color : #ffcc00;} ");
  newWindow.document.writeln("#white {color : #ffffff;} ");
  newWindow.document.writeln("</STYLE>");
  newWindow.document.writeln("<SCRIPT LANGUAGE=Javascript>");
  newWindow.document.writeln("var downYear = " + downYear);
  newWindow.document.writeln("var upYear = " + upYear);
  newWindow.document.writeln("function setMyDate(d,m,y) {");
  newWindow.document.writeln("window.close()");  
  newWindow.document.writeln("window.opener." + customFunc + "(d,m,y);");  
  newWindow.document.writeln("}");
  newWindow.document.writeln("function moveTo(moveOne) {");  
  newWindow.document.writeln("var mm1 = parseInt(document.form1.month1.options[document.form1.month1.selectedIndex].value);");    
  newWindow.document.writeln("var yy1 = parseInt(document.form1.year1.options[document.form1.year1.selectedIndex].value);");      
  newWindow.document.writeln("if (moveOne == 1 && mm1 > 1) document.form1.month1.options[document.form1.month1.selectedIndex].value = (mm1 - 1);");  
  newWindow.document.writeln("else if (moveOne == 2 && mm1 < 12) document.form1.month1.options[document.form1.month1.selectedIndex].value = (mm1 + 1);");    
  newWindow.document.writeln("else if (moveOne == 1 && mm1 == 1 && yy1 > downYear) {document.form1.month1.options[document.form1.month1.selectedIndex].value = 12;document.form1.year1.options[document.form1.year1.selectedIndex].value = (yy1 - 1);}" );      
  newWindow.document.writeln("else if (moveOne == 2 && mm1 == 12 && yy1 < upYear) {document.form1.month1.options[document.form1.month1.selectedIndex].value = 1;document.form1.year1.options[document.form1.year1.selectedIndex].value = (yy1 + 1);}" );        
  newWindow.document.writeln("else if (moveOne == 3 && yy1 > downYear) document.form1.year1.options[document.form1.year1.selectedIndex].value = (yy1 - 1);");      
  newWindow.document.writeln("else if (moveOne == 4 && yy1 < upYear) document.form1.year1.options[document.form1.year1.selectedIndex].value = (yy1 + 1);");        
  newWindow.document.writeln("window.opener.show_calendar(0, window.self, document.form1.day1.value, document.form1.month1.options[document.form1.month1.selectedIndex].value, document.form1.year1.options[document.form1.year1.selectedIndex].value, document.form1.mylang1.value,'" + customFunc + "');");  
  newWindow.document.writeln("}");  
  newWindow.document.writeln("<\/SCRIPT>"); 
  newWindow.document.writeln("<\/HEAD><body><form name=\"form1\">");  
  newWindow.document.writeln("<input type=\"hidden\" name=\"day1\" value=\"" + date + "\">");  
  newWindow.document.writeln("<a href=\"#\" name=\"backMonth\" onclick=\"moveTo(1)\"><img src=\"js\/images\/previous.gif\" width=20 height=19 border=0 alt=\"Προηγούμενος μήνας\"></a>");  
  if (mylang == 0) {
    newWindow.document.writeln("<SELECT name=\"month1\" size=\"1\" language=\"JavaScript\" style=\"font-family: Arial; font-size: 8pt\" onchange=\"window.opener.show_calendar(0, window.self, document.form1.day1.value, document.form1.month1.options[document.form1.month1.selectedIndex].value, document.form1.year1.options[document.form1.year1.selectedIndex].value, document.form1.mylang1.value,'" + customFunc + "');\">");
	  newWindow.document.writeln("<OPTION SELECTED value=\"" + (month+1) + "\">" + monthname[month] + "</OPTION>");
	  for (ii = 0; ii < 12; ii++) 
	    newWindow.document.writeln("<OPTION VALUE=\"" + (ii+1) + "\" >" + monthname[ii]);
    newWindow.document.writeln("</SELECT>");      
  }
  else if (mylang == 1) {
    newWindow.document.writeln("<SELECT name=\"month1\" size=\"1\" language=\"JavaScript\" style=\"font-family: Arial; font-size: 8pt\" onchange=\"window.opener.show_calendar(0, window.self, document.form1.day1.value, document.form1.month1.options[document.form1.month1.selectedIndex].value, document.form1.year1.options[document.form1.year1.selectedIndex].value, document.form1.mylang1.value,'" + customFunc + "');\">");
	  newWindow.document.writeln("<OPTION SELECTED value=\"" + (month+1) + "\">" + monthnameEN[month] + "</OPTION>");
	  for (ii = 0; ii < 12; ii++) 
	    newWindow.document.writeln("<OPTION VALUE=\"" + (ii+1) + "\" >" + monthnameEN[ii]);
    newWindow.document.writeln("</SELECT>");    
  }
  newWindow.document.writeln("<a href=\"#\" class=content id=black name=\"nextMonth\" onclick=\"moveTo(2)\"><img src=\"js\/images\/next.gif\" width=20 height=19 border=0 alt=\"Επόμενος μήνας\"></a>");    
  newWindow.document.writeln("<a href=\"#\" class=content id=black name=\"backYear\"onclick=\"moveTo(3)\"><img src=\"js\/images\/previous.gif\" width=20 height=19 border=0 alt=\"Προηγούμενος χρόνος\"></a>");
  newWindow.document.writeln("<SELECT name=\"year1\" size=\"1\" language=\"JavaScript\" style=\"font-family: Arial; font-size: 8pt\" onchange=\"window.opener.show_calendar(0, window.self, document.form1.day1.value, document.form1.month1.options[document.form1.month1.selectedIndex].value, document.form1.year1.options[document.form1.year1.selectedIndex].value, document.form1.mylang1.value,'" + customFunc + "');\">");
	newWindow.document.writeln("<OPTION SELECTED value=\"" + year + "\">" + year + "</OPTION>");
	for (ii = downYear; ii < (upYear + 1); ii++) 
	  newWindow.document.writeln("<OPTION VALUE=\"" + ii + "\" >" + ii);
  newWindow.document.writeln("</SELECT>");
  newWindow.document.writeln("<a href=\"#\" class=content id=black name=\"nextYear\" onclick=\"moveTo(2)\"><img src=\"js\/images\/next.gif\" width=20 height=19 border=0 alt=\"Επόμενος χρόνος\"></a><br><br>");
  newWindow.document.writeln("<input type=\"hidden\" style=\"font-family: Arial; font-size: 7pt\" name=\"mylang1\" value=\"" + mylang + "\">");    
  
  newWindow.document.writeln("<span class=contentbig id=blue>");
  if (mylang == 0) {  
    newWindow.document.writeln(dayname[dayOfWeek] + ", ");
    newWindow.document.writeln(monthname[month] + " ");
  }
  else if (mylang == 1) {
    newWindow.document.writeln(daynameEN[dayOfWeek] + ", ");
    newWindow.document.writeln(monthnameEN[month] + " ");  
  }
  if (date< 10) newWindow.document.write("0" + date + ", ");
  else newWindow.document.write(date + ", ");
  newWindow.document.write(year + "</span><BR><BR>");
  newWindow.document.write("<table width='100%' cellspacing='1' cellpadding='2' border='0' bgcolor=#000000>");  
  newWindow.document.write("<tr class=boldnav id=lightblue>");
  for (ii = 0; ii < 7; ii++) {
    if (mylang == 0) 
      newWindow.document.write("<td bgcolor=#0068cc class=boldnav id=white align=center>" + dayname[ii] + "</td>");
	else if (mylang == 1)
      newWindow.document.write("<td bgcolor=#0068cc class=boldnav id=white align=center>" + daynameEN[ii] + "</td>");
  }
  newWindow.document.write("</tr>");  
  newWindow.document.write("<tr bgcolor='#e9e9e9'>");  
  for (ii=0;cnt < firstDay; cnt++,ii++) {  
    newWindow.document.write("<td>&nbsp;</td>");	  
  }
  for (cnt=0;cnt < cntDays[month]; cnt++, ii++) {
	if (cnt > 0 && ii % 7 == 0) {
	  newWindow.document.write("</tr>");
      newWindow.document.write("<tr bgcolor='#e9e9e9'>");	  
    }
    newWindow.document.write("<td align=center><a href='#' class=boldnav id=black onClick='setMyDate(" + (cnt+1) + ", " + (month+1) + ", " + year + ")'>" + (cnt+1) + "</a></td>");	
  }
  for (; ii % 7 != 0; ii++)
    newWindow.document.write("<td>&nbsp;</td>");
  newWindow.document.write("</tr></table>");    

  newWindow.document.write("<br>"); 
  newWindow.document.write("<\/form><\/body><\/html>");    
}
var checkedOK = 1;
var checkBlur = 1;
var GCtrl = null;
   
function valInt(frm, fn, req, dn, up) {
   
   Ctrl = eval('document.'+frm+'.'+fn);
   if (checkedOK == 0 && GCtrl != null && GCtrl != Ctrl)
     checkBlur = 1;
   else
     checkBlur = 1;

   if (checkBlur == 1) {
     GCtrl = Ctrl;
     for(i=0; i<Ctrl.value.length; i++) {
           ch = Ctrl.value.charAt(i);
           if ((ch < '0' || ch > '9') && (ch != '-') && (ch != ' ')) {
              validatePrompt(Ctrl,"Το πεδίο είναι αριθμητικό");
              checkedOK = 0;
              return(false);
              }
           }
     myday = parseInt(Ctrl.value, 10);
     if(Ctrl.value.length < 1 && req == 1){
           validatePrompt(Ctrl,"To πεδίο δεν μπορεί να αφεθεί κενό");
           checkedOK = 0;
           return(false);
           }
     else if (myday < dn || myday > up) {
           validatePrompt(Ctrl,"Δεν υπάρχει τέτοια ημερομηνία");
           checkedOK = 0;
           return(false);
           }
     else  {
           checkedOK = 1;
           return(true);
           }
     }
    else return(true);
}


function validatePrompt(Ctrl,PromptStr){
        alert(PromptStr);
        Ctrl.focus();
        return;
}
