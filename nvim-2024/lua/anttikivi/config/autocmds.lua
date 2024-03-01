---@param name string
---@return number
local function augroup(name)
  return vim.api.nvim_create_augroup("anttikivi_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup "highlight_on_yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})
