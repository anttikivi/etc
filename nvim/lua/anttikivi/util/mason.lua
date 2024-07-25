local LazyUtil = require "lazy.core.util"

local M = {}

--- Gets a path to a package in the Mason registry.
---
--- This function is originally from `LazyVim/LazyVim` which is lisenced under
--- the Apache License 2.0. See the original code at
--- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
---
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
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

for _, level in ipairs { "info", "warn", "error" } do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "anttikivi_lsp"
    return LazyUtil[level](msg, opts)
  end
end

return M
