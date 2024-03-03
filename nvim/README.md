# dotfiles/nvim

This is my Neovim configuration.

## Install Instructions

> This Neovim configuration requires Neovim 0.9+. Always review the code before
> installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:anttikivi/dotfiles ~/.config/anttikivi/dotfiles
NVIM_APPNAME=anttikivi/dotfiles/nvim nvim --headless +"Lazy! sync" +qa
```

Open Neovim with this config:

```sh
NVIM_APPNAME=anttikivi/dotfiles/nvim nvim
```

## Plugins

The configuration uses [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim)
to manage plugins. You can find the plugin specification in the
[`anttikivi.plugins`](lua/anttikivi/plugins) module.

## Language Servers

The language servers are set in the
[`anttikivi.plugins.lsp`](lua/anttikivi/plugins/lsp.lua) module.

## License

This repository is licensed under the MIT License. See the [LICENSE](../LICENSE)
file for more information.
