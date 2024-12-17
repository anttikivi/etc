local no_icons = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "_" },
  topdelete = { text = "‾" },
  changedelete = { text = "~" },
}

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = function()
      return {
        signs = AK.config.use_icons and {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        } or no_icons,
        signs_staged = AK.config.use_icons and {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<C-h>",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon file",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Toggle Harpoon quick menu",
        },
      }

      local ordinal = {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
      }
      for i, v in ipairs(ordinal) do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = string.format("Switch to the %s Harpoon file", v),
        })
      end

      return keys
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    opts = function()
      return {
        signs = AK.config.use_icons,
      }
    end,
  },
  {
    import = "anttikivi.plugins.editor.fzf",
    enabled = function()
      return AK.pick.want() == "fzf"
    end,
  },
}
