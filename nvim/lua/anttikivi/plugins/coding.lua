return {
  {
    import = "anttikivi.plugins.cmp.blink",
    enabled = function()
      return AK.cmp_engine() == "blink.cmp"
    end,
  },
  {
    import = "anttikivi.plugins.cmp.nvim-cmp",
    enabled = function()
      return AK.cmp_engine() == "nvim-cmp"
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "AK" } },
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      --  - va)  - [V]isually select [A]round [)]parenthen
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      ---@type MiniPairs.config
      local pairs_opts = {
        modes = { insert = true, command = true, terminal = false },
        -- Skip autopair when next character is one of these.
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- Skip autopair when the cursor is inside these treesitter nodes.
        skip_ts = { "string" },
        -- Skip autopair when next character is closing pair and there are more
        -- closing pairs than opening pairs.
        skip_unbalanced = true,
        -- Better deal with markdown code blocks.
        markdown = true,
      }
      require("mini.pairs").setup(pairs_opts)
      AK.mini.pairs(pairs_opts)

      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },
}
