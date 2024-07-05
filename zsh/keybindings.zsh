bindkey -v
# bindkey "^C" vi-cmd-mode

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

bindkey -s ^f "tmux-sessionizer\n"

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
