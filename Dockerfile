FROM 814633283276.dkr.ecr.us-east-1.amazonaws.com/java:jdk8

MAINTAINER Ron Ellis <rone@benetech.org>

ENV BASEDIR /usr/local
ENV PIPELINE2_HOME $BASEDIR/daisy-pipeline
ENV PIPELINE2_SYS_PROPS $PIPELINE2_HOME/etc/system.properties
ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false
ENV PIPELINE2_DOWNLOAD_URL https://github.com/daisy/pipeline-assembly/releases/download/v1.10.0/pipeline2-1.10.0_linux.zip
ENV BUILDTIME_DEPS unzip

WORKDIR $BASEDIR 

RUN locale-gen en_US en_US.UTF-8 && \
    apt-get update && \
    apt-get install --yes $BUILDTIME_DEPS 

# Install and configure DAISY Pipeline 2
RUN wget $PIPELINE2_DOWNLOAD_URL -O pipeline2.zip && \
    unzip pipeline2.zip && \
    groupadd -g 11000 -r pipeline2 && \
    useradd -g pipeline2 -u 11000 -m -s /bin/bash pipeline2 && \ 
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
    find $PIPELINE2_HOME -type f -name '*.html' -exec chmod -x {} \; && \
    rm pipeline2.zip && \
    sed -i -e 's/org\.daisy\.pipeline\.ws\.host=localhost/org\.daisy\.pipeline\.ws\.host=0.0.0.0/g' $PIPELINE2_HOME/etc/system.properties && \
    echo 'org.ops4j.pax.logging.DefaultServiceLog.level=WARN' >> $PIPELINE2_SYS_PROPS && \
    echo 'org.ops4j.pax.logging.service.frameworkEventsLogLevel=WARN' >> $PIPELINE2_SYS_PROPS

USER pipeline2

CMD ["/bin/sh", "-c", "$PIPELINE2_HOME/bin/pipeline2", "remote"]
