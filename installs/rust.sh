#!/bin/sh

set -e

if [ "${HAS_CONNECTION}" = "true" ]; then
  if ! command -v rustc >/dev/null 2>&1; then
    echo "Installing the Rust toolchain"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- --no-modify-path -y
  elif [ "${DO_UPDATES}" = "true" ]; then
    echo "Updating the Rust toolchain"
    rustup update
  else
    echo "Not installing Rust"
  fi

  if ! command -v taplo >/dev/null 2>&1; then
    echo "Installing Taplo"
    os="$(uname | tr '[:upper:]' '[:lower:]')"
    arch="$(uname -m)"
    if [ "${arch}" = "arm64" ]; then
      arch="aarch64"
    fi
    curl -fsSL "https://github.com/tamasfe/taplo/releases/latest/download/taplo-full-${os}-${arch}.gz" | gzip -d - | install -m 755 /dev/stdin ~/.local/bin/taplo
  fi

  echo "Installing Rust-based tools"

  cargo install selene
fi
