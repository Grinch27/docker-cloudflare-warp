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
    && ARCH=$(dpkg --print-architecture) \
    && OS_VER=$(lsb_release -cs) \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${OS_VER} main" > /etc/apt/sources.list.d/cloudflare-client.list \
    # Clean pre-install
    && apt-get purge --autoremove -y \
        gpg \
        lsb-release \
    && apt-get purge --autoremove -y \
    # Install cloudflare-warp
    && apt-get update \
    && apt-get install -y \
        cloudflare-warp \
    # clean apt
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*.log \
    # startapp.sh
    && echo "#!/bin/sh\nservice dbus start\n/bin/warp-svc" > /startapp.sh \
    && chmod +x /startapp.sh
    
# ENTRYPOINT ["/bin/warp-svc"]
ENTRYPOINT ["/startapp.sh"]


The following additional packages will be installed:
  dbus dbus-bin dbus-daemon dbus-session-bus-common dbus-system-bus-common
  desktop-file-utils dirmngr gnupg gnupg-l10n gnupg-utils gnupg2 gpg-agent
  gpg-wks-client gpg-wks-server gpgsm iproute2 libapparmor1 libatm1 libbpf1
  libbsd0 libcap2-bin libdbus-1-3 libedit2 libelf1 libexpat1 libglib2.0-0
  libglib2.0-data libgpm2 libicu72 libjansson4 libksba8 libmnl0 libncursesw6
  libnftables1 libnftnl11 libnpth0 libnspr4 libnss3 libnss3-tools libpam-cap
  libpcap0.8 libtirpc-common libtirpc3 libxml2 libxtables12 netbase nftables
  pinentry-curses shared-mime-info xdg-user-dirs
Suggested packages:
  traceroute default-dbus-session-bus | dbus-session-bus dbus-user-session
  libpam-systemd pinentry-gnome3 tor parcimonie xloadimage scdaemon
  iproute2-doc python3:any low-memory-monitor gpm firewalld pinentry-doc
The following NEW packages will be installed:
  cloudflare-warp dbus dbus-bin dbus-daemon dbus-session-bus-common
  dbus-system-bus-common desktop-file-utils dirmngr gnupg gnupg-l10n
  gnupg-utils gnupg2 gpg-agent gpg-wks-client gpg-wks-server gpgsm iproute2
  libapparmor1 libatm1 libbpf1 libbsd0 libcap2-bin libdbus-1-3 libedit2
  libelf1 libexpat1 libglib2.0-0 libglib2.0-data libgpm2 libicu72 libjansson4
  libksba8 libmnl0 libncursesw6 libnftables1 libnftnl11 libnpth0 libnspr4
  libnss3 libnss3-tools libpam-cap libpcap0.8 libtirpc-common libtirpc3
  libxml2 libxtables12 netbase nftables pinentry-curses shared-mime-info
  xdg-user-dirs