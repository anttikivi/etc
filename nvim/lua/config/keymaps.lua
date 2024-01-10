local Util = require "lazyvim.util"

---@param mode string|string[]
---@param rhs string
---@param lhs string|function
---@param opts? table
local function map(mode, rhs, lhs, opts)
  vim.keymap.set(mode, rhs, lhs, opts)
end

-- Delete keymap for saving file with <C-s>
vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

-- Commands
vim.keymap.del("n", "<leader>l")
map("n", "<leader>cl", "<cmd>Lazy<cr>", { desc = "[L]azy" })
vim.keymap.del("n", "<leader>gg")
vim.keymap.del("n", "<leader>gG")
map("n", "<leader>cg", function()
  Util.terminal(
    { "lazygit" },
    { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }
  )
end, { desc = "lazy[g]it (root dir)" })
map("n", "<leader>cG", function()
  Util.terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "lazy[g]it (cwd)" })

-- Diagnostics
vim.keymap.del("n", "<leader>cd")
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Floating terminal
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end
map("n", "<leader>ct", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>cT", function()
  Util.terminal()
end, { desc = "Terminal (cwd)" })

-- To normal mode
map("i", "<C-c>", "<Esc>")

-- To file tree
map("n", "<leader>e", vim.cmd.Ex, { desc = "Go to the file [e]xplorer" })

-- Improved jump half a page
map("n", "<C-d>", "<C-d>zz", { desc = "Move down half a page" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up half a page" })

-- Easier increment and decrement
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- Deleting without yanking
map(
  { "n", "v" },
  "<leader>d",
  [["_d]],
  { desc = "[D]elete into black hole register" }
)
map({ "n", "v" }, "<leader>p", [["_dP]], { desc = "Delete and [p]aste" })

-- Make file an executable
map("n", "<leader>x", [[:!chmod +x %<CR>]], { desc = "Make file e[x]ecutable" })

-- Tmux sessioniser
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
