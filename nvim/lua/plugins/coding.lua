return {
  {
    "lukas-reineke/headlines.nvim",
    opts = {
      markdown = {
        fat_headline_lower_string = "⿳",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.completion.completeopt = "menu,menuone,noinsert,noselect"
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm { select = false },
        ["<S-CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
      })
    end,
  },
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },
}
