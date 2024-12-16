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
---@field ui anttikivi.util.ui
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

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
