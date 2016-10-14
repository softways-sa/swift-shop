<%@ page pageEncoding="UTF-8" %>

<%@ page import="java.util.*,gr.softways.dev.util.*,java.math.BigDecimal,java.sql.Timestamp
                ,gr.softways.dev.eshop.eways.v5.*
                ,gr.softways.dev.eshop.eways.v2.PrdPrice,gr.softways.dev.eshop.eways.v2.TotalPrice,gr.softways.dev.eshop.eways.v2.Product
                ,gr.softways.dev.eshop.eways.v2.ProductAttribute,gr.softways.dev.eshop.product.v2.ProductOptions
                ,gr.softways.dev.eshop.orders.v2.UndoOrder
                ,gr.softways.dev.eshop.product.v2.ProductOptionsValue,gr.softways.dev.swift.cmcategory.v1.*
                ,gr.softways.dev.eshop.category.v2.PrdCategoryMenuOption2" %>

<%@ include file="/deployment/deployment.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

String whereAmI = "", HTTP_PROTOCOL = "", top_jsp_path = "",
    MEGAMENU_PRDPROMO_URL = null;

boolean DISP_EQUAL_OPTIONS_PRICE = false, USE_MEGAMENU = true;

String HOME_CMCCode = "0101", LEFT_INFO_TABLE_CMCCode = "0102", RIGHT_INFO_TABLE_CMCCode = "0103";

String[] __configurationValues = Configuration.getValues(new String[] {"useSSL","dispEqualOptPrc","maintenance","maintenancePass","maintenancePage","not_megamenu","megamenu_prdpromo_url"});

if (__configurationValues[2] != null && "1".equals(__configurationValues[2])) {
    String __maintenancePass = (String) session.getAttribute(databaseId + ".maintenancePass");

    if (__maintenancePass == null || request.getParameter("mPass") != null) {
    
        if (request.getParameter("mPass") != null) {
            __maintenancePass = request.getParameter("mPass");
        }

        if (__maintenancePass == null) __maintenancePass = "";
    }
    session.setAttribute(databaseId + ".maintenancePass", __maintenancePass);
    
    if (!__maintenancePass.equals(__configurationValues[3])) {
        if (__configurationValues[4] != null && __configurationValues[4].length()>0) response.sendRedirect(__configurationValues[4]);
        else response.sendRedirect("/index.html");
        
        return;
    }
}

if (__configurationValues[0] != null && "1".equals(__configurationValues[0])) HTTP_PROTOCOL = "https://";
else HTTP_PROTOCOL = "http://";

if (__configurationValues[1] != null && "1".equals(__configurationValues[1])) DISP_EQUAL_OPTIONS_PRICE = true;
else if (__configurationValues[1] != null && "0".equals(__configurationValues[1])) DISP_EQUAL_OPTIONS_PRICE = false;

if (__configurationValues[5] != null && "1".equals(__configurationValues[5])) USE_MEGAMENU = false;

MEGAMENU_PRDPROMO_URL = __configurationValues[6];
    
// DEFAULT username-password
String defaultAuthUsername = "anonymous", defaultAuthPassword = "softways";
String authUsername = defaultAuthUsername, authPassword = defaultAuthPassword;

int maxRecentlyViewedProducts = 7;

if (session.getAttribute(databaseId + ".authUsername") == null) {
    session.setAttribute(databaseId + ".authUsername", authUsername);
}
else {
    authUsername = session.getAttribute(databaseId + ".authUsername").toString();
}

if (session.getAttribute(databaseId + ".authPassword") == null) {
    session.setAttribute(databaseId + ".authPassword", authPassword);
}
else {
    authPassword = session.getAttribute(databaseId + ".authPassword").toString();
}

String lang = (String) session.getAttribute(databaseId + ".lang");
if (lang == null || request.getParameter("lang") != null || request.getParameter("extLang") != null) {
    
    if (request.getParameter("lang") != null) {
        lang = request.getParameter("lang");
    }
    else if (request.getParameter("extLang") != null) {
        lang = request.getParameter("extLang");
    }
    
    if (lang == null) lang = "";
}
if (!lang.equals("LG") && !lang.equals("")) lang = "";
session.setAttribute(databaseId + ".lang", lang);

