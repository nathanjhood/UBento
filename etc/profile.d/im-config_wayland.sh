# /etc/profile.d/im-config_wayland.sh
#
# This sets the IM variables on Wayland.

if [ "$XDG_SESSION_TYPE" != 'wayland' ]; then
    return
fi

# don't do anything if im-config was removed but not purged
if [ ! -r /usr/share/im-config/xinputrc.common ]; then
    return
fi

if [ -r /etc/X11/Xsession.d/70im-config_launch ]; then
    . /etc/X11/Xsession.d/70im-config_launch
fi
