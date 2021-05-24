# nvidia-sdkmanager

## Why?
NVIDIA SDK Manager only supports older Ubuntu LTS releases, and it will not run on a VM. Unless you are happy to run Ubuntu on your computer, of have a spare machine to use just for SDK Manager, you're in a pickle. While NVIDIA provide a docker image for SDK Manager, it cannot not run the GUI (even though their docker image has Xorg installed) which means that it's limited to the CLI. While I'm normally a fan of the command line, this one is hard to use because the --help provides insufficient guidance, there's no man pages, and no tab completion.

## Usage
1. Clone this repo
2. Download the [https://developer.nvidia.com/sdkmanager_deb](NVIDIA SDK Manager) to this directory (requires NVIDIA developer account)
3. Run `./build.sh`
4. Run `./run.sh`

## Build notes
The build script assumes that you will run the SDK Manager under the same user account that you build it for. It looks up your user name and ID and provides those to the docker build via ARGs. When the container is built, it will be for your user only. Clunky, but it'll do for now.

## Security notes
Until I tighten things up, I'm running it with a bunch of insecure options:
* --privileged 
* --net=host 
* --security-opt seccomp=chrome.json (unsure if it is required with --privileged)

I'm also mounting a bunch of directories in ${HOME}, `/dev/bus/usb` and the `/tmp/.X11-unix` socket (read only)

But hey, it's not a web service, it's a local app on your machine.
