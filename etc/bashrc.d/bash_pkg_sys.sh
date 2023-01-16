
# Begin ~/bash_pkg.sh

if [ -d "/usr/share/pkgconfig" ] ; then
    PKG_CONFIG_PATH="/usr/share/pkgconfig:$PKG_CONFIG_PATH"
fi

if [ -d "/usr/lib/pkgconfig" ]; then
    PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

if [ -d "/usr/local/lib/pkgconfig" ] ; then
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

# End ~/bash_pkg.sh
