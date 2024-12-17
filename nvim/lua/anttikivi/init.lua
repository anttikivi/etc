vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? AKConfig
function M.setup(opts)
  require("anttikivi.config").setup(opts)
end

return M
