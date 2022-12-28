
# ~/.profile: executed by the command interpreter for login shells.

# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <https://creativecommons.org/publicdomain/zero/1.0/>.

# User dependent .profile file;
# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.

echo "$USER loading $HOME/.profile..."

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
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

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"
export XDG_CONFIG_HOME="$HOME/.config"

export USER_AT_HOST="$USER@$HOSTNAME"

echo "...$USER loaded $HOME/.profile"

# Startup commands
mesg n 2> /dev/null || true
