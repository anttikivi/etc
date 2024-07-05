alias reload="source ~/.zshrc"

alias -- -="cd -"
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias _="sudo "

alias d="dirs -v"

# Directory stack
for index in {1..9}; do
  alias "$index"="cd +${index} > /dev/null"
done
unset index

alias ls="ls --color=auto"
alias l="ls -lh"
alias la="ls -lAh"
alias ll="ls -lAhF"
alias lls="ls -lAhFtr"
alias lc="ls -CF"

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias md="mkdir -p"
alias rd="rmdir"

alias grep="grep --color"

alias cls="tput reset"

# Make the aliases for the different command implementations explicit.
alias which="whence -c"
alias type="whence -v"
alias where="whence -ca"

alias duf="du -sh * | sort -hr"

alias vi="nvim"
alias vim="nvim"

alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"

alias td="tmux detach"
alias tks="tmux kill-server"
alias tls="tmux list-sessions"

alias tf="terraform"
alias terrafrom="terraform"
