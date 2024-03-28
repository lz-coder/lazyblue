HOME_BIN="$HOME"/.local/bin
SKEL_DIR=/etc/skel.d
SKEL_DIR_BIN="$SKEL_DIR"/.local/bin


are_same_files() {
    if diff -sq $1 $2; then
        return 0
    else
        return 1
    fi
}

exists() {
    if test -e $1; then
        return 0
    else
        return 1
    fi
}

check() {
    if exists $2 && are_same_files $1 $2; then
        return 0
    else 
        return 1
    fi
}

if test "$(id -u)" -gt "0" && test -d "$HOME"; then

    if test ! -e "$HOME_BIN"; then
        mkdir -p "$HOME_BIN"
    fi

    if ! check "$SKEL_DIR_BIN"/toolbox-export "$HOME_BIN/toolbox-export"; then
        cp -f "$SKEL_DIR_BIN"/toolbox-export "$HOME_BIN"
    fi

    if ! check /bin/starship "$HOME_BIN"/starship; then
        cp -f /bin/starship "$HOME_BIN"
    fi


fi
