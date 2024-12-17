-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

local LazyUtil = require("lazy.core.util")

---@class anttikivi.util: LazyUtilCore
---@field cmp anttikivi.util.cmp
---@field config AKConfig
---@field format anttikivi.util.format
---@field lsp anttikivi.util.lsp
---@field lualine anttikivi.util.lualine
---@field mini anttikivi.util.mini
---@field pick anttikivi.util.pick
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

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

--- Gets a path to a package in the Mason registry. Prefer this to
--- `get_package`, since the package might not always be available yet and
--- trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if
    opts.warn
    and not vim.loop.fs_stat(ret)
    and not require("lazy.core.config").headless()
  then
    M.warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
        pkg,
        path
      )
    )
  end
  return ret
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
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
