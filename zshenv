export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export ZDOTDIR="${HOME}"

export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

SHARED_ENV_DIR="${XDG_CONFIG_HOME}/env"

for file in "${SHARED_ENV_DIR}/"*; do
  # Secrets should not be exposed to every single shell.
  test "${file}" = "${SHARED_ENV_DIR}/secrets.sh" && continue
  source "${file}"
done
unset file
