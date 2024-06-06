local true_colors = require("anttikivi.util").true_colors

return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    lazy = false,
    enabled = not true_colors,
    config = function()
      require("brunch").load()
      vim.cmd.colorscheme "brunch"
    end,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enabled = true_colors,
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end,
    priority = 1000,
  },
  {
    "cormacrelf/dark-notify",
    event = "VeryLazy",
    config = function()
      require("dark_notify").run()
    end,
  },
}
