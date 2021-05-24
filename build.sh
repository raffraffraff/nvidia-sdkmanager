#!/bin/bash
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ ! -f ${CWD}/sdkmanager*.deb ]; then
  echo "Opening browser to download NVIDIA SDK Manager (login required)"
  sleep 3
  x-www-browser https://developer.nvidia.com/sdkmanager_deb
else
  docker build --build-arg USER=${USER} --build-arg UID=${UID} -t sdkmanager:latest .
fi
