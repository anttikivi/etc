setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt CHASE_LINKS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME

function d() {
  if [[ -n "$1" ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d
