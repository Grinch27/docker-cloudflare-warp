ARG BASEIMAGE_OS="ubuntu"
ARG BASEIMAGE_VER="jammy"
# Pull base image. FROM ubuntu:jammy
FROM ${BASEIMAGE_OS}:${BASEIMAGE_VER}

# APT
# ARG APT_PLATFORM="linux/arm64"
ARG APT_SRC="archive.ubuntu.com"
ARG APT_OS_VER="jammy"
ARG APT_PACKAGES="curl gpg man expect iproute2 jq iptables iputils-ping systemd"
# APP
# ARG APP_VER="3.61.0.12-1"
ARG APP_PLATFORM="arm64"

# Update and install certificates
RUN apt-get update --ignore-missing && apt-get install -y --no-install-recommends --fix-missing ca-certificates

# Backup old sources and Add Ubuntu jammy sources
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak || true \
#     && echo "deb http://${APT_SRC}/ubuntu/ ${APT_OS_VER} main restricted universe multiverse" > /etc/apt/sources.list \
#     && echo "deb http://${APT_SRC}/ubuntu/ ${APT_OS_VER}-updates main restricted universe multiverse" >> /etc/apt/sources.list \
#     && echo "deb http://${APT_SRC}/ubuntu/ ${APT_OS_VER}-backports main restricted universe multiverse" >> /etc/apt/sources.list \
#     && echo "deb http://${APT_SRC}/ubuntu/ ${APT_OS_VER}-security main restricted universe multiverse" >> /etc/apt/sources.list

# Install packages
RUN apt-get update --ignore-missing && apt-get install -y --no-install-recommends --fix-missing ${APT_PACKAGES}

# Add cloudflare gpg key
RUN apt-get install -y --no-install-recommends --fix-missing gpg \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

# Add this repo to your apt-get repositories
RUN echo "deb [arch=${APP_PLATFORM} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${BASEIMAGE_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list

# Install cloudflare-warp
RUN apt-get update && apt-get install -y cloudflare-warp

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/log/*.log
