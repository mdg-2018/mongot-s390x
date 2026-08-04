FROM registry.access.redhat.com/ubi9/ubi

RUN yum update -y && \
    yum install -y \
    tar \
    gzip \
    apr \
    java-21-openjdk \
    shadow-utils && \
    yum clean all

# RUN groupadd -r -g 999 mongot && \
#     useradd -r -u 999 -g mongot -s /bin/bash -d /mongot-community mongot

RUN groupadd -r mongot && \
    useradd -r -g mongot -s /bin/bash -d /mongot-community mongot

WORKDIR /mongot-community

RUN curl -o /tmp/mongot-community.tar.gz -L https://downloads.mongodb.org/mongodb-search-community/1.70.1/mongot_community_1.70.1_linux_x86_64.tgz && \
    gunzip /tmp/mongot-community.tar.gz

# Extract the tarball
# The tarball creates a mongot-community/ directory with all contents
RUN tar -xf /tmp/mongot-community.tar -C /mongot-community --strip-components=1 && \
    rm /tmp/mongot-community.tar

RUN chmod +x /mongot-community/mongot

RUN chown -R mongot:mongot /mongot-community

# Create data directory with proper permissions
# The volume will be mounted here, so we need to ensure the directory exists
# and the mongot user has the right UID/GID
RUN mkdir -p /data/mongot && \
    chown -R mongot:mongot /data/mongot && \
    chmod -R 755 /data/mongot

VOLUME ["/data/mongot"]

# Switch to mongot user
USER mongot

# Expose default ports
# 27028: Query server port
# 9946: Metrics port
EXPOSE 27028 9946

ENV JAVA_HOME=/usr/lib/jvm/jre-21-openjdk

# Default command: run mongot with the default config
# Users can override the config by mounting a custom config.default.yml
CMD ["/mongot-community/mongot", "--config=/mongot-community/config.default.yml"]