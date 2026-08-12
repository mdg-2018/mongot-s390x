FROM quay.io/mongodb/mongodb-enterprise-server:8.0.28-ubi9
ARG TARGETARCH

USER root

RUN mkdir /tmp/mongodb

RUN echo "TARGETARCH is $TARGETARCH"

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      echo "Building for x86_64"; \
      curl -o /tmp/mongodb/mongodb.tar.gz -L https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel93-8.3.7.tgz; \
    elif [ "$TARGETARCH" = "s390x" ]; then \
      echo "Building for s390x"; \
      curl -o /tmp/mongodb/mongodb.tar.gz -L https://downloads.mongodb.com/linux/mongodb-linux-s390x-enterprise-rhel9-8.3.7.tgz; \
    fi

RUN tar -xzf /tmp/mongodb/mongodb.tar.gz -C /tmp/mongodb --strip-components=1 && \
    cp -r /tmp/mongodb/bin/* /usr/bin/ && \
    rm -rf /tmp/mongodb

USER mongod

CMD ["/usr/bin/mongod", "-f", "/etc/mongod.conf"]