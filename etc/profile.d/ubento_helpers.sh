# Aliases

# WSL
alias wsl="/mnt/c/Windows/System32/wsl.exe"

# Notepad
alias notepad="/mnt/c/Windows/System32/notepad.exe"

# WinRAR
alias winrar="/mnt/c/'Program Files'/WinRAR/WinRAR.exe"

# MS Colortool
alias colortool="/mnt/c/Users/{username}/.colortool/colortool.exe"

# VcXsrv
alias vcxsrv="/mnt/c/'Program Files'/VcXsrv/vcxsrv.exe &"

# XLaunch
alias xlaunch="/mnt/c/'Program Files'/VcXsrv/xlaunch.exe &"

# XAuth
alias xauth_win="/mnt/c/'Program Files'/VcXsrv/xauth.exe -f C://Users//{username}//.Xauthority"
alias xauth_lin="xauth"

# Apt Cache - clean
alias apt_cln='rm -rf /var/lib/apt/lists/*'

# UBento Init programs
alias at-spi-bus-launcher='/usr/libexec/at-spi-bus-launcher'
alias dbus-daemon='/usr/bin/dbus-daemon'


# Functions

sudo_autopasswd()
{
  :
  # echo "<your_ubuntu_wsl2_password>" | sudo -Svp ""
  # Default timeout for caching your sudo password: 15 minutes

  # If you're uncomfortable entering your password here,
  # you can comment out the line above. But keep in mind that functions
  # in a Bash script cannot be empty; comment lines are ignored.
  # A function should at least have a ':' (null command).
  # https://tldp.org/LDP/abs/html/functions.html#EMPTYFUNC

  # StoneyDSP EDIT: I'd like to find a way to capture our password using an
  # ecryption routine here to store our pwd into some kind of cookie file for
  # local re-use (xauth?)

  # Function courtesy of the X410 cookbook;
  # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
}

sudo_resetpasswd()
{
  # Clears cached password for sudo
  sudo -k

  # Function courtesy of the X410 cookbook;
  # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
}

settitle()
{
  echo -ne "\e]2;$@\a\e]1;$@\a";
}

set_runtime_dir()
{
  echo "Checking for XDG Runtime Dir..."

  if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    echo "XDG Runtime Dir not found..."
    {
      sudo_autopasswd
      # Create user runtime directories
      sudo mkdir $XDG_RUNTIME_DIR && sudo chmod 700 $XDG_RUNTIME_DIR && sudo chown $(id -un):$(id -gn) $XDG_RUNTIME_DIR

      # System D-Bus
      sudo service dbus start

      # --------------------
      # Start additional services as they are needed.
      # We recommend adding commands that require 'sudo' here. For other
      # regular background processes, you should add them below where a
      # session 'dbus-daemon' is started.
      # --------------------

      # sudo service network-manager start
      # sudo service mysql start
      # sudo service postgresql start
      # ...

      # Function courtesy of the X410 cookbook;
      # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
    }
    echo "Created new XDG Runtime Dir at $XDG_RUNTIME_DIR"
  else
    echo "Using active XDG Runtime Dir at $XDG_RUNTIME_DIR"
  fi
}

set_session_bus()
{
  echo "Checking session D_Bus..."

  local bus_file_path="$XDG_RUNTIME_DIR/bus"

  export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus_file_path

  if [ ! -e "$bus_file_path" ]; then
    echo "Session D-Bus not found..."
    {
      dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

      # --------------------
      # More background processes can be added here.
      # For 'sudo' requiring commands, you should add them above
      # where the 'dbus' service is started.
      # --------------------

      at-spi-bus-launcher --launch-immediately &

      # Function courtesy of the X410 cookbook;
      # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/

    }
    echo "Created session D-Bus at $DBUS_SESSION_BUS_ADDRESS"
  else
    echo "Using active D-Bus session at $DBUS_SESSION_BUS_ADDRESS"
  fi
}

