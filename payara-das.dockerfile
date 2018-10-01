FROM payara/server-full

MAINTAINER TRENDev trendevfr@gmail.com

ENV AS_ADMIN $PAYARA_PATH/bin/asadmin
ENV DOMAIN domain1
ENV ADMIN_USER admin
ENV ADMIN_PASSWORD admin
ENV NEW_ADMIN_PASSWORD payara
ENV WEBAPP comptandye

COPY ./id_rsa_vpn.key /root/

# Reset the admin password
RUN echo 'AS_ADMIN_PASSWORD='$ADMIN_PASSWORD'\n\
AS_ADMIN_NEWPASSWORD='$NEW_ADMIN_PASSWORD'\n\
EOF\n'\
> /opt/tmpfile

RUN echo 'AS_ADMIN_PASSWORD='$NEW_ADMIN_PASSWORD'\n\
EOF\n'\
> /opt/pwdfile

# Setup the password, javamail, jdbc and the security realm
# DB Server is db-mysql and not localhost (which is the url with a standalone docker mysql) !!!
RUN $AS_ADMIN start-domain $DOMAIN && \
$AS_ADMIN --user $ADMIN_USER --passwordfile=/opt/tmpfile change-admin-password && \
$AS_ADMIN --user $ADMIN_USER --passwordfile=/opt/pwdfile enable-secure-admin && \
$AS_ADMIN restart-domain $DOMAIN && \
$AS_ADMIN set configs.config.server-config.admin-service.das-config.dynamic-reload-enabled=false --passwordfile=/opt/pwdfile && \
# Disable Autodeploy
$AS_ADMIN set configs.config.server-config.admin-service.das-config.autodeploy-enabled=false --passwordfile=/opt/pwdfile && \
$AS_ADMIN delete-jvm-options --passwordfile=/opt/pwdfile -client:-Xmx512m: && \
$AS_ADMIN create-jvm-options --passwordfile=/opt/pwdfile -server:-Xmx2048m:-Xms2048m:-Dfish.payara.classloading.delegate=false:-DjvmRoute=\$\{com.sun.aas.instanceName\}  && \
$AS_ADMIN set-hazelcast-configuration --passwordfile=/opt/pwdfile --enabled=true --dynamic=true && \
$AS_ADMIN copy-config --passwordfile=/opt/pwdfile server-config dg-config && \
# Payara 5 only
$AS_ADMIN create-deployment-group --passwordfile=/opt/pwdfile dg-$WEBAPP && \
# Payara 4 - deprecated on Payara 5
# $AS_ADMIN create-cluster --passwordfile=/opt/pwdfile cl-$WEBAPP && \
$AS_ADMIN restart-domain $DOMAIN

#EXPOSE 7000-8000
EXPOSE 1-65000/udp 1-65000/tcp

# Start the server in verbose mode
ENTRYPOINT $AS_ADMIN start-domain -v $DOMAIN
