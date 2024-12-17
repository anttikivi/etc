return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "selene" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            local root = AK.root.get({ normalize = true })
            if root ~= vim.uv.cwd() then
              return false
            end
            return vim.fs.find(
              { "selene.toml" },
              { path = root, upward = true }
            )[1]
          end,
        },
      },
    },
  },
}
