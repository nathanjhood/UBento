# shellcheck shell=sh

# If we are running the GNOME session, source ~/.gnomerc, but only if
# we're in Wayland mode. If we're in X11 mode, this will be done by
# /etc/X11/Xsession.d/55gnome-session_gnomerc instead.

if [ "${XDG_SESSION_TYPE-}" = wayland ]; then
    desktops="$(IFS=:; set -- "$XDG_CURRENT_DESKTOP"; echo "$@")"
    for desktop in $desktops; do
        [ "$desktop" = "GNOME" ] && break
    done
    unset desktops

    if [ "$desktop" != "GNOME" ]; then
        unset desktop
        return
    fi
    unset desktop

    GNOMERC="$HOME/.gnomerc"
    if [ -r "$GNOMERC" ]; then
        # shellcheck source=/dev/null
        . "$GNOMERC"
    fi
fi

# We prepend /usr/share/gnome since its defaults.list actually points
# to /etc so it is configurable. This is idempotent, so we can do this
# unconditionally.
if [ -z "$XDG_DATA_DIRS" ]; then
    XDG_DATA_DIRS=/usr/share/gnome:/usr/local/share/:/usr/share/
elif [ -n "${XDG_DATA_DIRS##*/usr/share/gnome*}" ]; then
    XDG_DATA_DIRS=/usr/share/gnome:"$XDG_DATA_DIRS"
fi
export XDG_DATA_DIRS
