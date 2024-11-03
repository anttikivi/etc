local util = require("anttikivi.util")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = util.augroup("highlight-on-yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Detect Go HTML templates
-- autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   desc = "Detect Go HTML templates",
--   pattern = "*.html",
--   callback = function()
--     if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
--       vim.bo.filetype = "gohtmltmpl"
--     end
--   end,
-- })
