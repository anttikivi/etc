---@param mode string|string[]
---@param rhs string
---@param lhs string|function
---@param opts? table
local function map(mode, rhs, lhs, opts)
  vim.keymap.set(mode, rhs, lhs, opts)
end

map("i", "<C-c>", "<Esc>")
map("n", "<leader>e", vim.cmd.Ex, { desc = "Go to the file [e]xplorer" })

-- Take word wrap into account when moving up and down
map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

map("n", "<C-d>", "<C-d>zz", { desc = "Move down half a page" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up half a page" })

map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
map(
  { "i", "n" },
  "<esc>",
  "<cmd>noh<cr><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map(
  "n",
  "n",
  "'Nn'[v:searchforward].'zv'",
  { expr = true, desc = "Next search result" }
)
map(
  "x",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
map(
  "o",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
map(
  "n",
  "N",
  "'nN'[v:searchforward].'zv'",
  { expr = true, desc = "Previous search result" }
)
map(
  "x",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Previous search result" }
)
map(
  "o",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Previous search result" }
)

map("n", "<leader>gg", function()
  require("anttikivi.terminal").open(
    { "lazygit" },
    { esc_esc = false, ctrl_hjkl = false }
  )
end, { desc = "Open lazy[g]it" })

map(
  { "n", "v" },
  "<leader>d",
  [["_d]],
  { desc = "[D]elete into black hole register" }
)
map({ "n", "v" }, "<leader>p", [["_dP]], { desc = "Delete and [p]aste" })

map("n", "<leader>x", [[:!chmod +x %<CR>]], { desc = "Make file e[x]ecutable" })

map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
