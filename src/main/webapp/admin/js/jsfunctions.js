function isInteger(s) {
    for (i=0; i<s.length; i++) {
        ch = s.charAt(i);
        if ((ch < '0' || ch > '9') && (ch != '-') && (ch != ' ')) {
            return false;
        }
    }
    return true;
}

function isDecimal(s) {
    for (i=0; i<s.length; i++) {
        ch = s.charAt(i);
        if ((ch < '0' || ch > '9') && (ch != '.') && (ch != ',') 
                && (ch != '-') && (ch != ' ')) {
            return false;
        }
    }
    return true;
}

function hasFractionDigits(num, fractionDigits, localeCountry) {
    if (localeCountry == "GR") fractionSymbol=',';

    fractionPlace = num.indexOf(fractionSymbol);

    if (fractionPlace == -1) return false;

    if (fractionPlace == num.length) return false;

    var fr = num.substring(fractionPlace+1, num.length);

    if (fr.length != fractionDigits) return false;

    return true;
}

function isEmpty(s) {
    var tmp = "";

    for (i=0; i<s.length; i++) {
        if (s.charAt(i) != ' ') tmp += s.charAt(i);
    }

    if (tmp == "") return true;
    else return false;
}

function checkButton(buttonPressed) {
  if (buttonPressed.value == '0') {
    buttonPressed.value = '1';
	return true;
  }
  else return false;
}

function scale(number, sc) {
  // scale number to sc decimal places, defaults to 2
  sc = (!sc ? 2 : sc);
  return Math.round(number*Math.pow(10,sc))/Math.pow(10,sc);
}

function gotoLabel(labelName) {
      if (labelName != "") {
              document.location.hash = labelName;
      }
}

function isValidCodeChars(str) {
    var re=/^[-a-z0-9._]+$/i;
    return re.test(str);
}