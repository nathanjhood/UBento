
# Begin ~/bash_pkg.sh

# System vars
export DISTRO="$(lsb_release -cs)"
export ARCH="$(dpkg --print-architecture)"
export APT_SOURCES="/etc/apt/sources.list.d"

# For pkgconfig
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
