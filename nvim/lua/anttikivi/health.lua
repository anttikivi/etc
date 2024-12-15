-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function M.check()
  start("anttikivi")

  if not vim.version.cmp then
    error(
      string.format(
        "Neovim out of date: '%s'. Upgrade to latest stable or nightly",
        tostring(vim.version())
      )
    )
    return
  end

  if vim.version.cmp(vim.version(), { 0, 10, 0 }) >= 0 then
    ok(string.format("Neovim version is: '%s'", tostring(vim.version())))
  else
    error(
      string.format(
        "Neovim out of date: '%s'. Upgrade to latest stable or nightly",
        tostring(vim.version())
      )
    )
  end

  for _, cmd in ipairs({
    "bat",
    "curl",
    "fd",
    "fzf",
    "git",
    "rg",
  }) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    ---@cast commands string[]
    local found = false

    for _, c in ipairs(commands) do
      if vim.fn.executable(c) == 1 then
        name = c
        found = true
      end
    end

    if found then
      ok(("`%s` is installed"):format(name))
    else
      warn(("`%s` is not installed"):format(name))
    end
  end
end

return M
