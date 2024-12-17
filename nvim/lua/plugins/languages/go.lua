-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "goimports", "gofumpt" } },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                -- fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function()
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          AK.lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic =
                client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  ---@diagnostic disable-next-line: need-check-nil
                  tokenTypes = semantic.tokenTypes,
                  ---@diagnostic disable-next-line: need-check-nil
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
          -- end workaround
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },
}
