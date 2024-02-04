--  █████╗ ███╗   ██╗████████╗████████╗██╗    ██╗  ██╗██╗██╗   ██╗██╗
-- ██╔══██╗████╗  ██║╚══██╔══╝╚══██╔══╝██║    ██║ ██╔╝██║██║   ██║██║
-- ███████║██╔██╗ ██║   ██║      ██║   ██║    █████╔╝ ██║██║   ██║██║
-- ██╔══██║██║╚██╗██║   ██║      ██║   ██║    ██╔═██╗ ██║╚██╗ ██╔╝██║
-- ██║  ██║██║ ╚████║   ██║      ██║   ██║    ██║  ██╗██║ ╚████╔╝ ██║
-- ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝

-- Enable the experimental Lua module loader.
if vim.loader then
  vim.loader.enable()
end

-- Make sure that we're running up-to-date version of Neovim.
local expected_version = "0.9.5"
---@type Version?
local parsed_expected_version = vim.version.parse(expected_version) --[[@as Version?]]
local version = vim.version()

assert(
  parsed_expected_version,
  string.format("Invalid expected version string: %s", expected_version)
)

if vim.version.cmp(parsed_expected_version, version) > 0 then
  local msg = string.format(
    "Expected at least nvim %s but got %s.%s.%s instead. The configuration may not work as expected. Use at your own risk!",
    expected_version,
    version.major,
    version.minor,
    version.patch
  )
  vim.api.nvim_err_writeln(msg)
end

require "config.lazy"

require "anttikivi.filetypes"
require "anttikivi.parsers"
