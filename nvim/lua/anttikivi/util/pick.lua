-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

---@class anttikivi.util.pick
---@overload fun(command: string, opts?: anttikivi.util.pick.Opts): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

---@class anttikivi.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class AKPicker
---@field name string
---@field open fun(command: string, opts?: anttikivi.util.pick.Opts)
---@field commands table<string, string>

---@type AKPicker?
M.picker = nil

function M.config_files()
  return M.wrap("files", {
    ---@diagnostic disable-next-line: assign-type-mismatch
    cwd = vim.fn.stdpath("config"),
  })
end

---@param command? string
---@param opts? anttikivi.util.pick.Opts
function M.open(command, opts)
  if not M.picker then
    return AK.error("AK.pick: picker not set")
  end

  command = command ~= "auto" and command or "files"
  opts = opts or {}

  opts = vim.deepcopy(opts)

  if type(opts.cwd) == "boolean" then
    AK.warn("AK.pick: opts.cwd should be a string or nil")
    opts.cwd = nil
  end

  if not opts.cwd and opts.root ~= false then
    opts.cwd = AK.root({ buf = opts.buf })
  end

  command = M.picker.commands[command] or command
  M.picker.open(command, opts)
end

---@param picker AKPicker
function M.register(picker)
  -- this only happens when using :LazyExtras
  -- so allow to get the full spec
  if vim.v.vim_did_enter == 1 then
    return true
  end

  if M.picker and M.picker.name ~= M.want() then
    M.picker = nil
  end

  if M.picker and M.picker.name ~= picker.name then
    AK.warn(
      "`AK.pick`: picker already set to `"
        .. M.picker.name
        .. "`,\nignoring new picker `"
        .. picker.name
        .. "`"
    )
    return false
  end
  M.picker = picker
  return true
end

---@return "telescope" | "fzf"
function M.want()
  -- TODO: Currently, only fzf.
  return "fzf"
end

---@param command? string
---@param opts? anttikivi.util.pick.Opts
function M.wrap(command, opts)
  opts = opts or {}
  return function()
    AK.pick.open(command, vim.deepcopy(opts))
  end
end

return M
