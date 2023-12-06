FROM tomcat:8.5.96-jdk11-temurin as build

ENV CASTLEMOCK_VERSION=1.63

WORKDIR /tmp

RUN apt update && \
    apt install maven git zip -y

RUN git clone https://github.com/castlemock/castlemock.git && \
    cd castlemock && \
    git checkout tags/v$CASTLEMOCK_VERSION && \
    UserFileRepository=repository/repository-core/repository-core-file/src/main/java/com/castlemock/repository/core/file/user/UserFileRepository.java && \
    sed -i '/setUsername("admin")/i String username = System.getenv("CM_FILE_ADMIN_USERNAME");if (username == null || username.length() == 0) username = "admin";' $UserFileRepository && \
    sed -i 's/setUsername("admin")/setUsername(username)/' $UserFileRepository && \
    sed -i '/encode("admin")/i String pass = System.getenv("CM_FILE_ADMIN_PASSWORD");if (pass == null || pass.length() == 0) pass += System.currentTimeMillis();' $UserFileRepository && \
    sed -i 's/encode("admin")/encode(pass)/' $UserFileRepository && \
    mvn package

RUN mkdir -p /tmp/webapps/castlemock && \
    unzip /tmp/castlemock/deploy/deploy-tomcat/deploy-tomcat-war/target/castlemock.war -d /tmp/webapps/castlemock

# MOSTLY replicated from https://github.com/castlemock/docker/blob/master/Dockerfile
FROM tomcat:8.5.96-jdk11-temurin

COPY --from=build /tmp/webapps/castlemock /usr/local/tomcat/webapps/castlemock

# Delete the default applications
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/manager \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps.dist

USER nobody

# Expose HTTP port 8080
EXPOSE 8080