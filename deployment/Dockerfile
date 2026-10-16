
FROM tomcat:10.1-jdk21-temurin

# Deploy SmartFix as the ROOT application
COPY SmartFix.war /usr/local/tomcat/webapps/ROOT.war

# Install the startup script
COPY startup.sh /usr/local/tomcat/bin/smartfix-startup.sh

RUN sed -i 's/\r$//' /usr/local/tomcat/bin/smartfix-startup.sh \
    && chmod +x /usr/local/tomcat/bin/smartfix-startup.sh

# Tomcat's default HTTP connector port
EXPOSE 8080

ENTRYPOINT ["/bin/sh", "/usr/local/tomcat/bin/smartfix-startup.sh"]
