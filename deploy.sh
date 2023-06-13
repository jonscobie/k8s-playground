#!/usr/bin/env bash

# Exit if any command fails
set -e

# Build and push the Docker image
#docker build -t host.docker.internal:5000/rest_server --push .
docker build -t host.docker.internal:5000/rest_server .

# Create the ConfigMap from the config.ini file
kubectl create configmap rest-server-config --from-file=config/config.ini

# Apply the Deployment configuration
kubectl apply -f rest-server-deployment.yaml

echo "Image has been built and pushed to the local registry."
echo "Deployment and ConfigMap have been created."
