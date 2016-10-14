<%@ page pageEncoding="UTF-8" %>

<%
String databaseId = "swift-shop-v3";

String wwwrootFilePath = "/usr/local/www/vhosts/swift-shop-v3";

String appDir = "";

String userImagesWebPath = "/images",
       userImagesFilePath = wwwrootFilePath + userImagesWebPath,
       
       gImagesWebPath = "/gimages",
       gImagesFilePath = wwwrootFilePath + gImagesWebPath,
       
       userFilesWebPath = "/misc",
       userFilesFilePath = wwwrootFilePath + userFilesWebPath,
       
       newsletterFilesWebPath = "/newsletter",
       newsletterFilesFilePath = wwwrootFilePath + newsletterFilesWebPath,
       
       productImagesWebPath = "/prd_images",
       productImagesFilePath = wwwrootFilePath + productImagesWebPath,
       
       partnersWebPath = "/dn",
       partnersFilePath = wwwrootFilePath + partnersWebPath;

/** directory for import-export templates */
String TEMPLATE_DIR_IN_WEB_PATH = "/admin/template_data/in/",
       TEMPLATE_DIR_IN = wwwrootFilePath + TEMPLATE_DIR_IN_WEB_PATH;
       
String TEMPLATE_DIR_OUT = wwwrootFilePath + "/admin/template_data/out/";
%>
