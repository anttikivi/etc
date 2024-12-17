---@type boolean
vim.g.ak_eslint_auto_format = false

-- Enable the option to require a Prettier config file. If set to true and no
-- Prettier config file is found, the formatter will not be used.
---@type boolean
vim.g.ak_prettier_needs_config = false

---@type "basedpyright" | "pyright"
vim.g.ak_python_lsp = "pyright"

---@type "ruff" | "ruff_lsp"
vim.g.ak_python_ruff = "ruff"
