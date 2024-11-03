return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    lazy = false,
    enabled = not vim.g.true_colors,
    config = function()
      require("brunch").load()
      vim.cmd.colorscheme("brunch")
    end,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enabled = vim.g.true_colors and vim.g.color_scheme == "catppuccin",
    opts = {
      flavour = "auto",
      background = {
        dark = vim.g.color_scheme_dark_variant,
        light = vim.g.color_scheme_light_variant,
      },
      transparent_background = false,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    enabled = vim.g.true_colors and vim.g.color_scheme == "nightfox",
    opts = {},
    config = function(_, opts)
      require("nightfox").setup(opts)
      if vim.o.background == "light" then
        vim.cmd.colorscheme(vim.g.color_scheme_light_variant)
      elseif vim.o.background == "dark" then
        vim.cmd.colorscheme(vim.g.color_scheme_dark_variant)
      else
        vim.cmd.colorscheme(vim.g.color_scheme)
      end
    end,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    lazy = false,
    enabled = vim.g.true_colors and vim.g.color_scheme == "rose-pine",
    opts = {
      variant = "auto",
      dark_variant = vim.g.color_scheme_dark_variant,
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = vim.g.true_colors and vim.g.color_scheme == "tokyonight",
    opts = {
      style = vim.g.color_scheme_dark_variant,
      light_style = vim.g.color_scheme_light_variant,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
    priority = 1000,
  },
  {
    "cormacrelf/dark-notify",
    event = "VeryLazy",
    config = function()
      if vim.g.color_scheme == "nightfox" then
        require("dark_notify").run({
          schemes = {
            dark = vim.g.color_scheme_dark_variant,
            light = vim.g.color_scheme_light_variant,
          },
        })
      else
        require("dark_notify").run()
      end
    end,
  },
}
