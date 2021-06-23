FROM ubuntu:bionic

ARG USER
ARG UID
ENV PATH=${PATH}:/opt/nvidia/sdkmanager

RUN groupadd --gid ${UID} ${USER}
RUN useradd --uid ${UID} --gid ${UID} --shell /bin/bash --create-home ${USER}

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        binutils \
        cabextract \
        ca-certificates \
        cpio \
        curl \
        dialog \
        dnsutils \
        gosu \
        gpg-agent \
        iproute2 \
        iptables \
        jq \
        libgtk-3-0 \
        libnss3 \
        libx11-xcb1 \
        libxss1 \
        libxtst6 \
        netcat-traditional \
        openssh-client \
        pcmanfm \
        p7zip \
        perl \
        qemu-user-static \
        software-properties-common \
        sudo \
        unzip \
        usbutils \
        wget \
        xdg-utils \
        xxd 

# Supporting the SDK Manager "folder" icon:
# You could bloat out the container and do this "the right way", by installing
# a file manager, xdg-utils, exo-utils and then configure mimeapps. Or you can
# do it the quick hacky way: install pcmanfm and symlink it to xdg-open
RUN ln -sf /usr/bin/pcmanfm /usr/bin/xdg-open

RUN mkdir -p /etc/sudoers.d
RUN echo "${USER}    ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/grant_${USER}_nopasswd_sudo

COPY sdkmanager_*.deb /tmp/
RUN apt-get install -y -q /tmp/sdkmanager*_amd64.deb

USER ${USER}

ENTRYPOINT ["/bin/bash"]
CMD ["-c","sdkmanager-gui"]
