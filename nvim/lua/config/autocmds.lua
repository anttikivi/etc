---@param name string
---@return number
local function augroup(name)
  return vim.api.nvim_create_augroup("anttikivi_" .. name, { clear = true })
end

-- Fix the concealing of JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "fix_json_conceal",
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Set filetype for `.blade.php` files.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup "blade",
  pattern = "*.blade.php",
  command = "set ft=blade",
})
