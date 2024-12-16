-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

local LazyUtil = require("lazy.core.util")

---@class anttikivi.util: LazyUtilCore
---@field cmp anttikivi.util.cmp
---@field config AKConfig
---@field format anttikivi.util.format
---@field lsp anttikivi.util.lsp
---@field mini anttikivi.util.mini
---@field plugin anttikivi.util.plugin
---@field root anttikivi.util.root
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    t[k] = require("anttikivi.util." .. k)
    return t[k]
  end,
})

---Returns the selected completions engine. For now, I plan to use `blink.cmp`.
---@return "blink.cmp"
function M.cmp_engine()
  return "blink.cmp"
end

return M
