#!/bin/bash

# Ensure files and directories exist before docker attempts to mount them
touch ${HOME}/.nvidia-settings-rc
touch ${HOME}/.Xauthority
mkdir -p ${HOME}/.nvsdkm
mkdir -p ${HOME}/nvidia
mkdir -p ${HOME}/Downloads

# Fix incorrect permission on VisionWorks index.html which breaks installation on host
find ${HOME}/nvidia \
    -path "*rootfs*" -prune -false \
    -o \
    -path "*VisionWorks*" \
    -name index.html \
    -perm 444 \
    -exec chmod 664 {} \;

user_image=$(docker images -q sdkmanager:${USER})

if [ -n "${user_image}" ]; then
  IMAGE="sdkmanager:${USER}"
else
  IMAGE="sdkmanager:latest"
  echo "RECOMMENDED: Install 'Host' components, leave SDK Manager running, and run 'commit.sh' in another terminal"
  sleep 4
fi
 
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
  ${IMAGE}
