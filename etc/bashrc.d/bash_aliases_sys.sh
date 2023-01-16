# /etc/bashrc.d/bash_aliases.sh

# Aliases

# Some example alias instructions
# If these are enabled they will be used instead of any instructions they may mask.
# For example, alias rm='rm -i' will mask the rm application.
# To override the alias instruction use a \ before, ie \rm will call the real rm not the alias.

# Begin /etc/bashrc.d/bash_aliases.sh

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

# Some more ls aliases
# long list
alias ll='ls -l'
# all but . and ..
alias la='ls -A'
alias l='ls -CF'

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Tar shortcuts
alias tarc='tar cvf'
alias tarcz='tar czvf'
alias tarx='tar xvf'
alias tarxz='tar xvzf'

# Misc
# raw control characters
alias less='less -r'
# where, of a sort
alias whence='type -a'
# operating system
alias os='lsb_release -a'
# vim
alias vi='vim'
# git
alias g='git'

# Linux programs
alias at-spi-bus-launcher='/usr/libexec/at-spi-bus-launcher'
alias dbus-daemon='/usr/bin/dbus-daemon'

# WSL
alias wsl="/mnt/c/Windows/System32/wsl.exe"

# Notepad
alias notepad="/mnt/c/Windows/System32/notepad.exe"

# WinRAR
alias winrar="/mnt/c/'Program Files'/WinRAR/WinRAR.exe"

# Apt Cache - clean
alias apt_cln='rm -rf /var/lib/apt/lists/*'

# End /etc/bashrc.d/bash_aliases.sh
