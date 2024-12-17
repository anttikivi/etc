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
        }
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    opts = {
      signs = AK.config.use_icons,
    },
  },
  {
    import = "anttikivi.plugins.editor.fzf",
    enabled = function()
      return AK.pick.want() == "fzf"
    end,
  },
}
