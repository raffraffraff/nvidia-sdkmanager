#!/bin/bash

# This script saves the running sdkmanager container to a new image called sdkmanager:${USER}

ID=$(docker container ls -a -q --filter name=sdkmanager)

if [ -z "${ID}" ]; then
  echo "Could not find container 'sdkmanager' running. Did you exit?"
else
  docker commit sdkmanager sdkmanager:${USER}
fi
