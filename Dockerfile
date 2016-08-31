FROM ubuntu:14.04

MAINTAINER Ron Ellis <rone@benetech.org>

ENV BASEDIR /usr/local
ENV PIPELINE2_HOME $BASEDIR/daisy-pipeline
ENV PIPELINE2_SYS_PROPS $PIPELINE2_HOME/etc/system.properties
ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false

WORKDIR $BASEDIR 

# Install dependencies
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update && apt-get install -y openjdk-7-jre wget unzip
RUN locale-gen en_US en_US.UTF-8

# Install Pipeline 2
RUN wget https://github.com/daisy/pipeline-assembly/releases/download/v1.9/pipeline2-1.9-webui_linux.zip -O pipeline2.zip && unzip pipeline2.zip

RUN groupadd -g 11000 -r pipeline2 && \
    useradd -g pipeline2 -u 11000 -m -s /bin/bash pipeline2 && \ 
    chown -R pipeline2.pipeline2 $PIPELINE2_HOME/* && \
    chmod -R 755 $PIPELINE2_HOME && \
    chmod -R 755 $PIPELINE2_HOME/cli && \
    chmod -R 755 $PIPELINE2_HOME/system && \
    rm pipeline2.zip

RUN sed -i -e 's/org\.daisy\.pipeline\.ws\.host=localhost/org\.daisy\.pipeline\.ws\.host=0.0.0.0/g' $PIPELINE2_HOME/etc/system.properties && \
    echo 'org.ops4j.pax.logging.DefaultServiceLog.level=WARN' >> $PIPELINE2_SYS_PROPS && \
    echo 'org.ops4j.pax.logging.service.frameworkEventsLogLevel=WARN' >> $PIPELINE2_SYS_PROPS

USER pipeline2

CMD ["/bin/sh", "-c", "$PIPELINE2_HOME/bin/pipeline2", "remote"]
