
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

# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -x /usr/bin/dircolors ] && [ -f "$HOME/.dircolors" ]; then
    # enable color support of ls and also add handy aliases
    if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b "$HOME/.dircolors")

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
