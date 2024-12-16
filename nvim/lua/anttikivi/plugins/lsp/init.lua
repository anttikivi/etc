-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | { ensure_installed: string[] }
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to possibly load this newly installed LSP
          -- server.
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- This will set set the prefix to a function that returns the
            -- diagnostics icon based on the severity. This only works on a
            -- recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = AK.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = AK.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = AK.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = AK.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on
        -- Neovim >= 0.10.0. Be aware that you also will need to properly
        -- configure your LSP server to provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on
        -- Neovim >= 0.10.0. Be aware that you also will need to properly
        -- configure your LSP server to provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable lsp cursor word highlighting.
        document_highlight = {
          enabled = true,
        },
        -- Add any global capabilities here.
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- Options for vim.lsp.buf.format.
        -- `bufnr` and `filter` are handled by the AK formatter, but can be also
        -- overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- Set up automatic formatting.
      AK.format.register(AK.lsp.formatter())

      -- Set up keymaps.
      AK.lsp.on_attach(function(client, buffer)
        require("anttikivi.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      AK.lsp.setup()
      AK.lsp.on_dynamic_capability(
        require("anttikivi.plugins.lsp.keymaps").on_attach
      )

      -- Diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]
              :lower()
              :gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        -- Inlay hints
        if opts.inlay_hints.enabled then
          AK.lsp.on_supports_method(
            "textDocument/inlayHint",
            function(_, buffer)
              if
                vim.api.nvim_buf_is_valid(buffer)
                and vim.bo[buffer].buftype == ""
                and not vim.tbl_contains(
                  opts.inlay_hints.exclude,
                  vim.bo[buffer].filetype
                )
              then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
              end
            end
          )
        end

        -- Code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          AK.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd(
              { "BufEnter", "CursorHold", "InsertLeave" },
              {
                buffer = buffer,
                callback = vim.lsp.codelens.refresh,
              }
            )
          end)
        end
      end

      if
        type(opts.diagnostics.virtual_text) == "table"
        and opts.diagnostics.virtual_text.prefix == "icons"
      then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0
            and "●"
          or function(diagnostic)
            local icons = AK.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- Get all the servers that are available through mason-lspconfig.
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(
          require("mason-lspconfig.mappings.server").lspconfig_to_package
        )
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- Run manual setup if mason=false or if this is a server that
            -- cannot be installed with mason-lspconfig.
            if
              server_opts.mason == false
              or not vim.tbl_contains(all_mslp_servers, server)
            then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        ---@diagnostic disable-next-line: missing-fields
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            AK.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if AK.lsp.is_enabled("denols") and AK.lsp.is_enabled("vtsls") then
        local is_deno =
          require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        AK.lsp.disable("vtsls", is_deno)
        AK.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },
}
