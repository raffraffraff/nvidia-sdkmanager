# nvidia-sdkmanager

## What is this?
This project helps you to create an NVIDIA SDK Manager docker image that supports GUI mode

## Why?
The NVIDIA SDK Manager package is available in .deb (supporting Ubuntu) and .rpm (supporting CentOS/RedHat). While the [system requirements](https://docs.nvidia.com/sdk-manager/system-requirements/index.html) state that it supports Ubuntu versions 16.04, 18.04 and 20.04, there are threads on the [NVIDIA forum](https://forums.developer.nvidia.com/t/sdkmanager-not-supported-on-linux/71742/3) raising the issue that it only _really_ supports Ubuntu 18.04, and reports a cryptic "Linux. Not supported on Linux" message on Debian, Mint and later versions of Ubuntu.  Other forum threads indicate that SDK Manager does not work in a Virtual Machine either, so you must run an old Ubuntu LTS release on a 'real' computer to use SDK Manager.

NOTE: NVIDIA _do_ provide a docker image for SDK Manager, but it cannot not run the GUI even though it has most (but not all) of the GUI dependencies installed. I'm normally a fan of the command line, but `sdkmanager --cli` is hard to use because `--help` provides insufficient guidance, there are no man pages, and there is no tab completion.

## SDK Manager Version
The latest version is 1.6.0. This release appears to have a bug that affects "first time setup". If you have never launched SDK Manager before, and your home directory does not already have a pre-configured `~/.nvsdkm` directory or `~/.nvidia-settings-rc` file, the sdkmanager-gui fails silently after a few seconds. `strace` doesn't shed much light on the issue. I've been able to work around the issue by installing sdkmanager 1.5 _first_, performing the initial NVIDIA login, and _then_ upgading to 1.6. However, since there are no amazing new features in 1.6.0 I'm leaving this project on 1.5.1.

## Usage
1. Clone this repo
2. Create an NVIDIA developer account and [log in](https://developer.nvidia.com/login).
3. Download [NVIDIA SDK Manager](https://developer.nvidia.com/nvidia-sdk-manager-sdkmanager-deb-1517814) v1.5.1 to this directory
4. Run `./build.sh`
5. Run `./run.sh`
6. When SDK Manager GUI launches, log it into your NVIDIA developer account
7. Use SDK Manager to install the Host components (and do not exit!)
8. In another terminal, run `./commit.sh` to save the updated Docker image

## Build notes
It's assumed that you will run the image with the same user that built it. The build script detects your user details and recreates it inside the container. The container will only work properly from that same local user account. The reason for this choice is that the container must volume mount the `/tmp/.X11-unix` socket and your `.Xauthority` file when it runs, and so the processes inside the container must have access rights to them.

## Security notes
The container runs with a bunch of insecure options, so that the SDK Manager will work:
* --privileged 
* --net=host 
* --security-opt seccomp=chrome.json (unsure if it is required with --privileged)

It also mounts `/dev/bus/usb`, `/tmp/.X11-unix` socket (read only), `~/.Xauthority` and several directories in your local home directory.
