# shellcheck shell=bash

fpath+=("${HOME}/.zfunctions")

fpath=("${LOCAL_DIR}/lib/python3.11/site-packages/argcomplete/bash_completion.d" "${fpath[@]}")

autoload -U promptinit
promptinit

# zstyle ':prompt:purus:prompt:success' color green

prompt purus

autoload -U +X compinit
compinit

autoload -U +X bashcompinit
bashcompinit

autoload -U add-zsh-hook

export MANPAGER='nvim +Man!'

eval "$(register-python-argcomplete pipx)"

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "${nvmrc_path}" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "${nvmrc_node_version}" = "N/A" ]; then
      nvm install
    elif [ "${nvmrc_node_version}" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=${OLDPWD} nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# The Zsh options for reference:
# https://zsh.sourceforge.io/Doc/Release/Options.html
for file in ~/.zsh/*.zsh; do
  # shellcheck disable=SC1090
  source "${file}"
done
unset file
