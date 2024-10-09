#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

os_name="$(uname)"

if [ "${os_name}" = "Darwin" ]; then
  echo "Running the Darwin-based installations"

  echo "Installing general utilities"

  brew update
  brew install fzf jq ripgrep tmux reattach-to-user-namespace

  echo "Installing user interface utilities"

  brew install cormacrelf/tap/dark-notify
  brew install --cask nikitabobko/tap/aerospace

  echo "Installing tools"

  brew install clang-format

  if ! command -v gcloud >/dev/null 2>&1; then
    gcloud_dir="${HOME}/.local/opt/google-cloud-sdk"
    if [ -d "${gcloud_dir}" ]; then
      rm -rf "${gcloud_dir}"
    fi
    curl -LsS "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz" | tar -xzf - -C "$(dirname "${gcloud_dir}")"
  fi
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

echo "Running the platform-independent utility installations"

echo "Running the platform-independent tool installations"
pipx install ansible-lint
