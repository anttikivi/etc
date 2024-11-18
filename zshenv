# shellcheck shell=bash

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

if [ -e "${SHARED_ENV_DIR}/color_scheme.sh" ]; then
  source "${SHARED_ENV_DIR}/color_scheme.sh"
elif [ -n "${INSTALL_SCRIPT_BASEDIR}" ]; then
  source "${INSTALL_SCRIPT_BASEDIR}/color_scheme.sh"
fi

if [ -e "${SHARED_ENV_DIR}/directories.sh" ]; then
  source "${SHARED_ENV_DIR}/directories.sh"
elif [ -n "${INSTALL_SCRIPT_BASEDIR}" ]; then
  source "${INSTALL_SCRIPT_BASEDIR}/directories.sh"
fi

if [ -e "${SHARED_ENV_DIR}/terminals.sh" ]; then
  source "${SHARED_ENV_DIR}/terminals.sh"
elif [ -n "${INSTALL_SCRIPT_BASEDIR}" ]; then
  source "${INSTALL_SCRIPT_BASEDIR}/terminals.sh"
fi
