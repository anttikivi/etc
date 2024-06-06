local M = {}

---@param name string
---@return number
function M.augroup(name)
  return vim.api.nvim_create_augroup("anttikivi-" .. name, { clear = true })
end

---@type boolean
M.true_colors = os.getenv "COLORTERM" == "truecolor"

return M
