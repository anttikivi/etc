-- Enable the experimental Lua module loader.
if vim.loader then
  vim.loader.enable()
end

vim.uv = vim.uv or vim.loop
