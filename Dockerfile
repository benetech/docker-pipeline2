FROM josteinaj/daisy-pipeline 

MAINTAINER Ron Ellis <rone@benetech.org>

ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false

RUN groupadd -g 11000 -r pipeline2 && \
    useradd -g pipeline2 -u 11000 -m -s /bin/bash pipeline2 

RUN chown -R pipeline2.pipeline2 /home/root/daisy-pipeline/*

USER pipeline2

CMD ["/home/root/daisy-pipeline/bin/pipeline2"]
