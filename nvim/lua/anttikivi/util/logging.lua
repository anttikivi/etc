local LazyUtil = require "lazy.core.util"

local M = {}

for _, level in ipairs { "info", "warn", "error" } do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "anttikivi_logging"
    return LazyUtil[level](msg, opts)
  end
end

return M
