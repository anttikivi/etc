#!/bin/bash

set -e

echo "Watching for changes in the color scheme for kitty"

/opt/homebrew/bin/dark-notify -c ~/.local/bin/kitty_change_colors.sh
