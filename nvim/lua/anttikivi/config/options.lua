vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_list_hide = "^\\.DS_Store$"

local opt = vim.opt

-- opt.breakindent = true -- Enable break indent
-- Only set clipboard if not in ssh, to make sure the OSC 52 integration works
-- automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.colorcolumn = "80" -- Highlight column 80
opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'anttikivi.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guicursor = "" -- Don't use the thin cursor
opt.hlsearch = true -- Set highlight on search
opt.ignorecase = true -- Ignore case when searching
-- NOTE: This is set to `nosplit` in LazyVim, should I consider using it too?
opt.inccommand = "split" -- Incremental live preview of :s
opt.jumpoptions = "view"
-- opt.laststatus = 3 -- global statusline
-- TODO: See how this feels.
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Show line numbers
-- TODO: Set this only if true colors are enabled.
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
-- TODO: Check this out.
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- TODO: Toggle this if some statusline plugin is in use.
opt.showmode = false -- Don't show the mode, since it's already in status line
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters
opt.smartindent = true -- Insert indents automatically
-- opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = AK.config.true_colors -- True color support
-- opt.textwidth = 0 -- Maximum width of text
-- opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true -- Line wrap

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'anttikivi.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'anttikivi.util'.ui.foldtext()"
end
