FROM castlemock/castlemock:v1.58

RUN unzip /usr/local/tomcat/webapps/castlemock.war -d /usr/local/tomcat/webapps/castlemock && \
    rm /usr/local/tomcat/webapps/castlemock.war && \
    rm -rf /usr/local/tomcat/webapps.dist    

USER nobody

EXPOSE 8080
