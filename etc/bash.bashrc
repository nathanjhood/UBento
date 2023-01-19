
## /etc/bash.bashrc

## System-wide aliases and functions.

## To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty. You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <https://creativecommons.org/publicdomain/zero/1.0/>.

## It's NOT a good idea to change this file unless you know what you are doing. It's much better to create a custom.sh shell script in /etc/profile.d/ to make custom changes to your environment, as this will prevent the need for merging in future updates.

## System-wide environment variables and startup programs should go in /etc/profile.
## Personal environment variables and startup programs should go in ~/.bash_profile.
## Personal aliases and functions should go in ~/.bashrc.

# To enable the settings / commands in this file for login shells aswell, this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Begin /etc/bash.bashrc
echo "$0; # $USER loading /etc/bash.bashrc..."

if [ -d "/etc/bashrc.d" ]; then
    for script in "/etc/bashrc.d"/*.sh ; do
        if [ -r $script ]; then
            source $script
        fi
    done
    unset script
fi

if test -n "$SSH_CONNECTION" -a -z "$PROFILEREAD"; then
    . "/etc/profile" > /dev/null 2>&1
fi

## Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
## If this is an xterm set the title to user@host:dir

#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

## sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.

	EOF
    fi
    esac
fi

## if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
        fi
    }
fi

echo "$0; # ...$USER loaded /etc/bash.bashrc"
## End /etc/bash.bashrc
