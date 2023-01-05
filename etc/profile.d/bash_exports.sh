# /etc/profile.d/bash_exports.sh

# Begin /etc/profile.d/bash_exports.sh

## WSLg helpers

# Screen number
export DISPLAY_NUMBER="0"

# Auth key
export DISPLAY_TOKEN="$(echo '{sudo_autopasswd | sudo_resetpasswd}' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )"

# Server address
export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )"

# Encrypted X session address
# export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"

# Unencrypted X session address (if authentication fails, swap the above for this...)
#export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

#GL rendering
export LIBGL_ALWAYS_INDIRECT=1

# Set user-defined locale
export CHARSET="UTF-8"
export PAGER="less"
export PS1='\h:\w\$ '

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=1

# Desktop
export DESKTOP_SESSION=ubuntu
export GNOME_SHELL_SESSION_MODE=ubuntu

# Ubuntu default desktop (GNOME Shell variant)
# https://wiki.gnome.org/Projects/GnomeShell
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_SESSION_DESKTOP=ubuntu
export XDG_MENU_PREFIX=gnome-
export XDG_SESSION_TYPE=xwayland # default = x11
export XDG_SESSION_CLASS=user

# System vars
export DISTRO="$(lsb_release -cs)"
export ARCH="$(dpkg --print-architecture)"
export APT_SOURCES="/etc/apt/sources.list.d"

# End /etc/profile.d/bash_exports.sh
