-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

if vim.fn.has("nvim-0.10.0") == 0 then
  vim.api.nvim_echo({
    { "This Neovim configuration requires Neovim >= 0.10.0\n", "ErrorMsg" },
    { "Press any key to exit",                                 "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return {}
end

require("anttikivi.config").init()

return {
  {
    "folke/lazy.nvim",
    version = "*",
  },
  {
    -- "anttikivi/anttikivi",
    dir = vim.fn.expand("<script>:p:h"),
    name = "anttikivi",
    priority = 10000,
    lazy = false,
    opts = {},
    cond = true,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
}
