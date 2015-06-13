FROM ubuntu:14.04

MAINTAINER Ron Ellis <rone@benetech.org>

WORKDIR /usr/local

# Install dependencies
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update && apt-get install -y openjdk-7-jre wget unzip
RUN locale-gen en_US en_US.UTF-8

# Install Pipeline 2
RUN wget https://github.com/daisy/pipeline-assembly/archive/v1.7.1.zip -O pipeline2.zip && unzip pipeline2.zip

ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false

RUN groupadd -g 11000 -r pipeline2 && \
    useradd -g pipeline2 -u 11000 -m -s /bin/bash pipeline2 

RUN chown -R pipeline2.pipeline2 /usr/local/daisy-pipeline/*

RUN ls -l /usr/local/
RUN ls -l /home/root/

EXPOSE 8181

USER pipeline2

CMD ["/usr/local/daisy-pipeline/bin/pipeline2", "remote"]
