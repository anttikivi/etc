typeset -U path PATH

# TODO: It might be that `PATH` should be set in `.zshrc` on Linux.
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

path=("${LOCAL_BIN_DIR}" "${path[@]}")
path=("$(brew --prefix python)/libexec/bin" "${path[@]}")
path=("/usr/local/go/bin" "${path[@]}")
path=("${GOBIN}" "${path[@]}")
path=("${LOCAL_OPT_DIR}/nvim/bin" "${path[@]}")

if [ -e "${HOME}/.cargo/env" ]; then
  # shellcheck source=../.cargo/env
  source "${HOME}/.cargo/env"
fi

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

PYTHONPATH="$(brew --prefix)/lib/python$(python --version | awk '{print $2}' | cut -d '.' -f 1,2)/site-packages"
export PYTHONPATH
# vi: ft=zsh
