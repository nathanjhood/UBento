
## History Options

## Begin ~/.bash_history.sh

## Setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

## Don't put duplicate lines in the history...
HISTCONTROL="$HISTCONTROL${HISTCONTROL+,}ignoredups"

## ...or, force ignoredups and ignorespace
# export HISTCONTROL=ignoredups:ignorespace


## Ignore some controlling instructions. HISTIGNORE is a colon-delimited list of patterns which should be excluded. The '&' is a special pattern which suppresses duplicate entries...
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'

## ...ignore the ls command as well
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'

## Whenever displaying the prompt, write the previous line to disk
PROMPT_COMMAND="history -a"

## End ~/.bash_history.sh
