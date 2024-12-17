-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

return {
  -- TODO: Should this config be merged elsewhere?
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}
