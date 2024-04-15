# FROM ubuntu:jammy
# FROM debian:bookworm-slim
FROM jlesage/baseimage-gui:debian-11-v4

ARG APT_OS_VER="bullseye"
ARG APT_PLATFORM="arm64"

# ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --ignore-missing \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gpg \
        man \
        expect \
        iproute2 \
        jq \
        nftables \
        iputils-ping \
        systemd  \
        vim \
        sudo \
        procps \
        # tini \
    # Add cloudflare gpg key
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=${APT_PLATFORM} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${APT_OS_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list \
    # Install cloudflare-warp
    && apt-get update \
    && apt-get install -y \
        cloudflare-warp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*.log

RUN echo "#!/bin/sh\n/bin/warp-svc --disable-gpu-sandbox --no-sandbox" > /startapp.sh \
    # set /startapp.sh
    && chmod +x /startapp.sh \
    # openbox
    && mkdir -p /etc/openbox \
    && echo "<Type>normal</Type>\n<Name>cloudflare-warp</Name>" > /etc/openbox/main-window-selection.xml \
    # set /config/.config/mimeapps.list
    && mkdir -p /config/.config \
    && echo "\n[Default Applications]\nx-scheme-handler/cloudflare-warp=cloudflare-warp.desktop" > /config/.config/mimeapps.list \
    && chmod 777 /config/.config/mimeapps.list

# ENTRYPOINT ["/bin/warp-svc"]
ENTRYPOINT ["/init"]
