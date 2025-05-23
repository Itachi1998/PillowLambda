#!/bin/bash

LAYER_NAME="pillow-layer-python312-x86-64"
ZIP_FILE="${LAYER_NAME}.zip"
echo "--- Starting Lambda Layer Build Process ---"
echo "Layer name: $LAYER_NAME"
echo "Output ZIP: $ZIP_FILE"
echo "Starting docker image build for lambda layer..."
docker build -t "$LAYER_NAME-builder" .

if [ $? -ne 0 ]; then
  echo "ERROR: Docker build failed. Exiting..."
  exit 1
fi
echo "Docker image built."
echo "Creating temporary Docker container..."
CONTAINER_ID=$(docker create "$LAYER_NAME-builder" /bin/true)

if [ -z "$CONTAINER_ID" ]; then
  echo "ERROR: Failed to create Docker container. Exiting..."
  exit 1
fi
echo "Temporary container created: $CONTAINER_ID"

echo "Copying layer contents from container to host.."

docker cp "$CONTAINER_ID":/python ./python
if [ $? -ne 0]; then
  docker rm "$CONTAINER_ID" > /dev/null 2>&1
  echo "ERROR: Failed to copy files from container. Exiting.."
  exit 1
fi

echo "Layers copied."
echo "Removing temporary container."
docker rm "$CONTAINER_ID" > /dev/null
echo "Creating ZIP file package: $ZIP_FILE"
zip -r "$ZIP_FILE" python

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to create ZIP file. Exiting..."
  rm -rf python > /dev/null 2>&1
  exit 1
fi

echo "ZIP file created successfully."

echo "Cleaning up directory."

rm -rf python
docker rmi "$LAYER_NAME-builder" > /dev/null

echo "--- Layer Build Process Complete. ---"
echo "Your Lambda layer package is ready: $ZIP_FILE"
echo "You may now upload this file to AWS as a new layer."

