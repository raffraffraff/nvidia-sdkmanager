#!/bin/bash

# This script saves the running sdkmanager container to a new image called sdkmanager:${USER}

ID=$(docker container ls -a -q --filter name=sdkmanager)

if [ -z "${ID}" ]; then
  echo "Could not find container 'sdkmanager' running. Did you exit?"
else
  echo "Saving the container 'sdkmanager' to the docker image 'sdkmanager:${USER}'..."
  docker commit sdkmanager sdkmanager:${USER}

  echo

  docker images | grep sdkmanager

  echo
  echo "You should not need to keep the sdkmanager:latest image"
fi
