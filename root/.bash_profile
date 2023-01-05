# ~/.bash_profile

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.
# System wide environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

# executed by Bourne-compatible login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# Begin ~/.bash_profile
echo "$0; # $USER loading $HOME/.bash_profile..."

# If running bash
if [ "$BASH" ]; then
    # Get the user's aliases and functions
    if [ -f "$HOME/.bashrc" ] ; then
        source "$HOME/.bashrc"
    fi
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "$HOME/man" ]; then
    MANPATH="$HOME/man:$MANPATH"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "$HOME/info" ]; then
    INFOPATH="$HOME/info:$INFOPATH"
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#    pathappend .
#fi

export PATH MANPATH INFOPATH


## https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
fi

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

export USER_AT_HOST="$USER@$HOSTNAME"
# export PUBKEYPATH="$HOME\.ssh\id_ed25519.pub"

echo "$0; # ...$USER loaded $HOME/.bash_profile"
# End ~/.bash_profile

# Startup commands
mesg n 2> /dev/null || true
