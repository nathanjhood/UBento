
## /etc/profile.d/bash_exports.sh

## Begin /etc/profile.d/bash_exports.sh

## WSLg helpers

## Screen number
export DISPLAY_NUMBER="0"

## Auth key
export DISPLAY_TOKEN="$(echo '{sudo_autopasswd | sudo_resetpasswd}' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )"

## Server address
export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )"

## Encrypted X session address
#export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"

## Unencrypted X session address (if authentication fails, swap the above for this...)
#export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

## GL rendering
#export LIBGL_ALWAYS_INDIRECT=1

## Desktop defaults (if not set yet)
if [ -z "$DESKTOP_SESSION" ]; then
    export DESKTOP_SESSION="ubuntu"
fi

if [ -z "$GNOME_SHELL_SESSION_MODE" ]; then
    export GNOME_SHELL_SESSION_MODE="ubuntu"
fi

## Ubuntu default desktop (GNOME Shell variant)
if [ -z "$XDG_CURRENT_DESKTOP" ]; then
    export XDG_CURRENT_DESKTOP="ubuntu:GNOME"
fi

if [ -z "$XDG_SESSION_DESKTOP" ]; then
    export XDG_SESSION_DESKTOP="ubuntu"
fi

if [ -z "$XDG_MENU_PREFIX" ]; then
    export XDG_MENU_PREFIX="gnome-"
fi

if [ -z "$XDG_SESSION_TYPE" ]; then
    export XDG_SESSION_TYPE="x11"
fi

if [ -z "$XDG_SESSION_CLASS" ]; then
    export XDG_SESSION_CLASS="user"
fi

## End /etc/profile.d/bash_exports.sh
