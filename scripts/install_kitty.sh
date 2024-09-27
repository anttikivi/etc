#!/bin/sh

set -e

. ./scripts/versions.sh

required_minor_version="$(echo "${KITTY_VERSION}" | head -c "$(echo "${KITTY_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
wanted_version="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/kovidgoyal/kitty/releases | jq -r '.[] | .tag_name' | grep "${required_minor_version}" | sort -V | tail -1)"
current_version="$(kitty --version | cut -c $(("$(kitty --version | grep -ob "\ " | head -1 | grep -oE "[0-9]+")" + 2))-"$(kitty --version | grep -ob "\ " | head -2 | tail -1 | grep -oE "[0-9]+")")"

install_kitty() {
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n installer="version-$(echo "$1" | cut -c 2-)"
}

if ! command -v kitty >/dev/null 2>&1; then
  install_kitty "${wanted_version}"
elif [ "$(echo "${wanted_version}" | cut -c 2-)" != "${current_version}" ]; then
  install_kitty "${wanted_version}"
fi
