FROM docker.io/redhat/ubi8:latest

RUN yum install -y wget && \
    wget https://repo.mongodb.com/yum/redhat/8/mongodb-enterprise/8.3/s390x/RPMS/mongodb-enterprise-server-8.3.7-1.el8.s390x.rpm -O /tmp/mongodb-enterprise-server.rpm && \
    yum install -y /tmp/mongodb-enterprise-server.rpm && \
    rm /tmp/mongodb-enterprise-server.rpm && \
    yum clean all

RUN mkdir -p /data/db

EXPOSE 27017

CMD ["/usr/bin/mongod", "-f", "/etc/mongod.conf"]

