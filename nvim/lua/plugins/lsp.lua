return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "ansible-lint",
          "luacheck",
          "selene",
          "shfmt",
          "stylua",
        })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {},
        astro = {},
        bashls = {},
        cssls = {},
        gopls = {
          filetypes = { "go", "gomod", "gowork", "gotmpl", "gohtmltmpl" },
          templateExtension = { "gotmpl", "gohtmltmpl" },
        },
        html = {
          filetypes = { "gohtmltmpl", "html", "templ" },
          init_options = {
            provideFormatter = false,
          },
        },
        phpactor = {},
        stylelint_lsp = {},
        vimls = {},
      },
    },
  },
}
