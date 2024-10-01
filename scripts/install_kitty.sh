#!/bin/sh

set -e

. ./scripts/versions.sh

required_minor_version="$(echo "${KITTY_VERSION}" | head -c "$(echo "${KITTY_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
wanted_version="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/kovidgoyal/kitty/releases | jq -r '.[] | .tag_name' | grep "${required_minor_version}" | sort -V | tail -1)"
current_version="$(kitty --version | cut -c $(($(kitty --version | grep -ob "\ " | head -1 | grep -oE "[0-9]+") + 2))-"$(kitty --version | grep -ob "\ " | head -2 | tail -1 | grep -oE "[0-9]+")")"

install_kitty() {
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n installer="version-$(echo "${wanted_version}" | cut -c 2-)"
}

if ! command -v kitty >/dev/null 2>&1; then
  install_kitty
elif [ "$(echo "${wanted_version}" | cut -c 2-)" != "${current_version}" ]; then
  install_kitty
fi

readonly CONFIG_DIR="${HOME}/.config/kitty"
readonly CONFIG_FILE="${CONFIG_DIR}/kitty.conf"

if [ ! -d "${CONFIG_DIR}" ]; then
  mkdir -p "${CONFIG_DIR}"
fi

if [ -e "${CONFIG_FILE}" ]; then
  rm "${CONFIG_FILE}"
fi

cp ./templates/kitty.conf "${CONFIG_FILE}"

os_name="$(uname)"

if [ "${os_name}" = "Darwin" ]; then
  echo "Creating the Darwin-specific kitty binary links"
  ln -sf /Applications/kitty.app/Contents/MacOS/kitty /Applications/kitty.app/Contents/MacOS/kitten ~/.local/bin/

  echo "Creating and starting the Darwin-specific kitty daemon"
  launch_agent="fi.anttikivi.kittycolors.plist"

  if [ -f "${HOME}/Library/LaunchAgents/${launch_agent}" ]; then
    # TODO: Don't use this legacy syntax for `launchd`.
    launchctl unload -w ~/Library/LaunchAgents/"${launch_agent}"
    rm ~/Library/LaunchAgents/"${launch_agent}"
  fi
  cp ./templates/"${launch_agent}" ~/Library/LaunchAgents/"${launch_agent}"
  sed -i '' "s:{HOME}:${HOME}:g" ~/Library/LaunchAgents/"${launch_agent}"

  # TODO: Don't use this legacy syntax for `launchd`.
  launchctl load -w ~/Library/LaunchAgents/"${launch_agent}"
fi
