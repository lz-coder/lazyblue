ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY lzblue-firstboot /usr/bin

RUN rpm-ostree install distrobox gnome-tweaks podman-compose gh just gstreamer1-plugin-openh264 mozilla-openh264 && \
    rpm-ostree override remove gnome-software-rpm-ostree && \
    rpm-ostree kargs --append=rd.luks.options=tpm2-device=auto && \
    rpm-ostree initramfs --enable --arg=-a --arg=systemd-pcrphase && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    ostree container commit
