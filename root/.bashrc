
## ~/.bashrc

## Personal aliases and functions.

## Personal environment variables and startup programs should go in ~/.bash_profile.
## System wide environment variables and startup programs are in /etc/profile.
## System wide aliases and functions are in /etc/bashrc.

## If not running interactively, don't do anything
[ -z "$PS1" ] && return

## Begin ~/.bashrc
echo "$0; # $USER loading $HOME/.bashrc..."

## User specific aliases and functions
if [ -d "$HOME/.config/bash/bashrc.d" ]; then
    for rc in "$HOME/.config/bash/bashrc.d"/*; do
        if [ -f "$rc" ]; then
            source "$rc"
        fi
    done
    unset rc
fi

## make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

## Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -x /usr/bin/dircolors ]; then
    # enable color support of ls and also add handy aliases
    if [ -f "~/dircolors" ] ; then
        eval $(dircolors -b ~/dircolors)

        # classify files in colour
        alias ls='ls -hF --color=tty'
        alias dir='ls --color=auto --format=vertical'
        alias vdir='ls --color=auto --format=long'

        # show differences in colour
        alias grep='grep --color'
        alias egrep='egrep --color=auto'
        alias fgrep='fgrep --color=auto'
    fi
fi

## Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

echo "$0; # ...$USER loaded $HOME/.bashrc"
# End ~/.bashrc
