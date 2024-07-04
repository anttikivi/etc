# +--------------------------------+
# | Navigation and directory stack |
# +--------------------------------+

alias -- -="cd -"
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias _="sudo "

alias d="dirs -v"
for index ({1..9}) alias "$index"="cd +${index} > /dev/null"; unset index # directory stack

# +----+
# | ls |
# +----+

alias ls="ls --color=auto"
alias l="ls -lh"
alias la="ls -lAh"
alias ll="ls -lAhF"
alias lls="ls -lAhFtr"
alias lc="ls -CF"

# +-----------------+
# | File operations |
# +-----------------+

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias md="mkdir -p"
alias rd="rmdir"

# +------+
# | grep |
# +------+

alias grep="grep --color"

# +-------+
# | clear |
# +-------+

alias cls="tput reset"

# +--------+
# | whence |
# +--------+
# Make the aliases for the different command implementations explicit.

alias which="whence -c"
alias type="whence -v"
alias where="whence -ca"

# +----+
# | du |
# +----+

alias duf="du -sh * | sort -hr"

# +------+
# | nvim |
# +------+

alias vi="nvim"
alias vim="nvim"

# +----------------+
# | Pipe shortcuts |
# +----------------+

alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"

# +------+
# | tmux |
# +------+

alias td="tmux detach"
alias tks="tmux kill-server"
alias tls="tmux list-sessions"

# +-----------+
# | Terraform |
# +-----------+

alias tf="terraform"
alias terrafrom="terraform"
