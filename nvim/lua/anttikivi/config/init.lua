_G.AK = require("anttikivi.util")

local M = {}

AK.config = M

---@class AKConfig
local config = {}

---This function is based on LazyVim/LazyVim, licensed under Apache-2.0.
function M.setup()
  -- autocmds can be loaded lazily when not opening a file
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

      local health = require("anttikivi.health")
      vim.list_extend(health.valid, {
        "recommended",
        "desc",
        "vscode",
      })
    end,
  })
end

---This function is based on LazyVim/LazyVim, licensed under Apache-2.0.
---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      AK.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  local pattern = "KiviVim" .. name:sub(1, 1):upper() .. name:sub(2)
  -- always load lazyvim, then user file
  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: KiviVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end
