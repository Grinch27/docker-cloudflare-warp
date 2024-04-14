# ARG BASEIMAGE_OS="ubuntu"
# ARG BASEIMAGE_VER="jammy"
# Pull base image. FROM ubuntu:jammy
FROM ubuntu:jammy

# APT
ARG APT_OS_VER="jammy"
ARG APP_PLATFORM="arm64"

# Update and install certificates
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
        systemd

# Add cloudflare gpg key
RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=${APP_PLATFORM} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${APT_OS_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list

# Install cloudflare-warp
RUN apt-get update \
    && apt-get install -y \
        cloudflare-warp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*.log

ENTRYPOINT ["/bin/warp-svc"]