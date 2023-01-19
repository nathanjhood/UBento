
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
    export DBUS_PATH="bus"
    local bus_file_path="$XDG_RUNTIME_DIR/$DBUS_PATH"
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$bus_file_path"

    echo "Checking session D_Bus..."
    if [ ! -e "$bus_file_path" ]; then
        {
        echo "Session D-Bus not found..."
        /usr/bin/dbus-daemon --session --address="$DBUS_SESSION_BUS_ADDRESS" --nofork --nopidfile --syslog-only && \
        /usr/libexec/at-spi-bus-launcher --launch-immediately && \
        /usr/bin/dbus-update-activation-environment --all --verbose --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &
        echo "Created session D-Bus at $DBUS_SESSION_BUS_ADDRESS"
        }
    else
        echo "Using active D-Bus session at $DBUS_SESSION_BUS_ADDRESS"
    fi
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

## End /etc/profile.d/bash_functions.sh
