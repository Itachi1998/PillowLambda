#!/bin/bash

LAYER_NAME="pillow-layer-python313-x86-64"
ZIP_FILE="${LAYER_NAME}.zip"
CONTAINER_ID=""
BUILDER_IMAGE_TAG="$LAYER_NAME-builder"
cleanup() {
echo "--- Initiating cleanup ---"
if [ -n $CONTAINER_ID ]; then
  echo "Removing temp docker container: $CONTAINER_ID"
  docker rm "$CONTAINER_ID" > /dev/null 2>&1 || true 
fi
if docker images -q "$BUILDER_IMAGE_TAG" | grep -q .; then
  echo "Removing Docker image: $BUILDER_IMAGE_TAG"
  docker rmi "$BUILDER_IMAGE_TAG" /DEV/NULL 2>&1 || true
fi

if [ -d "./python" ]; then
  echo "Removing local 'python' directory."
  rm -rf python || true
fi
echo "=== Cleanup Complete ==="
}

trap cleanup EXIT
echo "--- Starting Lambda Layer Build Process ---"
echo "Layer name: $LAYER_NAME"
echo "Output ZIP: $ZIP_FILE"
echo "Build image tag: $BUILDER_IMAGE_TAG"
echo "Starting docker image build for lambda layer..."
docker build -t "$BUILDER_IMAGE_TAG" .

if [ $? -ne 0 ]; then
  echo "ERROR: Docker build failed. Exiting..."
  exit 1
fi
echo "Docker image built."
echo "Creating temporary Docker container..."
CONTAINER_ID=$(docker create "$BUILDER_IMAGE_TAG" /bin/true)

if [ -z "$CONTAINER_ID" ]; then
  echo "ERROR: Failed to create Docker container. Exiting..."
  exit 1
fi
echo "Temporary container created: $CONTAINER_ID"

echo "Copying layer contents from container to host.."

docker cp "$CONTAINER_ID":/python ./python
if [ $? -ne 0]; then
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
  exit 1
fi

echo "ZIP file created successfully."

echo "Cleaning up directory."

rm -rf python
docker rmi "$LAYER_NAME-builder" > /dev/null

echo "--- Layer Build Process Complete. ---"
echo "Your Lambda layer package is ready: $ZIP_FILE"
echo "You may now upload this file to AWS as a new layer."

