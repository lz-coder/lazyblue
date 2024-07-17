#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Turtle for nautilus
rpm-ostree install python-pygit2 nautilus-python meld
git clone https://gitlab.gnome.org/philippun1/turtle.git /tmp/turtle
python /tmp/turtle/install.py install

# Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
rpm-ostree install code && rm -rf /etc/yum.repos.d/vscode.repo

rpm-ostree override remove noopenh264 --install openh264
rpm-ostree install gnome-themes-extra sysprof gitg
rpm-ostree install gh distrobox podman-compose gstreamer1-plugin-openh264 podman-docker podman-tui helix zsh
rpm-ostree override remove gnome-terminal-nautilus gnome-terminal --install gnome-console
rpm-ostree override remove firefox firefox-langpacks --install epiphany
rpm-ostree override remove gnome-software-rpm-ostree

sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer
sed -i '/^PRETTY_NAME/s/Silverblue/Lazyblue/' /usr/lib/os-release

