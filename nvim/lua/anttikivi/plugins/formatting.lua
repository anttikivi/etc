return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        -- timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        blade = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        go = { "goimports", "gofumpt" },
        gohtmltmpl = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        lua = { "stylua" },
        markdown = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        toml = { "taplo" },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn" },
        },
      },
    },
  },
}
