FROM tomcat:8.0

ARG WEBAPPS=/usr/local/tomcat/webapps
ARG VERSION
RUN wget -P ${WEBAPPS} http://192.168.20.13:8081/nexus/content/repositories/training/task4/${VERSION}/task4.war