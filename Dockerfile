FROM tomcat:8.0
ARG NEXUS=http://192.168.20.13:8081/nexus/content/repositories/training/task4/
ARG WEBAPPS=/usr/local/tomcat/webapps
ARG VERSION=1.0.0
RUN wget -P ${WEBAPPS} ${NEXUS}${VERSION}/task4.war