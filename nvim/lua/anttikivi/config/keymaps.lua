-- To file explorer
vim.keymap.set(
  "n",
  "<leader>e",
  "<cmd>Rex<CR>",
  { desc = "Resume to file [E]xplorer" }
)
vim.keymap.set(
  "n",
  "<leader>E",
  "<cmd>Ex<CR>",
  { desc = "Resume to file [E]xplorer" }
)

-- To normal mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!"<CR>')

-- Make up and down take line wrapping into account
vim.keymap.set(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
vim.keymap.set(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Keybinds to make split navigation easier.
-- vim.keymap.set(
--   "n",
--   "<C-h>",
--   "<C-w><C-h>",
--   { desc = "Move focus to the left window" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-l>",
--   "<C-w><C-l>",
--   { desc = "Move focus to the right window" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-j>",
--   "<C-w><C-j>",
--   { desc = "Move focus to the lower window" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-k>",
--   "<C-w><C-k>",
--   { desc = "Move focus to the upper window" }
-- )

-- Resize window using <ctrl> + arrow keys
-- vim.keymap.set(
--   "n",
--   "<C-Up>",
--   "<cmd>resize +2<cr>",
--   { desc = "Increase Window Height" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-Down>",
--   "<cmd>resize -2<cr>",
--   { desc = "Decrease Window Height" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-Left>",
--   "<cmd>vertical resize -2<cr>",
--   { desc = "Decrease Window Width" }
-- )
-- vim.keymap.set(
--   "n",
--   "<C-Right>",
--   "<cmd>vertical resize +2<cr>",
--   { desc = "Increase Window Width" }
-- )

-- Move lines
-- TODO: I don't really like the fact that I use the arrow keys for these, but
-- I'm running out of keys to use. Maybe I'll find a better combination later.
vim.keymap.set(
  "n",
  "<A-down>",
  "<cmd>execute 'move .+' . v:count1<cr>==",
  { desc = "Move down" }
)
vim.keymap.set(
  "n",
  "<A-up>",
  "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
  { desc = "Move up" }
)
vim.keymap.set(
  "i",
  "<A-down>",
  "<esc><cmd>m .+1<cr>==gi",
  { desc = "Move down" }
)
vim.keymap.set("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set(
  "v",
  "<A-down>",
  ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
  { desc = "Move Down" }
)
vim.keymap.set(
  "v",
  "<A-up>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
  { desc = "Move Up" }
)

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Commenting
vim.keymap.set(
  "n",
  "gco",
  "o<esc>vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add comment below" }
)
vim.keymap.set(
  "n",
  "gcO",
  "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add comment above" }
)

-- Diagnostic keymaps
vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
-- TODO: Set a keymap for this.
vim.keymap.set(
  "n",
  "<leader>ce",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic [E]rror messages" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

-- Clear search with <esc>
vim.keymap.set(
  { "i", "n" },
  "<Esc>",
  "<cmd>noh<CR><Esc>",
  { desc = "Escape and clear hlsearch" }
)

vim.keymap.set(
  "t",
  "<Esc><Esc>",
  "<C-\\><C-n>",
  { desc = "Exit terminal mode" }
)

-- Use the sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Paste without overwriting the clipboard
vim.keymap.set(
  "x",
  "<leader>p",
  [["_dP]],
  { desc = "[P]aste without overwriting the clipboard" }
)

-- Delete without yanking
vim.keymap.set(
  { "n", "v" },
  "<leader>d",
  [["_d]],
  { desc = "[D]elete without yanking" }
)

-- Make file an executable
vim.keymap.set(
  "n",
  "<leader>x",
  [[:!chmod +x %<CR>]],
  { desc = "Make file e[x]ecutable" }
)
