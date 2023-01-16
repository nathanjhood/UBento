
# Shell Options

# See man bash for more options...

# Begin ~/bash_options.sh

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

# End ~/bash_options.sh
