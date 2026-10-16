FROM tomcat:10.1-jdk21-temurin

COPY SmartFix.war /usr/local/tomcat/webapps/ROOT.war
COPY startup.sh /usr/local/tomcat/bin/smartfix-startup.sh

RUN sed -i 's/\r$//' /usr/local/tomcat/bin/smartfix-startup.sh \
    && chmod +x /usr/local/tomcat/bin/smartfix-startup.sh

EXPOSE 10000

ENTRYPOINT ["/bin/sh", "/usr/local/tomcat/bin/smartfix-startup.sh"]