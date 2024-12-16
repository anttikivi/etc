if vim.loader then
  vim.loader.enable()
end

vim.uv = vim.uv or vim.loop

require("anttikivi.config").setup()
require("anttikivi.config.lazy").load({})
