local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

---@diagnostic disable-next-line: inject-field
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade",
}

---@diagnostic disable-next-line: inject-field
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
}

vim.treesitter.language.register("gotmpl", { "gohtmltmpl" })
