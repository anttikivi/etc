vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "anttikivi.config.options"
require "anttikivi.config.keymaps"
require "anttikivi.config.autocmds"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local lazy_opts = {
  dev = {
    path = "~/plugins",
    patterns = { "anttikivi" },
  },
  install = {
    colorscheme = "brunch",
  },
  ui = {
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
}

require("lazy").setup("plugins", lazy_opts)

require "anttikivi.filetypes"
require "anttikivi.parsers"
