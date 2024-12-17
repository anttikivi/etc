-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "ansible-lint" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
}
