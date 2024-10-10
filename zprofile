typeset -U path PATH

# TODO: It might be that `PATH` should be set in `.zshrc` on Linux.
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

path=("${HOME}/.local/bin" "${path[@]}")
path=("$(brew --prefix python)/libexec/bin" "${path[@]}")
path=("/usr/local/go/bin" "${path[@]}")
path=("${GOBIN}" "${path[@]}")
path=("${HOME}/.local/opt/nvim/bin" "${path[@]}")

source "${HOME}/.cargo/env"

export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

if [ -f "${HOME}/.local/opt/google-cloud-sdk/path.zsh.inc" ]; then
  source "${HOME}/.local/opt/google-cloud-sdk/path.zsh.inc"
fi

export PYTHONPATH="$(brew --prefix)/lib/python$(python --version | awk '{print $2}' | cut -d '.' -f 1,2)/site-packages"

export EDITOR="nvim"
export VISUAL="nvim"

export CC="clang"
export CXX="clang++"

if [ -f "${XDG_CONFIG_HOME}/env/secrets.sh" ]; then
  source "${XDG_CONFIG_HOME}/env/secrets.sh"
fi

# vi: ft=zsh
