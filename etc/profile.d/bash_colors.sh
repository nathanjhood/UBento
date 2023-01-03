# /etc/profile.d/bash_colors.sh

# Begin /etc/profile.d/bash_colors.sh

# Set some bash colors
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
SYMB="#"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Setup a normal prompt for root and a green one for users.
# Provides prompt for non-login shells, specifically shells started in the X
# environment. [Review the LFS archive thread titled 'PS1 Environment Variable'
# for a great case study behind this script addendum.]
if [[ $EUID == 0 ]] ; then

    PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"

else

    if [ "$USER" = root ]; then

        SYMB="#"
        PS1="$NORMAL\h [$NORMAL\w$NORMAL]# $NORMAL"

    else

        SYMB="$"
        PS1="$GREEN\h [$NORMAL\w$GREEN]\$ $NORMAL"

    fi

fi
unset NORMAL RED GREEN SYMB


#when USER_LS_COLORS defined do not override user LS_COLORS, but use them.
if [ -z "$USER_LS_COLORS" ]; then

    alias ll='ls -l' 2>/dev/null
    alias l.='ls -d .*' 2>/dev/null

    INCLUDE=
    COLORS=

    for colors in "$HOME/.dir_colors.$TERM" "$HOME/.dircolors.$TERM" \
        "$HOME/.dir_colors" "$HOME/.dircolors"; do
        [ -e "$colors" ] && COLORS="$colors" && \
        INCLUDE="`/usr/bin/cat "$COLORS" | /usr/bin/grep '^INCLUDE' | /usr/bin/cut -d ' ' -f2-`" && \
        break
    done

    [ -z "$COLORS" ] && [ -e "/etc/DIR_COLORS.$TERM" ] && \
    COLORS="/etc/DIR_COLORS.$TERM"

    [ -z "$COLORS" ] && [ -e "/etc/DIR_COLORS" ] && \
    COLORS="/etc/DIR_COLORS"

    # Existence of $COLORS already checked above.
    [ -n "$COLORS" ] || return

    if [ -e "$INCLUDE" ];
    then
        TMP="`/usr/bin/mktemp .colorlsXXX -q --tmpdir=/tmp`"
        [ -z "$TMP" ] && return

        /usr/bin/cat "$INCLUDE" >> $TMP
        /usr/bin/grep -v '^INCLUDE' "$COLORS" >> $TMP

        eval "`/usr/bin/dircolors --sh $TMP 2>/dev/null`"
        /usr/bin/rm -f $TMP
    else
        eval "`/usr/bin/dircolors --sh $COLORS 2>/dev/null`"
    fi

    [ -z "$LS_COLORS" ] && return
    /usr/bin/grep -qi "^COLOR.*none" $COLORS >/dev/null 2>/dev/null && return
fi
unset TMP COLORS INCLUDE

# End /etc/profile.d/bash_colors.sh
