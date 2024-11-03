-- Enable the experimental Lua module loader.
if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("anttikivi.util").set_global_variables()

require("anttikivi.config.options")
require("anttikivi.config.keymaps")
require("anttikivi.config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("anttikivi.plugins", {
  dev = {
    path = os.getenv("PROJECT_DIR"),
    patterns = { "anttikivi" },
  },
  install = {
    colorscheme = { vim.g.color_scheme },
  },
  ui = vim.g.icons_enabled and {} or {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  change_detection = {
    notify = false,
  },
})

require("anttikivi.filetypes")
require("anttikivi.parsers")
