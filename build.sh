#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Turtle for nautilus
dnf install -y python3-pygit2 python3-secretstorage nautilus-python meld
git clone https://gitlab.gnome.org/philippun1/turtle.git /tmp/turtle
python /tmp/turtle/install.py install

dnf install -y gnome-themes-extra sysprof gitg gnome-tweaks
dnf install -y podman-compose podman-docker podman-tui helix tmux epiphany distrobox
dnf remove -y firefox firefox-langpacks gnome-software-rpm-ostree rpm-ostree

sed -i '/^PRETTY_NAME/s/Silverblue/Lazyblue/' /usr/lib/os-release

