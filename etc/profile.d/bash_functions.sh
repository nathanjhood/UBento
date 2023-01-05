# /etc/profile.d/bash_functions.sh

# Begin /etc/profile.d/bash_functions.sh

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)

pathremove () {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE} ; do
        if [ "$DIR" != "$1" ] ; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done
    export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
    pathremove $1 $2
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
    pathremove $1 $2
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# if [ -d "/usr/local/lib/pkgconfig" ] ; then
#     pathappend "/usr/local/lib/pkgconfig" PKG_CONFIG_PATH
# fi

# if [ -d "/usr/local/bin" ]; then
#     pathprepend "/usr/local/bin"
# fi

# if [ -d "/usr/local/sbin" -a $EUID -eq 0 ]; then
#     pathprepend "/usr/local/sbin"
# fi

# Append "$1" to $PATH when not already in.
# Copied from Arch Linux, see #12803 for details.
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
            ;;
    esac
}
# append_path "/usr/local/sbin"
# append_path "/usr/local/bin"
# append_path "/usr/sbin"
# append_path "/usr/bin"
# append_path "/sbin"
# append_path "/bin"
unset -f append_path

settitle()
{
    echo -ne "\e]2;$@\a\e]1;$@\a";
}

sudo_autopasswd()
{
  :
  # echo "<your_ubuntu_wsl2_password>" | sudo -Svp ""
  # Default timeout for caching your sudo password: 15 minutes

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
        # sudo service network-manager start
        # sudo service mysql start
        # sudo service postgresql start
        # ...

        }

        echo "Created new XDG Runtime Dir at $XDG_RUNTIME_DIR"

    else

        echo "Using active XDG Runtime Dir at $XDG_RUNTIME_DIR"

    fi

    # Function courtesy of the X410 cookbook;
    # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/

}

set_session_bus()
{
    echo "Checking session D_Bus..."

    local bus_file_path="$XDG_RUNTIME_DIR/bus"

    export DBUS_SESSION_BUS_ADDRESS="unix:path=$bus_file_path"

    if [ ! -e "$bus_file_path" ]; then

        echo "Session D-Bus not found..."

        {

        dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &
        at-spi-bus-launcher --launch-immediately &

        }

        echo "Created session D-Bus at $DBUS_SESSION_BUS_ADDRESS"

    else

        echo "Using active D-Bus session at $DBUS_SESSION_BUS_ADDRESS"

    fi

    # Function courtesy of the X410 cookbook;
    # https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
}

cdnvm() {
    command cd "$@" || return $?
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}
#alias cd='cdnvm'
#cd "$PWD"

# End /etc/profile.d/bash_functions.sh
