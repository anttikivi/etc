if vim.loader then
  vim.loader.enable()
end

-- vim.uv = vim.uv or vim.loop

require("config.lazy").load()

-- require("anttikivi.config").setup()
