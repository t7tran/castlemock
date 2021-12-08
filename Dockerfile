FROM castlemock/castlemock
RUN unzip /usr/local/tomcat/webapps/castlemock.war -d /usr/local/tomcat/webapps/castlemock && \
    rm /usr/local/tomcat/webapps/castlemock.war && \
    rm -rf /usr/local/tomcat/webapps.dist    

EXPOSE 8080