String localeLanguage = "el", localeCountry = "GR";
if (lang.equals("LG")) {
    localeLanguage = "en";
    localeCountry = "UK";
}

// ------- catalog section
BigDecimal exchangeRate = new BigDecimal("1");

int curr1Scale = Integer.parseInt(gr.softways.dev.util.SwissKnife.jndiLookup("swconf/curr1Scale"));

int curr1DisplayScale = 2, curr2DisplayScale = 0;
int minCurr1DispFractionDigits = 2, minCurr2DispFractionDigits = 0;

int defaultCustomerType = gr.softways.dev.eshop.eways.Customer.CUSTOMER_TYPE_RETAIL;
int customerType = defaultCustomerType;

Customer customer = null;

Order order = null;

javax.servlet.http.Cookie[] cookies = null;

if (session.getAttribute(databaseId + ".customer") == null) {
    customer = new Customer(databaseId);
    
    customer.setAuthUsername(authUsername);
    customer.setAuthPassword(authPassword);

    customer.setCustLang(lang);
    customer.setCustomerType(customerType);
    
    session.setAttribute(databaseId + ".customer", customer);
}
else {
    customer = (Customer)session.getAttribute(databaseId + ".customer");

    if (customer.getAuthUsername() != null && customer.getAuthUsername().trim().length()>0) {
        authUsername = customer.getAuthUsername();
    }
    else customer.setAuthUsername(authUsername);

    if (customer.getAuthPassword() != null && customer.getAuthPassword().trim().length()>0) {
        authPassword = customer.getAuthPassword();
    }
    else customer.setAuthPassword(authPassword);

    customerType = customer.getCustomerType();
    if (customerType < 0) {
        customerType = defaultCustomerType;
        customer.setCustomerType(customerType);
    }

    customer.setCustLang(lang);

    session.setAttribute(databaseId + ".authUsername", authUsername);
    session.setAttribute(databaseId + ".authPassword", authPassword);
}

customer.setLocaleLanguage(localeLanguage);
customer.setLocaleCountry(localeCountry);
customer.setCurr1DisplayScale(curr1DisplayScale);
customer.setMinCurr1DispFractionDigits(minCurr1DispFractionDigits);

order = customer.getOrder();
    
if (customer.getOccupation() == null || customer.getOccupation().length() == 0) {
    String refCookieValue = request.getHeader("referer");
    if (refCookieValue == null || refCookieValue.length() == 0) {
        refCookieValue = "NO REFERER";
    }
    else refCookieValue = refCookieValue.replaceAll("[,]","%2C").replaceAll("[;]","%3B");
    
    if (refCookieValue.length()>100) refCookieValue = refCookieValue.substring(0,100);
    
    cookies = request.getCookies();
    if (cookies != null) {
        int cookiesLength = cookies.length;
        
        for (int i=0; i<cookiesLength; i++) {
            if (cookies[i].getName().equals("ref")) {
                customer.setOccupation(cookies[i].getValue());
                break;
            }
        }
    }
    
    if (customer.getOccupation() == null || customer.getOccupation().length() == 0) {
        try {
            javax.servlet.http.Cookie refCookie = new javax.servlet.http.Cookie("ref", refCookieValue);
            refCookie.setPath("/");
            refCookie.setMaxAge(30 * 24 * 60 * 60);
            response.addCookie(refCookie);
        }
        catch (Exception e) { }
        
        customer.setOccupation(refCookieValue);
    }
}

String CMCCode = request.getParameter("CMCCode"),
       CMRCode = request.getParameter("CMRCode");

if (CMCCode == null) CMCCode = "";
if (CMRCode == null) CMRCode = "";

if (CMCCode.equals("") && CMRCode.equals("")) {
    CMCCode = HOME_CMCCode;
}
request.setAttribute("CMCCode",CMCCode);

RecentlyViewedProducts recentlyViewedProducts = null;

if (session.getAttribute(databaseId + ".recentlyViewedProducts") == null) {
    recentlyViewedProducts = new RecentlyViewedProducts(maxRecentlyViewedProducts);
    
    session.setAttribute(databaseId + ".recentlyViewedProducts", recentlyViewedProducts);
}
else {
    recentlyViewedProducts = (RecentlyViewedProducts)session.getAttribute(databaseId + ".recentlyViewedProducts");
}
%>