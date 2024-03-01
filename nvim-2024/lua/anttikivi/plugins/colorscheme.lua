return {
  {
    "anttikivi/brunch.nvim",
    lazy = false,
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
