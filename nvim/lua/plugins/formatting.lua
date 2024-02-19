return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        blade = { "prettier" },
        css = { "prettier" },
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
