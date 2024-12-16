-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

_G.AK = require("anttikivi.util")

local M = {}

AK.config = M

---@class AKConfig
---@field colorscheme AKColorscheme The color scheme to use. This is set via environment variable during the setup.
---@field colorscheme_dark_variant string The name of the dark variant for the current color scheme. This is set via environment variable during the setup.
---@field colorscheme_light_variant string The name of the light variant for the current color scheme. This is set via environment variable during the setup.
---@field true_colors boolean Whether to enable true colors in the terminal.
---@field use_icons boolean Whether to enable icons.
local config = {
  -- If the completion engine supports the AI source, use that instead of inline
  -- suggestions.
  ai_cmp = false,
  -- Whether to follow the main branch of `saghen/blink.cmp`.
  blink_follow_main = false,
  defaults = {
    autocmds = true, -- anttikivi.config.autocmds
    keymaps = true, -- anttikivi.config.keymaps
    -- anttikivi.config.options can't be configured here since that's loaded
    -- before the AK setup. If you want to disable loading options, add
    -- `package.loaded["anttikivi.config.options"] = true` to the top of your
    -- init.lua.
  },
  -- Icons used by plugins.
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    },
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
      Snippet = "󱄽 ",
      String = " ",
      Struct = "󰆼 ",
      Supermaven = " ",
      TabNine = "󰏚 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = "󰀫 ",
    },
  },
}

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  -- TODO: Delay notifications until vim.notify was replaced or after 500ms.
  -- Right now, vim.notify is not replaced in this configuration.
  -- AK.lazy_notify()

  -- Load options here, before lazy init while sourcing plugin modules. This is
  -- needed to make sure options will be correctly applied after installing
  -- missing plugins.
  M.load("options")

  AK.plugin.setup()
end

---@param opts? AKConfig Optional configuration to override the defaults. The parameter is provided mainly for easier debugging.
function M.setup(opts)
  config.true_colors = vim.g.ak_true_colors
  config.colorscheme = config.true_colors and os.getenv("COLOR_SCHEME")
    or "brunch"
  config.colorscheme_dark_variant = config.true_colors
      and os.getenv("COLOR_SCHEME_DARK_VARIANT")
    or "saturday"
  config.colorscheme_light_variant = config.true_colors
      and os.getenv("COLOR_SCHEME_LIGHT_VARIANT")
    or "sunday"
  config.use_icons = vim.g.ak_use_icons

  config = vim.tbl_deep_extend("force", config, opts or {}) or {}

  -- Autocommands can be loaded lazily when not opening a file.
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("KiviVim", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")

      AK.format.setup()
      AK.root.setup()

      vim.api.nvim_create_user_command("KiviHealth", function()
        vim.cmd([[Lazy! load all]])
        vim.cmd([[checkhealth]])
      end, { desc = "Load all plugins and run :checkhealth" })
    end,
  })

  AK.track("colorscheme")
  AK.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load the colorscheme",
    on_error = function(msg)
      AK.error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
  AK.track()
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      AK.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  local pattern = "AK" .. name:sub(1, 1):upper() .. name:sub(2)
  -- always load lazyvim, then user file
  if M.defaults[name] or name == "options" then
    _load("anttikivi.config." .. name)
    vim.api.nvim_exec_autocmds(
      "User",
      { pattern = pattern .. "Defaults", modeline = false }
    )
  end
  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: AK may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

setmetatable(M, {
  __index = function(_, key)
    return config[key]
  end,
})

return M
