#!/bin/bash

if [ "$1" == "start" ]; then
    # Generate a mongodb replica set keyfile
    openssl rand -base64 756 > ./keyfile
    chmod 400 ./keyfile

    # Create the shared network if it does not already exist
    podman network exists mongodb-test || podman network create mongodb-test

    # Run mongodb enterprise container
    podman run --replace --name mongodb-enterprise -d -p 27027:27027 \
    --network mongodb-test \
    -e MONGO_INITDB_ROOT_USERNAME=root \
    -e MONGO_INITDB_ROOT_PASSWORD=password \
    -v $(pwd)/keyfile:/keyfile:ro,Z \
    -v $(pwd)/local-test-mongod-config.yaml:/etc/mongod.conf:ro,Z \
    mongodb-enterprise-server:8.3

    # Write root password file to be mounted in mongot
    echo "password" > ./mongodb-enterprise-root-password
    chmod 400 ./mongodb-enterprise-root-password

    # Run mongodb search container
    podman run --replace --name mongodb-search -d -p 27028:27028 \
    --network mongodb-test \
    -v $(pwd)/mongodb-enterprise-root-password:/tmp/mongodb-enterprise-root-password:ro,Z \
    -v $(pwd)/local-test-config.yaml:/mongot-community/config.default.yml:ro,Z \
    mongodb-search:1.70.1

elif [ "$1" == "stop" ]; then
    # Stop and delete containers
    podman stop mongodb-enterprise mongodb-search
    podman rm mongodb-enterprise mongodb-search
    podman network rm mongodb-test
    rm ./mongodb-enterprise-root-password
fi