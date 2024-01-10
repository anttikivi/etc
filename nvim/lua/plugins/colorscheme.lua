return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    lazy = true,
  },
  {
    "cormacrelf/dark-notify",
    event = "VeryLazy",
    config = function()
      require("dark_notify").run()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "brunch",
    },
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
}
