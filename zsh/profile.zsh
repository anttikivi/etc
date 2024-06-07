# Set utility environment variables.
export TOOLSPATH="$HOME/tools"

# Source the colors scheme environment variables.
source $HOME/.config/colors.sh

# Set up local binaries and scripts.
export PATH="$HOME/.local/bin:$PATH"
bindkey -s ^f "tmux-sessionizer\n"

# Set Neovim to the PATH.
export PATH="$TOOLSPATH/nvim/bin:$PATH"

# Set up the Homebrew shell environment.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Set up Alacritty.
export PATH="/Applications/Alacritty.app/Contents/MacOS:$PATH"

# Source the Alacritty completions.
source $HOME/.zsh_completion/_alacritty

# Set up Go.
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"

# Set up Python.
export PATH="$(brew --prefix python)/libexec/bin:$PATH"
# export PATH="$HOME/Library/Python/3.11/bin:$PATH"
export PYTHONPATH="$(brew --prefix)/lib/python$(python --version | awk '{print $2}' | cut -d '.' -f 1,2)/site-packages"

# Set up nvm.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Automatically switch to the correct Node.js version when changing directories.
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Set up Rust.
source "$HOME/.cargo/env"

# Set up PHP.
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Set up Terraform.
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Set up the Google Cloud CLI.

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$TOOLSPATH/google-cloud-sdk/path.zsh.inc" ]; then . "$TOOLSPATH/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$TOOLSPATH/google-cloud-sdk/completion.zsh.inc" ]; then . "$TOOLSPATH/google-cloud-sdk/completion.zsh.inc"; fi
