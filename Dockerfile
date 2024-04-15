# FROM ubuntu:jammy
FROM debian:bookworm-slim

ARG APT_OS_VER="bookworm"
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
        iptables \
        iputils-ping \
        systemd  \
        vim \
        sudo \
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

# ENTRYPOINT ["/bin/warp-svc"]
ENTRYPOINT ["/bin/bash", "/bin/warp-svc"]
