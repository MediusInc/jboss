FROM store/oracle/serverjre:8
MAINTAINER Ziga Ciglar <ziga.ciglar@medius.si>

ENV JBOSS_SHA1 4e5ce67ba33c4910a69e8a5e4a7348129682b88b
ENV JBOSS_HOME /opt/jboss/jboss

RUN yum update -y && yum install procps -y && yum clean all

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

USER root

RUN cd $HOME \
    && curl -O https://www.medius.si/assets/Uploads/jboss-eap-6.2.0.zip \
    && sha1sum jboss-eap-6.2.0.zip | grep $JBOSS_SHA1 \
    && jar xf jboss-eap-6.2.0.zip \
	&& mkdir -p ${JBOSS_HOME} \
    && mv $HOME/jboss-eap-6.2/* $JBOSS_HOME \
    && rm jboss-eap-6.2.0.zip \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod u+x ${JBOSS_HOME}/bin/standalone.sh \
    && chmod -R g+rw ${JBOSS_HOME}
    
WORKDIR ${JBOSS_HOME}/bin

USER jboss

EXPOSE 8080

ENTRYPOINT ["./standalone.sh", "-b", "0.0.0.0"]
