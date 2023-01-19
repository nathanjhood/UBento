
## ~/.bash_logout

## Executed by bash(1) when login shell exits.

## Begin ~/.bash_logout

#€ When leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

## End ~/.bash_logout
