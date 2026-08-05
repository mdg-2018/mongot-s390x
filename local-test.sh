#!/bin/bash

if [ "$1" == "start" ]; then
    # Generate a mongodb replica set keyfile
    openssl rand -base64 756 > ./keyfile

    # Run mongodb enterprise container
    podman run --name mongodb-enterprise -d -p 27017:27017 \
    -e MONGO_INITDB_ROOT_USERNAME=root \
    -e MONGO_INITDB_ROOT_PASSWORD=password \
    -v $(pwd)/keyfile:/keyfile \
    mongodb-enterprise-server:8.3

    # Write root password file to be mounted in mongot
    echo "password" > ./mongodb-enterprise-root-password

    # Run mongodb search container
    podman run --name mongodb-search -d -p 27028:27028 \
    -v $(pwd)/mongodb-enterprise-root-password:/tmp/mongodb-enterprise-root-password \
    -v $(pwd)/local-test-config.yaml:/mongot-community/config.default.yml \
    mongodb-search:1.70.1

elif [ "$1" == "stop" ]; then
    # Stop and delete containers
    podman stop mongodb-enterprise mongodb-search
    podman rm mongodb-enterprise mongodb-search
    rm ./mongodb-enterprise-root-password
fi