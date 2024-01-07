return {
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
          "<leader>ha",
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
          desc = "Switch the first marked Harpoon file",
        },
        {
          "<C-j>",
          function()
            harpoon:list():select(2)
          end,
          desc = "Switch the second marked Harpoon file",
        },
        {
          "<C-k>",
          function()
            harpoon:list():select(3)
          end,
          desc = "Switch the third marked Harpoon file",
        },
        {
          "<C-l>",
          function()
            harpoon:list():select(4)
          end,
          desc = "Switch the fourth marked Harpoon file",
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
        config = function()
          pcall(require("telescope").load_extension, "fzf")
        end,
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
    cmd = "Telescope",
    keys = function()
      local builtin = require "telescope.builtin"
      return {
        {
          "<leader><leader>",
          function()
            builtin.git_files { show_untracked = true }
          end,
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      local which_key = require "which-key"
      which_key.setup()
      which_key.register {
        ["g"] = { name = "+Goto" },
        ["<leader>g"] = { name = "+[g]it" },
      }
    end,
    event = "VeryLazy",
  },
}
