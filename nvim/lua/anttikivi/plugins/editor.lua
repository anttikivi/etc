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
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = require("telescope.actions").close,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require "telescope.builtin"

      vim.keymap.set(
        "n",
        "<leader>sh",
        builtin.help_tags,
        { desc = "[S]earch [H]elp" }
      )
      vim.keymap.set(
        "n",
        "<leader>sk",
        builtin.keymaps,
        { desc = "[S]earch [K]eymaps" }
      )
      vim.keymap.set(
        "n",
        "<leader>sf",
        builtin.find_files,
        { desc = "[S]earch [F]iles" }
      )
      vim.keymap.set(
        "n",
        "<leader>ss",
        builtin.builtin,
        { desc = "[S]earch [S]elect Telescope" }
      )
      vim.keymap.set(
        "n",
        "<leader>sw",
        builtin.grep_string,
        { desc = "[S]earch current [W]ord" }
      )
      vim.keymap.set(
        "n",
        "<leader>sg",
        builtin.live_grep,
        { desc = "[S]earch by [G]rep" }
      )
      vim.keymap.set(
        "n",
        "<leader>sd",
        builtin.diagnostics,
        { desc = "[S]earch [D]iagnostics" }
      )
      vim.keymap.set(
        "n",
        "<leader>sr",
        builtin.resume,
        { desc = "[S]earch [R]esume" }
      )
      vim.keymap.set(
        "n",
        "<leader>s.",
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      vim.keymap.set(
        "n",
        "<leader><leader>",
        builtin.buffers,
        { desc = "[ ] Find existing buffers" }
      )
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
          }
        )
      end, { desc = "[/] Fuzzily search in current buffer" })
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, { desc = "[S]earch [/] in Open Files" })
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()

      require("which-key").register {
        ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
        ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
        ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
        ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
        ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      }
    end,
  },
}
