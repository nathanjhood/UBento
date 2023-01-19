
## ~/.bash_profile

## Personal environment variables and startup programs.

## Personal aliases and functions should go in ~/.bashrc.
## System wide environment variables and startup programs are in /etc/profile.
## System wide aliases and functions are in /etc/bashrc.

## Begin ~/.bash_profile
echo "$0; # $USER loading $HOME/.bash_profile..."

## If running bash
if [ "$BASH" ]; then
    # Get the user's aliases and functions
    if [ -f "$HOME/.bashrc" ] ; then
        source "$HOME/.bashrc"
    fi
fi

if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    export PUBKEYPATH="$HOME/.ssh/id_ed25519.pub"
fi

echo "$0; # ...$USER loaded $HOME/.bash_profile"
## End ~/.bash_profile

## Startup commands can go here...
set_runtime_dir
#set_session_bus
#neofetch
mesg n 2> /dev/null || true
