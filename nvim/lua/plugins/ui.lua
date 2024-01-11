local Util = require "lazyvim.util"

return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "stevearc/dressing.nvim",
    enabled = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      return {
        options = {
          icons_enabled = false,
          theme = "brunch",
          component_separators = "|",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            { "diff", colored = false },
            { "diagnostics", colored = false },
          },
          lualine_c = {
            Util.lualine.root_dir(),
            -- "filename",
            { Util.lualine.pretty_path() },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    enabled = false,
  },
  {
    "MunifTanjim/nui.nvim",
    enabled = false,
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
  {
    "nvim-tree/nvim-web-devicons",
    enabled = false,
  },
}
