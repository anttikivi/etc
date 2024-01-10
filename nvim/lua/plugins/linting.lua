return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find(
              { "selene.toml" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            return vim.fs.find(
              { ".luacheckrc" },
              { path = ctx.filename, upward = true }
            )[1]
          end,
        },
      },
    },
  },
}
