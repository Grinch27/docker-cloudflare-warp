ARG BASEIMAGE_OS="debian:bookworm"
ARG BASEIMAGE_VER="slim"
# Pull base image. FROM debian:bookworm-slim
FROM ${BASEIMAGE_OS}-${BASEIMAGE_VER}

# APT
# ARG APT_PLATFORM="linux/arm64"
ARG APT_SRC="deb.debian.org"
ARG APT_OS_VER="bookworm"
ARG APT_PACKAGES="curl gpg man expect iproute2 jq iptables iputils-ping systemctl"
# APP
# ARG APP_VER="3.61.0.12-1"
ARG APP_PLATFORM="arm64"

RUN apt-get update --ignore-missing \
    && apt-get install -y --no-install-recommends --fix-missing ca-certificates \
    # Backup old sources
    && mv /etc/apt/sources.list /etc/apt/sources.list.bak || true \
    && mv /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak || true \
    # Add debian bookworm sources
    && echo "deb https://${APT_SRC}/debian/ ${APT_OS_VER} main contrib non-free non-free-firmware" > /etc/apt/sources.list \
    && echo "deb-src https://${APT_SRC}/debian/ ${APT_OS_VER} main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://${APT_SRC}/debian/ ${APT_OS_VER}-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://${APT_SRC}/debian/ ${APT_OS_VER}-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://${APT_SRC}/debian/ ${APT_OS_VER}-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://${APT_SRC}/debian/ ${APT_OS_VER}-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb https://${APT_SRC}/debian-security/ ${APT_OS_VER}-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    && echo "deb-src https://${APT_SRC}/debian-security/ ${APT_OS_VER}-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list \
    # Install packages
    && apt update --ignore-missing \
    && apt-get install -y --no-install-recommends --fix-missing ${APT_PACKAGES} \
    # Add cloudflare gpg key
    && apt-get install -y --no-install-recommends --fix-missing gpg \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    # Add this repo to your apt-get repositories
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bookworm main" > /etc/apt/sources.list.d/cloudflare-client.list
    && echo "deb [arch=${APP_PLATFORM} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${APT_OS_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list \
    # Install
    && apt-get update  \
    # && apt-get install -y --no-install-recommends --fix-missing cloudflare-warp \
    && apt-get install -y cloudflare-warp \
    # Clear cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*.log
