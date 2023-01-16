
if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi

if [ -d "/var/lib/snapd/desktop" ] ; then
    XDG_DATA_DIRS="/var/lib/snapd/desktop:$XDG_DATA_DIRS"
fi