auth_x()
{
    echo "$DISPLAY" 
    # Will print your encrypted X address...
    
    vcxsrv
    # Will launch your X-Server Windows executable...
    
    echo "Linux X Server keys:" && xauth_lin list
    
    echo "Windows X Server keys:" && xauth_win list
    
    # Authorize key on Linux side and pass to Windows
    xauth_lin add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN
    cp -f "$HOME/.Xauthority" "/mnt/c/Users/{username}/.Xauthority"
    xauth_win generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800
    
    # Vice-versa...
    xauth_win add $DISPLAY_ADDRESS:$DISPLAY_NUMBER . $DISPLAY_TOKEN
    cp -f "/mnt/c/Users/{username}/.Xauthority" "$HOME/.Xauthority"
    xauth_lin generate $DISPLAY_ADDRESS:$DISPLAY_NUMBER . trusted timeout 604800
    
    cp -f "$HOME/.Xauthority" "$HOME/.config/.Xauthority" # For backup/restoration...
    
    echo "Linux X Server keys:" && xauth_lin list
    
    echo "Windows X Server keys:" && xauth_win list
    
    # Could be a WSLENV translatable path? Or even a symlink to a Windows-side file?
    # "/mnt/c/Users/{username}/.Xauthority" = "C:\Users\{username}\.Xauthority"
}


## Global bin paths

if [ -d "/bin" ] ; then
    PATH="/bin:$PATH"
fi

if [ -d "/sbin" ] ; then
    PATH="/sbin:$PATH"
fi

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

if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi

if [ -d "/usr/local/pgsql/bin" ] ; then
    PATH="/usr/local/pgsql/bin:$PATH"
fi

export PATH


# Global info paths

if [ -d "/share/info" ] ; then
  INFOPATH="/share/info:$INFOPATH"
fi

if [ -d "/usr/info" ] ; then
  INFOPATH="/usr/info:$INFOPATH"
fi

if [ -d "/usr/share/info" ] ; then
  INFOPATH="/usr/share/info:$INFOPATH"
fi

if [ -d "/usr/local/info" ] ; then
  INFOPATH="/usr/local/info:$INFOPATH"
fi

export INFOPATH


## Global man paths

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

if [ -d "/usr/local/pgsql/share/man" ] ; then
    MANPATH="/usr/local/pgsql/share/man:$MANPATH"
fi

export MANPATH


## Global xdg paths - data

if [ -d "/usr/share" ] ; then
  XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"
fi

if [ -d "/usr/local/share" ] ; then
  XDG_DATA_DIRS="/usr/local/share:$XDG_DATA_DIRS"
fi

if [ -d "/usr/share/ubuntu" ] ; then
  XDG_DATA_DIRS="/usr/share/ubuntu:$XDG_DATA_DIRS"
fi

if [ -d "/var/lib/snapd/desktop" ] ; then
  XDG_DATA_DIRS="/var/lib/snapd/desktop:$XDG_DATA_DIRS"
fi

export XDG_DATA_DIRS


# Global xdg paths - config

if [ -d "/etc/xdg" ] ; then
  XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
fi

if [ -d "/etc/xdg/xdg-ubuntu" ] ; then
  XDG_CONFIG_DIRS="/etc/xdg/xdg-ubuntu:$XDG_CONFIG_DIRS"
fi

export XDG_CONFIG_DIRS

# WSLg helpers

# Screen number
export DISPLAY_NUMBER="0"

# Auth key
export DISPLAY_TOKEN="$(echo '{sudo_autopasswd | sudo_resetpasswd}' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )"

# Server address
export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )"

# Encrypted X session address
# export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"

# Unencrypted X session address (if authentication fails, swap the above for this...)
export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

#GL rendering
export LIBGL_ALWAYS_INDIRECT=1

# Set user-defined locale
# export LANG=$(locale -uU)
export CHARSET="UTF-8"
export PAGER="less"
export PS1='\h:\w\$ '

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=1

# Ubuntu default desktop (GNOME Shell variant)
# https://wiki.gnome.org/Projects/GnomeShell
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_SESSION_DESKTOP=ubuntu
export DESKTOP_SESSION=ubuntu
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_MENU_PREFIX=gnome-
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# https://www.postgresql.org/docs/13/install-post.html
export LD_LIBRARY_PATH="/usr/local/pgsql/lib"
export DATABASE_URL="postgresql://postgres:postgres@localhost:54322/postgres"

# System vars
export DISTRO="$(lsb_release -cs)"
export ARCH="$(dpkg --print-architecture)"
export APT_SOURCES="/etc/apt/sources.list.d"

# Runtime Dir
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
