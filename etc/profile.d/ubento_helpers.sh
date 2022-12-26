
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


export XDG_RUNTIME_DIR="/run/user/$(id -u)"


# WSLg helpers

export DISPLAY_NUMBER="0"
export magiccookie="$(echo '{vcxsrv}'|tr -d '\n\r'|md5sum|gawk '{print $1}')"
# export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}' ):$DISPLAY_NUMBER.$magiccookie
export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}' ):$DISPLAY_NUMBER.0"
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

# Commonly referenced environment variables for X11 sessions
# https://specifications.freedesktop.org/basedir-spec/latest/

export DISTRO="$(lsb_release -s -c)"
export ARCH="$(dpkg --print-architecture)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# https://www.postgresql.org/docs/13/install-post.html
export LD_LIBRARY_PATH="/usr/local/pgsql/lib"
export DATABASE_URL="postgresql://postgres:postgres@localhost:54322/postgres"


# Aliases

alias wsl="/mnt/c/Windows/System32/wsl.exe"

alias colortool="/mnt/c/Users/Nathan/.colortool/colortool.exe"

alias vcx_srv="/mnt/c/'Program Files'/VcXsrv/vcxsrv.exe"

alias x_launch="/mnt/c/'Program Files'/VcXsrv/xlaunch.exe"

alias x_auth="/mnt/c/'Program Files'/VcXsrv/xauth.exe -f 'C:\Users\Nathan\.Xauthority'"

alias notepad="/mnt/c/Windows/System32/notepad.exe"

alias winrar="/mnt/c/'Program Files'/WinRAR/WinRAR.exe"

# alias launch_x="vcxsrv -multiwindow -clipboard -wgl -auth 'C:\Users\Nathan\.Xauthority' -logfile 'C:\Users\Nathan\VcXSrv.log' -log>

alias at-spi-bus-launcher='/usr/libexec/at-spi-bus-launcher'
alias dbus-daemon='/usr/bin/dbus-daemon'

# 2>/dev>null &


# Functions

sudo_autopasswd()
{
  echo "<your_ubuntu_wsl2_password>" | sudo -Svp ""
  # Default timeout for caching your sudo password: 15 minutes

  # If you're uncomfortable entering your password here,
  # you can comment out the line above. But keep in mind that functions
  # in a Bash script cannot be empty; comment lines are ignored.
  # A function should at least have a ':' (null command).
  # https://tldp.org/LDP/abs/html/functions.html#EMPTYFUNC
}

sudo_resetpasswd()
{
  # Clears cached password for sudo
  sudo -k
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
      # Create user runtime directories
      mkdir $XDG_RUNTIME_DIR && chmod 700 $XDG_RUNTIME_DIR && chown $(id -un):$(id -gn) $XDG_RUNTIME_DIR

      # System D-Bus
      # service dbus start

      # --------------------
      # Start additional services as they are needed.
      # We recommend adding commands that require 'sudo' here. For other
      # regular background processes, you should add them below where a
      # session 'dbus-daemon' is started.
      # --------------------

      # service network-manager start
      # service mysql start
      # service postgresql start
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
      /usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

      # --------------------
      # More background processes can be added here.
      # For 'sudo' requiring commands, you should add them above
      # where the 'dbus' service is started.
      # --------------------

      /usr/libexec/at-spi-bus-launcher --launch-immediately &

    }
    echo "Created session D-Bus at $DBUS_SESSION_BUS_ADDRESS"
  else
    echo "Using active D-Bus session at $DBUS_SESSION_BUS_ADDRESS"
  fi
}

# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}



get_gith()
{
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | tee /usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null

    echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list

    apt update
}

get_node()
{
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_19.x $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nodesource.list

    echo "deb-src [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_19.x $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/nodesource.list

    apt update

    # apt install nodejs
}

get_yarn()
{
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null

    echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

    apt update

    # apt install yarn
}

get_pgadmin()
{
    curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

    echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list

    apt update
}

get_cmake()
{
    # wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

    curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

    echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list

    apt update

    # apt install kitware-archive-keyring cmake cmake-data cmake-doc ninja-build
}

get_chrome()
{
    curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$XDG_DOWNLOAD_DIR/chrome.deb"

    apt install "$XDG_DOWNLOAD_DIR/chrome.deb"
}

get_supabase()
{
    "curl https://github.com/supabase/cli/releases/download/v1.25.0/supabase_1.25.0_linux_amd64.deb" -o "$XDG_DOWNLOAD_DIR/supabase.deb"

    apt install "$XDG_DOWNLOAD_DIR/supabase_1.25.0_linux_amd64.deb"
}

get_nvm()
{
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh" | bash
}

get_postman()
{
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | bash
}

get_vcpkg_tool()
{
    . <(curl https://aka.ms/vcpkg-init.sh -L)

    . ~/.vcpkg/vcpkg-init
}
