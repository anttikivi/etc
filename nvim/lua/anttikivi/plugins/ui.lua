local icons = require("anttikivi.util").icons

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
      return {
        options = vim.g.icons_enabled and {
          icons_enabled = true,
          theme = vim.g.color_scheme,
          globalstatus = true,
        } or {
          icons_enabled = false,
          theme = vim.g.color_scheme,
          component_separators = "|",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            vim.tbl_extend("force", {
              "diff",
              colored = vim.g.true_colors,
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            }, vim.g.icons_enabled and {
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            } or {}),
            vim.tbl_extend(
              "force",
              { "diagnostics", colored = vim.g.true_colors },
              vim.g.icons_enabled
                  and {
                    symbols = {
                      error = icons.diagnostics.Error,
                      warn = icons.diagnostics.Warn,
                      info = icons.diagnostics.Info,
                      hint = icons.diagnostics.Hint,
                    },
                  }
                or {}
            ),
          },
          -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
