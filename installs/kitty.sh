#!/bin/sh

set -e

. ./utils/colors.sh
. ./versions.sh

if [ "${HAS_CONNECTION}" = "true" ]; then
  minor_ver="$(echo "${KITTY_VERSION}" | head -c "$(echo "${KITTY_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
  wanted_ver="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/kovidgoyal/kitty/releases | jq -r '.[] | .tag_name' | grep "${minor_ver}" | sort -V | tail -1)"
  current_ver="$(kitty --version | cut -c $(($(kitty --version | grep -ob "\ " | head -1 | grep -oE "[0-9]+") + 2))-"$(kitty --version | grep -ob "\ " | head -2 | tail -1 | grep -oE "[0-9]+")")"

  install_kitty() {
    echo "Running kitty installation"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n installer="version-$(echo "${wanted_ver}" | cut -c 2-)"
  }

  if ! command -v kitty >/dev/null 2>&1; then
    install_kitty
  elif [ "$(echo "${wanted_ver}" | cut -c 2-)" != "${current_ver}" ]; then
    if [ "${DO_UPDATES}" = "true" ]; then
      install_kitty
    else
      printf "%bkitty update available! Current version: %s, available version: %s%b" "${DOTFILES_ESC_YELLOW}" "${current_ver}" "${wanted_ver}" "${DOTFILES_ESC_RESET}"
    fi
  fi
fi

readonly config_dir="${HOME}/.config/kitty"
readonly config_file="${config_dir}/kitty.conf"
readonly config_line="include user.conf"

if [ ! -d "${config_dir}" ]; then
  mkdir -p "${config_dir}"
fi

if ! grep -xF "${config_line}" "${config_file}" >/dev/null 2>&1; then
  echo "${config_line}" >>"${config_file}"
fi

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
