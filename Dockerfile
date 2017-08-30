FROM java:8-jre

MAINTAINER Ron Ellis <rone@benetech.org>

ENV BASEDIR /usr/local
ENV PIPELINE2_BASEDIR $BASEDIR/daisy-pipeline
ENV PIPELINE2_DATA $PIPELINE2_BASEDIR/data
ENV PIPELINE2_DOWNLOAD_URL https://github.com/daisy/pipeline-assembly/releases/download/v1.10.2/pipeline2-1.10.2_linux.zip 
ENV BUILDTIME_DEPS unzip
ENV TMPDIR /tmp

WORKDIR $BASEDIR 

# install build time deps
RUN apt-get update && \
    apt-get install --yes $BUILDTIME_DEPS 

# Install and configure DAISY Pipeline 2
RUN wget $PIPELINE2_DOWNLOAD_URL -O pipeline2.zip && \
    unzip pipeline2.zip && \
    mkdir $PIPELINE2_BASEDIR/data && \
    chown -R root.root $PIPELINE2_BASEDIR && \
    chmod -R 755 $PIPELINE2_BASEDIR && \
    chmod -x $PIPELINE2_BASEDIR/*.txt $PIPELINE2_BASEDIR/etc/* && \
    find $PIPELINE2_BASEDIR -type f -name '*.jar' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.dat' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.properties' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.js' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.css' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.conf' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.gif' -exec chmod -x {} \; && \
    find $PIPELINE2_BASEDIR -type f -name '*.html' -exec chmod -x {} \;

# remove build time deps
RUN rm pipeline2.zip  && \
    apt-get remove --purge --yes $BUILDTIME_DEPS

# configures bind host, port etc for DAISY Pipeline2
COPY system.properties /usr/local/daisy-pipeline/etc/system.properties
# configures default (and other) log levels for DAISY Pipeline2
COPY config-logback.xml /usr/local/daisy-pipeline/etc/config-logback.xml

CMD ["/bin/sh", "-c", "$PIPELINE2_BASEDIR/bin/pipeline2 remote"]
