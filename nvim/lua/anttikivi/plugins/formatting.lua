return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        -- timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        blade = { "prettier" },
        css = { "prettier" },
        go = { "goimports", "gofumpt" },
        gohtmltmpl = { "prettier" },
        html = { "prettier" },
        htmlhugo = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        php = { "php_cs_fixer" },
        python = { "black" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        zsh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn" },
        },
      },
    },
  },
}
