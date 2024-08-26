local wezterm = require "wezterm"

return {
  font = wezterm.font {
    family = "JetBrains Mono",
    weight = "Regular",
    harfbuzz_features = { "calt=1", "clig=1", "liga=1", "zero=1" },
  },
  -- The recommended settings for JetBrains Mono:
  -- font_size: 13,
  -- line_height: 1.2,
  font_size = 13,
  line_height = 1.2,
  freetype_load_flags = "NO_HINTING",
  freetype_load_target = "Light",
  freetype_render_target = "HorizontalLcd",
}
