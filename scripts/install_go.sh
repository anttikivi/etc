#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

. ./scripts/versions.sh

required_minor_version="$(echo "${GO_VERSION}" | head -c "$(echo "${GO_VERSION}" | grep -m 2 -ob "\." | tail -1 | grep -oE "[0-9]+")")"
wanted_version="$(curl -LsS 'https://go.dev/dl/?mode=json&include=all' | jq -r '.[] | .version' | grep "${required_minor_version}" | sort -V | tail -1)"
# TODO: Some values of `uname -m` might need to be changed.
current_version="$(go version | sed "s/go version //" | sed "s: $(uname | tr '[:upper:]' '[:lower:]')/$(uname -m)::")"

install_go() {
  echo "Removing old Go installation"
  rm -r "${HOME}/.local/opt/go"

  echo "Downloading Go"
  archive_name="$(curl -LsS 'https://go.dev/dl/?mode=json&include=all' | jq -r --arg "wanted_version" "${wanted_version}" --arg "os" "$(uname | tr '[:upper:]' '[:lower:]')" --arg "arch" "$(uname -m)" '.[] | select(.version == $wanted_version) | .files[] | select(.os == $os and .arch == $arch and .kind == "archive") | .filename')"
  curl -LsS "https://go.dev/dl/${archive_name}" | tar -C "${HOME}/.local/opt" -xzf -
}

if ! command -v go >/dev/null 2>&1; then
  install_go
elif [ "${wanted_version}" != "${current_version}" ]; then
  install_go
fi

echo "Installing Go modules"

go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install github.com/a-h/templ/cmd/templ@latest
