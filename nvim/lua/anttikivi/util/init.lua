local M = {}

---@param name string
---@return number
function M.augroup(name)
  return vim.api.nvim_create_augroup("anttikivi-" .. name, { clear = true })
end

---@return nil
function M.set_global_variables()
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
  ---@type "catppuccin" | "kanagawa" | "rose-pine" | "brunch"
  vim.g.color_scheme = vim.g.true_colors and os.getenv "COLOR_SCHEME"
    or "brunch"

  ---The name of the dark variant for the current color scheme. Set via
  ---environment variable to match with the terminal's color scheme.
  ---
  ---@type string
  vim.g.color_scheme_dark_variant = vim.g.true_colors
      and os.getenv "COLOR_SCHEME_DARK_VARIANT"
    or "saturday"

  ---The name of the light variant for the current color scheme. Set via
  ---environment variable to match with the terminal's color scheme.
  ---
  ---@type string
  vim.g.color_scheme_light_variant = vim.g.true_colors
      and os.getenv "COLOR_SCHEME_LIGHT_VARIANT"
    or "sunday"
end

return M
