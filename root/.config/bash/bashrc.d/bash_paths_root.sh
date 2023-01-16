
# Begin ~/.bash_paths_root.sh

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

# If not already defined, set XDG_CACHE_HOME to $HOME/.cache (if it exists)...
if [ -z "$XDG_CACHE_HOME" ] && [ -d "$HOME/.cache" ]; then
    XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -z "$XDG_CONFIG_HOME" ] && [ -d "$HOME/.config" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ] && [ -d "$HOME/.local/share" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_STATE_HOME" ] && [ -d "$HOME/.local/state" ]; then
    XDG_STATE_HOME="$HOME/.local/state"
fi

# If not already defined, set XDG_CACHE_HOME to $HOME/.cache (if it exists)...
if [ -z "$XDG_CACHE_HOME" ] && [ -d "$HOME/.cache" ]; then
    XDG_CACHE_HOME="$HOME/.cache"
fi

if [ -z "$XDG_CONFIG_HOME" ] && [ -d "$HOME/.config" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ] && [ -d "$HOME/.local/share" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_STATE_HOME" ] && [ -d "$HOME/.local/state" ]; then
    XDG_STATE_HOME="$HOME/.local/state"
fi

# If not already defined, set XDG_CACHE_HOME to $HOME/.cache (if it exists)
if [ -z "$XDG_DESKTOP_DIR" ] && [ -d "$HOME/Desktop" ]; then
    XDG_DESKTOP_DIR="$HOME/Desktop"
fi

if [ -z "$XDG_DOCUMENTS_DIR" ] && [ -d "$HOME/Documents" ]; then
    XDG_DOCUMENTS_DIR="$HOME/Documents"
fi

if [ -z "$XDG_DOWNLOADS_DIR" ] && [ -d "$HOME/Downloads" ]; then
    XDG_DOWNLOADS_DIR="$HOME/Downloads"
fi

if [ -z "$XDG_MUSIC_DIR" ] && [ -d "$HOME/Music" ]; then
    XDG_MUSIC_DIR="$HOME/Music"
fi

if [ -z "$XDG_PICTURES_DIR" ] && [ -d "$HOME/Pictures" ]; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

if [ -z "$XDG_PUBLICSHARE_DIR" ] && [ -d "$HOME/Public" ]; then
    XDG_PUBLICSHARE_DIR="$HOME/Public"
fi

if [ -z "$XDG_TEMPLATES_DIR" ] && [ -d "$HOME/Templates" ]; then
    XDG_TEMPLATES_DIR="$HOME/Templates"
fi

if [ -z "$XDG_VIDEOS_DIR" ] && [ -d "$HOME/Videos" ]; then
    XDG_VIDEOS_DIR="$HOME/Videos"
fi

# End ~/.bash_paths_root.sh
