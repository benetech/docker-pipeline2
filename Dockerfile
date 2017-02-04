FROM java:8-jre

MAINTAINER Ron Ellis <rone@benetech.org>

ENV BASEDIR /usr/local
ENV PIPELINE2_HOME $BASEDIR/daisy-pipeline
ENV PIPELINE2_SYS_PROPS $PIPELINE2_HOME/etc/system.properties
ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false
ENV PIPELINE2_DOWNLOAD_URL https://github.com/daisy/pipeline-assembly/releases/download/v1.10.0/pipeline2-1.10.0_linux.zip
ENV BUILDTIME_DEPS unzip vim psmisc netcat net-tools

WORKDIR $BASEDIR 

RUN apt-get update && \
    apt-get install --yes $BUILDTIME_DEPS 

# Install and configure DAISY Pipeline 2
RUN wget $PIPELINE2_DOWNLOAD_URL -O pipeline2.zip && \
    unzip pipeline2.zip && \
    groupadd -g 11000 -r pipeline2 && \
    useradd -g pipeline2 -u 11000 -m pipeline2 && \ 
    mkdir $PIPELINE2_HOME/data && \
    chown -R root.root $PIPELINE2_HOME && \
    chmod -R 755 $PIPELINE2_HOME && \
    chown -R pipeline2.pipeline2 $PIPELINE2_HOME/data && \
    chmod -x $PIPELINE2_HOME/*.txt $PIPELINE2_HOME/etc/* && \
    find $PIPELINE2_HOME -type f -name '*.jar' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.dat' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.properties' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.js' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.css' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.conf' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.gif' -exec chmod -x {} \; && \
    find $PIPELINE2_HOME -type f -name '*.html' -exec chmod -x {} \;

# remove build time deps
RUN rm pipeline2.zip  && \
    apt-get remove --purge --yes $BUILDTIME_DEPS && \
    apt-get install --yes net-tools

# configures bind host, port etc.
COPY system.properties /usr/local/daisy-pipeline/etc/system.properties
# configures default (and other) log levels
COPY config-logback.xml /usr/local/daisy-pipeline/etc/config-logback.xml

USER pipeline2

CMD ["/bin/sh", "-c", "$PIPELINE2_HOME/bin/pipeline2", "remote"]
