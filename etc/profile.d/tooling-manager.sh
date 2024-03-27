if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.local/bin/toolbox-export; then
        mkdir -p "$HOME"/.local/bin/
        cp -f /etc/skel.d/.local/bin/toolbox-export "$HOME"/.local/bin
    fi
fi
