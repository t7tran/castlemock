FROM castlemock/castlemock
RUN unzip /usr/local/tomcat/webapps/castlemock.war -d /usr/local/tomcat/webapps/castlemock
EXPOSE 8080
