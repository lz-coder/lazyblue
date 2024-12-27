#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Turtle for nautilus
dnf install python3-pygit2 python3-secretstorage nautilus-python meld
git clone https://gitlab.gnome.org/philippun1/turtle.git /tmp/turtle
python /tmp/turtle/install.py install

dnf install gnome-themes-extra sysprof gitg gstreamer1-plugin-openh264 openh264
dnf install podman-compose podman-docker podman-tui helix zsh tmux epiphany
dnf remove noopenh264 firefox firefox-langpacks gnome-software-rpm-ostree rpm-ostree

sed -i '/^PRETTY_NAME/s/Silverblue/Lazyblue/' /usr/lib/os-release

