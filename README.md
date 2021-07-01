# nvidia-sdkmanager

## What?
NVIDIA SDK Manager docker image that supports GUI mode

## Why?
The NVIDIA SDK Manager package is available in .deb (supporting Ubuntu) and .rpm (supporting CentOS/RedHat). While the [system requirements](https://docs.nvidia.com/sdk-manager/system-requirements/index.html) state that it supports Ubuntu versions 16.04, 18.04 and 20.04, there are threads on the [NVIDIA forum](https://forums.developer.nvidia.com/t/sdkmanager-not-supported-on-linux/71742/3) raising the issue that it only _really_ supports Ubuntu 18.04, and reports a cryptic "Linux. Not supported on Linux" message on Debian, Mint and later versions of Ubuntu.  Other forum threads indicate that SDK Manager does not work in a Virtual Machine either, so you must run an old Ubuntu LTS release on a 'real' computer to use SDK Manager. This will not do.

NOTE: NVIDIA _do_ provide a docker image for SDK Manager, but it cannot not run the GUI even though it has most (but not all) of the GUI dependencies installed. I'm normally a fan of the command line, but `sdkmanager --cli` is hard to use because `--help` provides insufficient guidance, there are no man pages, and there is no tab completion.

WARNING: It looks like sdkmanager 1.6 is borked on a clean install (ie: where there isn't a `~/.nvsdkm` directory or `~/.nvidia-settings-rc` file). The symptom is that you run the sdkmanager-gui and it exits with code 1 after a few seconds. `strace` doesn't shed much light on the issue, but I've confirmed that installing sdkmanager 1.5 first, performing the initial NVIDIA login, and _then_ upgading to 1.6 gets around this. Well done NVIDIA!

## Usage
1. Clone this repo
2. Download the [NVIDIA SDK Manager](https://developer.nvidia.com/sdkmanager_deb) to this directory (requires NVIDIA developer account)
3. Run `./build.sh`
4. Run `./run.sh`
5. Use SDK Manager to install the Host components (and do not exit!)
6. Run `./commit.sh` in another terminal

## Build notes
The build script assumes that you will run the image as the same user that built it. It looks up your user name and ID and provides those to the docker build via ARGs. Once the container is built, it will be for this user only. Clunky, but it'll do for now.

## Security notes
Until I tighten things up, I'm running it with a bunch of insecure options:
* --privileged 
* --net=host 
* --security-opt seccomp=chrome.json (unsure if it is required with --privileged)

I'm also mounting a bunch of directories in ${HOME}, `/dev/bus/usb` and the `/tmp/.X11-unix` socket (read only)

But hey, it's not a web service, it's a local app on your machine.
