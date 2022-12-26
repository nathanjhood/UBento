
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

echo "$USER loading $HOME/.bashrc..."

# History Options

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
# HISTCONTROL=ignoredups:ignorespace

# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'

# Ignore the ls command as well
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

# Shell Options

# See man bash for more options...

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
set -o ignoreeof




# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
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

export CLICOLOR="1"
if [ "$color_prompt" = yes ]; then

  if [ "GIT_PS1_SHOWDIRTYSTATE" = "1" ]; then
     export PS1="\[\033[40m\]\[\033[34m\][ \u@\H:\[\033[36m\]\w\$(__git_ps1 \" \[\033[35m\]{\[\033[32m\]%s\[\033[35m\]}\")\[\033[34m\] ]$\[\033[0m\] "
  else
     export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi
else
  if [ "GIT_PS1_SHOWDIRTYSTATE" = "1" ]; then
    export PS1="\[\033[40m\]\[\033[34m\][ \u@\H:\[\033[36m\]\w\[\033[34m\] ]$\[\033[0m\] "
  else
    export PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Aliases

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

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

# Some more ls aliases
# long list
alias ll='ls -l'
# all but . and ..
alias la='ls -A'
alias l='ls -CF'

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # classify files in colour
    alias ls='ls -hF --color=tty'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    # show differences in colour
    alias grep='grep --color'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi

# Colorize grep
if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS="--color=auto" GREP_COLOR="1;31"
fi

echo "...$USER loaded $HOME/.bashrc"
