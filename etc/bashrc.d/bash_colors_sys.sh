# /etc/profile.d/bash_colors.sh

# Begin /etc/profile.d/bash_colors.sh

# Foreground colors
NORMAL="\[\e[0m\]"
BLACK="\[\e[1;30m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
BLUE="\[\e[1;34m\]"
MAGENTA="\[\e[1;35m\]"
CYAN="\[\e[1;36m\]"
WHITE="\[\e[1;37m\]"

LIGHT_BLACK="\[\e[1;90m\]"
LIGHT_RED="\[\e[1;91m\]"
LIGHT_GREEN="\[\e[1;92m\]"
LIGHT_YELLOW="\[\e[1;93m\]"
LIGHT_BLUE="\[\e[1;94m\]"
LIGHT_MAGENTA="\[\e[1;95m\]"
LIGHT_CYAN="\[\e[1;96m\]"
LIGHT_WHITE="\[\e[1;97m\]"

GIT_PS='$(__git_ps1 " (%s)") '
SYMB="#"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -x /usr/bin/dircolors ]; then
    # enable color support of ls and also add handy aliases
    if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b "/etc/dircolors")

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

# Setup a normal prompt for root and a green one for users.
# Provides prompt for non-login shells, specifically shells started in the X environment.
# [Review the LFS archive thread titled 'PS1 Environment Variable' for a great case study behind this script addendum.]
# uncomment for a colored prompt, if the terminal has the capability;
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ $EUID == 0 ]] ; then
        PS1="$RED\u$NORMAL@$RED\h$NORMAL:$BLUE[ $NORMAL\w $BLUE] $YELLOW\n$SYMB $NORMAL"
    else
        if [ "$USER" = root ]; then
            PS1="${debian_chroot:+($debian_chroot)}$RED\u$NORMAL@$RED\h$NORMAL:$BLUE[ $NORMAL\w $BLUE] $YELLOW\n$SYMB $NORMAL"
        else
            SYMB="\$"
            PS1="${debian_chroot:+($debian_chroot)}$GREEN\u$NORMAL@$GREEN\h$NORMAL:$BLUE[ $NORMAL\w $GIT_PS$BLUE] $YELLOW\n$SYMB $NORMAL"
        fi
    fi
else
    if [[ $EUID == 0 ]] ; then
        PS1="\u [ \w ]\n$SYMB "
    else
        if [ "$USER" = root ]; then
            PS1="${debian_chroot:+($debian_chroot)}\u@\h: [ \w ]\n$SYMB "
        else
            SYMB="\$"
            PS1="${debian_chroot:+($debian_chroot)}\u@\h: [ \w $GIT_PS]\n$SYMB "
        fi
    fi
fi
unset color_prompt force_color_prompt

# End /etc/profile.d/bash_colors.sh
