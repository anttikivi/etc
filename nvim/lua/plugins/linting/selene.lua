return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "selene" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
    },
  },
}
