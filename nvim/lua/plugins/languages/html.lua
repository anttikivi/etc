return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          init_options = {
            provideFormatter = false,
          },
        },
      },
    },
  },
}
