# The repository status will be displayed only if you are currently in a git repository.
# The %s token is the placeholder for the shown status.
#
# The prompt status always includes the current branch name.

# In addition, if you set GIT_PS1_SHOWDIRTYSTATE to a nonempty value, unstaged (*) and staged (+) changes will be shown next to the branch name.
# You can configure this per-repository with the bash.showDirtyState variable, which defaults to true once GIT_PS1_SHOWDIRTYSTATE is enabled.
GIT_PS1_SHOWDIRTYSTATE=1

# You can also see if currently something is stashed, by setting GIT_PS1_SHOWSTASHSTATE to a nonempty value.
# If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWSTASHSTATE=1

# If you would like to see if there're untracked files, then you can set GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value.
# If there're untracked files, then a '%' will be shown next to the branch name.
# You can configure this per-repository with the bash.showUntrackedFiles variable, which defaults to true once GIT_PS1_SHOWUNTRACKEDFILES is enabled.
GIT_PS1_SHOWUNTRACKEDFILES=1

# If you would like to see the difference between HEAD and its upstream, set GIT_PS1_SHOWUPSTREAM="auto".
# A "<" indicates you are behind, ">" indicates you are ahead, "<>" indicates you have diverged and "=" indicates that there is no difference.
# You can further control behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list of values:
#
#     verbose       show number of commits ahead/behind (+/-) upstream
#     name          if verbose, then also show the upstream abbrev name
#     legacy        don't use the '--count' option available in recent versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream
#
# By default, __git_ps1 will compare HEAD to your SVN upstream if it can find one, or @{upstream} otherwise.
# Once you have set GIT_PS1_SHOWUPSTREAM, you can override it on a per-repository basis by setting the bash.showUpstream config variable.
GIT_PS1_SHOWUPSTREAM="auto"

# You can change the separator between the branch name and the above state symbols by setting GIT_PS1_STATESEPARATOR.
# The default separator is SP.
GIT_PS1_STATESEPARATOR=" "

# When there is an in-progress operation such as a merge, rebase, revert, cherry-pick, or bisect, the prompt will include information related to the operation, often in the form "|<OPERATION-NAME>".
# When the repository has a sparse-checkout, a notification of the form "|SPARSE" will be included in the prompt.
# This can be shortened to a single '?' character by setting GIT_PS1_COMPRESSSPARSESTATE, or omitted by setting GIT_PS1_OMITSPARSESTATE.

# If you would like to see a notification on the prompt when there are unresolved conflicts, set GIT_PS1_SHOWCONFLICTSTATE to "yes".
# The prompt will include "|CONFLICT".
GIT_PS1_SHOWCONFLICTSTATE="yes"

# If you would like to see more information about the identity of commits checked out as a detached HEAD, set GIT_PS1_DESCRIBE_STYLE to one of these values:
#
#     contains      relative to newer annotated tag (v1.6.3.2~35)
#     branch        relative to newer tag or branch (master~4)
#     describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#     tag           relative to any older tag (v1.6.3.1-13-gdd42c2f)
#     default       exactly matching tag
#
# If you would like a colored hint about the current dirty state, set GIT_PS1_SHOWCOLORHINTS to a nonempty value.
GIT_PS1_SHOWCOLORHINTS="1"

# If you would like __git_ps1 to do nothing in the case when the current directory is set up to be ignored by git, then set GIT_PS1_HIDE_IF_PWD_IGNORED to a nonempty value.
# Override this on the repository level by setting bash.hideIfPwdIgnored to "false".
GIT_PS1_HIDE_IF_PWD_IGNORED="1"
