return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    lazy = true,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "auto",
      background = {
        dark = AK.config.colorscheme_dark_variant,
        light = AK.config.colorscheme_light_variant,
      },
      -- transparent_background = false,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {},
    config = function(_, opts)
      require("nightfox").setup(opts)
      if vim.o.background == "light" then
        vim.cmd.colorscheme(AK.config.colorscheme_light_variant)
      elseif vim.o.background == "dark" then
        vim.cmd.colorscheme(AK.config.colorscheme_dark_variant)
      else
        vim.cmd.colorscheme(AK.config.colorscheme)
      end
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    opts = {
      variant = "auto",
      dark_variant = AK.config.colorscheme_dark_variant,
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function()
      return {
        style = AK.config.colorscheme_dark_variant,
        light_style = AK.config.colorscheme_light_variant,
      }
    end,
  },
  {
    "cormacrelf/dark-notify",
    event = "VeryLazy",
    config = function()
      if AK.config.colorscheme == "nightfox" then
        require("dark_notify").run({
          schemes = {
            dark = AK.config.colorscheme_dark_variant,
            light = AK.config.colorscheme_light_variant,
          },
        })
      else
        require("dark_notify").run()
      end
    end,
  },
}
