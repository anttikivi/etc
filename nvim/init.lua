--  █████╗ ███╗   ██╗████████╗████████╗██╗    ██╗  ██╗██╗██╗   ██╗██╗
-- ██╔══██╗████╗  ██║╚══██╔══╝╚══██╔══╝██║    ██║ ██╔╝██║██║   ██║██║
-- ███████║██╔██╗ ██║   ██║      ██║   ██║    █████╔╝ ██║██║   ██║██║
-- ██╔══██║██║╚██╗██║   ██║      ██║   ██║    ██╔═██╗ ██║╚██╗ ██╔╝██║
-- ██║  ██║██║ ╚████║   ██║      ██║   ██║    ██║  ██╗██║ ╚████╔╝ ██║
-- ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝

-- Enable the experimental Lua module loader.
if vim.loader then
  vim.loader.enable()
end

-- Make sure that we're running up-to-date version of Neovim.
local expected_version = "0.9.4"
---@type Version?
local parsed_expected_version = vim.version.parse(expected_version) --[[@as Version?]]
local version = vim.version()

assert(
  parsed_expected_version,
  string.format("Invalid expected version string: %s", expected_version)
)

if vim.version.cmp(parsed_expected_version, version) > 0 then
  local msg = string.format(
    "Expected at least nvim %s but got %s.%s.%s instead. The configuration may not work as expected. Use at your own risk!",
    expected_version,
    version.major,
    version.minor,
    version.patch
  )
  vim.api.nvim_err_writeln(msg)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "anttikivi.globals"

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

require("anttikivi.utils").lazy_file()

local lazy_opts = {
  defaults = {
    lazy = false,
    version = false, -- Use the latest Git commit by default.
  },
  dev = {
    path = "~/projects",
  },
  install = {
    missing = true,
    colorscheme = { "brunch" },
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
  checker = { enable = true },
  change_detection = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

require("lazy").setup("plugins", lazy_opts)

require("anttikivi.filetypes").add_filetypes()

require "anttikivi.options"
require "anttikivi.keymaps"
require "anttikivi.autocmds"
