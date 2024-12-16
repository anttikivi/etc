-- This module is based on folke/dot, licensed under Apache-2.0.

local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

---@param opts? LazyConfig Optional configuration to override the defaults. The parameter is provided mainly for easier debugging.
function M.load(opts)
  vim.g.ak_true_colors = os.getenv("COLORTERM") == "truecolor"
  vim.g.ak_use_icons = vim.g.ak_true_colors

  opts = vim.tbl_deep_extend("force", {
    spec = {
      { import = "anttikivi.plugins" },
    },
    dev = {
      path = os.getenv("PROJECT_DIR"),
      patterns = { "anttikivi" },
    },
    install = {
      -- TODO: Have a common source for the available color schemes.
      colorscheme = {
        "brunch",
        "catppuccin",
        "nightfox",
        "rose-pine",
        "tokyonight",
      },
    },
    ui = vim.g.ak_use_icons and {} or {
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
  }, opts or {})
  require("lazy").setup(opts)
end

return M