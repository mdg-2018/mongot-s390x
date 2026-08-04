#!/bin/bash

if [ "$1" == "start" ]; then
    # Run mongodb enterprise container
    podman run quay.io/mongodb/mongodb-enterprise:8.3.7 --name mongodb-enterprise -d -p 27017:27017

    # Run mongodb search container
    podman run mongodb-search:1.70.1 --name mongodb-search -d -p 27028:27028

elif [ "$1" == "stop" ]; then
    # Stop and delete containers
    podman stop mongodb-enterprise mongodb-search
    podman rm mongodb-enterprise mongodb-search
fi