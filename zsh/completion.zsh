unsetopt MENU_COMPLETE
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt COMPLETE_IN_WORD

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'

[[ -r "${NVM_DIR}/bash_completion" ]] && \. "${NVM_DIR}/bash_completion"

complete -o nospace -C /opt/homebrew/bin/terraform terraform

if [ -f "${GCLOUD_SDK_DIR}/completion.zsh.inc" ]; then
  source "${GCLOUD_SDK_DIR}/completion.zsh.inc"
fi
