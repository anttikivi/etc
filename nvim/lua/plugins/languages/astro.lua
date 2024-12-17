-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

return {
  -- Astro requires the CSS server.
  { import = "plugins.languages.css" },
  -- Astro requires the TypeScript server.
  { import = "plugins.languages.typescript" },
  {
    "conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.astro = { "prettier" }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {},
      },
    },
  },
  -- Configure the TypeScript server plugin.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      AK.extend(
        opts.servers.vtsls,
        { "settings.vtsls.tsserver.globalPlugins" },
        ---@diagnostic disable-next-line: redundant-parameter
        {
          {
            name = "@astrojs/ts-plugin",
            location = AK.get_pkg_path(
              "astro-language-server",
              "/node_modules/@astrojs/ts-plugin"
            ),
            enableForWorkspaceTypeScriptVersions = true,
          },
        }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "astro" } },
  },
}
