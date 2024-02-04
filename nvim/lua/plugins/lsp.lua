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
      ansiblels = {},
      astro = {},
      bashls = {},
      cssls = {},
      html = {
        filetypes = { "gotmpl", "html", "templ" },
        provideFormatter = false,
      },
      phpactor = {},
      stylelint_lsp = {},
      vimls = {},
    },
  },
}
