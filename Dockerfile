FROM josteinaj/daisy-pipeline 

MAINTAINER Ron Ellis <rone@benetech.org>

ENV PIPELINE2_AUTH false
ENV PIPELINE2_LOCAL false

CMD ["/home/root/daisy-pipeline/bin/pipeline2"]
