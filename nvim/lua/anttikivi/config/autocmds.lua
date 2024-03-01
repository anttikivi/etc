local util = require "anttikivi.util"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = util.augroup "highlight-on-yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})
