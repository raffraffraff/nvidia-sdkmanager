#!/bin/bash

docker run \
  -it --rm \
  --privileged \
  --shm-size=1024M \
  --net=host \
  --security-opt seccomp=chrome.json \
  -e DISPLAY \
  -v /dev/bus/usb:/dev/bus/usb \
  -v ${HOME}/.Xauthority:${HOME}/.Xauthority:ro \
  -v ${HOME}/Downloads:${HOME}/Downloads \
  -v ${HOME}/nvidia:${HOME}/nvidia \
  -v ${HOME}/.nvidia-settings-rc:${HOME}/.nvidia-settings-rc \
  -v ${HOME}/.nvsdkm:${HOME}/.nvsdkm \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v /etc/localtime:/etc/localtime:ro \
  --name="sdkmanager" \
  sdkmanager:latest
