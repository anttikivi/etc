return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gohtmltmpl = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn" },
        },
      },
    },
  },
}
