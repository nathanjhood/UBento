
## WSLg helpers

## Begin /etc/profile.d/bash_wslg.sh

# Auth files
export ICEAUTHORITY="$XDG_RUNTIME_DIR/ICEauthority"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Auth apps
alias iceauth='iceauth -f $ICEAUTHORITY'
alias xauth='xauth -f $XAUTHORITY'

## Screen number
export DISPLAY_NUMBER="0"

## Auth key
export DISPLAY_TOKEN="$(cat '/etc/resolv.conf' | tr -d '\n\r' | md5sum | gawk '{print $1;}' )"

## Server address
export DISPLAY_ADDRESS="$(cat '/etc/resolv.conf' | grep nameserver | awk '{print $2; exit;}' )"

## Encrypted X session address
#export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.$DISPLAY_TOKEN"

## Unencrypted X session address (if authentication fails, swap the above for this...)
#export DISPLAY="$DISPLAY_ADDRESS:$DISPLAY_NUMBER.0"

## GL rendering
export LIBGL_ALWAYS_INDIRECT=""
export GDK_BACKEND="x11"

## End /etc/profile.d/bash_wslg.sh
