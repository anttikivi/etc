# shellcheck source=./zshenv
if [ -e ~/.zshenv ]; then
  source ~/.zshenv
fi

pathmunge() {
  if ! echo "${PATH}" | grep -Eq "(^|:)$1($|:)"; then
    if [ "$2" = "after" ]; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
  fi
}

# TODO: It might be that `PATH` should be set in `.zshrc` on Linux.
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

pathmunge "${LOCAL_BIN_DIR}"
pathmunge "/usr/local/go/bin"
pathmunge "${GOBIN}"
pathmunge "${LOCAL_OPT_DIR}/nvim/bin"

if [ -e "${HOME}/.cargo/env" ]; then
  # shellcheck source=../.cargo/env
  source "${HOME}/.cargo/env"
fi

command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
# shellcheck source=../.config/nvm/nvm.sh
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

GCLOUD_SDK_DIR="${LOCAL_OPT_DIR}/google-cloud-sdk"
export GCLOUD_SDK_DIR
if [ -f "${GCLOUD_SDK_DIR}/path.zsh.inc" ]; then
  # shellcheck source=../.local/opt/google-cloud-sdk/path.zsh.inc
  source "${GCLOUD_SDK_DIR}/path.zsh.inc"
fi
# vi: ft=sh
