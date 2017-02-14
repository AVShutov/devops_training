FROM tomcat:8.5

ARG NEXUS=http://172.17.0.1:8081/nexus/content/repositories/training/task4/
ARG WEBAPPS=/usr/local/tomcat/webapps
ARG VERSION=1.0.0
RUN wget -P ${WEBAPPS} ${NEXUS}${VERSION}/task4.war