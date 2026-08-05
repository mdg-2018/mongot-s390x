FROM docker.io/redhat/ubi8:latest

COPY mongodb-enterprise-8.3.repo /etc/yum.repos.d/mongodb-enterprise-8.3.repo

RUN yum install -y mongodb-enterprise && \
    yum clean all

RUN mkdir -p /data/db

EXPOSE 27017

CMD ["/usr/bin/mongod", "-f", "/etc/mongod-1.conf"]

