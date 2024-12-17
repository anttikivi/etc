-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

local auto_format = vim.g.ak_eslint_auto_format == nil
  or vim.g.ak_eslint_auto_format

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- Helps eslint find the eslintrc when it's placed in a subfolder
            -- instead of the cwd root.
            workingDirectories = { mode = "auto" },
            format = auto_format,
          },
        },
      },
      setup = {
        eslint = function()
          if not auto_format then
            return
          end

          local function get_client(buf)
            return AK.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = AK.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0.
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(
                  buf,
                  { namespace = vim.lsp.diagnostic.get_namespace(client.id) }
                )
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- Register the formatter with AK.
          AK.format.register(formatter)
        end,
      },
    },
  },
}
