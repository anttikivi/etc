local Config = require "config"
local colorscheme = require "colorscheme"
local fonts = require "fonts"
local keys = require "keys"

local config = Config:init()

---@type number
local window_padding = 6

config:append {
  automatically_reload_config = true,
  enable_tab_bar = false,
  window_padding = {
    left = window_padding,
    right = window_padding,
    top = window_padding,
    bottom = window_padding,
  },
}

config:append(colorscheme)
config:append(fonts)
config:append(keys)

return config.options
