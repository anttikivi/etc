local opt = vim.opt

opt.breakindent = true
-- TODO: Should I disable this?
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.colorcolumn = "80"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.expandtab = true
opt.guicursor = ""
opt.ignorecase = true -- case-insensitive search
opt.list = true -- Show some invisible characters
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true -- Override ignoring case if search pattern contains uppercase
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = false
opt.timeoutlen = 300
opt.undofile = true
-- opt.undolevels = 10000
opt.updatetime = 250
opt.wrap = true
