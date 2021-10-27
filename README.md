# No longer maintained
I don't have a Jetson any more, so I don't use this. For all I know, the latest NVIDIA SDK Manager might not even suck, so perhaps there's no need for it.

# nvidia-sdkmanager

## What is this?
This project helps you to create an NVIDIA SDK Manager docker image that supports GUI mode

## Why?
The NVIDIA SDK Manager package is available in .deb (supporting Ubuntu) and .rpm (supporting CentOS/RedHat). While the [system requirements](https://docs.nvidia.com/sdk-manager/system-requirements/index.html) state that it supports Ubuntu versions 16.04, 18.04 and 20.04, there are threads on the [NVIDIA forum](https://forums.developer.nvidia.com/t/sdkmanager-not-supported-on-linux/71742/3) raising the issue that it only _really_ supports Ubuntu 18.04, and reports a cryptic "Linux. Not supported on Linux" message on Debian, Mint and later versions of Ubuntu.  Other forum threads indicate that SDK Manager does not work in a Virtual Machine either, so you must run an old Ubuntu LTS release on a 'real' computer to use SDK Manager.

NOTE: NVIDIA _do_ provide a docker image for SDK Manager, but it cannot not run the GUI even though it has most (but not all) of the GUI dependencies installed. I'm normally a fan of the command line, but `sdkmanager --cli` is hard to use because `--help` provides insufficient guidance, there are no man pages, and there is no tab completion.

## SDK Manager Version
The latest version is 1.6.0. This release appears to have a bug that affects "first time setup". If you have never launched SDK Manager before, and your home directory does not already have a pre-configured `~/.nvsdkm` directory or `~/.nvidia-settings-rc` file, the sdkmanager-gui fails silently after a few seconds. `strace` doesn't shed much light on the issue. I've been able to work around the issue by installing sdkmanager 1.5 _first_, performing the initial NVIDIA login, and _then_ upgading to 1.6. However, since there are no amazing new features in 1.6.0 I'm leaving this project on 1.5.1.

## Building your own SDK Manager container
1. Clone this repo
2. Create an NVIDIA Developer account and [log in](https://developer.nvidia.com/login). NOTE: If you created the account using Google/Facebook authentication, you should also send a password reset since this SDK Manager login via QR Code appears to require one
3. Download [NVIDIA SDK Manager v1.5.1](https://developer.nvidia.com/nvidia-sdk-manager-sdkmanager-deb-1517814) to this project directory
4. Run `./build.sh` to create an image
5. Run `./run.sh` to launch a container
6. Log into SDK Manager using the QR Code method (click the link to copy the URL, use it in a browse that is logged into NVIDIA Developer portal)
7. Allow SDK Manager to upgrade and exit. On the command line you'll be prompted to save container changes, choose 'Y' to save
8. Run './run.sh' again. This time, install "Host Components" and exit. Again, when prompted to save container changes, choose 'Y' to save

## Running SDK Manager
Now that the SDK Manager is installed, configured, upgraded etc, you can it any time using `./run.sh`. You no longer need to save container changes, unless a new version of the SDK Manager is released.
 
## Build notes
The build script detects your user details and recreates it inside the container. The container will only work properly if you run it from that same local user account because it volume mounts the `/tmp/.X11-unix` socket and your `~/.Xauthority` file when it runs, and so the processes inside the container must have access rights to them.

## Security notes
The container runs with a bunch of insecure options, so that the SDK Manager will work:
* --privileged 
* --net=host 
* --security-opt seccomp=chrome.json (unsure if it is required with --privileged)

It also mounts `/dev/bus/usb`, `/tmp/.X11-unix` socket (read only), `~/.Xauthority` and several directories in your local home directory.
