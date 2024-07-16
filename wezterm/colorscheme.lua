local wezterm = require "wezterm"
local env_colors = require "env.colors"

local default_scheme = "Light"
local default_colors = default_scheme == "Dark" and "Catppuccin Mocha"
  or "Catppuccin Latte"

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return default_scheme
end

local function first_to_upper(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

local function scheme_for_appearance(appearance)
  ---@type "catppuccin" | "rose-pine" | nil
  local color_scheme = env_colors.color_scheme

  if color_scheme == nil then
    return default_colors
  end

  if env_colors.color_scheme == "catppuccin" then
    color_scheme = first_to_upper(color_scheme)
  end

  ---@type string | nil
  local variant = nil

  if appearance:find "Dark" then
    variant = env_colors.dark_variant
  else
    variant = env_colors.light_variant
  end

  if variant == nil then
    return default_colors
  end

  if env_colors.color_scheme == "catppuccin" then
    color_scheme = color_scheme .. " " .. first_to_upper(variant)
  else
    if env_colors.color_scheme == "rose-pine" and variant ~= "main" then
      color_scheme = color_scheme .. "-" .. variant
    end
  end

  return color_scheme
end

return {
  color_scheme = scheme_for_appearance(get_appearance()),
}
