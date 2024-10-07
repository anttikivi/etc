#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

. ./versions.sh

required_minor_version="$(echo "${NVIM_VERSION}" | head -c "$(echo "${NVIM_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
wanted_version="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" 'https://api.github.com/repos/neovim/neovim/releases?per_page=30' | jq -r '.[] | .tag_name' | grep "${required_minor_version}" | sort -V | tail -1)"
current_version="$(nvim --version | head --lines 1 | cut -c 6-)"
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
  echo "Installing Neovim ${wanted_version}"
  download_url="$(curl -LsSH "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/neovim/neovim/releases/tags/${wanted_version}" | jq --arg "archive_filename" "${archive_filename}" -r '.assets.[] | select(.name | endswith($archive_filename)) | .browser_download_url')"
  curl -LsS "${download_url}" | tar -xzf - -C "${HOME}/.local/opt"
  mkdir "${nvim_dir}"
  rsync -a "${HOME}/.local/opt/${archive_name}/" "${HOME}/.local/opt/nvim/"
  rm -rf "${HOME}/.local/opt/${archive_name}"
}

if ! command -v nvim >/dev/null 2>&1; then
  install_nvim
elif [ "${wanted_version}" != "${current_version}" ]; then
  install_nvim
  if [ "${DO_UPDATES}" = "true" ]; then
    install_nvim
  else
    printf "%bNeovim update available! Current version: %s, available version: %s%b" "${DOTFILES_ESC_YELLOW}" "${current_version}" "${wanted_version}" "${DOTFILES_ESC_RESET}"
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
