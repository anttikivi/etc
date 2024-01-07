return {
  {
    "anttikivi/brunch.nvim",
    dev = true,
    config = function()
      require("brunch").load()
      vim.cmd.colorscheme "brunch"
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
