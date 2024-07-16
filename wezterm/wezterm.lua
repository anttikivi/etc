local Config = require "config"
local colorscheme = require "colorscheme"
local fonts = require "fonts"
local keys = require "keys"

local config = Config:init()

config:append {
  automatically_reload_config = true,
  enable_tab_bar = false,
}

config:append(colorscheme)
config:append(fonts)
config:append(keys)

return config.options
