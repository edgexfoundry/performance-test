FROM openjdk:8u191-jdk-alpine3.9
LABEL maintainer=""
STOPSIGNAL SIGKILL
ENV JMETER_VERSION 5.1
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
ENV PATH ${JMETER_BIN}:$PATH
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh \
 && apk add --no-cache \
    curl \
    net-tools \
    shadow \
    tcpdump  \
 && cd /tmp/ \
 && curl --location --silent --show-error --output apache-jmeter-${JMETER_VERSION}.tgz https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
 && mkdir -p /opt/ \
 && tar x -z -f apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
 && rm -R -f apache* \
 && chmod +x ${JMETER_HOME}/bin/*.sh \
 && jmeter --version \
 && rm -fr /tmp/*
WORKDIR /jmeter
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
