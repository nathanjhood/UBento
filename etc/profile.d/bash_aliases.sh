# /etc/profile.d/bash_aliases.sh

# Aliases

# Begin /etc/profile.d/bash_aliases.sh

# color-grep initialization
[ -f /usr/libexec/grepconf.sh ] || return
#/usr/libexec/grepconf.sh -c || return

# color grep
alias grep='grep --color=auto' 2>/dev/null
alias egrep='egrep --color=auto' 2>/dev/null
alias fgrep='fgrep --color=auto' 2>/dev/null

# color zgrep
alias zgrep='zgrep --color=auto' 2>/dev/null
alias zfgrep='zfgrep --color=auto' 2>/dev/null
alias zegrep='zegrep --color=auto' 2>/dev/null

# color ls
alias ll='ls -l --color=auto' 2>/dev/null
alias l.='ls -d .* --color=auto' 2>/dev/null
alias ls='ls --color=auto' 2>/dev/null


# WSL
alias wsl="/mnt/c/Windows/System32/wsl.exe"

# Notepad
alias notepad="/mnt/c/Windows/System32/notepad.exe"

# WinRAR
alias winrar="/mnt/c/'Program Files'/WinRAR/WinRAR.exe"

# Apt Cache - clean
alias apt_cln='rm -rf /var/lib/apt/lists/*'

# Linux programs
alias at-spi-bus-launcher='/usr/libexec/at-spi-bus-launcher'
alias dbus-daemon='/usr/bin/dbus-daemon'

# End /etc/profile.d/bash_aliases.sh
