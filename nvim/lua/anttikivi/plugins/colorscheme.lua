return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    lazy = false,
    enabled = not vim.g.true_colors,
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
    enabled = vim.g.true_colors and vim.g.colorscheme == "catppuccin",
    opts = {
      flavour = "auto",
      background = {
        light = vim.g.colorscheme_light_variant,
        dark = vim.g.colorscheme_dark_variant,
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
