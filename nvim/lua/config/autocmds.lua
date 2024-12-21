local function augroup(name)
  return vim.api.nvim_create_augroup(
    "anttikivi_custom_" .. name,
    { clear = true }
  )
end

-- TODO: The options are not applied if I jump to a Python file by Harpoon.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python_colorcolumn"),
  pattern = "python",
  callback = function()
    vim.opt_local.colorcolumn = "72,79"
  end,
})
