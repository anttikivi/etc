return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css" } },
  },
}
