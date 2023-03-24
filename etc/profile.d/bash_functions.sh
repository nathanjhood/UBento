
## /etc/profile.d/bash_functions.sh

## Begin /etc/profile.d/bash_functions.sh

## Function adapted from the X410 cookbook;
## https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
set_runtime_dir()
{
    echo "Checking for XDG Runtime Dir..."

    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        {
        echo "XDG Runtime Dir not found..."
        # Create user runtime directories
        sudo mkdir "$XDG_RUNTIME_DIR"                     && \
        sudo chmod 700 "$XDG_RUNTIME_DIR"                 && \
        sudo chown $(id -un):$(id -gn) "$XDG_RUNTIME_DIR"
        echo "Created new XDG Runtime Dir at $XDG_RUNTIME_DIR"
        }
    else
        echo "Using active XDG Runtime Dir at $XDG_RUNTIME_DIR"
    fi
}

## Function adapted from the X410 cookbook;
## https://x410.dev/cookbook/wsl/running-ubuntu-desktop-in-wsl2/
set_session_bus()
{
    export DBUS_PATH="dbus-1"
    export DBUS_SOCK="session_bus_socket"
    local bus_file_path="$XDG_RUNTIME_DIR/$DBUS_PATH/$DBUS_SOCK"
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$bus_file_path"

    echo "Checking session D_Bus..."
    if [ ! -e "$bus_file_path" ]; then
        {
        echo "Session D-Bus not found..."
        sudo service dbus start
        /usr/bin/dbus-daemon --session --address="$DBUS_SESSION_BUS_ADDRESS" --nofork --nopidfile --syslog-only &
        /usr/libexec/at-spi-bus-launcher --launch-immediately --a11y=1 &
        /usr/bin/dbus-update-activation-environment --all --verbose &
        /usr/libexec/at-spi2-registryd --use-gnome-session --dbus-name=org.a11y.atspi.Registry &
        echo "Created session D-Bus at $DBUS_SESSION_BUS_ADDRESS"
        }
    else
        echo "Using active D-Bus session at $DBUS_SESSION_BUS_ADDRESS"
    fi
}


set_systemd()
{
    SYSTEMD_PID=$(ps -ef | grep '/lib/systemd/systemd --system-unit=basic.target$' | grep -v unshare | awk '{print $2}')
    if [ -z "$SYSTEMD_PID" ] || [ "$SYSTEMD_PID" != "1" ]; then
        export PRE_NAMESPACE_PATH="$PATH"
        (set -o posix; set) | \
            grep -v "^BASH" | \
            grep -v "^DIRSTACK=" | \
            grep -v "^EUID=" | \
            grep -v "^GROUPS=" | \
            grep -v "^HOME=" | \
            grep -v "^HOSTNAME=" | \
            grep -v "^HOSTTYPE=" | \
            grep -v "^IFS='.*"$'\n'"'" | \
            grep -v "^LANG=" | \
            grep -v "^LOGNAME=" | \
            grep -v "^MACHTYPE=" | \
            grep -v "^NAME=" | \
            grep -v "^OPTERR=" | \
            grep -v "^OPTIND=" | \
            grep -v "^OSTYPE=" | \
            grep -v "^PIPESTATUS=" | \
            grep -v "^POSIXLY_CORRECT=" | \
            grep -v "^PPID=" | \
            grep -v "^PS1=" | \
            grep -v "^PS4=" | \
            grep -v "^SHELL=" | \
            grep -v "^SHELLOPTS=" | \
            grep -v "^SHLVL=" | \
            grep -v "^SYSTEMD_PID=" | \
            grep -v "^UID=" | \
            grep -v "^USER=" | \
            grep -v "^_=" | \
            cat - > "$XDG_RUNTIME_DIR/.systemd_env"
        echo "PATH='$PATH'" >> "$XDG_RUNTIME_DIR/.systemd_env"
        #exec sudo /usr/sbin/enter-systemd-namespace "$BASH_EXECUTION_STRING"
    fi
    if [ -n "$PRE_NAMESPACE_PATH" ]; then
        export PATH="$PRE_NAMESPACE_PATH"
    fi
}
export -f set_systemd

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

## End /etc/profile.d/bash_functions.sh
