ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY lzblue-firstboot /usr/bin

RUN rpm-ostree install python-pygit2 nautilus-python meld && \
    git clone https://gitlab.gnome.org/philippun1/turtle.git /usr/local/turtle && \
    python /usr/local/turtle/install.py install && rm -rf /usr/local/turtle

RUN rpm-ostree override remove noopenh264 --install openh264 --install mozilla-openh264 && \
    rpm-ostree override remove gnome-terminal-nautilus gnome-terminal --install gnome-console && \
    rpm-ostree install zenity distrobox gnome-tweaks podman-compose gh just gstreamer1-plugin-openh264 && \
    rpm-ostree override remove gnome-software-rpm-ostree firefox firefox-langpacks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    ostree container commit
