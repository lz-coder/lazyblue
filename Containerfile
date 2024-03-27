ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY lzblue-firstboot /usr/bin

# Starship Shell Prompt
RUN curl -Lo /tmp/starship.tar.gz "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz" && \
  tar -xzf /tmp/starship.tar.gz -C /tmp && \
  install -c -m 0755 /tmp/starship /usr/bin && \
  echo 'eval "$(starship init bash)"' >> /etc/bashrc

# Turtle for nautilus
RUN rpm-ostree install python-pygit2 nautilus-python meld && \
    mkdir /etc/opt/turtle && cd /etc/opt/turtle && \
    git clone https://gitlab.gnome.org/philippun1/turtle.git . && \
    python install.py install && rm -rf /etc/opt/turtle

RUN wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -O /usr/libexec/brew-install && \
    chmod +x /usr/libexec/brew-install && \
    rpm-ostree override remove noopenh264 --install openh264 --install mozilla-openh264 && \
    rpm-ostree override remove gnome-terminal-nautilus gnome-terminal --install gnome-console && \
    rpm-ostree install zenity gnome-themes-extra distrobox gnome-tweaks podman-compose gh just gstreamer1-plugin-openh264 && \
    rpm-ostree override remove gnome-software-rpm-ostree firefox firefox-langpacks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    sed -i '/^PRETTY_NAME/s/Silverblue/LzBlue/' /usr/lib/os-release && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp

