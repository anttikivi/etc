export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export ZDOTDIR="${HOME}"

export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

export PYENV_ROOT="${HOME}/.pyenv"

export EDITOR="nvim"
export VISUAL="nvim"

export CC="clang"
export CXX="clang++"

SHARED_ENV_DIR="${XDG_CONFIG_HOME}/env"

source "${SHARED_ENV_DIR}/color_scheme.sh"
source "${SHARED_ENV_DIR}/directories.sh"
