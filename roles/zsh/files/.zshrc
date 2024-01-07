export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="anttikivi"
ZSH_CUSTOM="$HOME/dotfiles/zsh"

plugins=(git)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

export CC="clang"
