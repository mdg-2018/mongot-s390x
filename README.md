# mongot s390x

This Dockerfile can be used to build a mongot image that uses the Java 21 OpenJDK rather than its own embedded JRE. This change should allow the container to run on platforms other than those explicitly supported by MongoDB (which are x86_64 and aarch64 at the time of this writing).

To use this image in your deployment
- Build the image on the target platform (such as s390x)
- Load the image into your local container registry
- Install the MongoDB Controllers fo Kubernetes (MCK) using helm and include the settings specified in *values.yaml*
- Follow MongoDB's documentation for deploying search with your replica set.

**This is just an experiment, always use the official MongoDB images in production environments!**