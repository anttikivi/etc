return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        -- "permissions",
        -- "size",
      },
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 2000,
      },
      watch_for_changes = true,
      -- TODO: Review the default keymaps.
      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".DS_Store"
        end,
      },
    },
    keys = {
      { "-", "<cmd>Oil<CR>", mode = { "n" }, desc = "Open parent directory" },
    },
  },
}
