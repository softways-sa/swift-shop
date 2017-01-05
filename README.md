#### Dev environment setup with docker
```
docker run -d -h fbsrv -p 3050:3050 -v C:/temp/databases:/databases --name=fbsrv jacobalberty/firebird:2.5-sc
docker run -d --add-host="fbsrv:replace-fbsrv-container-host" -p 80:8080 -v $pwd/target/swift-shop-version-number:/usr/local/tomcat/webapps/ROOT --name=tomcat-sw tomcat:7.0-jre7
```
#### TODO:
* Add smtp server to dev environment