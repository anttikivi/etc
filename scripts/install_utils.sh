#!/bin/sh

set -e

not_supported() {
  echo "This operating system is not supported: $*" >&2
  exit 1
}

os_name="$(uname)"

if [ "${os_name}" = "Darwin" ]; then
  echo "Running on Darwin"

  brew update
  brew install fzf jq ripgrep
  brew install --cask nikitabobko/tap/aerospace
elif [ "${os_name}" = "Linux" ]; then
  echo "Checking the Linux distribution..."
  distro="$(cat /etc/*-release | grep ^ID | head -n1 | cut -d '=' -f2)"
  echo "Running on ${distro}"

  if [ "${distro}" = "debian" ]; then
    not_supported "${os_name}" "${distro}"
  elif [ "${distro}" = "ubuntu" ]; then
    not_supported "${os_name}" "${distro}"
  else
    not_supported "${os_name}" "${distro}"
  fi
else
  not_supported "${os_name}"
fi
