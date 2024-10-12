#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

os_name="$(uname)"

if [ "${HAS_CONNECTION}" = "true" ]; then
  if [ "${os_name}" = "Darwin" ]; then
    if ! command -v gcloud >/dev/null 2>&1; then
      gcloud_dir="${HOME}/.local/opt/google-cloud-sdk"
      if [ -d "${gcloud_dir}" ]; then
        rm -rf "${gcloud_dir}"
      fi
      curl -LsS "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz" | tar -xzf - -C "$(dirname "${gcloud_dir}")"
    elif [ "${DO_UPDATES}" = "true" ]; then
      gcloud components update
    fi
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
