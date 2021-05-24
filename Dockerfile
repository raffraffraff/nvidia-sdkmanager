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
        openssh-client \
        p7zip \
        perl \
        qemu-user-static \
        software-properties-common \
        sudo \
        unzip \
        usbutils \
        wget \
        xxd 

RUN mkdir -p /etc/sudoers.d
RUN echo "${USER}    ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/grant_${USER}_nopasswd_sudo

COPY sdkmanager_1.5.0-7774_amd64.deb /tmp/sdkmanager_1.5.0-7774_amd64.deb
RUN apt-get install -y -q /tmp/sdkmanager*_amd64.deb

USER ${USER}

ENTRYPOINT ["/bin/bash"]
CMD ["-c","sdkmanager-gui"]
