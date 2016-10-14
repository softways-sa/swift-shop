function isEmpty(s) {
    var tmp = "";

    for (i=0; i<s.length; i++) {
        if (s.charAt(i) != ' ') tmp += s.charAt(i);
    }

    if (tmp == "") return true;
    else return false;
}

function emailCheck (emailStr) {
    /* The following variable tells the rest of the function whether or not
    to verify that the address ends in a two-letter country or well-known
    TLD.  1 means check it, 0 means don't. */
    var checkTLD=0;
    
    var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;
    var emailPat=/^(.+)@(.+)$/;
    var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]";
    var validChars="\[^\\s" + specialChars + "\]";
    var quotedUser="(\"[^\"]*\")";
    var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
    var atom=validChars + '+';
    var word="(" + atom + "|" + quotedUser + ")";
    var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
    var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");
    var matchArray=emailStr.match(emailPat);

    if (matchArray==null) {
        return false;
    }
    var user=matchArray[1];
    var domain=matchArray[2];
    for (i=0; i<user.length; i++) {
        if (user.charCodeAt(i)>127) {
            return false;
        }
    }
    for (i=0; i<domain.length; i++) {
        if (domain.charCodeAt(i)>127) {
            return false;
       }
    }
    if (user.match(userPat)==null) {
        return false;
    }
    var IPArray=domain.match(ipDomainPat);
    if (IPArray!=null) {
        for (var i=1;i<=4;i++) {
            if (IPArray[i]>255) {
                return false;
            }
        }
        return true;
    }
    var atomPat=new RegExp("^" + atom + "$");
    var domArr=domain.split(".");
    var len=domArr.length;
    for (i=0;i<len;i++) {
        if (domArr[i].search(atomPat)==-1) {
        return false;
       }
    }
    if (checkTLD && domArr[domArr.length-1].length!=2 && 
        domArr[domArr.length-1].search(knownDomsPat)==-1) {
        return false;
    }
    if (len<2) {
        return false;
    }
    return true;
}
