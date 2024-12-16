---@diagnostic disable-next-line: unused-local
local no_icons = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "_" },
  topdelete = { text = "‾" },
  changedelete = { text = "~" },
}

if not AK.config.use_icons then
  vim.notify("Using icons")
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
    },
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
