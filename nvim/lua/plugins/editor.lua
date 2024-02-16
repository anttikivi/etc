return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      -- TODO: Maybe add keymaps later.
    },
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {}
    end,
    -- TODO: Update this when the branch is merged into master.
    branch = "harpoon2",
    event = "VeryLazy",
    keys = function()
      local harpoon = require "harpoon"

      return {
        {
          "<C-a>",
          function()
            harpoon:list():append()
          end,
          desc = "[A]ppend file to Harpoon list",
        },
        {
          "<leader>ht",
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "[T]oggle Harpoon quick menu",
        },
        {
          "<C-h>",
          function()
            harpoon:list():select(1)
          end,
          desc = "Switch to the first marked Harpoon file",
        },
        {
          "<C-j>",
          function()
            harpoon:list():select(2)
          end,
          desc = "Switch to the second marked Harpoon file",
        },
        {
          "<C-k>",
          function()
            harpoon:list():select(3)
          end,
          desc = "Switch to the third marked Harpoon file",
        },
        {
          "<C-l>",
          function()
            harpoon:list():select(4)
          end,
          desc = "Switch to the fourth marked Harpoon file",
        },
        {
          "<C-ö>",
          function()
            harpoon:list():select(5)
          end,
          desc = "Switch to the fifth marked Harpoon file",
        },
        {
          "<C-ä>",
          function()
            harpoon:list():select(6)
          end,
          desc = "Switch to the sixth marked Harpoon file",
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  -- {
  --   "nvim-pack/nvim-spectre",
  --   enabled = false,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.prompt_prefix = "> "
      opts.defaults.selection_caret = "> "
      local actions = require "telescope.actions"
      opts.defaults.mappings.i =
        vim.tbl_extend("force", opts.defaults.mappings.i, {
          ["<esc>"] = actions.close,
        })
    end,
  },
  -- TODO: Fix the highlights for the comments.
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        FIX = { icon = "☣︎ " },
        TODO = { icon = "✓ " },
        HACK = { icon = "♯ " },
        WARN = { icon = "⚠ " },
        PERF = { icon = "✦ " },
        NOTE = { icon = "♫ " },
        TEST = { icon = "⏲ " },
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
  },
}
