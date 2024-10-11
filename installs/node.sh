#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

. ../utils/colors.sh
. ../versions.sh

if [ "${HAS_CONNECTION}" = "true" ]; then
  minor_ver="$(echo "${NVM_VERSION}" | head -c "$(echo "${NVM_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
  wanted_ver="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" 'https://api.github.com/repos/nvm-sh/nvm/releases?per_page=100' | jq -r '.[] | .tag_name' | grep "${minor_ver}" | sort -V | tail -1 | cut -c 2-)"
  current_ver=""
  if command -v nvm >/dev/null 2>&1; then
    current_ver="$(nvm --version)"
  fi

  install_nvm() {
    echo "Installing nvm ${wanted_ver}"
    PROFILE=/dev/null bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${wanted_ver}/install.sh | bash"
    NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
  }

  if ! command -v nvm >/dev/null 2>&1; then
    printf "%bnvm was not found%b\n" "${ESC_YELLOW}" "${ESC_RESET}"
    install_nvm
  elif [ "${wanted_ver}" != "${current_ver}" ]; then
    if [ "${DO_UPDATES}" = "true" ]; then
      install_nvm
    else
      printf "%bnvm update available! Current version: %s, available version: %s%b\n" "${ESC_YELLOW}" "${current_ver}" "${wanted_ver}" "${ESC_RESET}"
    fi
  else
    echo "Not installing nvm"
  fi

  install_node() {
    if ! nvm which "$1" >/dev/null 2>&1; then
      echo "Installing Node.js $1"
      nvm install "$1"
      return
    elif [ "${DO_UPDATES}" = "true" ]; then
      current_ver="$(nvm version "$1")"
      # remote_ver="$(nvm version-remote "$1")"
      nvm install --reinstall-packages-from="$1" "$1"
      nvm uninstall "${current_ver}"
    else
      echo "Not installing Node.js $1"
    fi
  }

  install_node "18"
  install_node "20"
  install_node "22"

  nvm alias default 20
fi
