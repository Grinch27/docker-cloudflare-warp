# FROM ubuntu:jammy
FROM debian:bookworm-slim

# ARG APT_OS_VER="bookworm"
# ARG APT_PLATFORM="arm64"

# ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --ignore-missing \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gpg \
        lsb-release \
        # man \
        # expect \
        # iproute2 \
        # jq \
        # nftables \
        # systemd  \
        # iputils-ping \
        # vim \
        # sudo \
        # procps \
    # Add cloudflare gpg key
    && OS_ARCH=$(dpkg --print-architecture) \
    && OS_VER=$(lsb_release -cs) \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=${OS_ARCH} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${OS_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list \
    # Clean pre-install
    && apt-get purge --autoremove -y \
        gpg \
        lsb-release \
    && apt-get purge --autoremove -y \
    # Install cloudflare-warp
    && apt-get update \
    && apt-get install -y \
        cloudflare-warp \
    # Clean apt
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*.log \
    # ENTRYPOINT startapp.sh
    && echo "#!/bin/sh\nservice dbus start\n/bin/warp-svc" > /startapp.sh \
    && chmod +x /startapp.sh
    
# ENTRYPOINT ["/bin/warp-svc"]
ENTRYPOINT ["/startapp.sh"]