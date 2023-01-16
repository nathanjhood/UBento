# /etc/profile.d/bash_paths.sh

# Begin /etc/profile.d/bash_paths.sh

## Global bin paths
if [ -d "/usr/bin" ] ; then
    PATH="/usr/bin:$PATH"
fi

if [ -d "/usr/sbin" ] ; then
    PATH="/usr/sbin:$PATH"
fi

if [ -d "/usr/local/bin" ] ; then
    PATH="/usr/local/bin:$PATH"
fi

if [ -d "/usr/local/sbin" ] ; then
    PATH="/usr/local/sbin:$PATH"
fi

# Global bin paths - extras
if [ -d "/usr/games" ] ; then
    PATH="/usr/games:$PATH"
fi

if [ -d "/usr/local/games" ] ; then
    PATH="/usr/local/games:$PATH"
fi

if [ -d "/usr/local/lib/pkgconfig" ] ; then
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
fi
#export PATH

# Global info paths
if [ -d "/usr/info" ] ; then
    INFOPATH="/usr/info:$INFOPATH"
fi

if [ -d "/usr/share/info" ] ; then
    INFOPATH="/usr/share/info:$INFOPATH"
fi

if [ -d "/usr/local/info" ] ; then
    INFOPATH="/usr/local/info:$INFOPATH"
fi
#export INFOPATH


## Global man paths (defaults; "/usr/local/man:/usr/share/man:/usr/man:/share/man" )
if [ -d "/share/man" ] ; then
    MANPATH="/share/man:$MANPATH"
fi

if [ -d "/usr/man" ] ; then
    MANPATH="/usr/man:$MANPATH"
fi

if [ -d "/usr/share/man" ] ; then
    MANPATH="/usr/share/man:$MANPATH"
fi

if [ -d "/usr/local/man" ] ; then
    MANPATH="/usr/local/man:$MANPATH"
fi
#export MANPATH


## Global xdg paths - data
if [ -d "/usr/share" ] ; then
    XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"

    if [ -d "/usr/share/ubuntu" ] ; then
        XDG_DATA_DIRS="/usr/share/ubuntu:$XDG_DATA_DIRS"
    fi
fi

if [ -d "/usr/local/share" ] ; then
    XDG_DATA_DIRS="/usr/local/share:$XDG_DATA_DIRS"
fi
#export XDG_DATA_DIRS


# Global xdg paths - config
if [ -d "/etc/xdg" ] ; then
    XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"

    if [ -d "/etc/xdg/xdg-ubuntu" ] ; then
        XDG_CONFIG_DIRS="/etc/xdg/xdg-ubuntu:$XDG_CONFIG_DIRS"
    fi
fi
#export XDG_CONFIG_DIRS

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Runtime Dir
# export XDG_RUNTIME_DIR="/run/user/$(id -u)" # for systemd
# export XDG_RUNTIME_DIR="/mnt/wslg/runtime-dir" # no systemd

export PATH INFOPATH MANPATH PKG_CONFIG_PATH LD_LIBRARY_PATH XDG_DATA_DIRS XDG_CONFIG_DIRS

# End /etc/profile.d/bash_paths.sh
