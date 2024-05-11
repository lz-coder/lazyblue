ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY system_files /
COPY tools /usr/bin

# Turtle for nautilus
RUN rpm-ostree install python-pygit2 nautilus-python meld && \
    git clone https://gitlab.gnome.org/philippun1/turtle.git /tmp/turtle && \
    python /tmp/turtle/install.py install

# Install VSCode
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    rpm-ostree install code && rm -rf /etc/yum.repos.d/vscode.repo

# Install lazygit
RUN curl https://copr.fedorainfracloud.org/coprs/rivenirvana/lazygit/repo/fedora-${FEDORA_MAJOR_VERSION}/rivenirvana-lazygit-fedora-${FEDORA_MAJOR_VERSION}.repo \
     -o /etc/yum.repos.d/lazygit-copr.repo && \
    rpm-ostree install lazygit && rm -rf /etc/yum.repos.d/lazygit-copr.repo

RUN rpm-ostree override remove noopenh264 --install openh264 --install mozilla-openh264 && \
    rpm-ostree override remove gnome-terminal-nautilus gnome-terminal --install gnome-console && \
    rpm-ostree install gitg gh gnome-themes-extra distrobox podman-compose gstreamer1-plugin-openh264 \
    podman-docker podman-tui helix tmux zsh epiphany fastfetch && \
    rpm-ostree override remove gnome-software-rpm-ostree firefox firefox-langpacks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    sed -i '/^PRETTY_NAME/s/Silverblue/LzBlue/' /usr/lib/os-release && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp

