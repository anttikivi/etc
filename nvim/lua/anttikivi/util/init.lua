local env_colors = require "anttikivi.util.env.colors"

local M = {}

M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

---@param name string
---@return number
function M.augroup(name)
  return vim.api.nvim_create_augroup("anttikivi-" .. name, { clear = true })
end

---@return nil
function M.set_global_variables()
  vim.g.netrw_list_hide = "^\\.DS_Store$"

  ---Whether true colors are supported by the current terminal.
  ---
  ---@type boolean
  vim.g.true_colors = os.getenv "COLORTERM" == "truecolor"

  ---Whether icons are enabled.
  ---
  ---@type boolean
  vim.g.icons_enabled = vim.g.true_colors

  ---The name of the current color scheme. Set via environment variable to
  ---match with the terminal's color scheme.
  ---
  ---@type "catppuccin" | "rose-pine" | "brunch"
  vim.g.color_scheme = vim.g.true_colors and env_colors.color_scheme or "brunch"

  ---The name of the dark variant for the current color scheme. Set via
  ---environment variable to match with the terminal's color scheme.
  ---
  ---@type string
  vim.g.color_scheme_dark_variant = vim.g.true_colors
      and env_colors.dark_variant
    or "saturday"

  ---The name of the light variant for the current color scheme. Set via
  ---environment variable to match with the terminal's color scheme.
  ---
  ---@type string
  vim.g.color_scheme_light_variant = vim.g.true_colors
      and env_colors.light_variant
    or "sunday"
end

--- Gets a path to a package in the Mason registry.
---
--- This function is originally from `LazyVim/LazyVim` which is lisenced under
--- the Apache License 2.0. See the original code at
--- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
---
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_package_path(pkg, path, opts)
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

return M
