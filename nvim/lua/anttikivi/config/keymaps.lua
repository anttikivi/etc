-- The keymappings are based on LazyVim/LazyVim, licensed under Apache-2.0.

local map = vim.keymap.set

-- Better up and down: make them take line wrapping into account.
map(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "Down", expr = true, silent = true }
)
map(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)
map(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "Up", expr = true, silent = true }
)

-- Move lines
-- TODO: I don't really like the fact that I use the arrow keys for these, but
-- I'm running out of keys to use. Maybe I'll find a better combination later.
map(
  "n",
  "<A-down>",
  "<cmd>execute 'move .+' . v:count1<cr>==",
  { desc = "Move down" }
)
map(
  "n",
  "<A-up>",
  "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
  { desc = "Move up" }
)
map("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map(
  "v",
  "<A-down>",
  ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
  { desc = "Move Down" }
)
map(
  "v",
  "<A-up>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
  { desc = "Move Up" }
)

-- Clear search and stop snippet on escape.
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  AK.cmp.actions.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

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

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Commenting
map(
  "n",
  "gco",
  "o<esc>vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add comment below" }
)
map(
  "n",
  "gcO",
  "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add comment above" }
)

-- lazy.nvim
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy.nvim" })

-- Formatting
map({ "n", "v" }, "<leader>cf", function()
  AK.format({ force = true })
end, { desc = "Format" })

-- Diagnostic keymaps
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Git
map("n", "<leader>gb", function()
  Snacks.git.blame_line()
end, { desc = "Git blame line" })

-- Native snippets. Only needed on < 0.11, as 0.11 creates these by default.
if vim.fn.has("nvim-0.11") == 0 then
  map("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 })
        and "<cmd>lua vim.snippet.jump(1)<cr>"
      or "<Tab>"
  end, { expr = true, desc = "Jump next" })
  map({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 })
        and "<cmd>lua vim.snippet.jump(-1)<cr>"
      or "<S-Tab>"
  end, { expr = true, desc = "Jump previous" })
end

-- To file explorer
-- map("n", "<leader>e", "<cmd>Rex<CR>", { desc = "Resume to file explorer" })
-- map("n", "<leader>E", "<cmd>Ex<CR>", { desc = "Resume to file explorer" })

-- To normal mode
map("i", "<C-c>", "<Esc>")

-- Paste without overwriting the clipboard.
map(
  "x",
  "<leader>p",
  [["_dP]],
  { desc = "Paste without overwriting the clipboard" }
)

-- Delete without yanking.
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Make a file executable.
map("n", "<leader>x", [[:!chmod +x %<CR>]], { desc = "Make file executable" })

-- Use the sessionizer.
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
