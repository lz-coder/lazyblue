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
    git clone https://gitlab.gnome.org/philippun1/turtle.git /tmp/turtle && \
    python /tmp/turtle/install.py install
   
# Enabling rpm-fusion and installing codecs
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld --install mesa-vdpau-drivers-freeworld && \
    rpm-ostree override remove libavcodec-free --install=ffmpeg && \
    rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras \ 
    gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi


RUN rpm-ostree override remove noopenh264 --install openh264 --install mozilla-openh264 && \
    rpm-ostree override remove gnome-terminal-nautilus gnome-terminal --install gnome-console && \
    rpm-ostree install epiphany gitg zsh zenity gnome-themes-extra gnome-tweaks podman-compose just \ 
    gstreamer1-plugin-openh264 eza bat sysprof neovim && \
    rpm-ostree override remove gnome-software-rpm-ostree firefox firefox-langpacks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    sed -i '/^PRETTY_NAME/s/Silverblue/LzBlue/' /usr/lib/os-release && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod -R 1777 /tmp /var/tmp

