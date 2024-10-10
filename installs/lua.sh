#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

os_name="$(uname)"

if [ "${HAS_CONNECTION}" = "true" ]; then
  if [ "${os_name}" = "Darwin" ]; then
    brew install luarocks stylua
    luarocks install luacheck
  elif [ "${os_name}" = "Linux" ]; then
    distro="$(cat /etc/*-release | grep ^ID | head -n1 | cut -d '=' -f2)"
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
fi
