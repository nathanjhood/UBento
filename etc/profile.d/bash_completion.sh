# /etc/profile.d/bash_completion.sh

# shellcheck shell=sh disable=SC1091,SC2039,SC2166

# Check for interactive bash and that we haven't already been sourced.
if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then

    # Check for recent enough version of bash.
    if [ "${BASH_VERSINFO[0]}" -gt 4 ] ||
        [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -r "/usr/share/bash-completion/bash_completion" ]; then
            # Source completion code.
            source "/usr/share/bash-completion/bash_completion"
        fi
    fi

fi

# # check for interactive bash and only bash
# if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then

#     # enable bash completion in interactive shells
#     if ! shopt -oq posix; then

#         if [ -f "/usr/share/bash-completion/bash_completion" ]; then
#             source "/usr/share/bash-completion/bash_completion"
#         fi

#     fi

# fi
