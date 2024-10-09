#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

. ../utils/colors.sh
. ../versions.sh

if [ "${HAS_CONNECTION}" = "true" ]; then
  minor_ver="$(echo "${NVIM_VERSION}" | head -c "$(echo "${NVIM_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
  wanted_ver="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" 'https://api.github.com/repos/neovim/neovim/releases?per_page=30' | jq -r '.[] | .tag_name' | grep "${minor_ver}" | sort -V | tail -1)"
  current_ver="$(nvim --version | head --lines 1 | cut -c 6-)"
  os_name="$(uname)"
  archive_name=""
  if [ "${os_name}" = "Darwin" ]; then
    darwin_arch="$(uname -m)"
    case "${darwin_arch}" in
      arm64*)
        archive_name="nvim-macos-arm64"
        ;;
      *)
        not_supported "${os_name}" "${darwin_arch}"
        ;;
    esac
  elif [ "${os_name}" = "Linux" ]; then
    archive_name="nvim-linux64"
  else
    not_supported "${os_name}"
  fi
  archive_filename="${archive_name}.tar.gz"

  install_nvim() {
    echo "Removing the old Neovim installation"
    nvim_dir="${HOME}/.local/opt/nvim"
    rm -rf "${nvim_dir}"
    echo "Installing Neovim ${wanted_ver}"
    download_url="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/neovim/neovim/releases/tags/${wanted_ver}" | jq --arg "archive_filename" "${archive_filename}" -r '.assets.[] | select(.name | endswith($archive_filename)) | .browser_download_url')"
    curl -LsS "${download_url}" | tar -xzf - -C "${HOME}/tmp"
    mkdir "${nvim_dir}"
    rsync -a "${HOME}/tmp/${archive_name}/" "${nvim_dir}/"
    rm -rf "${HOME}/tmp/${archive_name}"
  }

  if ! command -v nvim >/dev/null 2>&1; then
    install_nvim
  elif [ "${wanted_ver}" != "${current_ver}" ]; then
    install_nvim
    if [ "${DO_UPDATES}" = "true" ]; then
      install_nvim
    else
      printf "%bNeovim update available! Current version: %s, available version: %s%b" "${ESC_YELLOW}" "${current_ver}" "${wanted_ver}" "${ESC_RESET}"
    fi
  else
    echo "Not installing Neovim"
  fi

  echo "Installing brunch.nvim"

  brunch_dir="${HOME}/development/plugins/brunch.nvim"
  brunch_repo="git@github.com:anttikivi/brunch.nvim.git"

  if [ ! -d "${brunch_dir}" ]; then
    git clone "${brunch_repo}" "${brunch_dir}"
  fi
fi
