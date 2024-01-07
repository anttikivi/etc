-- The terminal utilities in this module are from
-- [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim).
-- Copyright (c) 2024 LazyVim, Inc.
-- Licensed under Apache License 2.0.
local M = {}

local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? table
function M.open(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "anttikiviterm",
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true })

  local key = vim.inspect { cmd = cmd, count = vim.v.count1 }

  if terminals[key] and terminals[key]:buf_valid() then
    terminals[key]:toggle()
  else
    terminals[key] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[key].buf
    vim.b[buf].anttikiviterm_cmd = cmd
    if opts.esc_esc == false then
      vim.keymap.set("t", "<esc>", "<esc", { buffer = buf, nowait = true })
    end
    if opts.ctrl_hjkl == false then
      vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[key]
end

return M
